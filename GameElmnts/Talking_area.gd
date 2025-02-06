extends Area2D

export(NodePath) var talkingNode = ""

func _get_configuration_warning() -> String:
	if talkingNode == "":
		return "ERROR: empty targetNode"
	elif !talkingNode.has_method("talk"):
		return "ERROR: no talk method on target Node"
	else :
		return ""

# Called when the node enters the scene tree for the first time.
func call_talk():
	get_node(talkingNode).talk()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
