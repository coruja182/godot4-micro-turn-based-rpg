class_name PlayerUI extends VBoxContainer


@onready var _turn_manager: TurnManager = $"../TurnManager"

@export var buttons : Array[CombatActionButton]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(_turn_manager)
	_turn_manager.character_begin_turn.connect(on_character_begin_turn)
	_turn_manager.character_end_turn.connect(on_character_end_turn)


func on_character_begin_turn(p_character: Character) -> void:
	visible = p_character.is_player
	
	if p_character.is_player:
		_display_combat_actions(p_character.combat_actions)


func on_character_end_turn(character: Character) -> void:
	visible = false


func _display_combat_actions(p_combat_actions : Array[CombatAction]) -> void:
	var combat_actions_size : int = len(p_combat_actions)
	for i in len(buttons):
		var button = buttons[i]

		if i < combat_actions_size:
			button.combat_action = p_combat_actions[i]
		else:
			button.visible = false
