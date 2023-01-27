extends Node2D

onready var shape1 = preload("res://Objects/Shape1.tscn")
onready var shape2 = preload("res://Objects/Shape2.tscn")
onready var shape3 = preload("res://Objects/Shape3.tscn")
onready var shape4 = preload("res://Objects/Shape4.tscn")
onready var shape5 = preload("res://Objects/Shape5.tscn")
onready var shape6 = preload("res://Objects/Shape6.tscn")
onready var shape7 = preload("res://Objects/Shape7.tscn")

onready var blocc = preload("res://Objects/Block.tscn")
onready var zone = preload("res://Objects/Zone.tscn")

var shapes = []
var sh

enum State {Waiting, Active, Clear}
var curState
var num: int = -1
var count = -1

export (Array, Resource) var lvData
var curLvData

signal curPieceChanged

#UI
onready var lvText = $UI/Lv
onready var titleText = $UI/Title

#Sounds
onready var sfxUndo = $Sounds/SfxUndo
onready var sfxClick = $Sounds/SfxClick
onready var sfxReset = $Sounds/SfxReset
onready var sfxDrop = $Sounds/SfxDrop
onready var sfxClear = $Sounds/SfxClear
onready var sfxMessedUp = $Sounds/SfxMessedUp

onready var undoEffect = preload("res://Objects/Effects/UndoEffect.tscn")
onready var undoCreateEffect = preload("res://Objects/Effects/UndoCreateEffect.tscn")

onready var zoneNo = preload("res://Objects/ZoneNo.tscn")

var messedUp = false
var quit = false

#ready
func _ready():
	curState = State.Waiting
	shapes = [shape1, shape2, shape3, shape4, shape5, shape6, shape7]
	curLvData = lvData[Globals.level - 1]
	add_zone()
	
	if Globals.cleared == false:
		sfxReset.play()
		
	#UI
	lvText.text = "Level " + String(Globals.level)
	titleText.text = curLvData.lvTitle
	
	#for initial blocks
	clear_array()
	
	if curLvData.initialBlocks.empty():
		Globals.boardStatePos.append([])
	else:
		var initialBlockPos = []
		for i in range(curLvData.initialBlocks.size()):
			initialBlockPos.append(curLvData.initialBlocks[i] * 32)
			Globals.inactive_pos = initialBlockPos
			spawn_blocks(i)
		Globals.boardStatePos.append(initialBlockPos.duplicate(true))
		undo_create_effect(initialBlockPos)
		
		#if not curLvData.initGPlace.empty():
		#	insert_gimmick()
	$UI/Completed.visible = false
	if Globals.levelCompletions[Globals.level - 1] == true:
		$UI/Completed.visible = true
func clear_array():
	Globals.inactive_pos.clear()
	Globals.inactive_blocks.clear()
	Globals.boardStatePos.clear()
func add_zone():
	if Globals.cleared == true:
		yield(get_tree().create_timer(0.6), "timeout")
		Globals.cleared = false
	for place in curLvData.requirementCheck:
		var z = zone.instance()
		$ShapesArea.add_child(z)
		z.position = place * 32

#movement	
func move_left():
	if curState == State.Active:
		sh.move_left()
	sfxClick.play()	
func move_right():
	if curState == State.Active:
		sh.move_right()
		sfxClick.play()
func move_down():
	if curState == State.Active:
		sh.move_down()
		$Timer.start()
func hard_drop():
	if curState == State.Active:
		var ch = sh.get_children()
		var ii = 0
		while ii < 100:
			for i in range (ch.size()):
				if not ch[i].can_move_down():
					print(ii)
					_wait()
					sh.is_fixed = true
					return
			sh.move_down()
			$Timer.start()
			ii += 1

#get input
func _input(_event):
	
	if curState == State.Waiting && Globals.cleared == false:
		if Input.is_action_just_pressed("undo") and count >= 0:
			undo()
			
		if Input.is_action_just_pressed("proceed") and count < curLvData.pieceOrder.size() - 1:
			spawn_shape()
	
	if curState == State.Active:
		if Input.is_action_just_pressed("undo"):
			cancel()
		if sh:
			if Input.is_action_just_pressed("ui_right"):
				move_right()
			if Input.is_action_just_pressed("ui_left"):
				move_left()
			if Input.is_action_pressed("ui_down"):
				move_down()
			if Input.is_action_just_pressed("ui_down"):
				sfxClick.play()
			if Input.is_action_just_pressed("ui_up"):
				sh.rotate_it()
				sfxClick.play()
			if Input.is_action_just_pressed("hard_drop"):
				hard_drop()
			
	if Input.is_action_just_pressed("restart") && curState != State.Clear && Globals.cleared == false:
		Globals.restart_game()
		
	if Input.is_action_just_pressed("ui_cancel") && curState != State.Clear &&\
		 Globals.cleared == false && quit == false:
		quit = true
		LevelTransition.change_scene("LevelSelect")

#undo
func undo():
	Globals.undo()
	var undoPos = []
	var undoCreatePos = []
	undoPos.clear()
	undoCreatePos.clear()
	
	for item in Globals.boardStatePos[count+1]:
		if !Globals.boardStatePos[count].has(item): undoPos.append(item)
	for item in Globals.boardStatePos[count]:
		if !Globals.boardStatePos[count+1].has(item): undoCreatePos.append(item)
	undo_effect(undoPos)
	undo_create_effect(undoCreatePos)
	sfxUndo.play()
	if messedUp == true:
		messedUp = false
		$ClearStateAnim.play_backwards("MessedUp")
	
	for i in range(Globals.inactive_pos.size() - 1, -1, -1):
		Globals.inactive_blocks[i].destroy_block()
		
	Globals.inactive_pos.clear()
	Globals.inactive_pos = Globals.boardStatePos[count].duplicate(true)
	Globals.inactive_blocks.clear()
	Globals.boardStatePos.pop_back()
	
	count -= 1
	
	for i in range(Globals.inactive_pos.size()):
		spawn_blocks(i)
		
	emit_signal("curPieceChanged")
	
	#if not curLvData.initGPlace.empty():
	#	insert_gimmick()
func undo_effect(pos):	
	for j in range (pos.size()):
		var undoEff = undoEffect.instance()
		$ShapesArea.add_child(undoEff)
		undoEff.position = pos[j]
func undo_create_effect(pos):
	for j in range (pos.size()):
		var undoEff = undoCreateEffect.instance()
		$ShapesArea.add_child(undoEff)
		undoEff.position = pos[j]
func cancel():
	var undoPos = []
	undoPos.clear()
	for i in range(4):
		undoPos.append(sh.position + sh.get_child(i).position)
	undo_effect(undoPos)
	sfxUndo.play()
	
	sh.queue_free()
	curState = State.Waiting
	$TutoAnim.play('WaitingState')
	count -= 1
	
#spawning
func spawn_shape():
	$Timer.start()
	$TutoAnim.play('ActiveState')
	count += 1
	curState = State.Active
	num = curLvData.pieceOrder[count]
	sh = shapes[num].instance()
	$ShapesArea.add_child(sh)
	sh.position = Vector2(128, 32)
func spawn_blocks(i):
	var bl = blocc.instance()
	$ShapesArea.add_child(bl)
	bl.position = Globals.inactive_pos[i]
	bl.is_active = false
	Globals.inactive_blocks.append(bl)
	bl.has_parent = false
#func insert_gimmick():
#	for i in range(curLvData.initGPlace.size()):
#		Globals.inactive_blocks[curLvData.initGPlace[i]].change_gimmick(curLvData.initGType[i])

#in_game actions		
func _on_Timer_timeout():
	move_down()		
	$Timer.wait_time = Globals.speed	
func _wait():
	curState = State.Waiting
	sfxDrop.play()
	emit_signal("curPieceChanged")
	$TutoAnim.play('WaitingState')
	$Timer.stop()
	Globals.boardStatePos.append(Globals.inactive_pos.duplicate(true))
	
	if count >= curLvData.pieceOrder.size() - 1:
		final_check()

#last check
func final_check():
	var finalArray = []
	finalArray.clear()
	for i in range(curLvData.requirementCheck.size()):
		finalArray.append(curLvData.requirementCheck[i] * 32)
	
	if arrays_have_same_content(Globals.inactive_pos, finalArray):
		print("ok")
		curState = State.Clear
		sfxClear.play()
		Globals.cleared = true
		$ClearStateAnim.play("Clear")
		if(Globals.level < lvData.size()):
			Globals.next_level()
		else:
			print("GG")
			Globals.levelCompletions[24] = true
			Globals.save_game()
			LevelTransition.change_scene("LevelSelect")
	else:
		print("no")
		$ClearStateAnim.play("MessedUp")
		sfxMessedUp.stream.loop = false
		sfxMessedUp.play()
		messedUp = true
		indicate_wrong(finalArray)
func indicate_wrong(finalArray):
	var noPos = []
	noPos.clear()
	for item in Globals.inactive_pos:
		if !finalArray.has(item): noPos.append(item)
	for i in (noPos.size()):
		var nope = zoneNo.instance()
		$ShapesArea.add_child(nope)
		nope.position = noPos[i]
func arrays_have_same_content(a1, a2):
	if a1.size() != a2.size(): return false
	for item in a1:
		if !a2.has(item): return false
		if a1.count(item) != a2.count(item): return false
	return true
