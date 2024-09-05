extends CharacterBody3D

@export var health = 1000:
	set = set_health
@onready var health_label = $HealthLabel

signal health_changed

func _ready():
	health_label.text = "HP: " + str(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Setter function for health property
func set_health(value):
	# Check if the health is actually being changed
	if health != value:
		health = value
		emit_signal("health_changed")

# Handler for when health is changed
func _on_health_changed():
	print("HP:", health)
	health_label.text = "HP: %s" % [str(health)]
