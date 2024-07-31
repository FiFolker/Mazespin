extends PanelContainer

@export var highlight_color : Color

@onready var ranking_label = %RankingLabel
@onready var car_icon = %CarIcon
@onready var driver_name = %DriverName
@onready var chrono = %Chrono
@onready var bg = %Background

var driver : Driver

func _ready():
	Race.ranking_update.connect(_on_update_rank)
	bg.color = Color.TRANSPARENT
	
func load_data(new_driver:Driver) -> void:
	driver = new_driver
	ranking_label.text = str(driver.ranking)
	car_icon.texture = driver.car_data.sprite_small if driver.car_data != null else null
	driver_name.text = driver.short_name()
	chrono.text = Race.chrono_to_string(driver.general_chrono)
	if driver == CurrentDriver:
		bg.color = highlight_color
	
func _process(delta:float):
	
	if Race.state == Race.State.RUNING:
		if driver.ranking != 1:
			var leader : Driver = Race.leaderboard[0]
			var space_diff = (leader.car.progress_ratio + leader.current_lap) - (driver.car.progress_ratio + driver.current_lap)
			var time_diff : float = space_diff * Race.leaderboard[0].general_chrono
			var chrono_text : String = Race.chrono_to_string(time_diff)
			var lap_diff : int = floori(space_diff)
			if lap_diff > 0:
				var lap_string : String = "lap" if lap_diff == 1 else "laps"
				chrono_text = str(lap_diff) + lap_string
			chrono.text = "+" + chrono_text
		else:
			chrono.text = "Leader"
			
func _on_update_rank()-> void:
	ranking_label.text = str(driver.ranking)
	

