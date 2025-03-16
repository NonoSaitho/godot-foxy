extends CanvasLayer

var blinkable = false
var blinker = 5

func pause(pause):
	for node in get_children():
		node.visible = pause
	get_tree().paused = pause
	$ItemIceBox.position.y = 0
	$ItemSandBox.position.y = 0
	$ItemShovelBox.position.y = 0
	$ItemStringBox.position.y = 0
	
	if (pause):
		$SoundGroup/MenuDwn.play()
	else :
		$SoundGroup/MenuUp.play()

func process_box(itemBox, delta):
	if itemBox.position.y < 80 and itemBox.visible :
		itemBox.position.y += delta * 400
	if (itemBox.position.y > 80) :
		itemBox.position.y = 80
	
	if itemBox.position.y == 80 and blinkable :
		blinker -= delta * 10
		if blinker < 0 :
			itemBox.visible = !itemBox.visible
			blinker = 5

func _process(delta):
	process_box($ItemIceBox, delta)
	process_box($ItemSandBox, delta)
	process_box($ItemShovelBox, delta)
	process_box($ItemStringBox, delta)
	
func get_item(item):
	blinkable = true
	var itemBox = null
	if item == "Ice":
		itemBox = $ItemIceBox
		$ItemIceBox/ItemIce.visible = true
		GlobalScene.ice += 1
		if GlobalScene.ice >= 2 :
			GlobalScene.ice = 2
			$ItemIceBox/ItemIceOK.visible = true
	elif item == "Sand":
		itemBox = $ItemSandBox
		$ItemSandBox/ItemSand.visible = true
		GlobalScene.sand += 1
		if GlobalScene.sand >= 2 :
			GlobalScene.sand = 2
			$ItemSandBox/ItemSandOK.visible = true
	elif item == "Shovel":
		itemBox = $ItemShovelBox
		$ItemShovelBox/ItemShovel.visible = true
		GlobalScene.shovel += 1
		if GlobalScene.shovel >= 2 :
			GlobalScene.shovel = 2
			$ItemShovelBox/ItemShovelOK.visible = true
	elif item == "String":
		itemBox = $ItemStringBox
		$ItemStringBox/ItemString.visible = true
		GlobalScene.hair += 1
		if GlobalScene.hair >= 2 :
			GlobalScene.hair = 2
			$ItemStringBox/ItemStringOK.visible = true
	else :
		return
	
	itemBox.position.y = -80
	itemBox.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$SoundGroup/ItemGet.play()

func hide_items():
	blinkable = false
	for node in get_children():
		node.visible = false
	$ItemIceBox.position.y = 0
	$ItemSandBox.position.y = 0
	$ItemShovelBox.position.y = 0
	$ItemStringBox.position.y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		node.visible = false

func exit():
	GlobalScene.pos = null
	get_tree().change_scene("res://Levels/Title.tscn")
	GlobalScene.pausable = false
	pause(false)
	GlobalScene.ice = 0
	$ItemIceBox/ItemIce.visible = false
	$ItemIceBox/ItemIceOK.visible = false
	GlobalScene.shovel = 0
	$ItemShovelBox/ItemShovel.visible = false
	$ItemShovelBox/ItemShovelOK.visible = false
	GlobalScene.hair = 0
	$ItemStringBox/ItemString.visible = false
	$ItemStringBox/ItemStringOK.visible = false
	GlobalScene.sand = 0
	$ItemSandBox/ItemSand.visible = false
	$ItemSandBox/ItemSandOK.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel") && GlobalScene.pausable && !GlobalScene.isCutScene :
		pause(!get_tree().paused)
	elif event.is_action_pressed("ui_home") && get_tree().paused:
		exit()

func _on_ButtonRes_pressed():
	pause(!get_tree().paused)

func _on_ButtonMM_pressed():
	exit()
