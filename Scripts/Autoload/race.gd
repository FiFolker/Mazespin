extends Node

enum MODE {CHRONO, AI}

var track : Track
var car : Car
var mode : MODE
var is_singleplayer : bool

func init(track:Track, car:Car, mode:MODE, is_singleplayer : bool):
	self.track = track
	self.car = car
	self.mode = mode
	self.is_singleplayer = is_singleplayer
	
