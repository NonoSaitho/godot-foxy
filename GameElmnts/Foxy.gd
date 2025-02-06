extends KinematicBody2D

const UP = Vector2(0, -1)

const GRAVITY = 1800
const SPEED_INCR = 2000
const MAX_SPEED = 600
const JUMP_HEIGHT = -600
const JUMP_DOUBLE = -400

var motion = Vector2()
var tic = 0
var last_ground = 0.1
var second_jump = true
var ouch_tic = 0
var actionnable = true
var cut_scene = false

## POWERS :
## double jump
## speak with animals
## fox vision
## climbing

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_sprite():
	return $FoxySprite

func flip(flip):
	$FoxySprite.flip_h = flip
	$FoxyTailR.visible = !flip
	$FoxyTailL.visible = flip
	$KnotR.visible=!flip
	$KnotL.visible=flip

func initCutScene(flip, x, y):
	if flip != null :
		flip(flip)
	if x != null:
		position.x = x
	if y != null:
		position.y = y
	motion.x = 0
	motion.y = 0

func update_sprite(animation, flip):
	$FoxySprite.play(animation)
	flip(flip)

func _on_FoxySprite_frame_changed():
	if $FoxySprite.animation == "Run" and $FoxySprite.frame == 1:
		$Run.play()
	
	if $FoxySprite.animation == "Bark":
		if $FoxySprite.frame == 1:
			$Bark.play()
		if $FoxySprite.frame == 3:
			$Bark.play()

func spawnPoof():
	var poofy = $Poof.duplicate()
	var timer = Timer.new()
	get_parent().add_child(poofy)
	poofy.add_child(timer)
	poofy.visible = true
	poofy.position = self.position
	poofy.frame = 0
	
	poofy.play("Poof")
	
	timer.connect("timeout", poofy, "queue_free")
	timer.set_wait_time(2)
	timer.start()
	print("child count = ", get_parent().get_child_count())

func set_cutscene(boolean):
	cut_scene = boolean
	
func getHit(silence):
	if !silence:
		$Hit.play()
	if ouch_tic == 0:
		print("i'm hit")
		ouch_tic = 0.5
		$CollisionShape.disabled = true
		actionnable = false
		$FoxySprite.play("Ouch")

func reactionnable():
	$FoxySprite.play("Idle")
	actionnable = true

func blink():
	self.modulate.a = 0.3 if Engine.get_frames_drawn() % 2 == 0 else 1.0
	
func update_tail():
	
	var tail_motion = Vector2()
	var angle_shift = 0
	
	if motion.x == 0 and motion.y == 0:
		## FoxyTailL
		## if we flip when x=0, angle becomes 180
		tail_motion.x = motion.x
		tail_motion.y = motion.y
	elif $FoxySprite.flip_h:
		## FoxyTailL
		tail_motion.x = -motion.x
		tail_motion.y = motion.y
		angle_shift = 20
	else :
		tail_motion.x = motion.x
		tail_motion.y = motion.y
		angle_shift = 20
	
	var tail_angle = rad2deg(tail_motion.angle())
	tail_angle = tail_angle + angle_shift
	
	if $FoxySprite.flip_h:
		## FoxyTailL
		$FoxyTailL.set_rotation_degrees(-tail_angle)
	else :
		## FoxyTailR
		$FoxyTailR.set_rotation_degrees(tail_angle)

func drift(delta):
	if motion.x > 0:
		motion.x -= GRAVITY*delta
		if motion.x < 0:
			motion.x = 0
	elif motion.x < 0:
		motion.x += GRAVITY*delta
		if motion.x > 0:
			motion.x = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##print("1. motion : ", motion)
	update_tail()
	
	motion.y += GRAVITY*delta
	
	if ouch_tic > 0:
		blink()
		ouch_tic -= delta
		if ouch_tic <= 0 :
			print("end of ouch_tic !")
			ouch_tic = 0
			if $FoxySprite.animation != "Ouch":
				print("end of invincibility !")
				self.modulate.a = 1.0
			else :
				print("little bit of invincibility !")
	
	if actionnable && !cut_scene:
		## Barking
		if Input.is_action_just_pressed("ui_select"):
			if is_on_floor():
				$FoxySprite.play("Bark")
				actionnable = false
				var val = "True" if cut_scene else "False"
				print("cut scene is at "+val)
				print("Bark !")
#				for body in $Area2D.get_overlapping_bodies():
#					if body.has_method("interact"):
#						body.interact()
				for area in $talk.get_overlapping_areas():
					if area.has_method("call_talk") and !cut_scene :
						area.call_talk()

		## running & floating
		elif Input.is_action_pressed("ui_right"):
			motion.x += SPEED_INCR*delta
			flip(false)
			if is_on_floor() and $FoxySprite.animation != "Run":
				$FoxySprite.play("Run")
		elif Input.is_action_pressed("ui_left"):
			motion.x -= SPEED_INCR*delta
			flip(true)
			if is_on_floor() and $FoxySprite.animation != "Run":
				$FoxySprite.play("Run")
		else :
			## idling
			if motion.x == 0 :
				if is_on_floor() and $FoxySprite.animation != "Idle":
					$FoxySprite.play("Idle")
			else :
				## stopping
				drift(delta)
		
		if is_on_floor():
			if last_ground <= 0 :
				$Land.play()
			last_ground = 0.1
			second_jump = true
		else :
			if last_ground > 0:
				last_ground -= delta
			if tic <= 0 and motion.y > 50 : ## avoid engine fake fall
				$FoxySprite.play("Fall")
		
		## JUMPING !!
		## Coyotte jump
		if is_on_floor() or last_ground > 0 :
			if Input.is_action_just_pressed("ui_up") :
				motion.y = JUMP_HEIGHT
				$FoxySprite.play("Jump")
				$Jump.play()
				tic = 0.25 ## tic is to keep jumping
		elif second_jump:
			if Input.is_action_just_pressed("ui_up"):
				second_jump = false
				print("double jump !!")
				motion.y = JUMP_DOUBLE
				$FoxySprite.play("Jump")
				$Jump.play()
				spawnPoof()
				tic = 0.25 ## tic is to keep jumping
		
		if Input.is_action_just_pressed("ui_down") :
			position.y +=1 ## drop down from one way collision tile
		
		if tic > 0:
			if Input.is_action_pressed("ui_up"):
				motion.y -= GRAVITY*delta
			tic -= delta ## keep jumping
			if Input.is_action_just_released("ui_up"):
				print("reset tic at", tic)
				tic = 0 ## stop jumping
		
	else :
		drift(delta)
		if $FoxySprite.animation == "Bark":
			if $FoxySprite.frame == 4:
				# animation end
				reactionnable()
				print("bark end")
		elif $FoxySprite.animation == "Ouch":
			if ouch_tic == 0 :
				ouch_tic = 0.5
				$CollisionShape.disabled = false
				reactionnable()
				print("ouch end")
	
	## limit speed
	if motion.x > MAX_SPEED:
		motion.x = MAX_SPEED
	elif motion.x < -MAX_SPEED:
		motion.x = -MAX_SPEED
	if motion.y > MAX_SPEED*2:
		motion.y = MAX_SPEED*2
	elif motion.y < -MAX_SPEED*2:
		motion.y = -MAX_SPEED*2
	
	if (!cut_scene) :
		motion = move_and_slide(motion, UP)
	else :
		motion = Vector2()
	
	## collision checks
	for idx in get_slide_count():
		var collison = get_slide_collision(idx)
		if "snowball" in collison.collider.name :
			getHit(false)
			collison.collider.disable()
