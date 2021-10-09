@echo off
setlocal enabledelayedexpansion
color 0a
title Multiprocessing for FFmpeg Interpolation v0.6-alpha
cls
echo Multiprocessing for FFmpeg Interpolation v0.6-alpha-github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation Copyright (c) 2021 presidente_nixon

cd ..
if exist workspace (
	for /f "usebackq tokens=* delims=" %%a in (workspace\settings.txt) do (
		set %%a
	)
	
	for /l %%a in (1,1,!instances!) do (
		set /a instance=%%a
		
		cd workspace\subworkspace!instance!
		for %%b in ("*.!fileType!") do (
			rem input file name with file format
			set fileName=%%b
			rem input file name
			set name=!fileName:~0,-4!
			
			cd ../..
			if exist "workspace\subworkspace!instance!\!name!.txt" (
				rem how many times this instance has tried to process the video
				for /f "usebackq tokens=* delims=" %%c in ("workspace\subworkspace!instance!\!name!.txt") do (
					set /a amountTried=%%c
				)
				
				for /f "usebackq tokens=* delims=" %%c in (`externals\ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "workspace\subworkspace!instance!\!fileName!" 2^>^&1`) do (
					set /a videoDuration=%%c
				)

				for /f "usebackq tokens=* delims=" %%c in (`externals\ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "workspace\subworkspace!instance!\sub-out\!name!.!amountTried!.mp4" 2^>^&1`) do (
					set /a upscaledDuration=%%c
				)

				ffmpeg  -i "workspace\subworkspace!instance!\!fileName!" -ss !upscaledDuration! -to !videoDuration! -c copy "workspace\subworkspace!instance!\!name!1.mkv"
				
				del "workspace\subworkspace!instance!\!fileName!" /f /s /q
				ren "workspace\subworkspace!instance!\!name!1.mkv" "!fileName!"
			)
			
			cd workspace\subworkspace!instance!
		)
		
		start /b algorithm !instance!
		cd ../..
	)
	
	cd externals
	exit
) else (
	rem dynamicRange: Either sdr(standard dynamic range) or hdr(high dynamic range)
	set dynamicRange=%2
	rem instances: how many threads the program will use
	set /a instances=%4
	rem encoder: encoding for interpolation, either h264 or hevc
	set encoder=%6

	echo interpolation: checking the inputs...
	if not !encoder!==h264 if not !encoder!==hevc (
		echo encoder type not valid.
		if not !dynamicRange!==sdr if not !dynamicRange!==hdr (
			echo dynamic range type not valid.
		)
		
		if !instances! gtr 8 (
			echo instances amount not valid.
		)
		
		pause
		exit
	)

	if not !dynamicRange!==sdr if not !dynamicRange!==hdr (
		echo dynamic range type not valid.
		if !instances! gtr 8 (
			echo instances amount not valid.
		)
		
		pause
		exit
	)

	if !instances! gtr 8 (
		echo instances amount not valid.
		pause
		exit
	)
	
	echo interpolation: inputs valid

	rem fileType: input file type
	set fileType=%1
	rem fileType: input file location
	set inLocation=%3
	rem interpolatedRate: output fps
	set /a interpolatedRate=%5
	rem fileType: output file location
	set outLocation=%7

	echo interpolation: creating workspace...
	md input
	md output
	md workspace
	echo interpolation: workspace created
	
	echo interpolation: copying input files to input folder...
	for %%a in ("!inLocation!\*.!fileType!") do (
		rem input file name with file format and directory
		set fileName=%%a
		
		xcopy "!fileName!" input /c /y
	)
	
	echo interpolation: saving user inputs...
	echo fileType=!fileType! > workspace\settings.txt
	echo /a instances=!instances! >> workspace\settings.txt
	echo /a interpolatedRate=!interpolatedRate! >> workspace\settings.txt
	echo outLocation=!outLocation!>> workspace\settings.txt
	echo interpolation: user inputs saved
	
	cd input
	for %%a in ("*.!fileType!") do (
		rem input file name with file format
		set fileName=%%a
		rem input file name
		set name=!fileName:~0,-4!
		
		echo interpolation: reading resolution of !fileName!...
		cd ..
		for /f "usebackq tokens=* delims=" %%b in (`externals\ffprobe -v error -select_streams v:0 -show_entries stream^=width^,height -of csv^=s^=x:p^=0 "input\!fileName!" 2^>^&1`) do (
			set resolution=%%b
		)
		echo interpolation: !fileName! resolution read
		
		echo interpolation: calculating suitable bitrate and maxbitrate for !fileName!...
		if !resolution!==1920x1080 (
			if !interpolatedRate! leq 30 (
				if !dynamicRange!==sdr (
					set /a bitrate=8
					set /a maxBitrate=10
				) else (
					set /a bitrate=10
					set /a maxBitrate=12
				)
			) else (
				if !dynamicRange!==sdr (
					set /a bitrate=12
					set /a maxBitrate=15
				) else (
					set /a bitrate=15
					set /a maxBitrate=16
				)
			)
		) else if !resolution!==1280x720 (
			if !interpolatedRate! leq 30 (
				if !dynamicRange!==sdr (
					set /a bitrate=5
					set /a maxBitrate=7
				) else (
					set /a bitrate=7
					set /a maxBitrate=8
				)
			) else (
				if !dynamicRange!==sdr (
					set /a bitrate=8
					set /a maxBitrate=10
				) else (
					set /a bitrate=10
					set /a maxBitrate=12
				)
			)
		) else if !resolution!==2560x1440 (
			if !interpolatedRate! leq 30 (
				if !dynamicRange!==sdr (
					set /a bitrate=16
					set /a maxBitrate=20
				) else (
					set /a bitrate=20
							set /a maxBitrate=24
				)
				) else (
				if !dynamicRange!==sdr (
						set /a bitrate=24
					set /a maxBitrate=30
				) else (
					set /a bitrate=30
					set /a maxBitrate=35
				)
			)
		) else if !resolution!==3840x2160 (
			if !interpolatedRate! leq 30 (
				if !dynamicRange!==sdr (
					set /a bitrate=35
					set /a maxBitrate=45
				) else (
					set /a bitrate=44
					set /a maxBitrate=56
				)
			) else (
				if !dynamicRange!==sdr (
					set /a bitrate=53
					set /a maxBitrate=68
				) else (
					set /a bitrate=66
					set /a maxBitrate=85
				)
			)
		) else if !resolution!==852x480 (
			if !interpolatedRate! leq 30 (
				set /a bitrate=3
				set /a maxBitrate=4
			) else (
				set /a bitrate=4
				set /a maxBitrate=5
			)
		) else if !resolution!==480x360 (
			if !interpolatedRate! leq 30 (
				set /a bitrate=1
				set /a maxBitrate=2
			) else (
				set /a bitrate=2
				set /a maxBitrate=3
			)
		) else (
			set /a bitrate=66
			set /a maxBitrate=85
		)
		
		echo interpolation: bitrate and maxbitrate calculated for !fileName!, now saving...
		echo /a bitrate=!bitrate! > workspace\!name!_settings.txt
		echo /a maxBitrate=!maxBitrate! >> workspace\!name!_settings.txt
		echo encoder=!encoder! >> workspace\!name!_settings.txt
		echo interpolation: bitrate and maxbitrate for !fileName! saved
		cd input
	)

	cd ..
	for /l %%a in (1,1,!instances!) do (
		set /a instance=%%a
		
		echo interpolation: setting up subworkspace!instance!...
		md workspace\subworkspace!instance!\sub-out
		xcopy externals\algorithm.bat workspace\subworkspace!instance! /c /y
		echo interpolation: subworkspace!instance! setup
		
		cd input
		for %%b in ("*.!fileType!") do (
			rem input file name with file format
			set fileName=%%b
			rem input file name
			set name=!fileName:~0,-4!
			
			echo interpolation: reading !fileName! duration...
			cd ..
			for /f "usebackq tokens=* delims=" %%c in (`externals\ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "input\!fileName!" 2^>^&1`) do (
				set /a duration=%%c
			)
			echo interpolation: !fileName! duration read
		
			echo interpolation: calculating split videos durations for !fileName!...
			set /a newDuration=!duration!/!instances!
			set /a start=!instance!*!newDuration!-!newDuration!
			set /a end=!newDuration!*!instance!
			echo interpolation: split video durations calculated for !fileName!
		
			echo interpolation: splitting !fileName!...
			externals\ffmpeg -i "input\!fileName!" -ss !start! -to !end! -c copy "workspace\subworkspace!instance!\!name! !instance!.mkv"
			echo interpolation: split !fileName!
			cd input
		)
		
		rem starting the interpolation software
		cd ..
		cd workspace\subworkspace!instance!
		echo interpolation: starting algorithm!instance!...
		start /b algorithm !instance!
		echo interpolation: algorithm!instance! started
		cd ../..
	)
)

cd externals
exit