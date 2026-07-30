# Miclaw Root Helper

[English](#english) | [中文](#中文)

---

## 中文

### 简介

Miclaw Root Helper 是一个 KernelSU / Magisk 模块，为 [miclaw](https://github.com/anthropics/claude-code) AI 助手提供 root 权限执行能力。

### 功能

- **NC Root Shell** — 在 `127.0.0.1:9999` 监听，提供 root shell 访问
- **host-mcp 桥接** — 自动启动 host-mcp 服务，为 miclaw 提供 MCP 工具调用能力
- **开机自启** — service.sh 在开机时自动启动所有服务
- **自动恢复** — 服务崩溃后自动重启

### 前置条件

- Android 设备已 root（KernelSU 或 Magisk）
- 已安装 [miclaw](https://github.com/anthropics/claude-code) AI 助手

### 安装

#### 方法一：下载预编译包

1. 从 [Releases](../../releases) 下载最新 zip
2. 在 KSU / Magisk 管理器中刷入
3. 重启设备

#### 方法二：从源码构建

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/miclaw_root_helper.git
cd miclaw_root_helper

# 运行构建脚本（自动下载 host-mcp 二进制）
chmod +x build.sh
./build.sh v3.0

# 生成的 zip 文件在当前目录
```

### 文件结构

```
miclaw_root_helper/
├── module/
│   ├── module.prop          # 模块元数据
│   ├── service.sh           # 开机启动脚本
│   ├── uninstall.sh         # 卸载清理脚本
│   ├── META-INF/            # KSU/Magisk 刷入脚本
│   └── host-mcp             # (构建时自动下载，不包含在仓库中)
├── build.sh                 # 构建脚本
├── LICENSE                  # MIT License
└── README.md                # 本文件
```

### 工作原理

1. 设备开机后，`service.sh` 等待 `sys.boot_completed`
2. 启动 NC 监听器：`toybox nc -s 127.0.0.1 -p 9999 -L /system/bin/sh -l`
3. 启动 host-mcp 服务：`host-mcp serve`（监听 `127.0.0.1:8765`）
4. miclaw 通过 host-mcp 获得 root shell 执行能力

### 端口说明

| 服务 | 端口 | 用途 |
|------|------|------|
| NC Root Shell | 127.0.0.1:9999 | 直接 root shell 访问 |
| host-mcp | 127.0.0.1:8765 | MCP 工具调用桥接 |

### 致谢

- [host-mcp](https://github.com/mark3labs/mcphost) — MCP 桥接服务
- [KernelSU](https://github.com/tiann/KernelSU) — Android root 方案

### License

[MIT](LICENSE)

---

## English

### Introduction

Miclaw Root Helper is a KernelSU / Magisk module that provides root execution capabilities for the [miclaw](https://github.com/anthropics/claude-code) AI assistant.

### Features

- **NC Root Shell** — Listens on `127.0.0.1:9999` for root shell access
- **host-mcp bridge** — Auto-starts host-mcp service for MCP tool calling
- **Auto-start on boot** — service.sh starts all services on boot
- **Auto-recovery** — Services restart automatically after crash

### Prerequisites

- Rooted Android device (KernelSU or Magisk)
- [miclaw](https://github.com/anthropics/claude-code) AI assistant installed

### Installation

#### Option 1: Download pre-built package

1. Download the latest zip from [Releases](../../releases)
2. Flash via KSU / Magisk manager
3. Reboot

#### Option 2: Build from source

```bash
git clone https://github.com/YOUR_USERNAME/miclaw_root_helper.git
cd miclaw_root_helper
chmod +x build.sh
./build.sh v3.0
```

### How it works

1. On boot, `service.sh` waits for `sys.boot_completed`
2. Starts NC listener: `toybox nc -s 127.0.0.1 -p 9999 -L /system/bin/sh -l`
3. Starts host-mcp service: `host-mcp serve` (listens on `127.0.0.1:8765`)
4. miclaw uses host-mcp to execute commands with root privileges

### Ports

| Service | Port | Purpose |
|---------|------|---------|
| NC Root Shell | 127.0.0.1:9999 | Direct root shell access |
| host-mcp | 127.0.0.1:8765 | MCP tool calling bridge |

### Acknowledgments

- [host-mcp](https://github.com/mark3labs/mcphost) — MCP bridge service
- [KernelSU](https://github.com/tiann/KernelSU) — Android root solution

### License

[MIT](LICENSE)
