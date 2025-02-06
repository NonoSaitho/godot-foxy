extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Cotillon1.emitting = false
	$Cotillon2.emitting = false

func play():
	$Cotillon1.emitting = true
	$Cotillon2.emitting = true
	yield(get_tree().create_timer(2.0), "timeout")
	$Cotillon1.emitting = false
	$Cotillon2.emitting = false
