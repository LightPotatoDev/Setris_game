extends Node2D

onready var unfilledTexture = preload("res://Sprites/Zone4.png")
onready var filledTexture = preload("res://Sprites/ZoneFilled.png")

func _ready():
# warning-ignore:return_value_discarded
	Globals.connect("inact_shape", self, "change_color")
# warning-ignore:return_value_discarded
	Globals.connect("undo", self, "change_color")
	
func change_color():
	yield(get_tree().create_timer(0.05), "timeout")
	if Globals.inactive_pos.has(position):
		$Sprite.texture = filledTexture
	else:
		$Sprite.texture = unfilledTexture
		
func _on_AnimationPlayer_animation_finished(_ZoneAnim):
	change_color()
