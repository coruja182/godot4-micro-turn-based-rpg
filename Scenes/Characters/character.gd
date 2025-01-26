class_name Character extends Node2D


var _current_health : int

var opponent : Character

@export var max_health : int = 25
@export var is_player : bool
@export var visual : Texture2D
@export var flip_visual : bool = false
@export var combat_actions : Array[CombatAction]

@onready var _health_bar: ProgressBar = $HealthBar
@onready var _health_bar_label: Label = $HealthBar/Label
@onready var _turn_manager: TurnManager = $"../TurnManager"
@onready var _sprite: Sprite2D = $Sprite


func _ready() -> void:
	_sprite.texture = visual
	_sprite.flip_h = flip_visual

	_current_health = max_health
	_update_health_bar()
	assert(_turn_manager)
	_turn_manager.character_begin_turn.connect(on_character_begin_turn)
	print("Character ", name, " connected to turn manager signals")


func take_damage(pAmount: int) -> void:
	_current_health = clamp(_current_health - pAmount, 0, max_health)
	print_debug("_current_health ", _current_health)
	_update_health_bar()
	
	if (_current_health <= 0):
		_turn_manager.character_died(self)
		queue_free()
		
func heal(p_amount: int) -> void:
	_current_health = clamp(_current_health + p_amount, 0, max_health)
	_update_health_bar()


func _update_health_bar() -> void:
	_health_bar.max_value = max_health
	_health_bar.value = _current_health
	print_debug("_health_bar.value ", _health_bar.value, "_health_bar.max_value ", _health_bar.max_value)
	_health_bar_label.text = "%s / %s" % [_current_health, max_health]


func on_character_begin_turn(p_character: Character) -> void:
	print_debug("on_character_begin_turn ", p_character.name)
	if p_character == self and not p_character.is_player:
		_decide_combat_action()


func _decide_combat_action() -> void:
	print_debug(name, " _decide_combat_action")
	var health_percent : float = float(_current_health) / float(max_health)
	
	for i_combat_action in combat_actions:
		if i_combat_action.heal > 0:
			if randf() > health_percent:
				cast_combat_action(i_combat_action)
				return
			else:
				continue
			
		cast_combat_action(i_combat_action)
		return


func cast_combat_action(p_action: CombatAction) -> void:	
	print_debug("cast_combat_action ", p_action)
	if p_action.damage > 0:
		opponent.take_damage(p_action.damage)
	elif p_action.heal > 0:
		self.heal(p_action.heal)
		
	_turn_manager.end_current_turn()
