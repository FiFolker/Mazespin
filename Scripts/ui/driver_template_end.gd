extends PanelContainer
class_name DriverTemplateEnd

@export var highlight_color : Color

@onready var pos = %Pos
@onready var d_name = %Name
@onready var car = %Car
@onready var gap = %Gap
@onready var best_lap = %BestLap
@onready var bg = %Background
@onready var laps = %Laps

func _ready():
	bg.color = Color.TRANSPARENT

func load_data(driver:Driver) -> void:
	pos.text = str(driver.ranking)
	car.texture = driver.car_data.sprite_small if driver.car_data != null else null
	car.tooltip_text = driver.car_data.get_info()
	d_name.text = driver.driver_name
	var gap_str : String = "Leader"
	if driver != Race.leaderboard[0]:
		gap_str = "+" + Race.chrono_to_string(driver.general_chrono - Race.leaderboard[0].general_chrono)
	gap.text = gap_str
	best_lap.text = Race.chrono_to_string(driver.best_lap)
	laps.text= str(driver.current_lap)
	if driver == CurrentDriver.driver:
		bg.color = highlight_color
	
