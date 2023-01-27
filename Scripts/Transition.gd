extends CanvasLayer

func begin():
	$AnimationPlayer.play("TransitionOut")

func change_level():
	$AnimationPlayer.play('RESET')
	$AnimationPlayer.play('TransitionIn')
	yield($AnimationPlayer, 'animation_finished')
	Globals.level += 1
	Globals.restart_game()
	$AnimationPlayer.play("TransitionOut")
	
func change_scene(sceneName):
	var scene = "res://Scenes/" + sceneName + ".tscn"
	$AnimationPlayer.play('RESET')
	$AnimationPlayer.play('TransitionIn')
	yield($AnimationPlayer, 'animation_finished')
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene)
	$AnimationPlayer.play("TransitionOut")
