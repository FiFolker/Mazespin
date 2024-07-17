extends PathFollow2D

@export var speed:float = 100
@export var slow_down_scale : float = 5.0

var has_to_slow_down: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	self.progress += speed*delta
	if has_to_slow_down:
		speed = 0


func _on_player_area_entered(area):
	if area is QTEArea:
		has_to_slow_down = true
		var qte : QTEArea = area
		qte.generate_qte()
		qte.qte_win.connect(qte_success)
		

func slow_down(delta:float) -> void:
	print("slow ...")
	speed -= delta * slow_down_scale  # Diminue progressivement
	if speed < 0.05 : 
		speed = 0

func qte_success() -> void:
	has_to_slow_down = false
	speed = 200
