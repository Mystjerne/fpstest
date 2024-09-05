extends Weapon

@onready var animation_player = $AnimationPlayer

func _ready():
	damage = 10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("mouse_left"):
		animation_player.play("stab")


func _on_area_3d_body_entered(body):
	if body.name == "Skeleton":
		print(get_parent())
		var player_strength = get_parent().strength
		body.health -= damage * player_strength
		
	#pass # Replace with function body.
