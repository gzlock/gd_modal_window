extends CanvasLayer

# class ModalWindowManager


signal children_visible_changed(visible: bool)

const DEFAULT_WINDOW = preload("res://addons/modal_window/default_window.tscn")

var global_preset: PackedScene = DEFAULT_WINDOW


# 初始化对话框管理器
func _init() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
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
	dialog.visibility_changed.connect(_on_window_visible_changed.bind(dialog))
	dialog.visibility_changed.connect(self._visible_listener)
	dialog.visible = true
	_visible_listener()
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

func _visible_listener() -> void:
	var has_visible_window = false
	for w in get_children():
		if w is ModalWindow and w.visible:
			has_visible_window = true
			break
	children_visible_changed.emit(has_visible_window)

var print_debug := false
