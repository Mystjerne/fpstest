extends Timer
signal timer_tick
signal countdown_finished 

#need to calculate total time in respect to the player's reload spd
@export var total_time: int = 10
var time_remaining: int = total_time

func _ready():
	self.start(1.0)

func _on_timeout():
	# Decrease the remaining time by 1
	time_remaining -= 1  
	emit_signal("timer_tick", time_remaining)  # Emit the custom signal with the remaining time
	
	#print("Time remaining: ", time_remaining)
	
	if time_remaining <= 0:
		self.stop()
		emit_signal("countdown_finished")

func start_countdown(seconds: int):
	total_time = seconds
	time_remaining = total_time
	self.start(1.0)

func stop_countdown():
	self.stop()
