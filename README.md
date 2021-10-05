# Multiprocessing-for-ffmpeg-interpolation
A motion interpolation application that adds multiprocessing to an ffmpeg option called minterpolate.

# How it came about
This ideo for this project came from when I discovered about AI upscaling algorithms because I was just sucha nerd, then going to motion algorithms, and thinking that I wanted to use motion interpolation algorithms on my youtube videos that I make on my youtube channel: https://www.youtube.com/channel/UCNUJ_KmDxx-NTxOZGSZbSBQ, however I found that although it produced pretty decent results, I thought that it was rather quite slow and since I had already learned some batch before, I thought that it would be a good ideo to try and integrate multiprocessing into the algorithm.

# How to use it
The syntax is: interpolation filetype dynamicrange inlocation instances interpolatedrate encoder outlocation.

Interpolation is to initialize the program, filetype is the file format that the input videos are in, dynamicrange is the dynamicrange of the input videos, inlocation is the location of the input video file(it must be absolute and must direct to the folder that the video/videos is/are in), instances is how many different threads you want, interpolatedrate is what you want the output frame rate to be, encoder is what encoder you want, and outlocation is pretty much the same as the inlocation except it is for the ouput file.

So for instance, if you wanted to interpolate an sdr, mp4 file to 60fps encoded with h264 using 2 threads, then you would type: 
```
interpolation mp4 sdr "location" 2 60 h264 "location"
```
If you wanted to interpolate an hdr, mkv file to 100fps encoding with hevc using 1 thread, then you would type:
```
interpolation mkv hdr "location" 1 100 hevc "location"
```
Sorry for the scuffy, unpolished syntax that is put it simply, nothing like ffmpeg, but this is currently the best I can do and I will change that in the future if I can. Currently, there are 2 main things on the todo list, a supsending sessions feature, and a more usable syntax. Also just a side note, the video that you input must be at least 3 seconds long, small things, but just needed to be clear that if it doesn't work and your video is shorter than 3 seconds, now you know why, although this is technically a "bug", I am not able to fix it as it is on an ffmpeg level and also it doesn't really matter since it's just such a short video.

# Downloads
## The latest version can found here
https://github.com/presidente-nixon/Multiprocessing-for-ffmpeg-interpolation/releases/tag/v0.3-alpha

# License
Multiprocessing for ffmpeg interpolation is under the MIT license.

# Credits
- ffmpeg
