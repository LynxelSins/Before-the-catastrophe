extends Node3D

# ---------- VARIABLES ---------- #

var score = 0
var elapsed_time: float = 0.0

# 1. ประกาศตัวแปรเป็น null ก่อน
var timer: Timer = null 

# ---------- FUNCTIONS ---------- #

func _ready():
	# **ใช้ call_deferred เพื่อให้แน่ใจว่าการค้นหาโหนดเกิดขึ้นหลังจาก Scene Tree ถูกสร้างเสร็จ**
	# และแก้ไขปัญหา Race Condition
	call_deferred("initialize_timer")
	
# **เพิ่มฟังก์ชันใหม่นี้**
func initialize_timer():
	var timers = get_tree().get_nodes_in_group("GameTimeNode")
	if timers.size() > 0:
		timer = timers[0] # กำหนดให้ timer เป็นโหนดแรกในกลุ่ม
	# 2. ตรวจสอบและดำเนินการ
	if not is_instance_valid(timer): 
		push_error("GameManager requires a direct child node named 'GameTimer' (Timer node) to function properly.")
		return # ออกจากฟังก์ชันถ้าหาไม่เจอ
		
	# 3. โค้ดที่ดำเนินการต่อเมื่อ Timer ถูกพบ
	timer.autostart = false
	timer.one_shot = false
		
func _process(_delta):
	show_mouse_cursor()
	
	# 3. ตรวจสอบ is_instance_valid(timer) ก่อนเรียก method ใด ๆ 
	if is_instance_valid(timer) and not timer.is_stopped():
		elapsed_time += _delta 

# Making Cursor visible using "mouse_visible" key which is assigned in Project Settings > Input Map
func show_mouse_cursor():
	if Input.is_action_just_pressed("mouse_visible"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func add_score():
	score += 1

func reset_score():
	score = 0
	elapsed_time = 0.0

func start_game_timer():
	if is_instance_valid(timer):
		elapsed_time = 0.0
		timer.start()

func stop_game_timer():
	if is_instance_valid(timer):
		timer.stop()
	
func get_formatted_time() -> String: 
	# แปลงเวลาเป็นรูปแบบ นาที:วินาที.มิลลิวินาที
	var minutes = floor(elapsed_time / 60.0)
	var seconds = fmod(elapsed_time, 60.0)
	
	return "%02d:%05.2f" % [minutes, seconds]
