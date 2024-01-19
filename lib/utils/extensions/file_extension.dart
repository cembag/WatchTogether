import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

extension FileExtension on File {
  Future<ui.Image> toImage() async {
    List<int> fileBytes = await readAsBytes();
    ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(fileBytes));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}