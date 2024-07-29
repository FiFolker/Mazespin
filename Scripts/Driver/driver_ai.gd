extends Driver
class_name DriverAI
# ai things

func solve_qte(qte_sequence:QTEArea) -> void:
	var rng = randf()
	if rng > 0.4:
		qte_sequence._on_qte_done()
		print(driver_name, " : success")
	else:
		qte_sequence._on_qte_failure()
		print(driver_name, " : fail ...")
