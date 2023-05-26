# whisper.cpp

## How to

```bash
$ git clone https://github.com/anyj0527/whisper.cpp
$ cd whisper.cpp
$ git checkout nnstreamer-cpp-filter-v1.2.1
$ bash ./models/download-ggml-model.sh base.en
$ make nnstreamer
$ gst-launch-1.0  \
alsasrc device=hw:2 ! audioconvert ! audio/x-raw,format=S16LE,channels=1,rate=16000,layout=interleaved ! \
tensor_converter frames-per-tensor=3200 ! tensor_aggregator frames-in=3200 frames-out=48000 frames-flush=44800 frames-dim=1 ! \
tensor_transform mode=arithmetic option=typecast:float32,add:0.5,div:32767.5 ! \
tensor_transform mode=dimchg option=0:1 ! \
other/tensors,num_tensors=1,dimensions=48000:1:1:1,types=float32,format=static ! \
queue leaky=2 max-size-buffers=10 ! \
tensor_filter framework=cpp model=nnstreamer_whisper_filter,libnnstreamer-whisper.so ! \
other/tensors,format=static ! tensor_sink
```
