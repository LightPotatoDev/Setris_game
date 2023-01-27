extends Node2D

func _ready():
	LevelTransition.begin()
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimationPlayer.play("Start")
