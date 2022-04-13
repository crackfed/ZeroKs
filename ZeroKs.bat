@echo off
enabledelayedexpansion
if not exist %~dp0temp md %~dp0temp
if not exist %~dp0implode md %~dp0implode
if not exist %~dp0explode md %~dp0explode
:Option
setlocal
cls
echo.
echo.                     ZeroKs v. 0.00
echo.
echo.             I-mplode  E-xplode  N-fo  X-it
echo.
set /p "option=Select:->"
if %option%==I set option=i
if %option%==i goto :Implode
if %option%==E set option=e
if %option%==e goto :Explode
if %option%==N set option=n
if %option%==n call :Info
if %option%==X set option=x
if %option%==x echo Thank you and goodbye.&exit /b
goto :Option
:Implode
echo.
echo              ZeroKs implode file to 0 bytes
echo.
echo Set input directory (file to implode)
echo ENTER for default [%~dp0]
set /p "ImplodeInputDir=:->"
if not defined ImplodeInputDir set ImplodeInputDir=%~dp0
if not exist %ImplodeInputDir% goto :Implode
echo.
echo Directory of %ImplodeInputDir%
echo.
set num=0
for %%A in (%ImplodeInputDir%\*.*) do (
set /a num=!num!+1
set file!num!=%%~nxA
echo !num!	%%~nxA)
echo.
echo Select file by number
set /p "ImplodeInputFileNum=:->"
set OriginalFileName=!file%ImplodeInputFileNum%!
for %%A in (%ImplodeInputDir%\%OriginalFileName%) do (
set ImplodeInputFilePathName=%%~fA)
echo.
echo Set output directory
echo ENTER for default [%~dp0implode\]
set /p "ImplodeOutputDir=:->"
if not defined ImplodeOutputDir set ImplodeOutputDir=%~dp0implode
if not exist %ImplodeOutputDir% goto :Implode
call CERTUTIL.EXE -encode %ImplodeInputFilePathName% %~dp0temp\%OriginalFileName%.enc >nul
call FIND.EXE /c "==" %~dp0temp\%OriginalFileName%.enc >nul
set el=%errorlevel%
call FIND.EXE /c "=" %~dp0temp\%OriginalFileName%.enc >nul
set el=%el%%errorlevel%
set linenumber=10000
for /f "skip=1 usebackq delims=" %%A in ("%~dp0temp\%OriginalFileName%.enc") do (
set /a linenumber=!linenumber!+1
set "line=%%A"
set "line=!line:/=(!"
set "line=!line:+=)!"
set /a totalfiles=!linenumber!-10001
if "!line:~0,1!"=="-" set /a numfiles=!linenumber!-10001 & set line=!numfiles!_files_%el%&set linenumber=10000
copy /y nul %ImplodeOutputDir%\%OriginalFileName%[!linenumber!]!line! >nul)
del %~dp0temp\%OriginalFileName%.enc
echo.
echo ZeroKs file implode complete.
echo !OriginalFileName! saved as (%totalfiles%) 0 byte files in [%ImplodeOutputDir%\]
echo.
endlocal
pause
goto :Option
:Explode
setlocal
echo.
echo           ZeroKs explode file to original state
echo.
echo Set input directory
echo ENTER for default [%~dp0implode\]
set /p "ExplodeInputFileDir=:->"
if not defined ExplodeInputFileDir set ExplodeInputFileDir=%~dp0implode
if not exist %ExplodeInputFileDir% goto :Explode
echo.
echo Directory of %ExplodeInputFileDir%
echo.
set num=0
for %%A in (%ExplodeInputFileDir%\*10000*.*) do (
set /a num=!num!+1
set file!num!=%%~nxA
echo !num!	%%~nxA)
echo.
echo Select file by number
set /p "ExplodeInputFileNum=:->"
echo.
echo Set output directory
echo ENTER for default [%~dp0explode\]
set /p "ExplodeOutputDir=:->"
if not defined ExplodeOutputDir set ExplodeOutputDir=%~dp0explode
set indexfile=!file%ExplodeInputFileNum%!
call :Countloop
copy nul %~dp0temp\%OriginalFileName%.enc >nul
for /f "skip=1" %%A in ('dir /o /a-d /b %ExplodeInputFileDir%\%OriginalFileName%*') do ( 
set line=%%A
set line=!line:~%startpos%!
set "line=!line:(=/!"
set "line=!line:)=+!"
echo !line! >> %~dp0temp\!OriginalFileName!.enc)
for /f %%A in ('dir /o /a-d /b %ExplodeInputFileDir%\%OriginalFileName%*_*.*') do ( 
set addon=%%A
set "addon=!line:~-2")
for %%A in (%ExplodeOutputDir%\%OriginalFileName%) do (
set ExplodeOutputFilePathName=%%~fA)
if exist %ExplodeOutputFilePathName% (
echo.
echo File %ExplodeOutputFilePathName% exists.
set /p "ow=Overwrite? (Y/N):->"
if !ow!==Y set ow=y
if not !ow!==y (
goto :Option
) else (     
del %ExplodeOutputFilePathName%))    
if !addon!==01 echo ==>> %~dp0temp\%OriginalFileName%.enc
if !addon!==10 echo =>> %~dp0temp\%OriginalFileName%.enc
call CERTUTIL.EXE -decode %~dp0temp\%OriginalFileName%.enc %ExplodeOutputFilePathName% >nul
del %~dp0temp\%OriginalFileName%.enc
echo.
echo ZeroKs file explode complete.
echo !OriginalFileName! restored in [%ExplodeOutputDir%\]
echo.
endlocal
pause
goto :Option
:Countloop
if not defined count set /a count=0
set /a count=%count%+1
set leftchr=%indexfile:~0,1%
set tempfilename=%tempfilename%%leftchr%
if "%leftchr%"=="[" set OriginalFileName=%tempfilename:~0,-1%
if "%leftchr%"=="]" set /a startpos=%count% & exit /b
set indexfile=%indexfile:~1%
goto :Countloop
:Info
echo.
echo Implosion. Collapse. Entropy. Dark matter. Zero.
echo.
echo ZeroKs will convert most any file to 0 K bytes,
echo at least from what you can tell by the file size.
echo.
echo When ZeroKs implodes a file, the data is not
echo stored IN files. Instead, it IS the files.
echo And the files are always size zero.
echo.
echo One consequence, in theory at least, is that
echo when a disk quota is in effect, the operating
echo system (or perhaps cloud server) may not see
echo the imploded files as using any space at all.
echo.
echo Zeroks is written entirely in Windows batch
echo so you know you're getting the best quality
echo code money can't buy. Plus, it's text readable.
echo.
echo Feel free to copy it. You can even ZeroKs it.
echo.
echo NO Copyright 2022 Jim Worley tirespider@gmail.com
echo.
pause
exit /b
