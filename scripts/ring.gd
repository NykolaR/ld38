extends Spatial

var dead = false
onready var animation = get_node("animation")
onready var sound = get_node("sound")

var init

func _ready():
	init = get_scale()

func reset():
	dead = false
	animation.set_current_animation("collected")
	animation.stop()
	set_hidden(false)
	set_scale(init)

func _on_collision_body_enter( body ):
	if not dead:
		dead = true
		animation.set_current_animation("collected")
		animation.play()
		sound.play("hoop")
		if body.has_method("_expand"):
			body._expand()

func _on_animation_finished():
	set_hidden(true)
