@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo  CMEtK — Sistema de Cotacao
echo  Iniciando servidor local...
echo.

:: Verifica se Python esta instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo  ERRO: Python nao encontrado.
    echo  Instale em: https://python.org/downloads
    pause
    exit /b 1
)

:: Mata qualquer servidor na porta 8765 que ja esteja rodando
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8765') do taskkill /PID %%a /F >nul 2>&1

:: Inicia servidor HTTP em background
start /B python -m http.server 8765 --bind 127.0.0.1

:: Aguarda 1 segundo e abre o navegador
timeout /t 1 /nobreak >nul
start http://127.0.0.1:8765/cotacao-cmetk.html

echo  Sistema aberto no navegador.
echo  Para encerrar, feche esta janela.
echo.

:: Mantém o servidor rodando
:loop
timeout /t 5 /nobreak >nul
goto loop
