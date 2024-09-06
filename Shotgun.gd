extends Weapon
@onready var animation_player = $AnimationPlayer
@onready var shotgun_raycast = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 1
	reload_spd = 2

func enable(is_enabled:bool):
	self.visible = is_enabled
	shotgun_raycast.enabled = is_enabled

func _input(_event):
	if Input.is_action_just_pressed("mouse_left"):
		animation_player.play("shotgun_blast")
		if shotgun_raycast.is_colliding():
			var collider = shotgun_raycast.get_collider()
			#if shotgun_raycast.get_collider()
			if collider.name == "Skeleton":
				var player_strength = get_parent().strength
				collider.health -= damage * player_strength
