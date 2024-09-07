extends CharacterBody3D
@export var  SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var sensivity = 0.3

@export var strength = 90:
	set = set_strength
@export var reload_spd = 1:
	set = set_reload_spd

@onready var knife = $Knife
@onready var shotgun = $Shotgun
@onready var meat = $Meat
@onready var staff = $Staff
@onready var equipment_types = {"ranged" : shotgun, "consumable" : meat , "melee" : knife, "magic": staff}
@onready var ui = get_parent().get_node("UI")

var current_equipment_focus = "ranged"
 
var fov = false
var lerp_speed = 1

func set_reload_spd(value):
	reload_spd = value
	ui.player_reload_spd = reload_spd
	print("player Reload_spd has been changed to: ", reload_spd)

func set_strength(value):
	strength = value
	ui.player_strength = strength
	print("player Strength has been changed to: ", strength)

func get_character_and_weapon_stats():
	var stats = {}
	for type in equipment_types:
		var weapon = equipment_types[type]
		if weapon.has_method("get_stats"):
			stats[type] = weapon.get_stats()
		else:
			stats[type] = {}
	stats["player"] = {"strength": strength, "reload_spd": reload_spd}
	return stats
	
func _ready():
	print(get_character_and_weapon_stats())
	change_equipment()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	if Input.is_action_just_pressed("toggle_debug"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN or Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	if event is InputEventMouseMotion:
		$Camera.rotation_degrees.x -= event.relative.y * sensivity
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * sensivity
		
	if Input.is_action_just_pressed("1"):
		current_equipment_focus = "ranged"
		change_equipment()
		
	if Input.is_action_just_pressed("2"):
		current_equipment_focus = "consumable"
		change_equipment()

	if Input.is_action_just_pressed("3"):
		current_equipment_focus = "melee"
		change_equipment()

	if Input.is_action_just_pressed("4"):
		current_equipment_focus = "magic"
		change_equipment()


func change_equipment():
	for key in equipment_types.keys():
			if key == current_equipment_focus:
				equipment_types[key].enable(true)
			else:
				equipment_types[key].enable(false)

func increase_strength(increase_in_strength):
	strength += increase_in_strength

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("RUN"):
		$Camera.fov +=2
		$Camera.fov = clamp($Camera.fov,85,110)
		SPEED = 7.0
	if  Input.is_action_just_released("RUN"):
		$Camera.fov = 85
		SPEED = 5.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

#Reload level if player jumps off and hits the respawn collision box.
func _on_area_3d_body_entered(body):
	if body.name=="Player":
		get_tree().change_scene_to_file("res://leveldesign/Level.tscn")
