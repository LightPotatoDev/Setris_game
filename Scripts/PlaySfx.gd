extends AudioStreamPlayer

export (String) var funcName

func _ready():
# warning-ignore:return_value_discarded
	Globals.connect(funcName, self, "play_sound")

func play_sound():
	play()
