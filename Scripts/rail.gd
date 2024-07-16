extends PathFollow2D

@export var speed:float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	self.progress += speed*delta
