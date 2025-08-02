<img src="./logo.png">

# Godot Modal Window v0.1 / [中文](./README_cn.md)

## Features
* Easy to use
* Pure GDScript implementation
* Stacked multiple windows
* Rich customization options
* Supports fully customizable window UI skins
* Regular method support for chaining calls, i.e., `win.a().b().c()`
* Implemented using await to wait for the modal window to close, i.e., `await win.wait_to_close()`

## 🎉 Experience the Best Practices 🎉

**Download this project locally and run the example scene.**

## How To Use

1. Enable the ModalWindow addon

![image](./images/en_enable_addon.png)

2. Enable the ModalWindowManager in the globals setting

![image](./images/en_enable_manager.png)

3. Use this code to create the window: `ModalWinddowManager.create('Content','Title')`


## Supported Platforms
* Web
* Windows
* Linux
* Android
* iOS

## ⚠️ Please refer to the [🔗 Custom Preset Scene](./custom_modal_window_preset.tscn) for the node naming conventions to create custom window scenes.

## Assets 
* [Kenny UI Pack (CC0)](https://kenney.nl/assets/ui-pack)
* [Ninja Asset Pack(CC0)](https://pixel-boy.itch.io/ninja-adventure-asset-pack)
* [Pixelated Elegance Font - CC0](https://ggbot.itch.io/pixelated-elegance-font)

## Todo
* Write a documents