gst-launch-1.0 \
v4l2src ! videoconvert ! videoscale ! video/x-raw,width=1920,height=1080,format=RGB,framerate=30/1 ! tee name=t \
t. ! queue leaky=2 max-size-buffers=10 ! videocrop left=420 right=420 ! videoscale ! video/x-raw,width=256,height=256,format=RGB ! \
  tensor_converter ! other/tensors,format=static,num_tensors=1,types=uint8,dimensions=3:256:256:1:1:1:1:1 ! \
  queue ! tensor_transform mode=arithmetic option=typecast:float32,div:255.0 ! \
  queue ! tensor_filter framework=tensorflow2-lite model=selfie_segmentation_256_256.tflite custom=Delegate:XNNPACK,NumThreads:4 ! \
  other/tensors,format=static ! queue ! tensor_transform mode=arithmetic option=mul:255.0 ! \
  tensor_transform mode=typecast option=uint8 ! \
  tensor_decoder mode=direct_video ! video/x-raw,width=256,height=256,format=GRAY8 ! \
  videoconvert ! videoscale ! video/x-raw,width=1080,height=1080 ! mix.sink_0 \
t. ! queue ! mix.sink_1 \
compositor name=mix sink_0::alpha=1.0 sink_0::xpos=420 sink_1::alpha=0.3 ! \
  video/x-raw,width=1920,height=1080,format=RGBA ! videoconvert ! xvimagesink
