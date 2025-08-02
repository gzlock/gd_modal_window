<img src="./logo.png">

# Godot模态窗口 v0.1 / [English](./README.md)

## 优点
* 简单易用
* 纯gdscript代码实现
* 多窗口堆叠
* 丰富的自定义选项
* 支持完全自定义窗口UI皮肤
* 常规方法支持链式调用，即`win.b().c().d()`
* 实现了使用await等待模态窗口关闭，即`await win.wait_to_close()`

## 🎉体验最佳实践🎉

**下载这个项目到本地，运行example场景即可。**


## 使用方法

1. 启用ModalWindow插件

![image](./images/cn_enable_addon.png)

2. 启用全局设置里的ModalWindowManager

![image](./images/cn_enable_manager.png)

3. 创建窗口`ModalWinddowManager.create('窗口内容','窗口标题')`


# 两种方法自定义窗体风格
1. 全局

    `ModalWindowManager.global_preset = ...`

2. 针对单一窗口
   
    `ModalWindowManager.create('content', 'title', packed_scene)`



## 支持平台
* Web
* Windows
* Linux
* Android
* iOS

## ⚠️请参照[🔗示范的预设场景](./custom_modal_window_preset.tscn)的节点命名规范来创建自定义窗口场景

## Assets 
* [Kenny ui pack(CC0)](https://kenney.nl/assets/ui-pack)
* [Ninja Asset Pack(CC0)](https://pixel-boy.itch.io/ninja-adventure-asset-pack)
* [Pixelated Elegance Font - CC0](https://ggbot.itch.io/pixelated-elegance-font)

## TODO
* 编写文档
