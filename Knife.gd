extends Weapon

@onready var animation_player = $AnimationPlayer
@onready var knife_area3d = $Area3D

func _ready():
	damage = 1
	reload_spd = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func enable(is_enabled:bool):
	self.visible = is_enabled
	knife_area3d.monitoring = is_enabled

func _input(_event):
	if Input.is_action_just_pressed("mouse_left"):
		animation_player.play("stab")

func _on_area_3d_body_entered(body):
	if body.name == "Skeleton":
		print(get_parent())
		var player_strength = get_parent().strength
		body.health -= damage * player_strength
		
	#pass # Replace with function body.
