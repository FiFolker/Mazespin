extends Area2D
class_name QTEArea

signal qte_sequence_success
signal qte_sequence_failure

@export var QTE_SCENE : PackedScene 
var qte:QTE

@export var number_of_qte:int

# idk but smth like that so the timer isn't always the same and it depends of the difficulty
# idk if i put difficulty as an option in the menu or it depends of the progression of the player
# the more far you're are the more it's quick ???
#enum DIFFICULTY {EASY=10, MEDIUM=5, HARD=1}
#@export var difficulty : DIFFICULTY = DIFFICULTY.EASY

var _qte_shown : bool = true

var index_qte : int = 0

func get_area_size() -> Vector2:
	if !($CollisionShape2D.shape is RectangleShape2D):
		return Vector2.ZERO
	return $CollisionShape2D.shape.size * self.scale

func start_qte(displayable:bool) -> void:
	index_qte += 1
	_qte_shown = displayable
	qte = QTE_SCENE.instantiate()
	qte.qte_done.connect(_on_qte_done)
	qte.qte_failure.connect(_on_qte_failure)
	add_child(qte)
	if qte.is_node_ready():
		qte.generate_qte(_qte_shown)

func start_qte_ai() -> void:
	pass # to do

func _on_qte_done() -> void:
	if index_qte < number_of_qte:
		start_qte(_qte_shown)
	else:
		qte_sequence_success.emit()

func _on_qte_failure() -> void:
	qte_sequence_failure.emit()

func _on_area_entered(area):
	#start_qte()
	pass

