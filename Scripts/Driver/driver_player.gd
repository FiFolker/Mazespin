extends Driver
class_name DriverPlayer

func _input(event):
	if event.is_action_pressed("pause") and Race.state == Race.State.RUNING:
		if Race.state != Race.State.PAUSE:
			Race.pause()
		else:
			Race.resume()
	
