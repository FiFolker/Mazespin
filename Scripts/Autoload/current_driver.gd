extends Node

var driver : DriverPlayer

# somes stats with files and name to choose here and it'll be in autoload way
func _ready():
	driver = DriverPlayer.new(DriverData.new("FiFolker", null, -1))

# FOR STATS
var best_rank : int
# or dico for stat idk like
var stats : Dictionary = {
	"best rank" : 5,
	"average chrono" : 1.5
}
# or this format idk
var stats2 : Dictionary = {
	"best" : {
		"rank" : 5,
		"chrono" : 1.5
	},
	"average" : {
		"rank" : 5,
		"chrono" : 1.5
	}
}
