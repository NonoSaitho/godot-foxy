extends Sprite

func _ready():
	if GlobalScene.shovel > 1:
		self.visible = true
