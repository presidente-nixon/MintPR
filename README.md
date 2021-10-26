# Mint mpr
A motion interpolation application that adds multiprocessing to an FFmpeg option called minterpolate.

## How it came about
This idea for this project came from when I discovered about AI upscaling algorithms because I was just sucha nerd, then going to motion algorithms, and thinking that I wanted to use motion interpolation algorithms on my youtube videos that I make on my youtube channel: [presidente nixon](https://www.youtube.com/channel/UCNUJ_KmDxx-NTxOZGSZbSBQ), however I found that although it produced pretty decent results, I thought that it was rather quite slow and since I had already learned some batch before, I thought that it would be a good idea to try and integrate multiprocessing into the algorithm.

## How to use it
The syntax is: `interpolation filetype dynamicrange inlocation instances interpolatedrate encoder outlocation`

`interpolation` is to initialize the program, `filetype` is the file format that the input videos are in, `dynamicrange` is the dynamic range of the input videos, `inlocation` is the location of the input video file(it MUST be absolute and must direct to the folder that the video/videos is/are in), `instances` is how many concurrent threads you want, `interpolatedrate` is what you want the output frame rate to be, `encoder` is what encoder you want, and `outlocation` is pretty much the same as the inlocation except it is for the ouput file. To learn more click [here](https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/wiki/All-The-Commands).

Sorry for the scuffy, unpolished syntax that is put it simply, nothing like FFmpeg, but this is currently the best I can do and I will change that in the future if I can which is why currently, there are 2 main things on the todo list, a supsending sessions feature, and a more usable syntax.

Just a side note, the video that you input must be at least 3 seconds long, small things, but just needed to be clear that if it doesn't work and your video is shorter than 3 seconds, now you know why, although this is technically a "bug", I am not able to fix it as it is on an FFmpeg level and also it doesn't really matter since it's just such a short video.

---
### Examples
So for instance, if you wanted to interpolate an sdr, mp4 file to 60fps encoded with h264 using 2 threads, then you would type: 
```
interpolation mp4 sdr "location" 2 60 h264 "location"
```
If you wanted to interpolate an hdr, mkv file to 100fps encoding with hevc using 1 thread, then you would type:
```
interpolation mkv hdr "location" 1 100 hevc "location"
```
## Downloads
### The latest version can found here
https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/releases/tag/v0.6-alpha

You can get 2 versions, the normal version, and the unlocked version, the normal version locks how many instances you can have to 8 so that if you accidentally choose more than 8 instances, your computer doesn't fry up, and the unlocked version as you can probably guess, unlocks how many instances you can have, this is mainly for people that really want fast interpolating and also have cpus with at least 6 cores.

## Documentations
### [Multiprocessing for FFmpeg Interpolation Wiki](https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/wiki)
If you have more questions or just want to learn more about the program, go to this page.
### [All The Commands](https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/wiki/All-The-Commands)
If you still have absolutely no idea how to use the commands in this program, you can go to this very informative website.
### [Architecture](https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/wiki/Architecture)
This is a detailed explaination on what all of the different files do.
### [Developing The Program](https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/wiki/Developing-The-Program)
If you want to develop and change the program, this is a quick, short and easy tutorial to teach you how.
### [How The Program Works](https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/wiki/How-The-Program-Works)
Your interested in the nitty gritty are you? Well great, because I have just the site for you!

## License
Multiprocessing for FFmpeg interpolation is under the MIT license. Just be 100% clear, **I am 14 years old** at the time of writing this and **I am no where near to being a lawyer**, so if the MIT license conflicts with the LGPLv2.1 license of FFmpeg, please let me know, hopefully though if it does, it doesn't grab to much attention to FFmpeg since I am not selling this "product" for money.
## Contributing
To contribute to the project you must create a pull request featuring your contributions, to learn more, click [here](https://github.com/presidente-nixon/Multiprocessing-for-FFmpeg-Interpolation/blob/main/CONTRIBUTING.md) or go to contributing.md.
## Credits
- [FFmpeg](https://www.ffmpeg.org/)
