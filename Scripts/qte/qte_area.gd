extends Area2D
class_name QTEArea

signal qte_sequence_success
signal qte_sequence_failure

@export var QTE_PLAYER_SCENE : PackedScene 
@export var QTE_AI_SCENE : PackedScene 
var qte:QTE

@export var number_of_qte:int

# idk but smth like that so the timer isn't always the same and it depends of the difficulty
# idk if i put difficulty as an option in the menu or it depends of the progression of the player
# the more far you're are the more it's quick ???
#enum DIFFICULTY {EASY=10, MEDIUM=5, HARD=1}
#@export var difficulty : DIFFICULTY = DIFFICULTY.EASY

var car : Car

var is_player :bool

func get_area_size() -> Vector2:
	if !($CollisionShape2D.shape is RectangleShape2D):
		return Vector2.ZERO
	return $CollisionShape2D.shape.size * self.scale

func start_qte() -> void:
	is_player = true
	car.index_qte += 1
	qte = QTE_PLAYER_SCENE.instantiate() as QTE
	qte.qte_done.connect(_on_qte_done)
	qte.qte_failure.connect(_on_qte_failure)
	add_child(qte)

func start_qte_ai() -> void:
	is_player = false
	car.index_qte += 1
	qte = QTE_AI_SCENE.instantiate() as QTEAI
	qte.qte_done.connect(_on_qte_done)
	qte.qte_failure.connect(_on_qte_failure)
	add_child(qte)

func _on_qte_done() -> void:
	if car.index_qte < number_of_qte:
		if is_player:
			start_qte()
		else:
			start_qte_ai()
	else:
		qte_sequence_success.emit()

func _on_qte_failure() -> void:
	qte_sequence_failure.emit()

func _on_area_entered(area):
	if area.get_parent() is Car:
		car = area.get_parent() as Car
		if area.get_parent().driver is DriverAI:
			start_qte_ai()
		elif area.get_parent().driver is DriverPlayer:
			start_qte()
			

