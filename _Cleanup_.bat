@echo off
title Delete temp files (Delphi)
cls
echo Deleting....
del *.dcu /s
del *.ppu /s
del *.o /s
del *.~* /s
del *.dsk /s
del *.cfg /s
del *.dof /s
del *.bk? /s
del *.mps /s
del *.rst /s
del *.s /s
del *.a /s
del *.local /s
del *.identcache /s
del *.ddp
pause
echo Clear...
exit