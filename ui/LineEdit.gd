extends LineEdit
@onready var sibling_label = get_parent().get_node("Label")

var previous_valid_text = ""

func _on_lineedit_text_changed(new_text):
	# Only allow integers as input.
	if new_text.is_valid_int() or new_text.is_valid_float():
		previous_valid_text = new_text
		self.text = new_text
		
	else:
		self.text = previous_valid_text
		 
func _on_text_submitted(new_text):
	print("_on_text_submitted was called")
	self.deselect()

func is_valid_float(input_text: String) -> bool:
	# Allow negative sign, decimal point, and numeric values
	if input_text == "-" or input_text == ".":
		return true
	# Allow a number with a trailing decimal, such as "90."
	if input_text.ends_with(".") and input_text.trim_suffix(".").is_valid_int():
		return true

	# Try to convert to a float, and check if it's a valid number
	var converted = input_text.to_float()
	return str(converted) == input_text or input_text == "0" or input_text == "-0"
