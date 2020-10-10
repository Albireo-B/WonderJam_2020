extends Spatial


onready var transitionScene = get_node("SceneTransitionRect")
onready var tween = get_node("Movement_Tween")
onready var cameraRaycast = get_node("Camera/RayCast")
onready var dialogBox = get_node("Dialog_Box")
onready var letterScene = preload("res://assets/Scenes/letter.tscn")
onready var islandIntermediate = preload("res://assets/Scenes/IslandIntermediate.tscn")
onready var islandComplete = preload("res://assets/Scenes/IslandComplete.tscn")
onready var placeholderplan = get_node("/root/RootNode/placeholder/Plan")

var wordList = [
	"it was" , "not meant" , "that we" , "should voyage" , "this far",
"ultimate horror" , "often paralyses" , "memory in" , "a merciful way",
"the world is" , "indeed comic" ,  "but the" , "joke is" , "on mankind",
"pleasure to me" , "is wonder",
"changeless thing" , "that lurks"  , "behind" , "the veil"  , "of reality",
"unless they happen" , "to be insane",
"and with" , "strange aeons" , "even death" , "may die",
"formless" , "infinite" , "unchanging" , "and unchangeable" , "void",
"where they" , "roll in" , "their horror" , "unheeded"
]

var selectedLetter = null
var selectedbody = null
var inLetterGame = false
var currentIslandSceneIndex = 1
var currentIslandNode
var sentence = ""
var currentNode
var spacing = 0.25
var level1DialogArrays = ["What happened here?","I can't remember anything","Poor guys"]
var level2DialogArrays = ["Hi there","General kenobi","Bip","Boup","tryndamere est passé par la"]
var level3DialogArrays = ["Hi there","General kenobi","Bip","Boup","tryndamere est passé par la"]

func selectAlpha(obj, selected):
	obj.get_node("MeshInstance").get_node("outline").visible = selected

# Called when the node enters the scene tree for the first time.
func _ready():
	currentIslandNode = get_node("Environment")
	var alpha = "a".to_ascii()
	for i in range(0,26):
		var letter = letterScene.instance()
		letter.speed = 1
		var newalpha = alpha
		newalpha[0] = alpha[0]+i
		letter.set_letter(newalpha.get_string_from_ascii())
		get_node("/root/RootNode/Zone_Lettres/Plan").add_child(letter) 
	switchMode()
		
	start("start")

func start(sentence_):
	for child in placeholderplan.get_children():
		child.queue_free()
	for child in get_node("/root/RootNode/answer").get_children():
		child.queue_free()
	
	sentence = sentence_
	print(sentence)
	var iterator = 0
	for letter in sentence:
		if letter != " ":
			var letterNode = letterScene.instance()
			letterNode.speed = 0
			letterNode.set_letter(letter)
			placeholderplan.add_child(letterNode)
			letterNode.translate(Vector3((-sentence.length()*spacing)/2+iterator * spacing,0,0))
			letterNode.visible = false
		iterator+=1
	nextCar()


	
	
	
func nextCar():
	placeholderplan.get_child(0).queue_free()		
	
	var letterNode = placeholderplan.get_child(1)
	selectAlpha(letterNode,true)

	letterNode.visible = true
	currentNode = letterNode
	
	
	
func _process(delta):
	if inLetterGame:
		if cameraRaycast.is_colliding():
			selectedLetter = cameraRaycast.get_collider()
			if  inplan(selectedLetter):
					selectAlpha(selectedLetter,true)
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(selectedLetter)
		else :
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	else:
		if cameraRaycast.is_colliding():
			selectedbody = cameraRaycast.get_collider()
			selectedbody.get_child(0).get_node("Outline").visible = true
		else :
			clearBodiesOutline()


func displayAccordingMessage():
	match currentIslandSceneIndex:
		1:
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").text = level1DialogArrays[randi()%level1DialogArrays.size()]
		2:
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").text = level2DialogArrays[randi()%level2DialogArrays.size()]
		3:
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").text = level2DialogArrays[randi()%level2DialogArrays.size()]
			
func clearBodiesOutline():
	if selectedbody:
		selectedbody.get_child(0).get_node("Outline").visible = false
		
#deactivate collision mesh to allow the raycast to find the letter and inversely
func switchMode():
	clearBodiesOutline()
	clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	if inLetterGame:
		switchCollisions("Bodies",false)
		for L in get_node("Zone_Lettres/Plan").get_children():
			L.visible = true
		switchCollisions("Letters",true)
	else:
		switchCollisions("Bodies",true)
		for L in get_node("Zone_Lettres/Plan").get_children():
			L.visible = false
		switchCollisions("Letters",false)

func switchCollisions(objectsType,enabled):
	if objectsType == "Bodies":
		for N in currentIslandNode.get_node("Dead_Bodies").get_children():
			for i in range (1,N.get_children().size()-1):
				N.get_child(i).disabled = !enabled
	else :
		for N in get_node("Zone_Lettres/Plan").get_children():
			N.get_node("CollisionShape").disabled = !enabled
			


func clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(letter):
	for L in get_node("Zone_Lettres/Plan").get_children():
		if L != letter:
			selectAlpha(L,false)

func inplan(obj):
	return obj.get_parent() == get_node("/root/RootNode/Zone_Lettres/Plan")
	
func istheletter(obj):
	return obj.get_letter() == currentNode.get_letter()
	

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_accept"):
			inLetterGame = !inLetterGame
			switchMode()
		elif event.is_action_pressed("ui_cancel"):
			changeSceneOrEndGame()
	if event is InputEventMouseButton:
		if event.pressed:
			if inLetterGame:
				var obj = cameraRaycast.get_collider()
				if cameraRaycast.is_colliding() && inplan(obj) && istheletter(obj) :
					moveLetter(obj)
					if placeholderplan.get_child(1):
						nextCar()
					else:
						start(wordList[randi()%wordList.size()])
			else :
				if cameraRaycast.is_colliding():
					if dialogBox.visible:
						inLetterGame = !inLetterGame
						dialogBox.visible = false
						switchMode()
					else:
						displayAccordingMessage()
						dialogBox.visible = true
						dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label/Body_AnimationPlayer").play("TextDisplay")

				
func moveLetter(letter):
	if letter is KinematicBody:
		var newletter = letter.duplicate()
		var oldpos = letter.global_transform.origin
		get_node("/root/RootNode/answer").add_child(newletter)
		newletter.translation = oldpos
		newletter.speed = 0
		selectAlpha(newletter, false)
		var targetLocation = currentNode.global_transform.origin
		var rotationNeeded = Vector3(-30,0,0)
		tween.interpolate_property(newletter,"translation",newletter.translation,
		targetLocation,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.interpolate_property(newletter,"rotation_degrees",newletter.rotation_degrees,
		rotationNeeded,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		
func changeSceneOrEndGame():
		match currentIslandSceneIndex:
			1:
				fadeIn_IncrScene_ChangeEnv(islandIntermediate)
			2:
				fadeIn_IncrScene_ChangeEnv(islandComplete)
			3:
				endGame()

func fadeIn_IncrScene_ChangeEnv(newEnv):
	transitionScene.get_node("AnimationPlayer").play("Fade_in")
	yield(transitionScene.get_node("AnimationPlayer"), "animation_finished")
	currentIslandNode.queue_free()
	var newInstance = newEnv.instance()
	currentIslandNode = newInstance
	get_tree().get_root().get_node("RootNode").add_child(newInstance)
	transitionScene.get_node("AnimationPlayer").play("Fade_out")
	currentIslandSceneIndex+=1
	
func endGame():
	get_tree().quit()
	

