extends Resource
class_name LevelData

export (String) var lvTitle

enum shapes {I = 0, L, T, J, O, Z, S}
export (Array, shapes) var pieceOrder

#export (Array, int) var GOrder
#export (Array, int) var GPlace
#enum gimmicks {Default = 0, Shift, Fire, Ice}
#export (Array, gimmicks) var GType

export(Array, Vector2) var requirementCheck

export(Array, Vector2) var initialBlocks
#export (Array, int) var initGPlace
#export (Array, gimmicks) var initGType
