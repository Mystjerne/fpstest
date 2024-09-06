extends MeshInstance3D
class_name Weapon


@export var damage = 0
@export var reload_spd = 0

func _ready():
	pass # Replace with function body.
# this function will get the stats as a dictionary
func get_stats():
	return {
		"damage": damage,
		"reload_speed": reload_spd
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
