extends Label

var count = 0

func _ready():
	for i in range (25):
		if Globals.levelCompletions[i] == true:
			count += 1
	text = str(count) + " / 25 Levels Complete"
	
	$Congrats.visible = false
	
	if count >= 25:
		$Congrats.visible = true
