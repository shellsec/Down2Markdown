# 笔记应用程序自动更新工具

这是一个智能的自动更新工具，用于自动检查并更新多个主流笔记应用程序。

## 🚀 功能特性

- **多应用支持**: 同时支持6个主流笔记应用程序
- **智能检测**: 自动检查GitHub上的最新版本
- **一键更新**: 自动下载、安装最新版本
- **进程管理**: 智能终止旧进程，确保更新顺利进行
- **详细日志**: 完整的更新过程记录
- **配置灵活**: 可轻松启用/禁用特定应用程序

## 📱 支持的应用程序

| 应用程序 | 描述 | GitHub仓库 |
|---------|------|-----------|
| **Obsidian** | 强大的Markdown笔记应用 | [obsidianmd/obsidian-releases](https://github.com/obsidianmd/obsidian-releases) |
| **NoteGen** | AI驱动的智能笔记应用 | [codexu/note-gen](https://github.com/codexu/note-gen) |
| **Yank Note** | 开源笔记应用 | [purocean/yn](https://github.com/purocean/yn) |
| **Joplin** | 端到端加密笔记应用 | [laurent22/joplin](https://github.com/laurent22/joplin) |
| **思源笔记** | 本地优先的笔记应用 | [siyuan-note/siyuan](https://github.com/siyuan-note/siyuan) |
| **Trilium Notes** | 分层笔记应用 | [TriliumNext/Trilium](https://github.com/TriliumNext/Trilium) |

## 🛠️ 使用方法

### 快速开始

0. **无需依赖，**双击运行** `文件smart_updater.bat` 
1. **需要依赖的，双击运行** `run_update.bat` 文件
2. 脚本将自动检查依赖项、下载最新版本并安装所有启用的应用程序

### 手动运行

如果您已经安装了Python和所需的依赖项，也可以直接运行Python脚本：

```bash
python auto_update.py
```

## ⚙️ 配置说明

### 启用/禁用应用程序

在 `auto_update.py` 文件顶部的 `APPS_CONFIG` 字典中，您可以控制哪些应用程序参与自动更新：

```python
"obsidian": {
    "name": "Obsidian",
    "github_url": "https://github.com/obsidianmd/obsidian-releases/releases",
    "process_name": "Obsidian.exe",
    "enabled": True,  # 设置为 False 可禁用此应用程序
    "download_pattern": "Obsidian-{version}.exe",
    "version_format": "v{version}"
}
```

### 调整更新延迟

修改 `UPDATE_DELAY` 变量来调整应用程序之间的更新延迟（默认5秒）：

```python
UPDATE_DELAY = 10  # 改为10秒延迟
```

## 📋 系统要求

- **操作系统**: Windows 10/11
- **Python**: 3.6 或更高版本
- **网络**: 稳定的网络连接以访问GitHub
- **权限**: 管理员权限（推荐）

## 📁 文件说明

| 文件 | 说明 |
|------|------|
| `auto_update.py` | 主要的更新脚本 |
| `requirements.txt` | Python依赖项列表 |
| `run_update.bat` | 批处理文件，用于安装依赖并运行脚本 |
| `update_log.txt` | 更新过程的详细日志文件 |
| `github_page.html` | GitHub页面缓存（用于调试） |

## 📊 更新流程

1. **网络检查**: 验证网络连接
2. **版本检测**: 检查每个应用程序的最新版本
3. **下载安装**: 下载最新安装程序
4. **进程管理**: 终止旧版本进程
5. **自动安装**: 运行新版本安装程序
6. **状态报告**: 显示更新结果统计

## 📝 日志示例

```
2025-01-16 10:30:15 - INFO - === 开始自动更新过程 ===
2025-01-16 10:30:15 - INFO - 网络连接正常
2025-01-16 10:30:15 - INFO - 将更新以下应用程序: ['Obsidian', 'NoteGen', 'Yank Note', 'Joplin', '思源笔记', 'Trilium Notes']
2025-01-16 10:30:15 - INFO - 正在更新 Obsidian (1/6)
2025-01-16 10:30:18 - INFO - 找到最新版本: v1.8.10
2025-01-16 10:30:25 - INFO - Obsidian 更新成功
2025-01-16 10:30:30 - INFO - 正在更新 NoteGen (2/6)
...
```

## ⚠️ 注意事项

- **进程终止**: 脚本运行时会终止当前运行的应用程序进程
- **管理员权限**: 建议以管理员身份运行以确保正确安装
- **防火墙设置**: 确保防火墙允许脚本访问GitHub
- **备份数据**: 建议在更新前备份重要数据
- **网络稳定**: 确保网络连接稳定，避免下载中断

## 🔧 故障排除

### 常见问题

1. **网络连接失败**
   - 检查网络连接
   - 确认防火墙设置
   - 尝试使用VPN

2. **权限不足**
   - 以管理员身份运行
   - 检查杀毒软件设置

3. **下载失败**
   - 检查磁盘空间
   - 确认网络稳定性
   - 查看详细错误日志

### 查看日志

详细的错误信息会记录在 `update_log.txt` 文件中，可用于排查问题。

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个工具！

## �� 许可证

本项目采用MIT许可证。