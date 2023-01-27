extends Node

func _ready():
# warning-ignore:return_value_discarded
	Globals.connect("undo", self, "destroy")
	
func destroy():
	queue_free()
