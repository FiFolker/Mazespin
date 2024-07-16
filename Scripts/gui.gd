extends CanvasLayer

@onready var timer : Timer = %Timer
@onready var timer_label = %TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_label.text = str(timer.time_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_label.text = str(timer.time_left)
