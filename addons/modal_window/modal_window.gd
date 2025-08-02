# 该脚本定义了一个自定义对话框类 ModalWindow，继承自 Node。
# 该对话框包含一个背景颜色和一个可接受的对话框窗口。
# 提供了信号和方法来处理对话框的交互。

extends Control
class_name ModalWindow

# 只在开发时输出
var _print_debug := true

@onready var bg: ColorRect = %Background # 背景颜色节点
@onready var _btn_close: BaseButton = %BtnClose
@onready var _head: HBoxContainer = %Head
@onready var _content_container: MarginContainer = %ContentContainer
@onready var _foot: HFlowContainer = %Foot
@onready var _title_label: Label = %Title
@onready var _content_label: Label = %Content

var head: Control:
	get:
		return _head
var foot: Control:
	get:
		return _foot

# 定义信号，用于在对话框中执行操作时发出
signal action(window: ModalWindow, action: String, checked: bool)


var buttons: Dictionary[String, Button] = {}


func _ready() -> void:
	_btn_close.pressed.connect(_on_close_button_click)
	get_viewport().size_changed.connect(request_reset_size)


# 定义对话框的安全区域内边距
var _safe_padding: Vector2 = Vector2(100, 100)
var safe_padding: Vector2:
	get:
		return _safe_padding
func set_area_safe_padding(value: Vector2) -> ModalWindow:
	_safe_padding = value
	return self

# TODO
# 定义对话框是否可以通过按下 Escape 键关闭
var dialog_close_on_escape: bool = false

var _ok_to_close: bool = true
var ok_to_close: bool:
	get:
		return _ok_to_close
func set_ok_to_close(value: bool) -> ModalWindow:
	_ok_to_close = value
	return self


# 设置内容容器的大小
var _content_size: Vector2 = Vector2.ZERO
var content_size: Vector2:
	get:
		return _content_size
func set_content_size(value: Vector2) -> ModalWindow:
	_content_size = value
	return request_reset_size()

# 定义对话框标题
var _title: String = ""
var title: String:
	get:
		return _title
func set_title(value: String) -> ModalWindow:
	_title = value
	_head_changed()
	return request_reset_size()

# 定义背景颜色
const DEFAULT_BG_COLOR: Color = Color(0, 0, 0, 0.5)
var _bg_color: Color = DEFAULT_BG_COLOR
var bg_color: Color:
	get:
		return _bg_color
func set_bg_color(value: Color) -> ModalWindow:
	_bg_color = value
	if bg:
			bg.color = value
	return self


# 定义是否隐藏关闭按钮
var _show_close_button: bool = true
var show_close_button_value: bool:
	get:
		return _show_close_button
func show_close_button(value: bool) -> ModalWindow:
	_show_close_button = value
	_head_changed()
	return request_reset_size()


# Todo
# 定义对话框是否可以拖动
var _draggable: bool = true
var draggable: bool:
	get:
		return _draggable
func set_draggable(value: bool) -> ModalWindow:
	_draggable = value
	return self

# 定义对话框是否可以通过点击背景关闭
var _click_bg_to_close := true
var click_bg_to_close: bool:
	get:
		return _click_bg_to_close
func allow_click_bg_to_close(value: bool) -> ModalWindow:
	_click_bg_to_close = value
	return self

# 0: 无内容, 1: 文本, 2: 节点
var _content_type := 0
# 定义对话框内容的变量
var _content: String
func set_content_string(value: String) -> ModalWindow:
	_content_type = 1
	_content_node = null
	_content = value
	return self

var _content_node: Node
func set_content_node(node: Node) -> ModalWindow:
	_content_type = 2
	_content = ''
	_content_node = node
	return self


# 添加自定义按钮的方法
# 参数:
# - action_name (String): 按钮触发的动作
# - text (String): 按钮显示的文本
# - disabled (bool): 按钮是否禁用
# 返回值:
# - ModalWindow: 返回当前对话框实例
func add_button(action_name: String, text: String, disabled: bool = false) -> ModalWindow:
	if buttons.has(action_name):
		push_error("The button already exists: %s" % action_name)
	else:
		var button = Button.new()
		button.text = text
		button.pressed.connect(_button_click.bind(action_name))
		_print('button name: %s, text: %s, disabled: %s' % [action_name, text, disabled])
		button.disabled = disabled
		buttons[action_name] = button
		_foot.add_child(button)
	return self

# 添加复选框按钮的方法
# 参数:
# - action_name (String): 按钮触发的动作
# - text (String): 按钮显示的文本
# - checked (bool): 按钮是否选中
# 返回值:
# - ModalWindow: 返回当前对话框实例
func add_checkbutton(action_name: String, text: String, checked: bool = false) -> ModalWindow:
	if buttons.has(action_name):
		push_error("The checkbutton already exists: %s" % action_name)
	else:
		var checkbutton = CheckButton.new()
		checkbutton.text = text
		checkbutton.button_pressed = checked
		checkbutton.pressed.connect(_checkbutton_click.bind(action_name))
		buttons[action_name] = checkbutton
		_foot.add_child(checkbutton)
	return self

# 添加自定义按钮节点的方法
# 参数:
# - action_name (String): 按钮触发的动作
# - node (BaseButton): 自定义按钮节点
# 返回值:
# - ModalWindow: 返回当前对话框实例
func add_button_node(action_name: String, node: BaseButton) -> ModalWindow:
	if buttons.has(action_name):
		push_error("The button already exists: %s" % action_name)
	else:
		node.pressed.connect(_button_click.bind(action_name))
		buttons[action_name] = node
		_foot.add_child(node)
	return self

func set_disabled(action_name: String, disabled: bool) -> ModalWindow:
	if buttons.has(action_name):
		buttons[action_name].disabled = disabled
	else:
		push_error("The button does not exist: %s" % action_name)
	return self


func _button_click(action_name: String) -> void:
	if not buttons.has(action_name):
		return
	_focus_button = action_name
	action.emit(self, action_name, false)
	if _ok_to_close and action_name == "ok":
		visible = false

func _checkbutton_click(action_name: String) -> void:
	var button: CheckButton = buttons[action_name]
	action.emit(self, action_name, button.button_pressed)

func _clear_buttons() -> void:
	for button in buttons.values():
		button.queue_free()
	buttons.clear()

func _clear_action_connections() -> void:
	var connections = action.get_connections()
	for connection in connections:
		action.disconnect(connection.callable)


func _on_background_input(event: InputEvent) -> void:
	# 鼠标点击背景关闭对话框
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if _click_bg_to_close:
			self.visible = false


# 关闭按钮点击事件
func _on_close_button_click() -> void:
	visible = false
	action.emit(self, 'close', false)

# focus管理
var _focus_button: String
func set_focus_button(action_name: String) -> ModalWindow:
	_focus_button = action_name
	return self
func get_focus() -> void:
	await get_tree().process_frame
	if _focus_button and buttons.has(_focus_button):
		buttons[_focus_button].grab_focus()
	else:
		if buttons.is_empty():
			_btn_close.grab_focus()
		else:
			buttons.values()[0].grab_focus()

# 重置对话框大小和位置
var _reset_size_pending := false
func request_reset_size() -> ModalWindow:
	# _print("请求重置对话框大小和位置, frame: %s" % Engine.get_frames_drawn())
	if _reset_size_pending:
		return self
	_reset_size_pending = true
	call_deferred("_reset_size")
	return self
func _reset_size() -> void:
	_print("重置对话框大小和位置, frame: %s" % Engine.get_frames_drawn())
	# 当gialog_foot没有子节点时，_content_container的bottom margin设置为0
	_content_container.add_theme_constant_override("margin_bottom", 0 if _foot.get_child_count() == 0 else 10)
	
	_content_container.custom_minimum_size = _content_size
	%Window.reset_size()
	var window_size = %Window.size
	# 游戏窗口大小
	var viewport_size = get_viewport_rect().size

	# 如果对话框的大小超过了游戏窗口大小，则将其限制在游戏窗口大小内
	var copy_content_size = _content_size
	var large_then_width = window_size.x >= (viewport_size.x - _safe_padding.x)
	var large_then_height = window_size.y >= (viewport_size.y - _safe_padding.y)
	if large_then_width or large_then_height:
		_print('触发计算大小')
		var c_size = _content_size
		if large_then_width:
			copy_content_size.x = _content_size.x - (window_size.x - (viewport_size.x - _safe_padding.x))
		if large_then_height:
			copy_content_size.y = _content_size.y - (window_size.y - (viewport_size.y - _safe_padding.y))
			print('多出 %s' % (window_size.y - (viewport_size.y - _safe_padding.y)))
		# 设置内容容器的最小大小
		_content_container.custom_minimum_size = copy_content_size
	_print(
		"画面大小：%s, 窗口：%s, 指定大小: %s, 计算后: %s, 最后窗口大小: %s" %
	 	[viewport_size, window_size, content_size, copy_content_size, %Window.size]
		)
	%Window.reset_size()
	window_size = %Window.size
	%Window.position = (viewport_size - window_size) / 2
	_reset_size_pending = false
	# _print("对话框大小和位置已重置, frame: %s" % Engine.get_frames_drawn())


# 对话框可见性改变时调用
func _on_visibility_changed() -> void:
	if visible:
		_on_visible()
	else:
		_on_disvisible()
	
func _on_visible() -> void:
	await get_tree().process_frame
	bg.color = _bg_color
	_head_changed()

	_content_label.visible = _content_type == 1
	if _content_type == 1:
		_content_label.text = _content
	elif _content_type == 2:
		_content_container.add_child(_content_node)
	get_focus()
	request_reset_size()
func _on_disvisible() -> void:
	# 关闭对话框时，发出等待关闭的信号
	_wait_to_close.emit()
	if _content_node:
		_content_container.remove_child(_content_node)
	queue_free()


	# await get_tree().process_frame
	# _content_type = 0
	# _content_node = null
	# _title = ''
	# _content = ''
	# _show_close_button = true
	# _bg_color = DEFAULT_BG_COLOR
	# _clear_buttons()
	# _clear_action_connections()

func _head_changed() -> void:
	# _print("control_head title:%s， close_btn:%s" % [_title, _show_close_button])
	if _title_label == null:
		return
	if _title.is_empty() and not _show_close_button:
		_head.visible = false
		return
	_head.visible = true
	_title_label.text = _title
	_btn_close.visible = _show_close_button

# 等待对话框被关闭的信号
signal _wait_to_close
func wait_to_close() -> Signal:
	return _wait_to_close

func _print(content: String) -> void:
	if _print_debug:
		print(content)
