extends QTE
class_name QTEAI

var key_to_find:InputEvent
var rand_key:InputEvent
var rng : float
var time_to_wait : float

func _ready():
	setup()
	generate_qte()
	
func generate_qte() -> void:
	key_to_find = get_random_key_from_pool()
	#rand_key = get_random_key_from_pool() useful only if i want to do it in this way idk if it's better or not
	rng = randf() # to know if he will win or not
	time_to_wait = randf_range(qte_timer.wait_time*0.05, qte_timer.wait_time)
	#print("to find : ", key_to_find, "\nfound : ", rand_key, "\nrng :", rng,"\ntime to wait : ", time_to_wait) debug print
	qte_timer.start()

func _process(delta):
	if time_to_wait != 0:
		time_to_wait -= delta
	if time_to_wait <= 0:
		if rng > 0.5: # rand_key == key_to_find idk which one is the best but both works
			qte_done.emit()
			clear_qte()
		else:
			qte_failure.emit()
			clear_qte()
