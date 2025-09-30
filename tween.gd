extends Node3D

func _ready() -> void:
	_tween()

func _tween():
		# 创建 Tween
	var tween := create_tween()

	# 正向播放
	tween.tween_property(self, "position:x", -5., 5.0)

	# 等待完成后反向播放
	await tween.finished

	# 创建新的反向 Tween
	tween = create_tween()
	tween.tween_property(self, "position:x", 5., 5.0)
	await tween.finished
	_tween()
