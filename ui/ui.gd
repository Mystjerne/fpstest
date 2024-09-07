extends CanvasLayer
signal stat_changed
# Called when the node enters the scene tree for the first time.
# The UI only gets the players and weapon stats once, from onready.
@onready var player = self.get_parent().get_node("Player")
@onready var knife = player.get_node("Knife")
@onready var staff = player.get_node("Staff")
@onready var shotgun = player.get_node("Shotgun")
@onready var meat = player.get_node("Meat")

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
@onready var consumable_reload_spd = get_weapon_stat("consumable", "reload_spd")

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

#Cooldown timers
@export_node_path("Timer") var ranged_timer
@export_node_path("Timer") var consumable_timer
@export_node_path("Timer") var melee_timer
@export_node_path("Timer") var magic_timer

#Cooldown labels (the black numbers on top of the icons)
@export_node_path("Label") var consumable_cooldown_label
@export_node_path("Label") var magic_cooldown_label
@export_node_path("Label") var ranged_cooldown_label
@export_node_path("Label") var melee_cooldown_label


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
	
	
	_set_timer_durations()
	
	#total_time
	#Ranged Cooldown

func _set_timer_duration(node_path: NodePath, duration: float) -> void:
	var node = get_node_or_null(node_path)
	print("DURATION:", duration, node_path)
	if node:
		node.total_time = duration
	else:
		push_warning("Timer node not found: " + str(node_path))
		
	#start the timers.
	

func _set_timer_durations() -> void:
	_set_timer_duration(consumable_timer, consumable_reload_spd * player_reload_spd)
	_set_timer_duration(ranged_timer, ranged_reload_spd * player_reload_spd)
	_set_timer_duration(melee_timer, melee_reload_spd * player_reload_spd)
	_set_timer_duration(magic_timer, magic_reload_spd * player_reload_spd)

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
	get_node(ranged_strength_edit).release_focus()
	emit_signal("stat_changed")

func _on_rangedeq_reloadspd_edit_submitted(new_text):
	player.equipment_types["ranged"].reload_speed = string_to_number(new_text)
	weapon_stats["ranged"]["reload_speed"] = string_to_number(new_text)
	get_node(ranged_reload_speed_edit).release_focus()
	emit_signal("stat_changed")
#
# Melee equipment functions
func _on_meleeeq_str_edit_submitted(new_text):
	player.equipment_types["melee"].damage = string_to_number(new_text)
	weapon_stats["melee"]["damage"] = string_to_number(new_text)
	get_node(melee_strength_edit).release_focus()
	emit_signal("stat_changed")

func _on_meleeeq_reloadspd_edit_submitted(new_text):
	player.equipment_types["melee"].reload_speed = string_to_number(new_text)
	weapon_stats["melee"]["reload_speed"] = string_to_number(new_text)
	get_node(melee_reload_speed_edit).release_focus()
	emit_signal("stat_changed")

## Consumable equipment functions
func _on_consumableeq_str_edit_submitted(new_text):
	player.equipment_types["consumable"].strength_increase = string_to_number(new_text)
	weapon_stats["consumable"]["strength_increase"] = string_to_number(new_text)
	get_node(consumable_strength_increase_edit).release_focus()
	emit_signal("stat_changed")
#
func _on_consumableeq_reloadspd_edit_submitted(new_text):
	player.equipment_types["consumable"].reload_speed = string_to_number(new_text)
	weapon_stats["consumable"]["reload_speed"] = string_to_number(new_text)
	get_node(consumable_reload_speed_edit).release_focus()
	emit_signal("stat_changed")
#
## Magic equipment functions
func _on_magiceq_str_edit_submitted(new_text):
	player.equipment_types["magic"].damage = string_to_number(new_text)
	weapon_stats["magic"]["damage"] = string_to_number(new_text)
	get_node(magic_strength_edit).release_focus()
	emit_signal("stat_changed")
#
func _on_magiceq_reloadspd_edit_submitted(new_text):
	player.equipment_types["magic"].reload_speed = string_to_number(new_text)
	weapon_stats["magic"]["reload_speed"] = string_to_number(new_text)
	get_node(magic_reload_speed_edit).release_focus()
	emit_signal("stat_changed")

func string_to_number(string_value: String):
	if "." in string_value:
		return float(string_value)
	else:
		return int(string_value)

#On timer timeout, allow the player to use their weapon again.


#On timer tick (1 second has passed) set the corresponding cooldown label to -1 what it was before.
func _on_ranged_eq_timer_timer_tick(time_remaining):
	_update_cooldown_label(ranged_cooldown_label, time_remaining)

func _on_potion_timer_timer_tick(time_remaining):
	_update_cooldown_label(consumable_cooldown_label, time_remaining)

func _on_knife_timer_timer_tick(time_remaining):
	_update_cooldown_label(melee_cooldown_label, time_remaining)

func _on_magic_timer_timer_tick(time_remaining):
	_update_cooldown_label(magic_cooldown_label, time_remaining)

func _update_cooldown_label(label_path, time_remaining):
	var label = get_node(label_path)
	print(label_path, time_remaining)
	if time_remaining <= 0:
		label.text = "0"
	else:
		label.text = str(ceil(time_remaining))

func _on_knife_start_cooldown():
	knife.cooldown_finished = false
	get_node(melee_timer).start_countdown()
	#start the countdown wait

func _on_shotgun_start_cooldown():
	shotgun.cooldown_finished = false
	get_node(ranged_timer).start_countdown()
	
func _on_meat_start_cooldown():
	meat.cooldown_finished = false
	get_node(consumable_timer).start_countdown()
	
func _on_staff_start_cooldown():
	staff.cooldown_finished = false
	get_node(magic_timer).start_countdown()

func _on_magic_timer_countdown_finished():
	staff.cooldown_finished = true

func _on_knife_timer_countdown_finished():
	knife.cooldown_finished = true

func _on_potion_timer_countdown_finished():
	meat.cooldown_finished = true

func _on_ranged_eq_timer_countdown_finished():
	shotgun.cooldown_finished = true
