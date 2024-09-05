extends CanvasLayer
signal stat_changed
# Called when the node enters the scene tree for the first time.
@onready var player_strength = self.get_parent().get_node("Player").strength
@onready var player_reload_spd = self.get_parent().get_node("Player").reload_spd

func _ready():
	#Get the player stats. Get the equipment stats. Use a formula to calculate the reload
	print("player strength:", player_strength)
	print("player reload spd:", player_reload_spd)
	

func _process(delta):
	pass

#signals emited from the player stat line edits when enter is pressed on the line edit
func _on_strength_edit_submitted(new_text):
	emit_signal("stat_changed")

func _on_player_reloadspd_edit_submitted(new_text):
	emit_signal("stat_changed")
	



func _on_timeout():
	pass # Replace with function body.
