# PiliPlus 任务入口
# 统一使用 just 作为命令运行器：https://github.com/casey/just

# Windows 下显式使用 PowerShell 作为执行 shell（just 默认找 sh.exe，纯 PowerShell 环境 PATH 里没有）
set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]

# 默认：release 全量编译（按 ABI 分包）
default: build

alias b := build
alias d := debug
alias r := run
alias p := patch

# 给 Flutter SDK 和 pub 依赖打补丁（首次搭建、或升级 Flutter 版本后才需要跑）
# GITHUB_WORKSPACE 是 patch.ps1 依赖的 CI 环境变量，本地指向仓库根即可
patch:
    $env:GITHUB_WORKSPACE = '{{justfile_directory()}}'; pwsh lib/scripts/patch.ps1 android

# 生成版本信息文件 pili_release.json（会改写 pubspec.yaml 的 version 行，属构建副作用，提交代码前注意还原）
version:
    pwsh lib/scripts/build.ps1 android

# release 编译，按 ABI 分包；产物在 build/app/outputs/flutter-apk/，手机装 arm64-v8a 那个
build:
    flutter build apk --release --split-per-abi --dart-define-from-file=pili_release.json

# 不生成版本信息的 release 编译（App 内版本号显示 SNAPSHOT）
build-snapshot:
    flutter build apk --release --split-per-abi

# debug 包（applicationId 带 .debug 后缀，可与 release 共存）
debug:
    flutter build apk --debug

# 连接设备调试，支持热重载（USB 或无线 adb 均可，设备需先被 flutter devices 识别）
run:
    flutter run

# 拉取依赖（改了 pubspec.yaml 后执行）
deps:
    flutter pub get

# 清理构建产物（遇到莫名其妙的编译错误时先试这个）
clean:
    flutter clean
