class_name CombatActionButton extends Button


var combat_action : CombatAction :
	set(value):
		combat_action = value
		text = combat_action.display_name

@onready var _turn_manager: TurnManager = $"../../TurnManager"


func _ready() -> void:
	assert(_turn_manager)


func _on_pressed() -> void:
	print_debug("_on_pressed of ", self)
	_turn_manager._current_character.cast_combat_action(combat_action)
