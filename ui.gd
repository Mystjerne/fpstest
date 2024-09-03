extends CanvasLayer
signal stat_changed
# Called when the node enters the scene tree for the first time.

func _ready():
	pass

func _process(delta):
	pass

#signals emited from the player stat line edits when enter is pressed on the line edit
func _on_strength_edit_submitted(new_text):
	emit_signal("stat_changed")

func _on_player_reloadspd_edit_submitted(new_text):
	emit_signal("stat_changed")
	

