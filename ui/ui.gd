extends CanvasLayer
signal stat_changed
# Called when the node enters the scene tree for the first time.
# The UI only gets the players and weapon stats once, from onready.
@onready var player = self.get_parent().get_node("Player")
@onready var player_strength = player.strength:
	set = player_changed_strength
@onready var player_reload_spd = player.reload_spd

# Function to retrieve a specific stat for a given weapon type
# Parameters:
#   weapon_type: String - The type of weapon (e.g., "melee", "ranged", "magic")
#   stat_name: String - The name of the stat to retrieve (e.g., "damage", "reload_speed")
#   default_value: Any - The value to return if the stat doesn't exist (default: 0)
# Returns:
#   The value of the specified stat, or the default value if not found
func get_weapon_stat(weapon_type, stat_name, default_value = 0):
	return weapon_stats.get(weapon_type, {}).get(stat_name, default_value)
	
# Weapon stats
@onready var weapon_stats = player.get_character_and_weapon_stats()

@onready var melee_weapon_dmg = get_weapon_stat("melee", "damage")
@onready var melee_reload_spd = get_weapon_stat("melee", "reload_speed")

# Ranged weapon variables (e.g. shotgun)
@onready var ranged_weapon_dmg = get_weapon_stat("ranged", "damage")
@onready var ranged_reload_spd = get_weapon_stat("ranged", "reload_speed")

# Magic weapon variables (e.g. staff)
@onready var magic_weapon_dmg = get_weapon_stat("magic", "damage")
@onready var magic_reload_spd = get_weapon_stat("magic", "reload_speed")

# Consumable item variables (e.g. meat)
@onready var consumable_reload_spd = get_weapon_stat("consumable", "reload_speed")

@export_node_path("LineEdit") var strength_edit
@export_node_path("LineEdit") var reload_speed_edit
@export_node_path("Timer") var ranged_timer
@export_node_path("Timer") var consumable_timer
@export_node_path("Timer") var melee_timer
@export_node_path("Timer") var magic_timer

func _ready():
	print_tree()
	# Get the player stats. Get the equipment stats. Use a formula to calculate the reload
	print("player strength:", player_strength)
	print("player reload spd:", player_reload_spd)
	get_node(strength_edit).text = str(player_strength)
	get_node(reload_speed_edit).text = str(player_reload_spd)
	
	# Print weapon stats
	print("Weapon stats:", weapon_stats)
	print("Melee weapon damage:", melee_weapon_dmg)
	print("Ranged weapon damage:", ranged_weapon_dmg)
	print("Magic weapon damage:", magic_weapon_dmg)

func player_changed_strength(new_value):
	player_strength = new_value
	get_node(strength_edit).text = str(player_strength)
	
#signals emited from the player stat line edits when enter is pressed on the line edit
func _on_strength_edit_submitted(new_text):
	player_strength = new_text
	emit_signal("stat_changed")

func _on_player_reloadspd_edit_submitted(new_text):
	player_reload_spd = new_text
	emit_signal("stat_changed")

func _on_timeout():
	pass # Replace with function body.
