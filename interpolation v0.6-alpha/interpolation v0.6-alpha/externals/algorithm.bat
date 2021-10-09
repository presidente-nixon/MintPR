@echo off
setlocal enabledelayedexpansion
color 0a
title Multiprocessing for FFmpeg Interpolation v0.6-alpha
rem Multiprocessing for FFmpeg Interpolation v0.6-alpha-github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation Copyright (c) 2021 presidente_nixon

set /a instance=%1

cd ..
for /f "usebackq tokens=* delims=" %%a in (settings.txt) do (
	set %%a
)

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
	
	echo algorithm!instance!: reading !fileName! variables...
	for /f "usebackq tokens=* delims=" %%b in ("workspace\!name!_settings.txt") do (
		set %%b
	)
	echo algorithm!instance!: !fileName! variables read
	
	echo algorithm!instance!: interpolating !fileName2!...
	externals\ffmpeg -i "workspace\subworkspace!instance!\!fileName2!" -vf "minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=!interpolatedRate!'" -c:v !encoder! -b:v !bitrate!M -maxrate !maxBitrate!M -bufsize !bitrate!M "workspace\subworkspace!instance!\sub-out\!name2!.!amountTried!.mkv"
	echo algorithm!instance!: interpolated !fileName2!
	
	echo algorithm!instance!: concatenating !fileName2!...
	echo file '!name2!.1.mkv' > workspace\subworkspace!instance!\sub-out\list.txt
	for /l %%b in (2,1,!amountTried!) do (
		set /a amountTried2=%%b
		echo file '!name2!.!amountTried2!.mkv' >> workspace\subworkspace!instance!\sub-out\list.txt
	)
	
	externals\ffmpeg -f concat -safe 0 -i workspace\subworkspace!instance!\sub-out\list.txt -c copy "workspace\subworkspace!instance!\sub-out\!fileName2!"
	echo algorithm!instance!: !fileName2! concatenated
	
	echo algorithm!instance!: moving !fileName2!...
	move /y "workspace\subworkspace!instance!\sub-out\!fileName2!" output
	echo algorithm!instance!: !fileName2! moved
	del workspace\subworkspace!instance!\sub-out /f /s /q
	del workspace\subworkspace!instance!\!name!.txt /f /s /q
	cd input
)

rem stitching it back together
for %%a in ("*.!fileType!") do (
	set fileName=%%a
	set name=!fileName:~0,-4!
	
	cd ..
	for /l %%b in (1,1,!instances!) do (
		set /a instance2=%%b
		
		if exist "output\!name! !instance2!.mkv" (
			if exist "workspace\!name!.txt" (
				rem how many of the split videos are ready
				for /f "usebackq tokens=* delims=" %%c in ("workspace\!name!.txt") do (
					set /a amountReady=%%c
				)
				
				rem changing amount for next round if any
				set /a amountReady+=1
				echo !amountReady! > workspace\!name!.txt
				
				rem if all videos are done, create video
				if !amountReady!==!instances! (
					rem concat list
					echo file '!name! 1.mkv' > output\list.txt
					for /l %%c in (2,1,!instances!) do (
						set /a instance3=%%c
						echo file '!name! !instance3!.mkv' >> output\list.txt
					)
					
					echo algorithm!instance!: concatenating !fileName!...
					externals\ffmpeg -f concat -safe 0 -i output\list.txt -c copy "!outLocation!\!name!.mp4"
					echo algorithm!instance!: !fileName! concatenated
					
					for /l %%c in (1,1,!instances!) do (
						set /a instance3=%%c
						
						del "output\!name! !instance3!.mkv" /f /s /q
						del "workspace\subworkspace!instance3!\!name! !instance3!.mkv" /f /s /q
					)
				)
			) else (
				echo 1 > workspace\!name!.txt
			)
		)
	)
	
	del "workspace\!name!.txt" /f /s /q
	del "output\list.txt" /f /s /q
	cd input
)

cd ..
for /l %%a in (1,1,!instances!) do (
	set /a instance2=%%a
	if not exist workspace\subworkspace!instance2!\*.mkv (
		set /a amountDeleted+=1
		if !amountDeleted!==!instances! (
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