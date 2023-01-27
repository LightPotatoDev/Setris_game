extends Button

var lv
var buttonPressed = false

onready var clearTexture = preload("res://Sprites/Gimmicks/BlueBlock.png")

func _ready():
	lv = int(text)
# warning-ignore:return_value_discarded
	connect("pressed", self, "_button_pressed")
	connect("mouse_entered", self, "on_mouse_entered")
	
	if Globals.levelCompletions[lv - 1] == true:
		icon = clearTexture

func _button_pressed():
	if buttonPressed == false:
		Globals.level = lv
		Globals.cleared = true
		LevelTransition.change_scene("Main")
		buttonPressed = true

func on_mouse_entered():
	Globals.on_mouse_entered()
