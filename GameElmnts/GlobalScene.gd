extends CanvasLayer

var pos
var motion
var flip
var animation
var was_hit
var fox

var ice = 0
var shovel = 0
var hair = 0
var sand = 0

var pausable = false

var isCutScene = false
var currentFoxy
var queueMusic
var currentMusic

var clam_out = false

func playCutScene(active):
	isCutScene = active
	currentFoxy.cut_scene = isCutScene
	
	## set borders
	if (isCutScene):
		if currentMusic != null:
			currentMusic.volume_db = -20
		$ColorRectTop.rect_position.y = -152
		$ColorRectBottom.rect_position.y = 569+152
	else :
		if currentMusic != null:
			currentMusic.volume_db = -8
		$ColorRectTop.rect_position.y = 0
		$ColorRectBottom.rect_position.y = 569

func play_music(music):
	if music == "BandMusic":
		queueMusic = $Musics/BandMusic
	elif music == "GreenHill":
		queueMusic = $Musics/GreenHill
	elif music == "SunBeach":
		queueMusic = $Musics/SunBeach
	elif music == "TallForest":
		queueMusic = $Musics/TallForest
	elif music == "Title":
		queueMusic = $Musics/Title
	elif music == "UnderCaves":
		queueMusic = $Musics/UnderCaves
	elif music == "WhiteMount":
		queueMusic = $Musics/WhiteMount
	else :
		queueMusic = null
	if queueMusic != null:
		queueMusic.volume_db = -8
	

func _process(delta):
	## music stuff
	if queueMusic != currentMusic:
		if currentMusic == null:
			currentMusic = queueMusic
			if currentMusic != null:
				currentMusic.play()
		else :
			currentMusic.volume_db -= 40*delta
			if currentMusic.volume_db < -50:
				currentMusic.stop()
				currentMusic = null;
			
	
	## cut scene stuff
	if (isCutScene) :
		if $ColorRectTop.rect_position.y < 0:
			$ColorRectTop.rect_position.y += delta * 500
			if $ColorRectTop.rect_position.y > 0:
				$ColorRectTop.rect_position.y = 0
		if $ColorRectBottom.rect_position.y > 569:
			$ColorRectBottom.rect_position.y -= delta * 500
			if $ColorRectBottom.rect_position.y < 569:
				$ColorRectBottom.rect_position.y = 569
	else :
		if $ColorRectTop.rect_position.y > -152:
			$ColorRectTop.rect_position.y -= delta * 500
			if $ColorRectTop.rect_position.y < -152:
				$ColorRectTop.rect_position.y = -152
		if $ColorRectBottom.rect_position.y < 569+152:
			$ColorRectBottom.rect_position.y += delta * 500
			if $ColorRectBottom.rect_position.y > 569+152:
				$ColorRectBottom.rect_position.y = 569+152

func check_finish():
	if ice == 2 and shovel == 2 \
		and hair == 2 and sand == 2 :
		yield(get_tree().create_timer(0.8), "timeout")
		self.playCutScene(true)
		currentFoxy.initCutScene(null, null, null)
		currentFoxy.get_node("FoxySprite").playing = false
		Pause.get_item("Ice")
		Pause.get_item("Sand")
		Pause.get_item("Shovel")
		Pause.get_item("String")
		yield(get_tree().create_timer(2.2), "timeout")
		$Finish.play()
		$Cotillons.play()
		yield(get_tree().create_timer(1.5), "timeout")
		$Finish2.play()
		yield(get_tree().create_timer(1.5), "timeout")
		self.playCutScene(false)
		currentFoxy.get_node("FoxySprite").playing = true
		Pause.hide_items()
