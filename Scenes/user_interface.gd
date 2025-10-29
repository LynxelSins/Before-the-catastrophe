extends CanvasLayer
@onready var menu = $GameMenu
@onready var sum = $GameSum
@onready var spawn_position = %SpawnPosition
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var gemAmount = $GameSum/gemAmount
@onready var timeUsed = $GameSum/TimeUsed

var coin_scene := preload("res://Scenes/Coin.tscn")
var coin_instance: Node = null


func _ready():
	sum.visible = false
	menu.visible = true
	#AudioManager.bgm_sfx.play()
	
func _process(delta):
	if Input.is_action_just_pressed("start"):
		start_game()
		
	elif Input.is_action_just_pressed("next"):
		# ในกรณีที่กด "next" เพื่อกลับเมนู
		menu.visible = true
		sum.visible = false
		 # **รีเซ็ตคะแนน**
		reset_coin()
		player.global_position = spawn_position.global_position
		
	
func start_game(): # **รวมตรรกะเริ่มต้นเกมไว้ที่นี่**
	menu.visible = false
	sum.visible = false
	GameManager.reset_score() # **รีเซ็ตคะแนน**
	reset_coin()
	player.global_position = spawn_position.global_position # **ย้ายผู้เล่นไปจุดเกิด**
	GameManager.start_game_timer()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		GameManager.stop_game_timer()
		if gemAmount:
			gemAmount.text= "Magic Gem: %d" % GameManager.score
		if timeUsed:
			timeUsed.text = "Time: %s" % GameManager.get_formatted_time()
		sum.visible = true
		menu.visible = false
		
		
func _on_button_next_pressed():
	sum.visible = false
	menu.visible = true
	 # **รีเซ็ตคะแนน**
	reset_coin()
	player.global_position = spawn_position.global_position
	
	
func reset_coin():
	# **ค้นหาโหนดทั้งหมดที่อยู่ในกลุ่ม "Coin" ทั่วทั้ง Tree**
	var coins := get_tree().get_nodes_in_group("Coin")
	for coin in coins:
		if coin.has_method("reset_coin"):
			coin.reset_coin()


func _on_start_pressed() -> void:
	pass # Replace with function body.
	start_game()
