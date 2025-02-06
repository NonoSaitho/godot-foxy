extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalScene.ice == 2 :
		$Cocktail.visible = true
		$Cocktail2.visible = true

func talk():
	if GlobalScene.ice < 2:
		get_parent().get_node("Foxy").initCutScene(false, 304, null)
		GlobalScene.playCutScene(true)
		yield(get_tree().create_timer(1.0), "timeout")
		yield(play_ask_ice(), "completed")
		if GlobalScene.ice == 1:
			yield(play_give_ice(), "completed")
		if GlobalScene.sand < 1:
			yield(play_get_sand(), "completed")
		GlobalScene.playCutScene(false)
		GlobalScene.check_finish()
	else :
		play_conversation() 
	
func play_ask_ice():
	$subject.play("Hot")
	$mark.play("Excl")
	
	$bubble.visible = true
	$subject.visible = true
	$mark.visible = true
	$mermaidSound.play()
	yield(get_tree().create_timer(2.2), "timeout")
	$bubble.play("Speachless")
	$subject.visible = false
	$mark.visible = false
	yield(get_tree().create_timer(2.5), "timeout")
	$bubble.play("Talk")
	$subject.play("Question")
	$subject.visible = true
	$mermaidSound.play()
	yield(get_tree().create_timer(2.2), "timeout")
	$bubble.visible = false
	$subject.visible = false
	$mark.visible = false

func play_give_ice():
	$subject.play("Ice")
	$mark.play("Excl")
	
	get_parent().get_node("Foxy/FoxySprite").play("Bark")
	yield(get_tree().create_timer(1.0), "timeout")
	$bubble.visible = true
	$subject.visible = true
	$mark.visible = true
	$mermaidSound.play()
	yield(get_tree().create_timer(1.5), "timeout")
	$bubble.visible = false
	$subject.visible = false
	$mark.visible = false
	
	$joy.visible = true
	$mermaidSound.play()
	Pause.get_item("Ice")
	yield(get_tree().create_timer(3.5), "timeout")
	$joy.visible = false
	Pause.hide_items()

func play_get_sand():
	$subject.play("Sand")
	$mark.play("Question")
	$bubble.visible = true
	$subject.visible = true
	$mark.visible = true
	$mermaidSound.play()
	yield(get_tree().create_timer(1.5), "timeout")
	$bubble.visible = false
	$mark.visible = false
	$subject.visible = false
	Pause.get_item("Sand")
	get_parent().get_node("Foxy/FoxySprite").play("Bark")
	yield(get_tree().create_timer(3.5), "timeout")
	Pause.hide_items()
	
func play_conversation():
	$subject.play("Hot")
	$mark.play("Excl")
	get_parent().get_node("talking_area").get_node("CollisionShape2D").disabled = true
	
	$bubble.visible = true
	$subject.visible = true
	$mark.visible = true
	$mermaidSound.play()
	yield(get_tree().create_timer(2.0), "timeout")
	$subject.play("Cocktail")
	$mark.play("Question")
	$mermaidSound.play()
	yield(get_tree().create_timer(2.5), "timeout")
	$bubble.visible = false
	$subject.visible = false
	$mark.visible = false
	
	get_parent().get_node("talking_area").get_node("CollisionShape2D").disabled = false
