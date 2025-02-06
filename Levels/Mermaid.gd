extends AnimatedSprite


var destination = 208

# Called when the node enters the scene tree for the first time.
func talk():
	get_parent().get_node("talking_area").get_node("CollisionShape2D").disabled = true
	get_parent().get_node("Foxy").initCutScene(false, null, null)
	GlobalScene.playCutScene(true)
	yield(play_mermaid_rise(), "completed")
	GlobalScene.playCutScene(false)

func play_mermaid_rise():
	yield(get_tree().create_timer(3.0), "timeout")
	$mermaidSound.play()
	destination = 162
	
	splash_around([0.3, 0.1, 0.2, 0.1, 0.05, 0.2, 0.1, 0.1, 0.05, 0.1, 0.05, 0.1])
	yield(get_tree().create_timer(3.0), "timeout")
	$talk_box.visible = true
	$mermaidSound.play()
	yield(get_tree().create_timer(1.0), "timeout")
	$mermaidSound.play()
	yield(get_tree().create_timer(1.0), "timeout")
	$talk_box.visible = false
	yield(get_tree().create_timer(1.0), "timeout")
	destination = 208
	splash_around([0.1, 0.1, 0.2, 0.1, 0.05, 0.1, 0.05, 0.1, 0.2, 0.1, 0.05, 0.1])
	yield(get_tree().create_timer(0.5), "timeout")
	get_parent().get_node("Clam/ClamGround").disabled = false
	get_parent().get_node("Clam/ClamSpr/ClamArea/ClamInterract").disabled = false
	yield(get_tree().create_timer(1.0), "timeout")
	splash_around([0.1, 0.1, 0.2, 0.1, 0.05, 0.1, 0.05, 0.1])
	yield(get_tree().create_timer(1.0), "timeout")
	

func splash_around(timers):
	var x = -5
	for n in timers:
		yield(get_tree().create_timer(n), "timeout")
		get_parent().get_node("WaterBody1").spawnSplash(position.x + x)
		x += 5
		if x > 10:
			x = -5

func _process(delta):
	if position.y != destination :
		var shift = delta * 30
		if position.y > destination :
			position.y -= shift
			if position.y < destination :
				position.y = destination
		if position.y < destination :
			position.y += shift
			if position.y > destination :
				position.y = destination
