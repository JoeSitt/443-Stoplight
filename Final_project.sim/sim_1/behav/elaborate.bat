@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 8110430ed1d442d39ac9911b7f6256a4 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot stop_light_behav xil_defaultlib.stop_light -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
