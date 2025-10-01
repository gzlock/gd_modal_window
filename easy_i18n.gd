extends Object

class_name i18n

const path = "res://assets/languages.json"

static var _content: Dictionary

static func _init() -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	
	var lang = 'zh' if OS.get_locale_language() == 'zh' else 'en'
	_content = json[lang]
	
static func ui(key: String) -> String:
	if not _content:
		_init()
	if _content.has(key):
		return _content[key]
	else:
		push_error("Missing key: " + key)
		return key
