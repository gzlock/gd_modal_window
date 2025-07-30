@tool
extends EditorPlugin

const AUTOLOAD_NAME := "ModalWindowManager"
const AUTOLOAD_PATH := "res://addons/modal_window/modal_window_manager.gd"

func _enter_tree() -> void:
	# 自动注册 Autoload
	if not ProjectSettings.has_setting("autoload/%s" % AUTOLOAD_NAME):
		ProjectSettings.set_setting("autoload/%s" % AUTOLOAD_NAME, AUTOLOAD_PATH)
		ProjectSettings.save()
		get_tree().reload_current_scene() # 可选：刷新场景以应用单例
	pass


# func _exit_tree() -> void:
# 	# 卸载 Autoload
# 	if ProjectSettings.has_setting("autoload/%s" % AUTOLOAD_NAME):
# 		ProjectSettings.set_setting("autoload/%s" % AUTOLOAD_NAME, null)
# 		ProjectSettings.save()
# 	pass
