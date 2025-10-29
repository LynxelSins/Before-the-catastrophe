extends Area3D

# ---------- VARIABLES ---------- #

@export_category("Properties")
@export var amplitude := 0.2 # ความสูงของการลอย
@export var frequency := 4 # ความถี่ของการลอย

var start_transform: Transform3D
var time_passed = 0.0
var is_collected = false # ติดตามสถานะการเก็บ

var initial_position := Vector3.ZERO
# @onready var player := get_tree().get_first_node_in_group("Player") # ไม่จำเป็นต้องใช้แล้ว

# ---------- FUNCTIONS ---------- #

func _ready():
	# บันทึกสถานะเริ่มต้นของเหรียญ (ตำแหน่ง/การหมุน/ขนาด)
	start_transform = global_transform
	initial_position = position # บันทึกตำแหน่ง Local Y สำหรับการลอย
	
	# ตรวจสอบให้แน่ใจว่าเหรียญแสดงผลเมื่อเริ่ม
	show()
	scale = Vector3.ONE

func _process(delta):
	if is_collected:
		return # หยุดการทำงานทั้งหมดหากถูกเก็บแล้ว
		
	coin_hover(delta)
	rotate_y(deg_to_rad(3))
	
	# **ตัดส่วน follow_player และ tween ออก**
	
# Coin Hover Animation
func coin_hover(delta):
	time_passed += delta
	
	# คำนวณตำแหน่ง Y ใหม่สำหรับการลอย
	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	position.y = new_y

# ---------- SIGNALS ---------- #

func _on_body_entered(body):
	# ตรวจสอบและเก็บเหรียญทันทีเมื่อชน
	if body.is_in_group("Player") and not is_collected:
		is_collected = true # ตั้งค่าสถานะเป็นถูกเก็บแล้ว
		GameManager.add_score()
		AudioManager.coin_sfx.play()
		#AudioManager.coin_sfx.play() # (ถ้ามีโหนด AudioManager อยู่ในฉาก)
		
		# **ซ่อนเหรียญทันที**
		hide()
		scale = Vector3.ZERO # ตั้งค่าขนาดเป็นศูนย์เพื่อหลีกเลี่ยง invert error

# **ลบฟังก์ชัน _on_range_body_entered ออกไป**
		
func reset_coin():
	# **ฟังก์ชันนี้จะรีเซ็ตเหรียญกลับสู่สถานะเดิม**
	
	# 1. คืนค่า Transform
	global_transform = start_transform 
	
	# 2. คืนค่าสถานะ
	scale = Vector3.ONE
	show()
	is_collected = false # รีเซ็ตสถานะการเก็บ
	time_passed = 0.0
	
	# 3. รีเซ็ตตำแหน่ง Local Y เพื่อให้การลอยทำงานถูกต้อง
	position.y = initial_position.y
