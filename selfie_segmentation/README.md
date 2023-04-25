# selfie_segmentation

The base model is from https://github.com/zoff99/backscrub/blob/main/models/selfiesegmentation_mlkit-256x256-2021_01_19-v1215.f16.tflite which is originally provided by google mlkit.
The tflite model has a custom op `Convolution2DTransposeBias` (which is quite common op for mediapipe models), making it is not possible to run via nnstreamer pipeline.
The uploaded model selfie_segmentation_256_256.tflite does not contain the custom op thanks to https://github.com/PINTO0309/tflite2tensorflow.

REF:
https://github.com/zoff99/tensorflow-lite-addons_compile
https://zenn.dev/pinto0309/articles/9d316860f8d418
