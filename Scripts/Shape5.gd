extends Shape0
class_name Shape5

func _ready():
	rotation_matrix = [
		[Vector2(0,0), Vector2(32,0), Vector2(0,32), Vector2(32,32)],
		[Vector2(0,0), Vector2(32,0), Vector2(0,32), Vector2(32,32)],
		[Vector2(0,0), Vector2(32,0), Vector2(0,32), Vector2(32,32)],
		[Vector2(0,0), Vector2(32,0), Vector2(0,32), Vector2(32,32)]
	]
	draw_shape()
	rotate_position = 1
