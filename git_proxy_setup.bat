@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

title GitHub连接问题解决工具

:MENU
cls
echo GitHub连接问题解决工具
echo =======================
echo.
echo 请选择一个选项:
echo 1) 设置HTTP代理
echo 2) 清除代理设置
echo 3) 将远程URL更改为SSH
echo 4) 使用GitHub CDN
echo 5) 延长连接超时时间
echo 6) 检查当前设置
echo q) 退出
echo.

set /p choice=您的选择: 

if "%choice%"=="1" goto SETUP_PROXY
if "%choice%"=="2" goto CLEAR_PROXY
if "%choice%"=="3" goto CHANGE_TO_SSH
if "%choice%"=="4" goto USE_FASTLY
if "%choice%"=="5" goto EXTEND_TIMEOUT
if "%choice%"=="6" goto CHECK_SETTINGS
if /i "%choice%"=="q" goto END
echo 无效的选择,请重试
timeout /t 2 > nul
goto MENU

:SETUP_PROXY
cls
echo 设置HTTP代理
echo ===========
echo.
set /p proxy_address=请输入HTTP代理地址 (例如: 127.0.0.1:7890): 

git config --global http.proxy "http://%proxy_address%"
git config --global https.proxy "http://%proxy_address%"
    
echo 代理已设置为: %proxy_address%
echo 您可以使用以下命令查看当前代理设置:
echo git config --global --get http.proxy
echo git config --global --get https.proxy
echo.
pause
goto MENU

:CLEAR_PROXY
cls
echo 清除代理设置
echo ===========
echo.

git config --global --unset http.proxy
git config --global --unset https.proxy
echo 已清除所有代理设置
echo.
pause
goto MENU

:CHANGE_TO_SSH
cls
echo 将远程URL更改为SSH
echo ================
echo.
echo 请确认您已经设置好SSH密钥并添加到GitHub账户
echo.
echo 当前远程仓库URL:
git remote -v
echo.
set /p remote_name=请输入远程仓库名称 (通常是origin): 

for /f "tokens=*" %%a in ('git remote get-url %remote_name%') do set current_url=%%a
echo 当前URL: !current_url!

if "!current_url:~0,19!"=="https://github.com/" (
    set repo_path=!current_url:~19!
    set ssh_url=git@github.com:!repo_path!
    
    git remote set-url %remote_name% "!ssh_url!"
    echo 已将远程URL更改为: !ssh_url!
) else (
    echo 当前URL不是GitHub HTTPS URL,无法自动转换
)
echo.
pause
goto MENU

:USE_FASTLY
cls
echo 使用GitHub CDN
echo =============
echo.

git config --global url."https://github.global.ssl.fastly.net/".insteadOf "https://github.com/"
echo 已配置使用fastly CDN代替直接连接GitHub
echo.
pause
goto MENU

:EXTEND_TIMEOUT
cls
echo 延长连接超时时间
echo ==============
echo.

git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
echo 已增加Git的连接超时时间
echo.
pause
goto MENU

:CHECK_SETTINGS
cls
echo 检查当前设置
echo ===========
echo.

echo 当前Git代理设置:
git config --global --get http.proxy
git config --global --get https.proxy
echo.
echo 当前远程仓库URL:
git remote -v
echo.
pause
goto MENU

:END
exit /b