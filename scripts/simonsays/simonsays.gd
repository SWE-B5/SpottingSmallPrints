extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#_on_goldene_truhe_start_simon_says()
	pass



var isActive = false
signal puzzleSuccessful
signal puzzleCanceled

func _on_goldene_truhe_start_simon_says():
	isActive = true
	print("Starting Simon Says")
	visible = isActive
	startGame()
	
func closeSimonSays():
	isActive = false
	visible = false

# VARIABLEN HIER ANPASSEN UND ENTSPRECHENDE METHODEN UNTEN AUSKOMMENTIEREN
var next_scene_path = "res://path/to/your_next_scene.tscn"

var rng = RandomNumberGenerator.new()
var max_rounds
var arr = [] #Länge = max_rounds, gefüllt mit zufälligen Zahlen zwischen 0-3
var buttons =[] #Array mit allen Buttons


var awaitingInput = false
var currentRound = 1 
var pointer = 0 # welche Position des Arrays grade angeklickt werden muss
var current_round_label

const speed = 0.5
var green_texture = preload("res://assets/simonsays/buttontextures/greenbutton/greenbutton_hovered.png")
var red_texture = preload("res://assets/simonsays/buttontextures/redbutton/redbutton_hovered.png")


func set_difficulty():
	if (PlayerVariables.difficulty == PlayerVariables.Difficulty.EASY):
		max_rounds = 5
	elif (PlayerVariables.difficulty == PlayerVariables.Difficulty.MEDIUM):
		max_rounds = 7
	elif (PlayerVariables.difficulty == PlayerVariables.Difficulty.HARD):
		max_rounds = 10
	else:
		max_rounds = 5

func startGame():
	#PlayerVariables.load_easy_game() # kann später vermutlich raus
	setupHUD()
	set_difficulty()
	max_rounds = 2
	print(max_rounds)
	buttons = [$Panel/BoxContainer/GreenButton,$Panel/BoxContainer/BlueButton,$Panel/BoxContainer/RedButton,$Panel/BoxContainer/YellowButton]
	for x in max_rounds:
		arr.append(rng.randi_range(0, buttons.size()-1))
	currentRound = 1
	await disableButtons();
	await blinkAllButtons(2,'')
	await StartRound()
#disabled den Input vom User -> texture_disabled
func disableButtons():
	for x in buttons:
		x.disabled = true
#enabled den Input vom User
func enableButtons():
	for x in buttons:
		x.disabled = false

#Startet die Runde
func StartRound():
	await disableButtons();
	await ShowRound(currentRound)
	await enableButtons()
	awaitingInput=true

#Zeigt die Reihenfolge bis i an
func ShowRound(i):
	await  get_tree().create_timer(1,false).timeout
	for x in i:
		#print(arr[x])
		buttons[arr[x]].texture_disabled = buttons[arr[x]].texture_hover
		await  get_tree().create_timer(speed,false).timeout
		buttons[arr[x]].texture_disabled = buttons[arr[x]].texture_normal
		await  get_tree().create_timer(speed,false).timeout
	
	
#blinkt alle Knöpfe in ihren Farben 
func blinkAllButtons(howOften,color):
	for i in howOften:
		for x in buttons:
			if color == 'red':
				x.texture_disabled = red_texture
			elif color == 'green':
				x.texture_disabled = green_texture
			else:
				x.texture_disabled = x.texture_hover
		await  get_tree().create_timer(0.5,false).timeout
		for x in buttons:
			x.texture_disabled = x.texture_normal
		await  get_tree().create_timer(0.5,false).timeout


#Rechnet den Input aus, ob er richtig ist.
#falsch-> rot blinken, reset neue Reihenfolge
#richtig -> Neue Runde
#ganz fertig(alle Runden richtig) -> Grün blinken, alles disablen TODO:Event aufrufen
func checkInput(buttonIndex):
	if awaitingInput:
		disableButtons()
		awaitingInput = false
		if arr[pointer] == buttonIndex:
			pointer=pointer +1
			print(" war richtig")
			if pointer >= currentRound:
				pointer=0
				if currentRound < max_rounds:
					print("Neue Runde")
					currentRound=currentRound+1
					setupHUD()
					StartRound()
				else:
					on_all_pairs_found()
					print("Geschafft")
					await blinkAllButtons(3,'green')
			else:
				enableButtons()
			awaitingInput=true
		else:
			print("Falsch, reset")
			pointer = 0
			currentRound=1
			setupHUD()
			arr =[]
			for x in max_rounds:
				arr.append(rng.randi_range(0, buttons.size()-1))
			await blinkAllButtons(2,'red')
			StartRound()

func _on_green_button_pressed():
	if awaitingInput:
		#print("pressed Green 0")
		checkInput(0)

func _on_blue_button_pressed():
	if awaitingInput:
		#print("pressed Blue 1")
		checkInput(1)

func _on_red_button_pressed():
	if awaitingInput:
		#print("pressed Red 2")
		checkInput(2)

func _on_yellow_button_pressed():
	if awaitingInput:
		#print("pressed Yellow 3")
		checkInput(3)

# funktion um <q> tastendruck abzufangen 
var is_scene_changing = false
func _process(delta):
	if Input.is_key_pressed(KEY_Q) and not is_scene_changing:
		is_scene_changing = true
		print("q")
		puzzleCanceled.emit()
		closeSimonSays()
		is_scene_changing = false
		# Weitere Logik für den Szenenwechsel
		# Zum Beispiel: get_tree().change_scene(next_scene_path)

# interface button 
func _on_button_pressed():
	# hier kann eine neue scene geladen werden 
	# zum beispiel: get_tree().change_scene(next_scene_path)
	print("q")

# gibt anzahl der runden auf interface aus
func setupHUD():
	current_round_label = get_node("Panel/PanelContainerTop/VBoxContainer/HBoxContainer/counter")
	current_round_label.text = str(currentRound)

# nach timer ende wird diese funktion ausgeführt
func _on_scene_change_timer_timeout():
	# hier kann eine neue scene geladen werden 
	# zum beispiel: get_tree().change_scene(next_scene_path)
	print("Rätsel gelöst! Scene wechsel.")
	puzzleSuccessful.emit()
	closeSimonSays()

# startet timer zum scenen wechsel
func on_all_pairs_found():
	$Panel/SceneChangeTimer.start()
