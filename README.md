# Linux System Health Monitor

[![Docker](https://img.shields.io/badge/Docker-Supported-blue.svg?logo=docker&logoColor=white)](https://www.docker.com/)
[![Linux](https://img.shields.io/badge/Platform-Linux%20%7C%20WSL-lightgrey.svg?logo=linux&logoColor=white)](https://www.kernel.org/)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20%2F%20Bash-orange.svg?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A lightweight, automated Linux system health monitoring script written in POSIX-compatible Shell (`/bin/sh`). It continuously monitors key system health metrics (CPU usage, memory consumption, disk capacity, and running process counts) at periodic intervals and immediately raises alerts when any metric breaches its predefined threshold.

---

## Dashboard Preview

<!-- Save your screenshot at docs/dashboard.png to display it here -->
<img width="562" height="215" alt="image" src="https://github.com/user-attachments/assets/8fb8abaa-6a60-41e1-a78f-f0fa13b5528b" />


---

## Features

- **Continuous Live Monitoring:** Automatically clears and refreshes the console display every 5 seconds.
- **Resource Metric Tracking:**
  - **CPU Utilization (%):** Computed dynamically using `top`.
  - **Memory Usage (%):** Derived from total vs. used RAM using `free -m`.
  - **Disk Space Usage (%):** Tracks root mount (`/`) consumption via `df -h`.
  - **Active Process Count:** Scans and counts all active tasks using `ps aux`.
- **Threshold Alerting:** Emits formatted `[ALERT]` messages whenever system resource limits are exceeded, alongside regular `[OK]` logs.
- **Graceful Termination:** Handles `SIGINT` (Ctrl+C) and `SIGTERM` signals for clean shutdown without leaving lingering background tasks.
- **Universal Linux Compatibility:** Uses standard POSIX shell (`#!/bin/sh`) syntax, allowing it to run natively on any Linux distribution, WSL, or inside minimal container images like Alpine.

---

## Predefined Thresholds

| Metric | Target | Threshold | Log Status |
| :--- | :--- | :--- | :--- |
| **CPU Usage** | CPU Cores | `> 80%` | `[ALERT]` if breached, else `[OK]` |
| **Memory Usage** | System RAM | `> 80%` | `[ALERT]` if breached, else `[OK]` |
| **Disk Space** | Root (`/`) | `> 80%` | `[ALERT]` if breached, else `[OK]` |
| **Process Count** | Total Tasks | `> 100` | `[ALERT]` if breached, else `[OK]` |

*Note: You can adjust the thresholds (`CPU_THRESHOLD`, `MEM_THRESHOLD`, `DISK_THRESHOLD`, `PROC_THRESHOLD`) and update interval (`INTERVAL`) directly at the top of the script.*

---

## Method 1: Running Directly on Native Linux / WSL (Without Docker)

You can run this script directly on bare-metal Linux servers, virtual machines, or Windows Subsystem for Linux (WSL).

### 1. Prerequisites
Ensure standard system utilities are installed:

- **Ubuntu / Debian:**
  ```bash
  sudo apt update && sudo apt install -y procps coreutils
