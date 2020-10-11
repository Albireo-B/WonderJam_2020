extends Spatial


# Declare member variables here. Examples:
var currentNode


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_node("Sprite3D/Viewport/VideoPlayer").is_playing():
		get_node("Sprite3D/Viewport/VideoPlayer").play()

func _input(event):
	pass
	
func _on_play_mouse_entered():
	get_node("play/MeshInstance").visible = true
	currentNode = "play"
	
func _on_play_mouse_exited():
	get_node("play/MeshInstance").visible = false
	currentNode = null

func _on_endless_mouse_entered():
	get_node("endless/MeshInstance").visible = true
	currentNode = "endless"
	
func _on_endless_mouse_exited():
	get_node("endless/MeshInstance").visible = false
	currentNode = null

func _on_quit_mouse_entered():
	get_node("quit/MeshInstance").visible = true
	currentNode = "quit"

func _on_quit_mouse_exited():
	get_node("quit/MeshInstance").visible = false
	currentNode = null



