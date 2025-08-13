@tool
extends EditorPlugin

const AUTOLOAD_NAME := "ModalWindowManager"
const AUTOLOAD_PATH := "res://addons/modal_window/modal_window_manager.gd"

func _enable_plugin():
	# The autoload can be a scene or script file.
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
