# oneAnime

使用 flutter 开发的 Anime1 第三方客户端, 一款简洁清爽无广告的看番软件。界面符合 Material You 规范。除了番剧，还有弹幕 (～￣▽￣)～

## 支持平台

- Android 10 及以上
- Windows 10 1806 及以上
- macOS 10.15 及以上 
- Linux

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

## 免责声明

本项目基于 GNU 通用公共许可证第3版（GPL-3.0）授权。我们不对其适用性、可靠性或准确性作出任何明示或暗示的保证。在法律允许的最大范围内，作者和贡献者不承担任何因使用本软件而产生的直接、间接、偶然、特殊或后果性的损害赔偿责任。

使用本项目需遵守所在地法律法规，不得进行任何侵犯第三方知识产权的行为。因使用本项目而产生的数据和缓存应在24小时内清除，超出24小时的使用需获得相关权利人的授权。

## 禁止商用条款

本软件仅供个人学习、研究或非商业用途。禁止将本软件用于任何商业目的，包括但不限于出售、出租、许可或以其他形式从中获利。

## 致谢

特别感谢 [AnimeOne](https://github.com/HQAnime/AnimeOne) 本项目使用了部分来自 AnimeOne 的代码以处理与 Anime1 的交互

特别感谢 [DandanPlayer](https://www.dandanplay.com/) 本项目使用了 dandanplayer 开放API 以提供弹幕交互。

特别感谢 [Bangumi](https://bangumi.tv/) 本项目使用了 Bangumi 开放API 以提供番剧元数据。

感谢 [fvp](https://github.com/wang-bin/fvp) 本项目跨平台媒体播放能力来自 fvp

感谢 [hive](https://github.com/isar/hive) 本项目持久化储存能力来自 hive




