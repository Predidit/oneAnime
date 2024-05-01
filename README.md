# oneAnime

使用 flutter 开发的 Anime1 第三方客户端, 一款简洁清爽无广告的看番软件。界面符合 Material You 规范。除了番剧，还有弹幕 (～￣▽￣)～

## 支持平台

- Android 10 and Above
- Windows 10 1806 and Above

## 功能 / 开发计划

- [x] 番剧目录
- [x] 番剧搜索
- [x] 番剧时间表
- [x] 番剧字幕
- [x] 分集播放
- [x] 倍速播放
- [x] 视频播放器
- [x] 硬件加速
- [x] 高刷适配
- [x] 在线更新
- [x] 配色方案
- [x] 追番列表
- [x] 番剧弹幕 <(￣︶￣)> 这个真的可以有
- [ ] 番剧下载
- [ ] 番剧更新提醒
- [ ] 还有更多 (/・ω・＼) 

## 下载

通过本页面 [release](https://github.com/Predidit/oneAnime/releases) 选项卡下载

## Q&A

#### Q: 番剧列表中的番剧为什么只有简介，没有精致的封面

A: 受限于 Anime1 网站本身的架构与设计，Anime1 不向用户提供精致的番剧封面。作为第三方客户端开发者，我们对此无能为力。

#### Q: 我在尝试自行编译该项目，编译的 windows 版本缺乏搜索优化功能。

 A: 本项目编译需要良好的网络环境，如果您位于中国大陆，可能需要设置恰当的镜像地址。同时由于 flutter_open_chinese_conventer 库并不支持 windows 平台，我们另外编译了 opencc 项目的动态链接库以解决兼容问题。我们略微裁剪过的 opencc 实现开源在 [这里](https://github.com/Predidit/open_chinese_convert_bridge)， 将由此项目编译得到的 opencc.dll 放在本项目编译产物目录下即可修复搜索优化功能。

 #### Q: 本项目使用 webview 技术吗，我不想要套壳浏览器。

 A: APP正常运行状态下不会加载 webview， 我们也很讨厌套壳浏览器。


 ## 致谢

特别感谢 [AnimeOne](https://github.com/HQAnime/AnimeOne) 本项目使用了部分来自 AnimeOne 的代码以处理与 Anime1 的交互

特别感谢 [DandanPlayer](https://www.dandanplay.com/) 本项目使用了 dandanplayer 开放API 以提供弹幕交互。

特别感谢 [Bangumi](https://bangumi.tv/) 本项目使用了 Bangumi 开放API 以提供番剧元数据。

感谢 [media_kit](https://github.com/media-kit/media-kit) 本项目跨平台媒体播放能力来自 media_kit

感谢 [hive](https://github.com/isar/hive) 本项目持久化储存能力来自 hive




