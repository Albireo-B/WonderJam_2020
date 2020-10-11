extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_play_mouse_entered():
	get_node("play/MeshInstance").visible = true
	
func _on_play_mouse_exited():
	get_node("play/MeshInstance").visible = false

func _on_endless_mouse_entered():
	get_node("endless/MeshInstance").visible = true
	
func _on_endless_mouse_exited():
	get_node("endless/MeshInstance").visible = false


func _on_quit_mouse_entered():
	get_node("quit/MeshInstance").visible = true

func _on_quit_mouse_exited():
	get_node("quit/MeshInstance").visible = false



