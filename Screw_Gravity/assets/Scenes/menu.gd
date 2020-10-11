extends Spatial


# Declare member variables here. Examples:
onready var transAnim = get_node("SceneTransitionRect/AnimationPlayer")
onready var trans = get_node("SceneTransitionRect")
var currentNode


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_node("Sprite3D/Viewport/VideoPlayer").is_playing():
		get_node("Sprite3D/Viewport/VideoPlayer").play()

func _input(event):
	if event is InputEventMouseButton:
		match currentNode:
			"play":
				trans.visible = true
				transAnim.play("Fade_in")
				yield(transAnim,"animation_finished")
				yield(get_tree().create_timer(1.0), "timeout")
				get_tree().change_scene("res://assets/Scenes/Game.tscn")
			"quit":
				trans.visible = true
				transAnim.play("Fade_in")
				yield(transAnim,"animation_finished")
				get_tree().quit()
	
func _on_play_mouse_entered():
	get_node("play/MeshInstance").visible = true
	currentNode = "play"
	
func _on_play_mouse_exited():
	get_node("play/MeshInstance").visible = false
	currentNode = null

func _on_quit_mouse_entered():
	get_node("quit/MeshInstance").visible = true
	currentNode = "quit"

func _on_quit_mouse_exited():
	get_node("quit/MeshInstance").visible = false
	currentNode = null

