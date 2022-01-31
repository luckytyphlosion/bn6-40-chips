#mkdir "temp" 2> /dev/null
tools/armips.exe src.s -strequ ver "bn6f.s"
tools/armips.exe src.s -strequ ver "bn6g.s"
#if errorlevel 1 pause
# tools\armips src.s -strequ ver "bn6g.s"
# if errorlevel 1 pause