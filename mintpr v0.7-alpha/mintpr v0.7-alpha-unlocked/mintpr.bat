@echo off
color 0a
title MintPR vtest

rem entering externals to prime interpolation software
cd externals
if exist eula.txt (
	goto :a
) else (
	goto :b
)

:a
echo MintPR vtest-github.com/presidente-nixon/MintPR Copyright (c) 2021 presidente_nixon
rem starting a new command prompt instance
start /b prompt :
exit

:b
echo MIT License
echo.
echo Copyright (c) 2021 presidente_nixon
echo MintPR uses FFmpeg under the LGPLv2.1.
echo I do not own FFmpeg, the relevant owners can be found at http://ffmpeg.org
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo.
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
set /p eula="accept [y/n]: "
if %eula%==y (
	echo. > eula.txt
	cls
	goto d
	:c
	rem starting a new command prompt instance
	start /b prompt :
	exit
) else (
	exit
)

:d
echo MintPR vtest-github.com/presidente-nixon/MintPR Copyright (c) 2021 presidente_nixon
goto c