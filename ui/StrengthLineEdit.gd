extends LineEdit
@onready var sibling_label = get_parent().get_node("Label")
#@onready var player_stat = get_parent().player_strength

var previous_valid_text = ""

# Called when the node enters the scene tree for the first time.
#func _ready():
	#self.text = str(player_stat)

func _on_strength_edit_text_changed(new_text):
	# Only allow integers as input.
	if new_text.is_valid_int():
		previous_valid_text = new_text
		self.text = new_text
		
	else:
		self.text = previous_valid_text



