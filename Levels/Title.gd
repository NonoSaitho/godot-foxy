extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScene.play_music("Title")


func start():
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().change_scene("res://Levels/GreenHill1.tscn")
	GlobalScene.pausable = true

func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		start()
	elif event.is_action_pressed("ui_home"):
		get_tree().quit()

func _on_ButtonStart_pressed():
	start()


func _on_ButtonQuit_pressed():
	get_tree().quit()
