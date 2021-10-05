# Multiprocessing-for-ffmpeg-interpolation
A motion interpolation application that adds multiprocessing to an ffmpeg option called minterpolate.

# How it came about
This ideo for this project came from when I discovered about AI upscaling algorithms because I was just sucha nerd, then going to motion algorithms, and thinking that I wanted to use motion interpolation algorithms on my youtube videos that I make on my youtube channel: https://www.youtube.com/channel/UCNUJ_KmDxx-NTxOZGSZbSBQ, however I found that although it produced pretty decent results, I thought that it was rather quite slow and since I had already learned some batch before, I thought that it would be a good ideo to try and integrate multiprocessing into the algorithm.

# How to use it
To use it, you must put your video in the input folder and use the following syntax: interpolation filetype dynamicrange instances interpolatedrate encoder.

Interpolation is to initialize the program, filetype is the file format that the input videos are in, dynamicrange is the dynamicrange of the input videos, instances is how many different threads you want, interpolatedrate is what you want the output frame rate to be, and the encoder is what encoder you want.

So for instance, if you wanted to interpolate an sdr, mp4 file to 60fps encoded with h264 using 2 threads, then you would type: 
```
interpolation mp4 sdr 2 60 h264
```
If you wanted to interpolate an hdr, mkv file to 100fps encoding with hevc using 1 thread, then you would type:
```
interpolation mkv hdr 1 100 hevc
```
Sorry for the scuffy, unpolished syntax that is put it simply, nothing like ffmpeg, but this is currently the best I can do and I will change that in the future if I can. Currently, there are 2 main things on the todo list, a supsending sessions feature, and a more usable syntax.

# Credits
- ffmpeg
