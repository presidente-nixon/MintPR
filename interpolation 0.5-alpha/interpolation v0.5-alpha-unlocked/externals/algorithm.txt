@echo off
setlocal enabledelayedexpansion
color 0a
title Multiprocessing for FFmpeg Interpolation v0.5-alpha
echo Multiprocessing for FFmpeg Interpolation v0.5-alpha-github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation Copyright (c) 2021 presidente_nixon
rem Multiprocessing for FFmpeg Interpolation v0.5-alpha-github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation Copyright (c) 2021 presidente_nixon

set /a instance=%1
set fileType=%2
set /a instances=%3
set /a interpolatedRate=%4
set outLocation=%5

rem interpolation
cd ../..
cd input
for %%a in ("*.!fileType!") do (
	set fileName=%%a
	set name=!fileName:~0,-4!
	
	rem split file name with file format
	set fileName2=!name! #!instance!.mkv
	rem split file name
	set name2=!fileName2:~0,-4!
	rem split output directory
	set outName2=workspace\subworkspace!instance!\sub-out\!name2!
	
	echo reading variables
	cd ..
	for /f "usebackq tokens=* delims=" %%b in (workspace\!name!_settings.txt) do (
		set /a bitrate=
		set /a maxBitrate=
		set encoder=
	)
	
	echo interpolating
	externals\ffmpeg -i "workspace\subworkspace!instance!\!fileName2!" -vf "minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=!interpolatedRate!'" -c:v !encoder! -b:v !bitrate!M -maxrate !maxBitrate!M -bufsize !bitrate!M "!outName2!.mkv"
	
	echo moving interpolated videos
	move /y "!outName2!.mkv" output
	cd input
)

rem stitching it back together
for %%a in ("*.!fileType!") do (
	set fileName=%%a
	set name=!fileName:~0,-4!
	set outName=!outLocation!\!name!
	
	cd ..
	for /l %%b in (1,1,!instances!) do (
		set /a instance=%%b
		
		if exist "output\!name! #!instance!.mkv" (
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
					echo file '!name! #1.mkv' > output\list.txt
					for /l %%c in (2,1,!instances!) do (
						set /a instance2=%%c
						echo file '!name! #!instance2!.mkv' >> output\list.txt
					)
					
					echo concatenating
					externals\ffmpeg -f concat -safe 0 -i output\list.txt -c copy "!outName!.mp4"
					
					echo deleting the split videos
					for /l %%c in (1,1,!instances!) do (
						set /a instance2=%%c
						
						del "output\!name! #!instance2!.mkv" /f /s /q
						del "workspace\subworkspace!instance2!\!name! #!instance2!.mkv" /f /s /q
					)
				)
			) else (
				echo 1 > workspace\!name!.txt
			)
		)
	)
	
	echo deleting temp files
	del "workspace\!name!.txt" /f /s /q
	del "output\list.txt" /f /s /q
	cd input
)

echo cleaning up workspace
cd ..
for /l %%a in (1,1,!instances!) do (
	set /a instance=%%a
	if not exist workspace\subworkspace!instance!\*.mkv (
		del workspace\subworkspace!instance! /f /s /q
		rd workspace\subworkspace!instance! /s /q
		
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