class_name LevelUI extends Control

@onready
var score_label: Label = $VertContainer/ScoreLabel
@onready
var missed_label: Label = $VertContainer/MissedLabel
var score: int = 0 : set = set_score
var missed: int = 0 : set = set_missed

func set_score(value: int) -> void:
	score = value
	score_label.text = "Score: {score}".format({"score": value})

func set_missed(value: int) -> void:
	missed = value
	missed_label.text = "Missed: {missed}".format({"missed": missed})
