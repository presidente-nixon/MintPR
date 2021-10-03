# Multiprocessing-for-ffmpeg-interpolation
A motion interpolation application that adds multiprocessing to an ffmpeg option called minterpolate

This ideo for this project came from when I discovered about AI upscaling algorithms because I was just sucha nerd, then going to motion algorithms, and thinking that I wanted to use motion interpolation algorithms on my youtube videos that I make on my youtube channel: https://www.youtube.com/channel/UCNUJ_KmDxx-NTxOZGSZbSBQ, however I found that although it produced pretty decent results, I thought that it was rather quite slow and since I had already learned some batch before, I thought that it would be a good ideo to try and integrate multiprocessing into the algorithm.

The syntax for use is interpolation instances encoder interpolatedrate filetype dynamicrange.
Interpolation is to initialize the program, instances is how many different threads you want, encoder is what encoder you want, interpolatedrate is what you want the output frame rate to be, filetype is the file format that the input videos are in, and dynamicrange is the dynamicrange of the input videos.
So for instance, if you wanted to interpolate an sdr, mp4 file to 60fps encoded with h264 using 2 threads, then you would type: 
interpolation 4 h264 60 mp4 sdr
If you wanted to interpolate an hdr, mkv file to 100fps encoding with hevc_amf using 1 thread, then you would type:
interpolation 1 hevc_amf 100 mkv hdr

Sorry for the scuffy, unpolished syntax that is put it simply, nothing like ffmpeg, but this is currently the best I can do and I will change that in the future if I can.
