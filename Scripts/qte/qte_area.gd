extends Area2D
class_name QTEArea

signal qte_sequence_success
signal qte_sequence_failure

@export var QTE_PLAYER_SCENE : PackedScene 
@export var QTE_AI_SCENE : PackedScene 
var qte:QTE

@export var number_of_qte:int

var is_player :bool

var index_qte : int = 0

func init(qte_area:QTEArea, car:Car) -> void:
	self.is_player = qte_area.is_player
	self.number_of_qte = qte_area.number_of_qte
	self.QTE_AI_SCENE = qte_area.QTE_AI_SCENE
	self.QTE_PLAYER_SCENE = qte_area.QTE_PLAYER_SCENE
	if car.driver is DriverAI:
		start_qte_ai()
	elif car.driver is DriverPlayer:
		start_qte()

func get_area_size() -> Vector2:
	if !($CollisionShape2D.shape is RectangleShape2D):
		return Vector2.ZERO
	return $CollisionShape2D.shape.size * self.scale

func start_qte() -> void:
	is_player = true
	index_qte += 1
	qte = QTE_PLAYER_SCENE.instantiate() as QTE
	qte.qte_done.connect(_on_qte_done)
	qte.qte_failure.connect(_on_qte_failure)
	add_child(qte)

func start_qte_ai() -> void:
	is_player = false
	index_qte += 1
	qte = QTE_AI_SCENE.instantiate() as QTEAI
	qte.qte_done.connect(_on_qte_done)
	qte.qte_failure.connect(_on_qte_failure)
	add_child(qte)

func _on_qte_done() -> void:
	if index_qte < number_of_qte:
		if is_player:
			start_qte()
		else:
			start_qte_ai()
	else:
		qte_sequence_success.emit()

func _on_qte_failure() -> void:
	qte_sequence_failure.emit()

