extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalScene.sand == 2 :
		$Hourglass.visible = true
	

func talk():
	if GlobalScene.sand < 2:
		get_parent().get_node("Foxy").initCutScene(true, 108, null)
		GlobalScene.playCutScene(true)
		yield(get_tree().create_timer(1.0), "timeout")
		yield(play_ask_Sand(), "completed")
		if GlobalScene.sand == 1:
			yield(play_give_sand(), "completed")
		if GlobalScene.hair < 1:
			yield(play_get_hair(), "completed")
		GlobalScene.playCutScene(false)
		GlobalScene.check_finish()
	else :
		play_joy() 
	
func play_ask_Sand():
	$bubble.play("Speachless")
	$subject.play("Hourglass")
	$mark.play("Excl")
	
	$bubble.visible = true
	yield(get_tree().create_timer(2.5), "timeout")
	$bubble.play("Talk")
	$subject.visible = true
	yield(get_tree().create_timer(1.2), "timeout")
	$subject.play("BrokenHourglass")
	$mark.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$bubble.visible = false
	$subject.visible = false
	$mark.visible = false
	
func play_give_sand():
	$bubble.play("Talk")
	$subject.play("Sand")
	$mark.play("Excl")
	
	get_parent().get_node("Foxy/FoxySprite").play("Bark")
	yield(get_tree().create_timer(1.0), "timeout")
	$bubble.visible = true
	$subject.visible = true
	$mark.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$bubble.visible = false
	$subject.visible = false
	$mark.visible = false
	
	$give.position = Vector2(52, -20)
	$give.play("Sand")
	$give.visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	$give.visible = false
	
	$joy.visible = true
	self.play("cheer")
	Pause.get_item("Sand")
	yield(get_tree().create_timer(3.5), "timeout")
	$joy.visible = false
	self.play("idle")
	Pause.hide_items()

func play_get_hair():
	$bubble.play("Speachless")
	$subject.play("String")
	$mark.play("Question")
	
	$bubble.visible = true
	yield(get_tree().create_timer(2.5), "timeout")
	$bubble.play("Talk")
	$mark.visible = true
	$subject.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$bubble.visible = false
	$mark.visible = false
	$subject.visible = false
	
	$give.position = Vector2(25, -10)
	$give.play("String")
	$give.visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	$give.visible = false
	
	Pause.get_item("String")
	get_parent().get_node("Foxy/FoxySprite").play("Bark")
	yield(get_tree().create_timer(3.5), "timeout")
	Pause.hide_items()
	
func play_joy():
	$joy.visible = true
	self.play("cheer")
	yield(get_tree().create_timer(2.2), "timeout")
	$joy.visible = false
	self.play("idle")

func _process(delta):
	if $give.visible:
		if $give.animation == "Sand" :
			$give.position.x -= delta*15
			$give.position.y = -20 + (sqrt(pow(30-$give.position.x, 2)))
		elif $give.animation == "String" :
			$give.position.x += delta*15
			$give.position.y = -20 + (sqrt(pow(38-$give.position.x, 2)))
