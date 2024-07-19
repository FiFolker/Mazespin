extends ProgressBar

@onready var path_follow_2d : PathFollow2D = %PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = path_follow_2d.progress_ratio * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	self.value = path_follow_2d.progress_ratio * 100
	if self.value == self.max_value and !%Chrono.paused:
		%Chrono.paused = true
	if %Chrono.time_left > 0 and %Chrono.paused:
		GameManager.has_won.emit()
		

