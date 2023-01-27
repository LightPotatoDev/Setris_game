extends Shape0
class_name Shape1

var blockPos: PoolVector2Array = []
var newPos: PoolVector2Array = []

func _ready():
	for h in range(4):
		blockPos.append(get_child(h).position)
	rotation_matrix.append(blockPos)
	
	for _i in range (3):
		for j in range(4):
			var curX = blockPos[j].x
			var curY = blockPos[j].y
			var temp = curX
			curX = -curY
			curY = temp
			newPos.append(Vector2(curX, curY))
		blockPos = newPos
		rotation_matrix.append(newPos)
		newPos = []

	draw_shape()
	rotate_position = 1
