extends Weapon
@onready var animation_player = $AnimationPlayer
@onready var shotgun_raycast = $RayCast3D
var cooldown_finished = true
signal start_cooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 1
	reload_spd = 2

func enable(is_enabled:bool):
	self.visible = is_enabled
	shotgun_raycast.enabled = is_enabled

func _input(_event):
	if Input.is_action_just_pressed("mouse_left"):
		print(cooldown_finished)
	if Input.is_action_just_pressed("mouse_left") and cooldown_finished and self.visible:
		
		
		animation_player.play("shotgun_blast")
		if shotgun_raycast.is_colliding():
			var collider = shotgun_raycast.get_collider()
			#if shotgun_raycast.get_collider()
			if collider.name == "Skeleton":
				var player_strength = get_parent().strength
				collider.health -= damage * player_strength
				
		emit_signal("start_cooldown")
