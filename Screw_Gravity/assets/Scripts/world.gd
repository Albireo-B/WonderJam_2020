extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tween = get_node("Movement_Tween")
onready var cameraRaycast = get_node("Camera/RayCast")
onready var letterScene = preload("res://assets/Scenes/letter.tscn")

var playtime = true
var selectedLetter = null
var oldletter = null


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var alpha = "a".to_ascii()
	for i in range(0,26):
		var letter = letterScene.instance()
		letter.speed = 1
		
		var newalpha = alpha
		newalpha[0] = alpha[0]+i
		letter.set_letter(newalpha.get_string_from_ascii())
		
		get_node("/root/world/plan").add_child(letter)
		
	newletter()
	

func newletter():
	if get_node("/root/world/placeholder").get_child(0):
		get_node("/root/world/placeholder").get_child(0).queue_free()
	
	var alpha = "a".to_ascii()
	alpha[0] += randi()%25
	
	var letter = letterScene.instance()
	letter.speed = 0
	letter.set_letter(alpha.get_string_from_ascii())
	
	var coloredMaterial = SpatialMaterial.new()
	coloredMaterial.albedo_color = Color.red
	letter.get_node("MeshInstance").set_material_override(coloredMaterial)
	
	get_node("/root/world/placeholder").add_child(letter)
	
	


func _process(delta):
	if cameraRaycast.is_colliding():
		selectedLetter = cameraRaycast.get_collider()
		var coloredMaterial = SpatialMaterial.new()
		coloredMaterial.albedo_color = Color.red
		selectedLetter.get_node("MeshInstance").set_material_override(coloredMaterial)
		clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(selectedLetter)
	else :
		clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)


func clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(letter):
	for L in get_node("plan").get_children():
		var coloredMaterial = SpatialMaterial.new()
		coloredMaterial.albedo_color = Color.white
		if L != letter :
			L.get_node("MeshInstance").set_material_override(coloredMaterial)


func inplan(obj):
	return obj.get_parent() == get_node("/root/world/plan")
	
func istheletter(obj):
	return obj.get_letter() == get_node("/root/world/placeholder").get_child(0).get_letter()
	
func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_accept"):
			playtime = true
			get_node("/root/world/ui/time").time = 30.0
			get_node("/root/world/ui/score").score = 0
			newletter()
	if event is InputEventMouseButton:
		if event.pressed:
			var obj = cameraRaycast.get_collider()
			if  playtime && cameraRaycast.is_colliding() && inplan(obj) && istheletter(obj):
				moveLetter(cameraRaycast.get_collider())
				newletter()
				var timeNode = get_node("/root/world/ui/time")
				timeNode.time += 1.0
				var scoreNode = get_node("/root/world/ui/score")
				scoreNode.score +=  1000
				
func moveLetter(letter):
		if oldletter:
			oldletter = oldletter.queue_free()
		var newletter = letter.duplicate()
		var oldpos = letter.global_transform.origin
		get_node("/root/world").add_child(newletter)
		newletter.translation = oldpos
		newletter.speed = 0
		var targetLocation = get_node("/root/world/placeholder").global_transform.origin + Vector3(-1,0,-1)
		var rotationNeeded = Vector3(-30,0,0)
		tween.interpolate_property(newletter,"translation",newletter.translation,
		targetLocation,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.interpolate_property(newletter,"rotation_degrees",newletter.rotation_degrees,
		rotationNeeded,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		oldletter = newletter


