extends Node

# ---------- VARIABLES ---------- #
@onready var jump_sfx = $JumpSfx
@onready var coin_sfx = $CoinSfx
@onready var bgm_sfx : AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	# โหลดเพลง
	var song = preload("res://Assets/Audio/SFX/Shuttling Through the Abyssal Rift • Training OST - Skirk Story Quest ｜ Genshin Imapct 5.7 OST.wav")
	bgm_sfx.stream = song
	
	# ถ้าไฟล์เป็น AudioStreamSample จะสามารถ loop ได้
	if song is AudioStreamPlayer:
		bgm_sfx.loop = true
	
	# เริ่มเล่น
	bgm_sfx.play()
