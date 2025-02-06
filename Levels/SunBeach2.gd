extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var clamDestination
var trigger = false

# Called when the node enters the scene tree for the first time.
func _ready():
	clamDestination = 145
	if GlobalScene.isCutScene :
		$Level/Clam.position.x = 0
		
		$Level/Foxy.position.x = 16
		$Level/Foxy.position.y = 160
		$Level/Foxy.flip(false)
		
		trigger = true
	else :
		$Level/Clam.position.x = 145
		
func clamEntered(foxy):
	if GlobalScene.isCutScene :
		foxy.cut_scene = true
		foxy.initCutScene(null, null, null)
		foxy.get_node("FoxySprite").play("Idle")
	else :
		GlobalScene.playCutScene(true)
		foxy.initCutScene(true, null, null)
		foxy.get_node("FoxySprite").play("Idle")
		clamDestination = 0
		trigger = true


# Called every frame. 'delta' is the elapsed time since the previous frame.l
func _process(delta):
	if $Level/Clam.position.x != clamDestination :
		var shift = delta * 50
		if $Level/Clam.position.x > clamDestination:
			$Level/Clam.position.x -= shift
			$Level/Foxy.position.x -= shift
			if $Level/Clam.position.x < clamDestination:
				$Level/Clam.position.x = clamDestination
		elif $Level/Clam.position.x < clamDestination:
			$Level/Clam.position.x += shift
			$Level/Foxy.position.x += shift
			if $Level/Clam.position.x > clamDestination:
				$Level/Clam.position.x = clamDestination
	elif trigger:
		if clamDestination == 145 :
			trigger = false
			GlobalScene.playCutScene(false)
		else :
			trigger = false
			get_tree().change_scene("res://Levels/SunBeach1.tscn")
