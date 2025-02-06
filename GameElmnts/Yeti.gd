extends Node2D

const TOSS_HEIGHT = 600
const TOSSING_ARRAY_REF = [10,10,20,20,30,30]

var throw_new_ball = 1
var toss_side = true
var tossing_array = [5,5]

func _ready():
	if GlobalScene.shovel > 1:
		$AnimatedSprite.play("shovel")
		self.position.x += 20
	elif GlobalScene.ice > 0:
		$AnimatedSprite.play("idle")

func talk():
	$AnimatedSprite.play("idle")
	if GlobalScene.shovel < 2:
		get_parent().get_node("Foxy").initCutScene(false, 108, null)
		GlobalScene.playCutScene(true)
		yield(get_tree().create_timer(1.0), "timeout")
		yield(play_ask_Igloo(), "completed")
		if GlobalScene.shovel == 1:
			yield(play_give_shovel(), "completed")
		if GlobalScene.ice < 1:
			yield(play_get_ice(), "completed")
		GlobalScene.playCutScene(false)
		GlobalScene.check_finish()
	else :
		play_joy() 
	
func play_ask_Igloo():
	$subject.play("Igloo")
	$mark.play("Question")
	
	$joy.visible = true
	$AnimatedSprite.play("joy")
	$grunt.play()
	yield(get_tree().create_timer(2.2), "timeout")
	$joy.visible = false
	$AnimatedSprite.play("idle")
	
	$bubble.visible = true
	$subject.visible = true
	$grunt.play()
	yield(get_tree().create_timer(2.0), "timeout")
	$mark.visible = true
	$grunt.play()
	yield(get_tree().create_timer(1.5), "timeout")
	$mark.visible = false
	$subject.visible = false
	$bubble.visible = false

func play_give_shovel():
	$subject.play("Shovel")
	$mark.play("Excl")
	
	get_parent().get_node("Foxy/FoxySprite").play("Bark")
	yield(get_tree().create_timer(1.0), "timeout")
	$bubble.visible = true
	$subject.visible = true
	$mark.visible = true
	$grunt.play()
	yield(get_tree().create_timer(1.5), "timeout")
	$bubble.visible = false
	$subject.visible = false
	$mark.visible = false
	
	$joy.visible = true
	$AnimatedSprite.play("joy")
	$grunt.play()
	Pause.get_item("Shovel")
	yield(get_tree().create_timer(3.5), "timeout")
	$joy.visible = false
	$AnimatedSprite.play("idle")
	Pause.hide_items()
	
	
func play_get_ice():
	$subject.play("Ice")
	$mark.play("Excl")
	
	$bubble.visible = true
	$subject.visible = true
	$mark.visible = true
	$grunt.play()
	yield(get_tree().create_timer(1.5), "timeout")
	$grunt.play()
	$mark.play("Question")
	yield(get_tree().create_timer(1.0), "timeout")
	$mark.visible = false
	$subject.visible = false
	$bubble.visible = false
	Pause.get_item("Ice")
	get_parent().get_node("Foxy/FoxySprite").play("Bark")
	yield(get_tree().create_timer(3.5), "timeout")
	Pause.hide_items()
	
func play_joy():
	$joy.visible = true
	$AnimatedSprite.play("joy")
	yield(get_tree().create_timer(2.2), "timeout")
	$joy.visible = false
	if self.position.x > 145 : 
		$AnimatedSprite.play("shovel")
	else :
		$AnimatedSprite.play("idle")

func spawnSnowball(toss_val, toss_side):
	var scene = load("res://GameElmnts/snowball.tscn")
	var snow_ball = scene.instance()
	snow_ball.set_name("snowball")
	add_child(snow_ball)
	var timer = Timer.new()

	snow_ball.add_child(timer)
	snow_ball.visible = true
	if toss_side :
		snow_ball.position.x += 20
		snow_ball.motion.x += toss_val*10
		snow_ball.motion.y -= TOSS_HEIGHT
	else :
		snow_ball.position.x -= 20
		snow_ball.motion.x -= toss_val*10
		snow_ball.motion.y -= TOSS_HEIGHT
	
	timer.connect("timeout", snow_ball, "queue_free")
	timer.set_wait_time(5)
	timer.start()
	$throw_ball.play()
	print("child count = ", self.get_child_count())

func _process(delta):
	if $AnimatedSprite.animation == "juggling":
		throw_new_ball -= delta
		if throw_new_ball <= 0 :
			throw_new_ball = 1
			spawnSnowball(tossing_array.pop_front(), toss_side)
			toss_side = !toss_side
			## print("toss !")
			if tossing_array.size() == 0 :
				## print("refurnish tossing array")
				tossing_array.append_array(TOSSING_ARRAY_REF)
				## randomiser
				tossing_array.shuffle()
				tossing_array.pop_front()
				tossing_array.pop_front()
				## print("tossing array : ", tossing_array)
		
		
