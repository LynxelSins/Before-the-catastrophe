extends Control

# ---------- VARIABLES ---------- #

@onready var coinsLabel = $CoinsLabel

# ---------- FUNCTIONS ---------- #

func _process(_delta):
	coinsLabel.text = " %d" % GameManager.score # Set the coin label text to the score variable
