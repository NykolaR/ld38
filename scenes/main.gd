extends Spatial

onready var player = get_node("bird")
onready var animation = get_node("animation")
onready var levels = get_node("levels")

func _ready():
	player.connect("_planet_change", self, "_whipe")

func _whipe():
	#animation.set_current_animation("whipe")
	animation.play("whipe")

func reset():
	for i in range (levels.get_child_count()):
		levels.get_child(i).reset()