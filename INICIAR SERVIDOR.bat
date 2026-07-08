@echo off
title Sistema de Cotacao FX - Servidor
echo.
echo  ==========================================
echo   Iniciando servidor do Sistema de Cotacao
echo  ==========================================
echo.
echo  Mantenha esta janela aberta enquanto usa o sistema.
echo  Para acessar: http://127.0.0.1:8766/cotacao-fx.html
echo.
cd /d "%~dp0"
start http://127.0.0.1:8766/cotacao-fx.html
python -m http.server 8766
pause
