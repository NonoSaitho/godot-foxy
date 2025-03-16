extends Node2D

export(int) var size_x = 0
export(int) var size_y = 0
export(String) var music = null

func _ready():
	GlobalScene.play_music(music)
	GlobalScene.currentFoxy = get_node("Foxy")
	
	get_node("Foxy/Camera2D").set_limit(MARGIN_RIGHT, size_x)
	get_node("Foxy/Camera2D").set_limit(MARGIN_BOTTOM, size_y)
	if(GlobalScene.pos != null):
		get_node("Foxy").set_position(GlobalScene.pos)
		get_node("Foxy").motion = GlobalScene.motion
		if GlobalScene.was_hit :
			print("i was hit")
			GlobalScene.was_hit = false
			get_node("Foxy").ouch_tic = 0.8
		get_node("Foxy").update_sprite(GlobalScene.animation, GlobalScene.flip)
	
	get_node("Foxy/Camera2D").reset_smoothing()
	

func _process(delta):
	## safety net in WhiteMountain levels ith snowballs
	var limit = size_y/5
	if $Foxy.position.y > limit + 10:
		$Foxy.position.y = limit + 5

