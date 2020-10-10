extends Spatial


onready var tween = get_node("Tween")
onready var objectToMove = get_node("Sprite3D")
var targetLocation = Vector3(0,0,0)
var rotationNeeded = Vector3(0,0,360)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			tween.interpolate_property(objectToMove,"translation",objectToMove.translation,
			targetLocation,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.interpolate_property(objectToMove,"rotation_degrees",objectToMove.rotation_degrees,
			rotationNeeded,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.start()
	
