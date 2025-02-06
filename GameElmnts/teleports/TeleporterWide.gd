tool

extends Area2D

export(String, FILE) var to_scene = ""
export(int) var to_x = 0
export(int) var to_y = 0

func _get_configuration_warning() -> String:
	if to_scene == "":
		return "ERROR: empty destination scene (to_scene)"
	else :
		return ""


func _on_PortalWide_body_entered(body):
	print("entered !!")
	var diff = self.position - body.position
	
	GlobalScene.pos = Vector2(to_x-diff.x, to_y)
	GlobalScene.motion = body.motion
	GlobalScene.flip = body.get_sprite().flip_h
	GlobalScene.animation = body.get_sprite().animation
	GlobalScene.was_hit = body.ouch_tic > 0
	
	# var new_pos = Vector2(to_x, to_y-diff.y)
	print("going to : ")
	print(diff)
	if get_tree().change_scene(to_scene) != OK :
		# Error handling if missed transition
		print("ERROR: couldn't change scene (get_tree().change_scene("+to_scene+"))")	
