extends Control

@onready var _label: Label = $Label


var dots = 0

func _ready() -> void:
	_run()

func _run():
	dots = (dots + 1) % 4
	_label.text = i18n.ui("loading") + ".".repeat(dots)
	if is_inside_tree():
		await get_tree().create_timer(0.25).timeout
		_run()
