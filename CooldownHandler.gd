extends BoxContainer

signal timer_tick
signal countdown_finished

var equipment_types = ["ranged", "potion", "melee", "magic"]

func _ready():
	for child in self.get_children():
		for grandchild in child.get_children():
			if grandchild is Timer:
				grandchild.total_time = 6

func _process(delta):
	pass

#calculate weapon reload time by multiplying weapon reload spd with player reload spd.
func get_weapon_reload_times():
	pass
