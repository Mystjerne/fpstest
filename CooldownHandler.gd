extends BoxContainer

signal timer_tick
signal countdown_finished

func _ready():
	for child in self.get_children():
		var Cooldown_Timer = Timer.new()
		child.add_child(Cooldown_Timer)
		#get the equipment default cooldown value. multiply it by the player's default reloadspd.
		#set the value of the timer.

func _process(delta):
	pass
