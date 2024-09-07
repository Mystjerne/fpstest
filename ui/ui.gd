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
@onready var consumable_strength_increase = get_weapon_stat("consumable", "strength_increase")
@onready var consumable_reload_spd = get_weapon_stat("consumable", "reload_speed")

#Player stats:
@export_node_path("LineEdit") var strength_edit
@export_node_path("LineEdit") var reload_speed_edit

#Melee stats:
@export_node_path("LineEdit") var melee_strength_edit
@export_node_path("LineEdit") var melee_reload_speed_edit

# Ranged stats:
@export_node_path("LineEdit") var ranged_strength_edit
@export_node_path("LineEdit") var ranged_reload_speed_edit

# Magic stats:
@export_node_path("LineEdit") var magic_strength_edit
@export_node_path("LineEdit") var magic_reload_speed_edit

# Consumable stats:
@export_node_path("LineEdit") var consumable_strength_increase_edit
@export_node_path("LineEdit") var consumable_reload_speed_edit


@export_node_path("Timer") var ranged_timer
@export_node_path("Timer") var consumable_timer
@export_node_path("Timer") var melee_timer
@export_node_path("Timer") var magic_timer

func _ready():
	# Get the player stats. Get the equipment stats. Use a formula to calculate the reload
	print("player strength:", player_strength)
	print("player reload spd:", player_reload_spd)
	get_node(strength_edit).text = str(player_strength)
	get_node(reload_speed_edit).text = str(player_reload_spd)
	
	# Print weapon stats
	
	# Melee stats
	get_node(melee_strength_edit).text = str(melee_weapon_dmg)
	get_node(melee_reload_speed_edit).text = str(melee_reload_spd)
	
	# Ranged stats
	get_node(ranged_strength_edit).text = str(ranged_weapon_dmg)
	get_node(ranged_reload_speed_edit).text = str(ranged_reload_spd)
	
	# Magic stats
	get_node(magic_strength_edit).text = str(magic_weapon_dmg)
	get_node(magic_reload_speed_edit).text = str(magic_reload_spd)
	
	# Consumable stats
	get_node(consumable_strength_increase_edit).text = str(consumable_strength_increase)
	get_node(consumable_reload_speed_edit).text = str(consumable_reload_spd)

func player_changed_strength(new_value):
	player_strength = new_value
	get_node(strength_edit).text = str(player_strength)
	
#signals emited from the player stat line edits when enter is pressed on the line edit
func _on_strength_edit_submitted(new_text):
	player_strength = new_text
	player.strength = player_strength
	emit_signal("stat_changed")
	
#When player submits a reload spd change via the debug menu, have to recalculate cooldowns.
#Cooldown is calculated by player reload_spd x weapon reload_spd in seconds.

#Reloadpsd change for Player
func _on_reloadspd_edit_submitted(new_text):
	player_reload_spd = new_text
	player.reload_spd = player_reload_spd
	emit_signal("stat_changed")

#Ranged equipment functions
func _on_rangedeq_str_edit_submitted(new_text):
	player.equipment_types["ranged"].damage = string_to_number(new_text)
	weapon_stats["ranged"]["damage"] = string_to_number(new_text)
	emit_signal("stat_changed")

func _on_rangedeq_reloadspd_edit_submitted(new_text):
	player.equipment_types["ranged"].reload_speed = string_to_number(new_text)
	weapon_stats["ranged"]["reload_speed"] = string_to_number(new_text)
	emit_signal("stat_changed")
#
# Melee equipment functions
func _on_meleeeq_str_edit_submitted(new_text):
	player.equipment_types["melee"].damage = string_to_number(new_text)
	weapon_stats["melee"]["damage"] = string_to_number(new_text)
	emit_signal("stat_changed")

func _on_meleeeq_reloadspd_edit_submitted(new_text):
	player.equipment_types["melee"].reload_speed = string_to_number(new_text)
	weapon_stats["melee"]["reload_speed"] = string_to_number(new_text)
	emit_signal("stat_changed")

## Consumable equipment functions
func _on_consumableeq_str_edit_submitted(new_text):
	player.equipment_types["consumable"].strength_increase = string_to_number(new_text)
	weapon_stats["consumable"]["strength_increase"] = string_to_number(new_text)
	emit_signal("stat_changed")
#
func _on_consumableeq_reloadspd_edit_submitted(new_text):
	player.equipment_types["consumable"].reload_speed = string_to_number(new_text)
	weapon_stats["consumable"]["reload_speed"] = string_to_number(new_text)
	emit_signal("stat_changed")
#
## Magic equipment functions
func _on_magiceq_str_edit_submitted(new_text):
	player.equipment_types["magic"].damage = string_to_number(new_text)
	weapon_stats["magic"]["damage"] = string_to_number(new_text)
	emit_signal("stat_changed")
#
func _on_magiceq_reloadspd_edit_submitted(new_text):
	player.equipment_types["magic"].reload_speed = string_to_number(new_text)
	weapon_stats["magic"]["reload_speed"] = string_to_number(new_text)
	emit_signal("stat_changed")

func string_to_number(string_value: String):
	if "." in string_value:
		return float(string_value)
	else:
		return int(string_value)

func _on_timeout():
	pass # Replace with function body.


func _on_lineedit_text_changed(new_text):
	pass # Replace with function body.
