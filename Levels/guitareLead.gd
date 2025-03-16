extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ruckus = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	check_play()

func check_play():
	if GlobalScene.hair > 1:
		get_parent().get_node("drummer").play("playing")
		get_parent().get_node("flutist").play("playing")
		get_parent().get_node("guitare").play("playing")
		play("playing")
		$BandSong.play()

func talk():
	if GlobalScene.hair < 2:
		get_parent().get_node("Foxy").initCutScene(true, 972, 730)
		GlobalScene.playCutScene(true)
		yield(get_tree().create_timer(1.0), "timeout")
		yield(play_ask_Hair(), "completed")
		if GlobalScene.hair == 1:
			yield(play_give_hair(), "completed")
		if GlobalScene.shovel < 1:
			yield(play_get_shovel(), "completed")
		GlobalScene.playCutScene(false)
		GlobalScene.check_finish()
		check_play()
	else :
		play_joy() 
	
func play_ask_Hair():
	$bubble.play("Speachless")
	$subject.play("NoMusic")
	$mark.play("Excl")
	
	$bubble.visible = true
	yield(get_tree().create_timer(2.5), "timeout")
	$bubble.play("Talk")
	$subject.visible = true
	yield(get_tree().create_timer(1.2), "timeout")
	$subject.play("Guitare")
	$mark.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$bubble.visible = false
	$subject.visible = false
	$mark.visible = false
	
func play_give_hair():
	$bubble.play("Talk")
	$subject.play("String")
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
	
	$give.position = Vector2(26, -2)
	$give.play("String")
	$give.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$give.visible = false
	
	$joy.visible = true
	Pause.get_item("String")
	yield(get_tree().create_timer(3.5), "timeout")
	$joy.visible = false
	Pause.hide_items()

func play_get_shovel():
	$subject.play("Shovel")
	$mark.play("Question")
	yield(get_tree().create_timer(0.5), "timeout")
	$bubble.visible = true
	$subject.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$mark.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$mark.visible = false
	$subject.visible = false
	$bubble.visible = false
	
	$give.position = Vector2(5, -2)
	$give.play("Shovel")
	$give.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$give.visible = false
	
	Pause.get_item("Shovel")
	get_parent().get_node("Foxy/FoxySprite").play("Bark")
	yield(get_tree().create_timer(3.5), "timeout")
	Pause.hide_items()
	
func play_joy():
	$ruckus.visible = true
	$ruckus2.visible = true
	$ruckus3.visible = true
	$BandSong.volume_db = 20
	ruckus = 100
	
func _process(delta):
	if ruckus > 0 :
		ruckus -= delta*30
		if ruckus < 0 :
			ruckus = 0
			$BandSong.volume_db = 10
			$ruckus.visible = false
			$ruckus2.visible = false
			$ruckus3.visible = false
	
	if $give.visible:
		if $give.animation == "String" :
			$give.position.x -= delta*15
			$give.position.y = -8 + (sqrt(pow(12-$give.position.x, 2)))
		elif $give.animation == "Shovel" :
			$give.position.x += delta*15
			$give.position.y = -4 + (sqrt(pow(12-$give.position.x, 2)))
