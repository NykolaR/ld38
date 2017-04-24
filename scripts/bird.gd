extends KinematicBody

export var minheight = 0.4
export var maxheight = 2
export var speed = 1
export var max_rot = 1
var changingplanets = false

var rotate = 0

onready var ray_d = get_node("raycast_d")
onready var ray_dl = get_node("raycast_dl")
onready var ray_f = get_node("raycast_f")
onready var animation = get_node("animation")
onready var bird = get_node("bird_mesh")
onready var camera = get_node("camera")
onready var camera_camera = get_node("camera/camera")
onready var planetcast = get_node("camera/planetcast")
onready var bigbird = get_node("bigbird")

signal _planet_change

var planet
var camera_r
var camera_t

func _ready():
	ray_d.set_cast_to(Vector3(0, minheight * -1, 0))
	ray_dl.set_cast_to(Vector3(0, maxheight * -1, 0))
	
	set_fixed_process(true)
	set_process(true)
	set_process_input(true)
	
	camera_r = camera.get_rotation()
	camera_t = camera_camera.get_translation()

func _input(event):
	if changingplanets:
		return
	if event.is_action_pressed("flap") and ray_dl.is_colliding():
		if not animation.is_playing():
			animation.set_current_animation("flap")
			animation.play()

func _expand():
	camera_camera.translate(Vector3(0,0,0.8))
	planetcast.translate(Vector3(0,-0.2,0))

func _process(delta):
	_planets()
	if changingplanets:
		animation.stop()
	
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_right"):
			rotate += 0.02
			rotate = min(rotate, max_rot)
		if Input.is_action_pressed("ui_left"):
			rotate -= 0.02
			rotate = max(rotate, -max_rot)
	else:
		if rotate < 0:
			rotate += 0.04
			if rotate > 0:
				rotate = 0
		if rotate > 0:
			rotate -= 0.04
			if rotate < 0:
				rotate = 0
	
	if Input.is_action_pressed("ui_down") and not ray_d.is_colliding() and not ray_f.is_colliding() and not animation.is_playing():
		rotate_x(-0.2 * delta)
	
	bird.set_rotation(Vector3(0,0,rotate * 0.4))
	camera.set_rotation(camera_r + Vector3(0,-rotate * 0.2,-rotate * 0.3))
	rotate_y(rotate * delta)

func _planets():
	if planetcast.is_colliding() and not changingplanets:
		if planet == null:
			planet = planetcast.get_collider()
		
		if not planet == planetcast.get_collider():
			bigbird.set_hidden(false)
			speed = 0.1
			
			if Input.is_action_pressed("flap"):
				changingplanets = true
				planet = planetcast.get_collider()
				emit_signal("_planet_change")
		else:
			bigbird.set_hidden(true)
			speed = 1
	else:
		if not changingplanets:
			bigbird.set_hidden(true)
			speed = 1
		else:
			bigbird.set_hidden(false)
			speed = 0.1

func _fixed_process(delta):
	if ray_d.is_colliding() or ray_f.is_colliding():
		rotate_x(1 * delta)
	elif animation.is_playing():
		if animation.get_pos() > 0.3:
			move(get_transform().basis.y * delta * 1.5)
	else:
		move(get_transform().basis.y * delta * -0.01)
		rotate_x(-0.08 * delta)
	
	move(get_transform().basis.z * delta * speed)

func _change_planet():
	changingplanets = false
	animation.set_current_animation("flap")
	animation.stop()
	set_translation(planet.get_node("spawn").get_global_transform().origin)
	set_rotation(Vector3())
	
	rotate = 0
	speed = 1
	camera_camera.set_translation(camera_t)
	planetcast.set_translation(Vector3())