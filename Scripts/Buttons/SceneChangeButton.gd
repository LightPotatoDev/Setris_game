extends Button

export (String) var sceneName
var buttonPressed = false

func _ready():
# warning-ignore:return_value_discarded
	connect("pressed", self, "_button_pressed")
	connect("mouse_entered", self, "on_mouse_entered")

func _button_pressed():
	if buttonPressed == false:
		LevelTransition.change_scene(sceneName)
		buttonPressed = true
		
func on_mouse_entered():
	Globals.on_mouse_entered()
