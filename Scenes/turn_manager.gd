class_name TurnManager extends Node


@export var characters : Array[Character]
@export var next_turn_delay_secs : float = 1.0
@onready var turn_label: Label = $TurnLabel


var _current_character : Character
var game_over : bool = false

signal character_begin_turn(character: Character)
signal character_end_turn(character: Character)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(len(characters) >= 2, 'must have at least 2 characters')
	begin_next_turn()


func begin_next_turn() -> void:
	var i_current_char : int = characters.find(_current_character)
	var next_character_index : int = i_current_char + 1
	if next_character_index >= len(characters):
		next_character_index = 0
	
	_current_character = characters[next_character_index]
	update_debug()
	emit_signal("character_begin_turn", _current_character)


func end_current_turn() -> void:
	emit_signal("character_end_turn", _current_character)
	await get_tree().create_timer(next_turn_delay_secs).timeout
	
	if not game_over:
		begin_next_turn()


func character_died(character: Character):
	game_over = true
	
	if character.is_player:
		print("Game Over!")
	else:
		print("You Win!")


func update_debug() -> void:
	turn_label.text = "Turn of %s"  % _current_character.name
