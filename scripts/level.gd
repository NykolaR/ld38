extends Spatial

onready var rings = get_node("rings")

func _ready():
	pass

func reset():
	for i in range (rings.get_child_count()):
		rings.get_child(i).reset()