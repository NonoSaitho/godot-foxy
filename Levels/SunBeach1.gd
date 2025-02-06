extends Node2D

const high_clam = 156

var clamDestination = 314
var trigger = false

func _ready():
	clamDestination = 314
	if GlobalScene.isCutScene :
		$Level/Clam.position.x = 540
		$Level/Clam.position.y = high_clam
		get_node("Level/talking_area/CollisionShape2D").disabled = true
		get_node("Level/Clam/ClamGround").disabled = false
		get_node("Level/Clam/ClamSpr/ClamArea/ClamInterract").disabled = false
		
		$Level/Foxy.position.x = 554
		$Level/Foxy.position.y = high_clam
		$Level/Foxy.flip(true)
		
		trigger = true
	elif GlobalScene.clam_out :
		$Level/Clam.position.y = high_clam
		get_node("Level/talking_area/CollisionShape2D").disabled = true
		get_node("Level/Clam/ClamGround").disabled = false
		get_node("Level/Clam/ClamSpr/ClamArea/ClamInterract").disabled = false
		GlobalScene.clam_out = false
		

func _process(delta):
	if $Level/Clam/ClamGround.disabled == false :
		var posY = $Level/Clam.position.y
		if posY > high_clam :
			print("up the clam !!")
			var shift = delta * 30
			posY -= shift
			if posY < high_clam :
				posY = high_clam
			$Level/Clam.position.y = posY
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
		if clamDestination == 314 :
			trigger = false
			GlobalScene.playCutScene(false)
		else :
			trigger = false
			get_tree().change_scene("res://Levels/SunBeach2.tscn")
	

func clamEntered(foxy):
	if GlobalScene.isCutScene :
		foxy.cut_scene = true
		foxy.initCutScene(true, null, null)
		foxy.get_node("FoxySprite").play("Idle")
	else :
		GlobalScene.playCutScene(true)
		foxy.initCutScene(false, null, null)
		foxy.get_node("FoxySprite").play("Idle")
		clamDestination = 540
		trigger = true
