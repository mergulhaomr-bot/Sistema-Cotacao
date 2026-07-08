@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo  Fentex Surgical -- Sistema de Cotacao FX
echo  Iniciando servidor local...
echo.

:: Detecta o comando Python disponivel
set PYCMD=
py --version >nul 2>&1
if not errorlevel 1 set PYCMD=py

if "%PYCMD%"=="" (
python --version >nul 2>&1
if not errorlevel 1 set PYCMD=python
)

if "%PYCMD%"=="" (
python3 --version >nul 2>&1
if not errorlevel 1 set PYCMD=python3
)

if "%PYCMD%"=="" (
    echo  ERRO: Python nao encontrado.
    echo  Instale em: https://python.org/downloads
    pause
    exit /b 1
)

echo  Python encontrado: %PYCMD%

:: Mata servidor anterior na porta 8766
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8766') do taskkill /PID %%a /F >nul 2>&1

:: Inicia servidor
start /B %PYCMD% servidor.py

timeout /t 2 /nobreak >nul
start http://127.0.0.1:8766/cotacao-fx.html?v=3

echo  Sistema aberto. Para encerrar, feche esta janela.
echo.

:loop
timeout /t 5 /nobreak >nul
goto loop
