extends MeshInstance3D
@onready var animation_player = $AnimationPlayer
@export var strength_increase: float = 0.1

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func enable(is_enabled:bool):
	self.visible = is_enabled
	
func _input(_event):
	if Input.is_action_just_pressed("mouse_left") and self.visible:
		animation_player.play("eat_meat")
		increase_player_damage()
		
func increase_player_damage():
	var player = get_parent()
	print(player)
	if player and player.has_method("increase_strength"):
		player.increase_strength(strength_increase)
		print("player_strength: ", player.strength)

func get_stats():
	return {
		"strength_increase": strength_increase
	}
