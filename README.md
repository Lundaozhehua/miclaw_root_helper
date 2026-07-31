# Miclaw Root Helper

KSU/Magisk 模块：开机自启 nc 9999 root shell + host-mcp MCP bridge，**无需 Termux:Boot**。

## 功能

- 🔧 **nc 9999**：开机自动启动 root shell 监听（127.0.0.1:9999）
- 🌐 **host-mcp**：MCP bridge 服务（127.0.0.1:8765），供 miclaw AI 助手调用
- 📁 **自动部署**：模块内置 host-mcp 二进制 + 配置，开机自动部署到 `/data/adb/host-mcp/`
- 🔇 **完全静默**：无 UI 弹出，无 Termux Activity 启动
- 📦 **安装顺序无关**：模块和 Termux 先装后装均可

## 前置条件

- KSU (KernelSU) 或 Magisk
- Android 设备
- [可选] Termux（用于扩展 bash/python/node 工具）

## 安装

1. 下载最新 release zip
2. 在 KSU/Magisk 管理器中刷入
3. 重启
4. 配置 miclaw MCP 连接（见下方）

## miclaw MCP 配置

在 miclaw 中配置 `mcp/mcp_servers.json`：

```json
{
    "servers": [
        {
            "name": "host-mcp",
            "url": "http://127.0.0.1:8765/mcp",
            "headers": {
                "Authorization": "Bearer <token from config/token>"
            }
        }
    ]
}
```

## 目录结构

```
/
├── module/              # KSU 模块源码
│   ├── META-INF/        # 刷机包结构
│   ├── module.prop      # 模块信息
│   ├── service.sh       # 开机启动脚本
│   └── uninstall.sh     # 卸载清理
├── config/              # host-mcp 配置
│   ├── config.json      # host-mcp 服务配置
│   └── token            # API 认证 token
├── setup.sh             # 手动配置脚本
├── build.sh             # 构建脚本
├── LICENSE
└── README.md
```

## 启动流程

```
等开机完成 → sleep 10 → nc 9999 启动 → 部署 host-mcp → mkdir Termux 目录 → 启动 host-mcp
```

## Changelog

### v5.3.3 (2026-07-31)
- ✅ service.sh 加 `mkdir -p` 解决安装顺序问题（模块先装/Termux 先装均可）
- ✅ 删除 Termux 自动初始化逻辑（不再闪 UI）
- ✅ 完全静默后台运行

### v5.3.2
- 固定 config.json 和 token 打包

### v5.3.1
- service.sh 清理冗余逻辑

### v5.3.0
- 去掉 Termux 自动装包，简化启动流程

### v5.2.0
- Termux 自动初始化增强

### v5.1.0
- host-mcp 迁移到 `/data/adb/host-mcp/`（解决 SELinux 问题）

### v5.0.0
- 初版：nc 9999 + host-mcp + Termux 自动初始化

## 原理

模块开机后执行 `service.sh`：
1. `nc -ll -p 9999 -e /system/bin/sh` 提供 root shell
2. 将内置的 host-mcp 二进制和配置部署到 `/data/adb/host-mcp/`
3. 启动 `host-mcp serve` 提供 MCP 协议服务
4. miclaw 通过 localhost 连接 host-mcp 执行 root 命令

## 致谢

- **[host-mcp](https://github.com/Thiasap/host-mcp)** by [Thiasap](https://github.com/Thiasap) — Streamable HTTP MCP server for Termux/Linux/WSL，本模块的核心组件
- [KernelSU](https://github.com/tiann/KernelSU) — Android root 方案

> ⚠️ host-mcp 为第三方项目，本仓库仅将其打包为 KSU 模块方便使用。host-mcp 二进制文件的版权归原作者所有。

## License

MIT
