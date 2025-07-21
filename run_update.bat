@echo off
echo ===== Down2Markdown 自动更新工具 =====
echo.

REM 检查Python是否已安装
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到Python安装。请安装Python 3.6或更高版本。
    echo 您可以从 https://www.python.org/downloads/ 下载Python。
    echo.
    pause
    exit /b 1
)

echo [信息] 检测到Python安装。
echo.

REM 安装所需的依赖项
echo [信息] 正在安装所需的依赖项...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [错误] 安装依赖项失败。
    pause
    exit /b 1
)
echo [信息] 依赖项安装成功。
echo.

REM 运行更新脚本
echo [信息] 开始运行自动更新脚本...
python auto_update.py
if %errorlevel% neq 0 (
    echo [错误] 更新过程失败。请查看update_log.txt获取详细信息。
    pause
    exit /b 1
)

echo.
echo [信息] 更新过程已完成。
pause
exit /b 0