extends Node2D

var is_active = true
var block_size = 32
var has_parent = true

onready var destroyEffect = preload("res://Objects/Effects/BlockDestroyEffect.tscn")
onready var dropEffect = preload("res://Objects/Effects/DropEffect.tscn")

#enum Gimmick {Default, Shift, Fire, Ice}
#var curGimmick = Gimmick.Default

#onready var shiftDBlock = preload("res://Sprites/Gimmicks/ShiftDBlock.png")

func _ready():
# warning-ignore:return_value_discarded
	Globals.connect("inact_shape", self, "inactivate_it")
		
#func change_gimmick(type):
#	if type == Gimmick.Shift:
#		$Sprite.texture = shiftDBlock
#		curGimmick = type
	
func inactivate_it():
	if is_active:
		is_active = false
		Globals.inactive_pos.append(get_parent().position + position)
		Globals.inactive_blocks.append(self)
		Globals.inactivate_shape()
		if has_parent:
			unparent()
		drop_effect()
		check_full_line()
	#if curGimmick == Gimmick.Shift:
	#	gimmick_shift()

#Check if a move is possible
func can_rotate(val) -> bool:
	if Globals.inactive_pos.has(Vector2(get_parent().position.x+val.x, get_parent().position.y + val.y)) \
	or is_off_screen(Vector2(get_parent().position.x+val.x, get_parent().position.y + val.y)):
		Globals.cant_rotate()
		return false
	else:
		return true
func cant_rotate_effect():
	$Sprite.modulate = Color.tomato
	yield(get_tree().create_timer(0.05), "timeout")
	$Sprite.modulate = Color.white
	
	
func is_off_screen(vec) -> bool:
	if vec.x < 0:
		return true
	elif vec.x >= get_parent().get_parent().get_rect().size.x:
		return true
	elif vec.y < 0:
		return true
	elif vec.y >= get_parent().get_parent().get_rect().size.y:
		return true
	else:
		return false
func can_move_down():
	if Globals.inactive_pos.has(Vector2(get_parent().position.x + position.x, get_parent().position.y + position.y + block_size)) \
	or get_parent().position.y + position.y == block_size * 19:
		inactivate_it()
		return false
	else:
		return true
func can_move_left():
	if Globals.inactive_pos.has(Vector2(get_parent().position.x + position.x - block_size, get_parent().position.y + position.y)) \
	or get_parent().position.x + position.x == 0 or not is_active:
		return false
	else:
		return true
func can_move_right():
	if Globals.inactive_pos.has(Vector2(get_parent().position.x + position.x + block_size, get_parent().position.y + position.y)) \
	or get_parent().position.x + position.x == block_size * 9 or not is_active:
		return false
	else:
		return true

func unparent():
	var new_parent = get_parent().get_parent()
	position = get_parent().position + position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	has_parent = false
	
func drop_effect():
	var eff = dropEffect.instance()
	get_parent().add_child(eff)
	eff.position = position
	
func check_full_line():
	var index = 0
	var count = 0
	var positions_to_erase = []
	var blocks_to_shift = []
	
	for i in Globals.inactive_pos:
		if i.y == position.y:
			positions_to_erase.append(index)
			count += 1
		index += 1
		
	if count == 10:
		destroy_line(positions_to_erase)
		Globals.clear_line()
		index = 0
		for i in Globals.inactive_pos:
			if i.y < position.y:
				blocks_to_shift.append(index)
			index += 1
		shift_blocks(blocks_to_shift)

func destroy_block():
	queue_free()
	
func destroy_effect():
	var eff = destroyEffect.instance()
	get_parent().add_child(eff)
	eff.position = position

#Classic rule
func destroy_line(indexes):
	Globals.add_points()
	var line_vals = indexes
	for i in range(line_vals.size()-1, -1, -1):
		Globals.inactive_pos.remove(line_vals[i])
		Globals.inactive_blocks[line_vals[i]].destroy_block()
		Globals.inactive_blocks[line_vals[i]].destroy_effect()
		Globals.inactive_blocks.remove(line_vals[i])
func shift_blocks(blocks):
	for i in blocks:
		Globals.inactive_pos[i].y += block_size
		Globals.inactive_blocks[i].position.y += block_size

#Gimmicks
#func gimmick_shift():
#	print(has_parent)
#	print(Globals.inactive_pos)
#	var d = 0
#	for i in Globals.inactive_pos:
#		if has_parent == false:
#			while Globals.inactive_pos.has(Vector2(position.x, position.y + d)):
#				print("dd")
#				d += 32
#				if d > 1000:
#					break
		#d += 32
		#Globals.inactive_pos[i].y += d
		#Globals.inactive_blocks[i].position.y += d
