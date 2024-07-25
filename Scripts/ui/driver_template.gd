extends HBoxContainer

@onready var ranking_label = %RankingLabel
@onready var car_icon = %CarIcon
@onready var driver_name = %DriverName
@onready var chrono = %Chrono

func _ready():
	pass
	
func load_data() -> void:
	ranking_label.text = str(get_meta("ranking")) if get_meta("ranking") != null else "NULL"
	car_icon.texture =  get_meta("car") if get_meta("car") != null else null
	driver_name.text = get_meta("name") if get_meta("name") != null else "NULL"
	chrono.text = str(get_meta("chrono")) if get_meta("chrono") != null else "0:00.000"
	
func _process(delta:float):
	chrono.text = str(get_meta("chrono")) if get_meta("chrono") != null else "0:00.000"
