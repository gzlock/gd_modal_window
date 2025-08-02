extends CanvasLayer

const DEFAULT_WINDOW = preload("res://addons/modal_window/default_window.tscn")

var global_preset: PackedScene = DEFAULT_WINDOW


# 初始化对话框管理器
func _init() -> void:
	name = "ModalWindowManager"
	layer = 2
	
# 创建对话框
func create(content: Variant, title: String = "", preset: PackedScene = null) -> ModalWindow:
	if preset == null:
		preset = global_preset
	if global_preset == null:
		preset = DEFAULT_WINDOW
	var dialog: ModalWindow = preset.instantiate()
	dialog.name = "ModalWindow %d" % (get_child_count() + 1)
	ModalWindowManager.add_child(dialog)
	dialog.visible = true
	dialog.visibility_changed.connect(_on_window_visible_changed.bind(dialog))
	if content is String:
		dialog.set_content_string(content)
	elif content is Node:
		dialog.set_content_node(content)
	return dialog.set_title(title)

func _on_window_visible_changed(win: ModalWindow) -> void:
	if not win.visible:
		for w in get_children():
			if w is ModalWindow and w != win and w.visible:
				w.get_focus()
