extends Timer
signal timer_tick
signal countdown_finished 

#need to calculate total time in respect to the player's reload spd
var total_time : int
var time_remaining: int

func _ready():
	pass
	#self.start(1.0)

func _on_timeout():
	# Decrease the remaining time by 1
	time_remaining -= 1
	print("time_remaining:", time_remaining)
	emit_signal("timer_tick", time_remaining)  # Emit the custom signal with the remaining time
	
	#print("Time remaining: ", time_remaining)
	
	if time_remaining <= 0:
		self.stop()
		emit_signal("countdown_finished")

func start_countdown():
	time_remaining = total_time
	self.start(1.0)
	print("self:", self)

func stop_countdown():
	self.stop()
