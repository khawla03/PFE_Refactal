class_name Player
extends KinematicBody


signal exit_coding(player)
signal resumed(player)
signal discover_mode(enabled)
signal look_at_item(item_name)
signal Hint(player)

###################-VARIABLES-####################

# Camera
export(float) var mouse_sensitivity = 8.0
export(NodePath) var head_path = "Head"
export(NodePath) var cam_path = "Head/Camera"
export(float) var FOV = 80.0
var mouse_axis := Vector2()
var cursor_pressed := false
var cursor_start_position : Vector2
onready var head: Spatial = get_node(head_path)
onready var cam: Camera = get_node(cam_path)
# Move
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var snap := Vector3()
var sprint_enabled := true
var sprinting := false
# Walk
const FLOOR_MAX_ANGLE: float = deg2rad(46.0)
export(float) var gravity = 30.0
export(int) var walk_speed = 10
export(int) var sprint_speed = 16
export(int) var acceleration = 8
export(int) var deacceleration = 10
export(float, 0.0, 1.0, 0.05) var air_control = 0.3
export(int) var jump_height = 10
var _speed: int
var _is_sprinting_input := false
var _is_jumping_input := false
# Screen touch control
const MIN_DRAG = 50
const CLICK_TIMEOUT = 200
var _is_pressing := false
var _press_start : Vector2
var _move_index := -1
var _mid_screen_x := 0.0
var _last_touch_press := 0
# Interaction
var is_interacting := false
# Discover mode
var is_discover_mode := false
# onready
onready var hud := $HUD
onready var menu = $InGameMenu
onready var interactionRay := $Head/Camera/AimRayCast/InteractionRayCast
onready var anim = $Animations


########################-BUILT-IN METHODS##########################


# Called when the node enters the scene tree
func _ready() -> void:
	if is_interacting:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = FOV
	cam.current = true
	_mid_screen_x = get_viewport().size.x / 2


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	mouse_axis.x = (Input.get_action_strength("look_right") - Input.get_action_strength("look_left")) * mouse_sensitivity * 1.5
	mouse_axis.y = (Input.get_action_strength("look_down") - Input.get_action_strength("look_up")) * mouse_sensitivity * 1.5
	

#	if Input.is_action_just_pressed("move_jump"):
#		_is_jumping_input = true
#
#	if Input.is_action_pressed("move_sprint"):
#		_is_sprinting_input = true
	pass


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	walk(delta)
	if mouse_axis != Vector2.ZERO:
		camera_rotation(true)


# Called when there is an input event
func _input(event: InputEvent) -> void:
	if is_interacting:
		return
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		camera_rotation(false)
	if event.is_action("discover_mode"):
		set_discover_mode(event.is_pressed())
	check_interaction(event)
	_check_screen_inputs(event)


func _unhandled_input(event):
	if event.is_action_pressed("exit"):
		if menu.visible:
			menu.hide()
			emit_signal("resumed", self)
		elif is_interacting:
			emit_signal("exit_coding", self)
		else:
			menu.show()
			focus_mode(true)
			ActionsData.save_action('Level paused','')
	if event.is_action_pressed("ui_hint"):
		ActionsData.save_action('Hint Opened','')
		focus_mode(true)
		emit_signal("Hint",self)
		pass

########################-MOUVEMENT METHODS##########################


func walk(delta: float) -> void:
	if is_interacting:
		return
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		jump()
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	sprint(delta)
	
	accelerate(delta)
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, FLOOR_MAX_ANGLE)
	_is_jumping_input = false
	_is_sprinting_input = false


func camera_rotation(from_screen :  bool) -> void:
	if not from_screen and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()


func accelerate(delta: float) -> void:
	# Where would the player go
	var _temp_vel: Vector3 = velocity
	var _temp_accel: float
	var _target: Vector3 = direction * _speed
	
	_temp_vel.y = 0
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
		
	else:
		_temp_accel = deacceleration
	
	if not is_on_floor():
		_temp_accel *= air_control
	
	# Interpolation
	_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	
	# Make too low values zero
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.01
		if abs(velocity.x) < _vel_clamp:
			velocity.x = 0
		if abs(velocity.z) < _vel_clamp:
			velocity.z = 0


func jump() -> void:
	if _is_jumping_input:
		velocity.y = jump_height
		snap = Vector3.ZERO


func sprint(delta: float) -> void:
	if can_sprint():
		_speed = sprint_speed
		cam.set_fov(lerp(cam.fov, FOV * 1.05, delta * 8))
		sprinting = true
		
	else:
		_speed = walk_speed
		cam.set_fov(lerp(cam.fov, FOV, delta * 8))
		sprinting = false


func can_sprint() -> bool:
	return (sprint_enabled and is_on_floor() and _is_sprinting_input and move_axis.x >= 0.5)


func _check_screen_inputs(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			_last_touch_press = OS.get_ticks_msec()
			if event.position.x < _mid_screen_x:
				_press_start = event.position
				_is_pressing = true
				_move_index = event.index
		else:
			if (OS.get_ticks_msec() - _last_touch_press) <= CLICK_TIMEOUT:
				var interact = InputEventAction.new()
				interact.action = "interact"
				Input.parse_input_event(interact)
			if event.index == _move_index:
				_stop_moving()

	if event is InputEventScreenDrag:
		if event.index != _move_index:
			mouse_axis = event.relative
			camera_rotation(true)
		elif _is_pressing:
			var relative = _press_start - event.position
			if abs(relative.x) > MIN_DRAG:
				if relative.x < 0:
					Input.action_press("move_right")
				else:
					Input.action_press("move_right", 0)
				if relative.x > 0:
					Input.action_press("move_left")
				else:
					Input.action_press("move_left", 0)
			if abs(relative.y) > MIN_DRAG:
				if relative.y < 0:
					Input.action_press("move_backward")
				else:
					Input.action_press("move_backward", 0)
				if relative.y > 0:
					Input.action_press("move_forward")
				else:
					Input.action_press("move_forward", 0)


func _stop_moving():
	_is_pressing = false
	_move_index = -1
	Input.action_press("move_right", 0)
	Input.action_press("move_left", 0)
	Input.action_press("move_backward", 0)
	Input.action_press("move_forward", 0)

########################-INTERACTION METHODS##########################

func check_interaction(event: InputEvent):
	if event.is_action_released("interact"):
		if interactionRay.is_colliding():
			if interactionRay.get_collider().is_in_group("Interactable"):
				if interactionRay.get_collider().is_interactable:
					interactionRay.get_collider().interact(self)
	pass


func focus_mode(paused: bool):
	if paused:
		is_interacting = true
#		set_physics_process(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if hud:
			hud.hide()
	else:
		is_interacting = false
#		set_physics_process(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if hud:
			hud.show()


func stop_coding():
	focus_mode(false)


func set_discover_mode(enabled: bool):
	if enabled and not is_discover_mode:
		if anim.is_playing():
			anim.stop()
		is_discover_mode = true
		anim.play("enable_discover_mode")
	elif not enabled:
		if anim.is_playing():
			anim.stop()
		is_discover_mode = false
		anim.play("disable_discover_mode")


func _enable_discover_mode():
#	for mesh in get_tree().get_nodes_in_group("ItemMesh"):
#		for index in mesh.get_surface_material_count():
#			mesh.set_surface_material(index, item_discover_material)
	emit_signal("discover_mode", true)
#	for mesh in get_tree().get_nodes_in_group("MapMesh"):
#		for index in mesh.get_surface_material_count():
#			mesh.set_surface_material(index, map_discover_material)


func _disable_discover_mode():
#	for mesh in get_tree().get_nodes_in_group("ItemMesh"):
#		for index in mesh.get_surface_material_count():
#			mesh.set_surface_material(index, null)
	emit_signal("discover_mode", false)
#	for mesh in get_tree().get_nodes_in_group("MapMesh"):
#		for index in mesh.get_surface_material_count():
#			mesh.set_surface_material(index, null)


func _on_InGameMenu_resume():
	emit_signal("resumed", self)


func _on_AimRayCast_item_entred(item):
	emit_signal("look_at_item", item.display_name)
