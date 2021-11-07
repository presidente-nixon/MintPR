@echo off
setlocal enabledelayedexpansion
color 0a
title MintPR vtest
rem MintPR vtest-github.com/presidente-nixon/MintPR Copyright (c) 2021 presidente_nixon

set /a instance=%1

cd ..
for /f "usebackq tokens=* delims=" %%a in (settings.txt) do (
	set %%a
)

set outLocation=!outLocation:~1,-1!

rem interpolation
cd ..
cd input
for %%a in ("*.!fileType!") do (
	set fileName=%%a
	set name=!fileName:~0,-4!
	
	cd ..
	if exist "workspace\subworkspace!instance!\!name!.txt" (
		rem how many times this instance has tried to process the video
		for /f "usebackq tokens=* delims=" %%b in ("workspace\subworkspace!instance!\!name!.txt") do (
			set /a amountTried=%%b
		)
		
		rem changing amount for next round if any
		set /a amountTried+=1
		echo !amountTried! > workspace\subworkspace!instance!\!name!.txt
	) else (
		set amountTried=1
		echo !amountTried! > workspace\subworkspace!instance!\!name!.txt
	)
	
	rem split file name with file format
	set fileName2=!name! !instance!.mkv
	rem split file name
	set name2=!fileName2:~0,-4!
	
	echo.
	echo interpolation!instance!.bat: reading !fileName! variables...
	
	for /f "usebackq tokens=* delims=" %%b in ("workspace\!name!_settings.txt") do (
		set %%b
	)
	
	echo.
	echo interpolation!instance!.bat: !fileName! variables read
	
	echo.
	echo interpolation!instance!.bat: interpolating !fileName2!...
	echo.
	
	externals\ffmpeg -i "workspace\subworkspace!instance!\!fileName2!" -vf "minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=!interpolatedRate!'" -c:v !encoder! -b:v !bitrate!M -maxrate !maxBitrate!M -bufsize !bitrate!M "workspace\subworkspace!instance!\sub-out\!name2!.!amountTried!.mkv"
	
	echo.
	echo interpolation!instance!.bat: interpolated !fileName2!
	
	if !amountTried! geq 2 (
		echo.
		echo interpolation!instance!.bat: concatenating !fileName2!...
		echo file '!name2!.1.mkv' > workspace\subworkspace!instance!\sub-out\list.txt
		for /l %%b in (2,1,!amountTried!) do (
			set /a amountTried2=%%b
			echo file '!name2!.!amountTried2!.mkv' >> workspace\subworkspace!instance!\sub-out\list.txt
		)
		
		externals\ffmpeg -f concat -safe 0 -i workspace\subworkspace!instance!\sub-out\list.txt -video_track_timescale 90000 -strict -2 -c copy "workspace\subworkspace!instance!\sub-out\!fileName2!"
		
		echo.
		echo interpolation!instance!.bat: !fileName2! concatenated
	) else (
		ren "workspace\subworkspace!instance!\sub-out\!name2!.1.mkv" "!fileName2!"
	)
	
	echo.
	echo interpolation!instance!.bat: moving !fileName2!...
	
	move /y "workspace\subworkspace!instance!\sub-out\!fileName2!" output
	
	echo.
	echo interpolation!instance!.bat: !fileName2! moved
	
	del workspace\subworkspace!instance!\sub-out /f /s /q
	del "workspace\subworkspace!instance!\!name!.txt" /f /s /q
	
	rem stitching it back together
	if exist "workspace\!name!.txt" (
		rem how many of the split videos are ready
		for /f "usebackq tokens=* delims=" %%b in ("workspace\!name!.txt") do (
			set /a amountReady=%%b
		)
		
		rem changing amount for next round if any
		set /a amountReady+=1
		echo !amountReady! > workspace\!name!.txt
		
		rem if all videos are done, create video
		if !amountReady! equ !instances! (
			rem concat list
			echo file '!name! 1.mkv' > output\list.txt
			for /l %%b in (2,1,!instances!) do (
				set /a instance2=%%b
				echo file '!name! !instance2!.mkv' >> output\list.txt
			)
			
			echo.
			echo interpolation!instance!.bat: concatenating !fileName!...
			
			externals\ffmpeg -f concat -safe 0 -i output\list.txt -video_track_timescale 90000 -strict -2 -c copy  "!outLocation!\!name!.mp4"
			
			echo.
			echo interpolation!instance!.bat: !fileName! concatenated
			
			for /l %%b in (1,1,!instances!) do (
				set /a instance2=%%b
				
				del "output\!name! !instance2!.mkv" /f /s /q
				del "workspace\subworkspace!instance2!\!name! !instance2!.mkv" /f /s /q
			)
			
			del "output\list.txt" /f /s /q
			del "input\!fileName!" /f /s /q
			del "workspace\!name!_settings.txt" /f /s /q
			del "workspace\!name!.txt" /f /s /q
		)
	) else (
		echo 1 > workspace\!name!.txt
	)
	
	cd input
)

cd ..
for /l %%a in (1,1,!instances!) do (
	set /a instance2=%%a
	if not exist workspace\subworkspace!instance2!\*.mkv (
		set /a amountDeleted+=1
		if !amountDeleted! equ !instances! (
			del workspace /f /s /q
			del input /f /s /q
			del output /f /s /q
			rd workspace /s /q
			rd input /s /q
			rd output /s /q
		)
	)
)

cd externals
exit