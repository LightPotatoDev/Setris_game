extends GridContainer

var lvData
onready var slot = preload("res://Objects/Display/Panel.tscn")

onready var shape1 = preload("res://Objects/Display/DisplayShape1.tscn")
onready var shape2 = preload("res://Objects/Display/DisplayShape2.tscn")
onready var shape3 = preload("res://Objects/Display/DisplayShape3.tscn")
onready var shape4 = preload("res://Objects/Display/DisplayShape4.tscn")
onready var shape5 = preload("res://Objects/Display/DisplayShape5.tscn")
onready var shape6 = preload("res://Objects/Display/DisplayShape6.tscn")
onready var shape7 = preload("res://Objects/Display/DisplayShape7.tscn")

var shapes = []
var slots = []
var main
var sh = []

func _ready():
	main = get_tree().root.get_node("Main")
	lvData = main.lvData[Globals.level - 1]
	shapes = [shape1, shape2, shape3, shape4, shape5, shape6, shape7]
	
	for i in range(lvData.pieceOrder.size()):
		var s = slot.instance()
		add_child(s)
		slots.append(s)
		sh = shapes[lvData.pieceOrder[i]].instance()
		sh.scale = Vector2(0.5, 0.5)
		sh.position = Vector2(40, 40)
		s.add_child(sh)
		
	slots[0].get("custom_styles/panel/StyleBoxTexture").modulate_color = Color("e64c3737")


func _on_Main_curPieceChanged():
	#get_node("Panel").get("custom_styles/panel/StyleBoxTexture").modulate_color = Color("e6ff0000")
	for i in range(lvData.pieceOrder.size()):
		slots[i].get("custom_styles/panel/StyleBoxTexture").modulate_color = Color("e62d3137")
	if main.count + 1 < lvData.pieceOrder.size():
		slots[main.count+1].get("custom_styles/panel/StyleBoxTexture").modulate_color = Color("e64c3737")
	else:
		slots[main.count].get("custom_styles/panel/StyleBoxTexture").modulate_color = Color("e62d3137")
