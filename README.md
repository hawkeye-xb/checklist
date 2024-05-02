# 勾勾清单
## 项目背景
- 从0落地过Flutter项目
- 个人生活需要

最近临近过年，加上经常出门，需要频繁列出门必带物品的确认清单。本来用的华为备忘录，一次两次还好，都重新列，但是却没有复制的功能！复制的内容需要重新设置成Todo清单，另外带提醒功能的不聚会，容易与别的提醒搞混。接着研究了iPhone的备忘录，也没有！并且都不能快速创建副本。

所以就造了个轮子，一开始使用web indexDB做过一版有功能没有ui的，打算将web tab添加到桌面快速打开，通过浏览器tab做快速打开也勉强能接受，不过得联网（没法通过发送文件，直接将HTML添加到桌面），还有就是我可能就我接受了。

后续是想要添加提醒功能，作为无联网日常小工具使用，使用过weex和rn之后，开发感确实也谈不上太好，更别说直接webview的方式了，苹果都提示禁止提示了十多年了。也正好，作为独立开发过河摸石头，在这基础上刚好想要试试Flutter，就改APP开发了。

除了快速副本确认清单，可以根据新文件修改清单内容之外；还找到了个场景，比如：起床八段锦、睡前十分钟阅读也是个人可以使用上的。

## 功能整理

## 开发过程（Blog）
过程记录，作为Blog分享。方便给大家做个参考，说不准什么时候、什么原因，想要成为独立开发者。
- [Flutter 环境搭建](https://hawkeye-xb.xyz/zh/posts/flutter/armmacosenvsetup/)
- 研发过程
	- [代码开发，仰仗GPT大哥](https://hawkeye-xb.xyz/zh/posts/flutter/sometriviaaboutthedevelopmentprocess/)
  - GPT的一些使用。
  - Github Copilot的一些使用。
  - [FLutter 打包APK](https://hawkeye-xb.xyz/zh/posts/flutter/buildapkandaab/)

- 图标设计。
- APP 发布
	- apple app store（Todo：买账号..）
	- google play（进行中）
	  - 账号（需要充25刀）
		- App bundle发布
		- apk发布
	- ~~华为应用商城（国内需要软著）~~
	- APK 发布Github Release（CICD已完成）✅
	  - 手动发布到Github Release
	  - [自动构建、发布到Github Release](https://hawkeye-xb.xyz/zh/posts/flutter/githubcicdproject/)
### 
## Release
1. **app-armeabi-v7a-release.apk**:
    - 这个APK是为搭载ARMv7或更低版本CPU架构的设备准备的。ARMv7架构是一种32位架构，广泛用于较旧的Android设备中。
2. **app-arm64-v8a-release.apk**:
    - 这个APK是为搭载ARMv8-A（通常称为arm64）CPU架构的设备准备的。ARMv8-A是一种64位架构，提供了更好的性能和更高效的能源使用，是现代Android设备中常见的架构。

[所有下载安装包](https://github.com/hawkeye-xb/checklist/releases)
