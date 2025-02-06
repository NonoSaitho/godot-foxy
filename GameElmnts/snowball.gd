extends KinematicBody2D

const UP = Vector2(0, -1)

const GRAVITY = 1800
const MAX_SPEED = 500

var motion = Vector2()

func disable():
	$CollisionShape.disabled = true

func _process(delta):
	
	motion.y += GRAVITY*delta
	
	## side motion
	if motion.x > 0:
		motion.x -= 100*delta
		if motion.x < 0:
			motion.x = 0
	elif motion.x < 0:
		motion.x += 100*delta
		if motion.x > 0:
			motion.x = 0
	
	## limit speed
	if motion.y > MAX_SPEED*2:
		motion.y = MAX_SPEED*2
	elif motion.y < -MAX_SPEED*2:
		motion.y = -MAX_SPEED*2
	
	motion = move_and_slide(motion, UP)
	
	## collision checks
	for idx in get_slide_count():
		var collison = get_slide_collision(idx)
		if "Foxy" in collison.collider.name :
			collison.collider.getHit(false)
			disable()
