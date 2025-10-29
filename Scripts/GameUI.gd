extends Control

# ---------- VARIABLES ---------- #

@onready var coinsLabel = $CoinsLabel
@onready var time_hud_label = $Time
# ---------- FUNCTIONS ---------- #

func _process(_delta):
	coinsLabel.text = " %d" % GameManager.score # Set the coin label text to the score variable
	time_hud_label.text = "Time: %s" % GameManager.get_formatted_time()
