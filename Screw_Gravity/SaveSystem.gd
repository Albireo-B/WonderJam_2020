extends Node2D

var highscore = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save_path = "es://save-file.cfg"
var config = ConfigFile.new()
var load_resonser = config.load(save_path)


func _ready():
	pass 

func saveValue(section, key):
	config.set_value(section, key, highscore)
	config.save(save_path)
	
func loadValue(section, key):
	highscore = config.get_value(section, key, highscore)
