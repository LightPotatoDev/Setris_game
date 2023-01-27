extends Resource

const _order = [
	#simple first puzzles
	"LvData1",
	"LvData2",
	"LvData3",
	"LvData4",
	#includes line destroy
]

static func get_level(var index: int):
	return load(str("res://LevelData/", _order[index], ".tres"))
