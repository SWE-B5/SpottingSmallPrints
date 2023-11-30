extends Panel

# VARIABLEN HIER ANPASSEN UND ENTSPRECHENDE METHODEN UNTEN AUSKOMMENTIEREN
var next_scene_path = "res://path/to/your_next_scene.tscn"

var rng = RandomNumberGenerator.new()
var max_rounds = 10
var arr = [] #Länge = max_rounds, gefüllt mit zufälligen Zahlen zwischen 0-3
var buttons =[] #Array mit allen Buttons


var awaitingInput = false
var currentRound = 1 
var pointer = 0 # welche Position des Arrays grade angeklickt werden muss
var current_round_label


var green_texture = preload("res://assets/simonsays/buttontextures/greenbutton/greenbutton_hovered.png")
var red_texture = preload("res://assets/simonsays/buttontextures/redbutton/redbutton_hovered.png")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	setupHUD()
	buttons = [$BoxContainer/GreenButton,$BoxContainer/BlueButton,$BoxContainer/RedButton,$BoxContainer/YellowButton]
	for x in max_rounds:
		arr.append(rng.randi_range(0, buttons.size()-1))
	currentRound = 1
	await disableButtons();
	await blinkAllButtons(2)
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
	await  get_tree().create_timer(1).timeout
	for x in i:
		#print(arr[x])
		buttons[arr[x]].texture_disabled = buttons[arr[x]].texture_hover
		await  get_tree().create_timer(0.1).timeout
		buttons[arr[x]].texture_disabled = buttons[arr[x]].texture_normal
		await  get_tree().create_timer(0.1).timeout
	
	
#blinkt alle Knöpfe in ihren Farben 
func blinkAllButtons(howOften):
	for i in howOften:
		for x in buttons:
			x.texture_disabled = x.texture_hover
		await  get_tree().create_timer(0.5).timeout
		for x in buttons:
			x.texture_disabled = x.texture_normal
		await  get_tree().create_timer(0.5).timeout

#blinkt alle Knöpfe in Rot
func blinkRed(howOften):
	for i in howOften:
		for x in buttons:
			x.texture_disabled = red_texture
		await  get_tree().create_timer(0.5).timeout
		for x in buttons:
			x.texture_disabled = x.texture_normal
		await  get_tree().create_timer(0.5).timeout	

#blinkt alle Knöpfe in Grün
func blinkGreen(howOften):
	for i in howOften:
		for x in buttons:
			x.texture_disabled = green_texture
		await  get_tree().create_timer(0.5).timeout
		for x in buttons:
			x.texture_disabled = x.texture_normal
		await  get_tree().create_timer(0.5).timeout	

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
					await blinkGreen(3)
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
			await blinkRed(2)
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
		# Weitere Logik für den Szenenwechsel
		# Zum Beispiel: get_tree().change_scene(next_scene_path)

# interface button 
func _on_button_pressed():
	# hier kann eine neue scene geladen werden 
	# zum beispiel: get_tree().change_scene(next_scene_path)
	print("q")

# gibt anzahl der runden auf interface aus
func setupHUD():
	current_round_label = get_node("PanelContainerTop/VBoxContainer/HBoxContainer/counter")
	current_round_label.text = str(currentRound)

# nach timer ende wird diese funktion ausgeführt
func _on_scene_change_timer_timeout():
	# hier kann eine neue scene geladen werden 
	# zum beispiel: get_tree().change_scene(next_scene_path)
	print("Rätsel gelöst! Scene wechsel.")

# startet timer zum scenen wechsel
func on_all_pairs_found():
	$SceneChangeTimer.start()
