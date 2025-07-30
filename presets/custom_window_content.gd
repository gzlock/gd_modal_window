extends RichTextLabel

signal scrolled_to_bottom
@onready var v_scroll: ScrollBar = get_v_scroll_bar()

func _ready() -> void:
	text = i18n.ui(text)
	v_scroll.value_changed.connect(_on_scroll)
	#scroll_ended.connect(_on_scroll_ended)

func _on_scroll(scroll_pos: float) -> void:
	var scroll_max = v_scroll.max_value
	var page = v_scroll.page

	if scroll_pos >= scroll_max - page:
		scrolled_to_bottom.emit()
