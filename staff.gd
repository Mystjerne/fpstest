extends Weapon

@onready var animation_player = $AnimationPlayer
@onready var staff_area3d = $Area3D
var cooldown_finished = true
signal start_cooldown

func _ready():
	damage = 3
	reload_spd = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.

func enable(is_enabled:bool):
	self.visible = is_enabled
	staff_area3d.monitoring = is_enabled

func _input(_event):
	if Input.is_action_just_pressed("mouse_left") and cooldown_finished and self.visible:
		emit_signal("start_cooldown")
		animation_player.play("staff_slam")

func _on_area_3d_body_entered(body):
	if body.name == "Skeleton":
		var player_strength = get_parent().strength
		body.health -= damage * player_strength
		
	#pass # Replace with function body.
