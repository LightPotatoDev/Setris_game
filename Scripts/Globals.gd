extends Node

signal inact_shape
signal add_points
signal cant_rotate
signal clear_line
signal undo
signal on_mouse_entered

var inactive_pos = []
var inactive_blocks = []

#for undo function
var boardStatePos = []

var speed = 1

var level = 1
var cleared = true
var levelCompletions = []

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"

func _ready():
	load_game()
	print("aaaa")

func inactivate_shape():
	emit_signal("inact_shape")
	
func add_points():
	emit_signal("add_points")
	
func cant_rotate():
	emit_signal("cant_rotate")
	
func undo():
	emit_signal("undo")
	
func clear_line():
	emit_signal("clear_line")
	
func on_mouse_entered():
	emit_signal("on_mouse_entered")
	
func restart_game():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func next_level():
	Globals.levelCompletions[Globals.level - 1] = true
	save_game()
	LevelTransition.change_level()
	
func save_game():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var data = {
		"levelCompletions" : levelCompletions
	}
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "poto99")
	if error == OK:
		file.store_var(data)
		file.close()
		
func load_game():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "poto99")
		if error == OK:
			var player_data = file.get_var()
			levelCompletions = player_data["levelCompletions"]
			file.close()
	else:
		for _i in range(25):
			levelCompletions.append(false)
