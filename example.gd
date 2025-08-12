extends Control


const CUSTOM_MODAL_WINDOW_PRESET = preload("res://presets/custom_modal_window_preset.tscn")
const CUSTOM_PIXEL_MODAL_WINDOW_PRESET = preload("res://presets/custom_pixel_modal_window_preset.tscn")
const WAIT_INDICATOR = preload("res://presets/wait_indicator.tscn")
const CUSTOM_WINDOW_CONTENT = preload("res://presets/custom_window_content.tscn")
const FORUM_WINODW_CONTENT = preload("res://presets/forum_window_content.tscn")

@onready var pixel_style_switch: CheckButton = $VBoxContainer/VBoxContainer/PixelStyleSwitch
@onready var btn_win1: Button = %Win1
@onready var btn_win2: Button = %Win2
@onready var btn_win3: Button = %Win3


func _ready() -> void:
	ModalWindowManager.global_preset = CUSTOM_MODAL_WINDOW_PRESET
	i18n.init()
	pixel_style_switch.text = i18n.ui(pixel_style_switch.text)
	btn_win1.text = i18n.ui(btn_win1.text)
	$VBoxContainer/VBoxContainer1/Label.text = i18n.ui($VBoxContainer/VBoxContainer1/Label.text)
	btn_win2.text = i18n.ui(btn_win2.text)
	$VBoxContainer/VBoxContainer2/Label.text = i18n.ui($VBoxContainer/VBoxContainer2/Label.text)
	btn_win3.text = i18n.ui(btn_win3.text)
	$VBoxContainer/VBoxContainer3/Label.text = i18n.ui($VBoxContainer/VBoxContainer3/Label.text)

func _on_win_1_pressed() -> void:
	ModalWindowManager \
	.create(i18n.ui('simple_window'), i18n.ui('title')) \
	.set_content_size(Vector2(200, 100))


var win2: ModalWindow

func _on_win_2_pressed() -> void:
	# 获取游戏窗口大小
	var monitor_size = get_viewport().get_visible_rect().size

	var user_agreement_size := Vector2((monitor_size / 2).x, monitor_size.y)
	
	var content = CUSTOM_WINDOW_CONTENT.instantiate()
	content.scrolled_to_bottom.connect(_user_agreement_scroll_to_bottom)

	win2 = ModalWindowManager.create(content, i18n.ui('title')) \
	.add_checkbutton("close_btn", i18n.ui('close_btn'), true) \
	.add_checkbutton("title", i18n.ui('window_title'), true) \
	.add_checkbutton("bg_color", i18n.ui('random_color'), _random_bg_color) \
	.add_checkbutton("content_size", i18n.ui('content_size')) \
	.add_checkbutton("click_bg_to_close", i18n.ui('click_bg_to_close'), false) \
	.add_button("sub_window", i18n.ui('sub_window')) \
	.add_button("ok", i18n.ui('ok')) \
	.set_disabled("ok", true) \
	.allow_click_bg_to_close(false)
	win2.action.connect(func(_w: ModalWindow, action_name: String, checked: bool) -> void:
		match action_name:
			"sub_window":
				var sub_win = ModalWindowManager.create(i18n.ui('sub_window_content'), i18n.ui('sub_window')) \
				.allow_click_bg_to_close(false) \
				.show_close_button(false) \
				.add_button("focus", i18n.ui('focus_button')) \
				.add_button("ok", i18n.ui('ok')) \
				.set_focus_button("focus")
			"title":
				_w.set_title(i18n.ui('title') if checked else "")
			"close_btn":
				_w.show_close_button(not _w.show_close_button_value)
			"bg_color":
				_random_bg_color = checked
			"content_size":
				_w.set_content_size(user_agreement_size if checked else Vector2.ZERO)
			"click_bg_to_close":
				_w.allow_click_bg_to_close(checked)
	)

func _user_agreement_scroll_to_bottom() -> void:
	# print('Scrolled to bottom')
	if win2:
		win2.set_disabled("ok", false)

func _physics_process(delta: float) -> void:
	if win2 and _random_bg_color:
		_change_dialog_bg_color(delta)


var _random_bg_color := false
var _target_bg_color: Color = Color(randf(), randf(), randf(), 0.5)
var _lerp := 0.0
# 使用定时器随机改变对话框的背景颜色，每1秒改变一次，需要有颜色过渡效果
func _change_dialog_bg_color(delta: float) -> void:
	var current_color: Color = win2.bg_color
	var new_color: Color = current_color.lerp(_target_bg_color, delta)
	_lerp += delta
	win2.set_bg_color(new_color)
	if _lerp >= 1:
		_target_bg_color = Color(randf(), randf(), randf(), 0.5)
		_lerp = 0


var _win3: ModalWindow
func _on_win_3_pressed() -> void:
	var forum: Forum = FORUM_WINODW_CONTENT.instantiate()
	_win3 = ModalWindowManager.create(forum, i18n.ui('register')) \
	.add_button("submit", i18n.ui("submit"))
	
	_win3.action.connect(func(_w: ModalWindow, action_name: String, _checked: bool) -> void:
		match action_name:
			"submit":
				var username = forum.username_input.text
				var password = forum.password_input.text
				if username.is_empty():
					await ModalWindowManager.create(i18n.ui('username_empty'), i18n.ui('error')).wait_to_close()
					await get_tree().create_timer(0.01).timeout
					forum.username_input.grab_focus()
					return
				elif password.is_empty():
					await ModalWindowManager.create(i18n.ui('password_empty'), i18n.ui('error')).wait_to_close()
					await get_tree().create_timer(0.01).timeout
					forum.password_input.grab_focus()
					return
				var loading = ModalWindowManager.create(WAIT_INDICATOR.instantiate(), i18n.ui('loading')) \
				.show_close_button(false) \
				.allow_click_bg_to_close(false)
				await get_tree().create_timer(2).timeout
				loading.visible = false

				ModalWindowManager.create("%s: %s\n%s: %s" % [i18n.ui('username'), username, i18n.ui('password'), password], i18n.ui('success')) \
				.set_content_size(Vector2(200, 100))
		)


func _on_pixel_style_switch_toggled(toggled_on: bool) -> void:
	# This will change the global preset for ModalWindow
	ModalWindowManager.global_preset = CUSTOM_PIXEL_MODAL_WINDOW_PRESET if toggled_on else CUSTOM_MODAL_WINDOW_PRESET
	# Or you can use:
	# ModalWindowManager.create('content', 'title', CUSTOM_PIXEL_MODAL_WINDOW_PRESET)
	# to create a window with the different preset directly.
