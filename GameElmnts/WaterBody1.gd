extends Area2D

func spawnSplash(position):
	$plouf.play()
	var splashy = $splash.duplicate()
	var timer = Timer.new()
	get_parent().add_child(splashy)
	splashy.add_child(timer)
	splashy.visible = true
	splashy.position.x = position
	splashy.position.y = 180
	splashy.frame = 0
	
	splashy.play("splash")
	
	timer.connect("timeout", splashy, "queue_free")
	timer.set_wait_time(2)
	timer.start()

func _on_WaterBody1_body_entered(body):
	if "Foxy" in body.name :
			spawnSplash(body.position.x)
			body.getHit(true)
			GlobalScene.clam_out = get_parent().get_node("Clam").position.y == 156
