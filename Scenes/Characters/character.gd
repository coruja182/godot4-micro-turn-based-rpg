class_name Character extends Node2D


var _current_health : int = 25

@export var max_health : int = 25
@export var is_player : bool

@onready var _health_bar: ProgressBar = $HealthBar
@onready var _health_bar_label: Label = $HealthBar/Label


func _ready() -> void:
	_current_health = max_health
	_update_heatlh_bar()


func _update_heatlh_bar() -> void:
	_health_bar.max_value = max_health
	_health_bar.value = (float(_current_health) / float(max_health)) * 100
	_health_bar_label.text = "%s / %s" % [_current_health, max_health]
