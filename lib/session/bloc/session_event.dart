part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class PhotoCaptured extends SessionEvent {
  const PhotoCaptured({required this.aspectRatio, required this.image});

  final double aspectRatio;
  final CameraImage image;

  @override
  List<Object> get props => [aspectRatio, image];
}

class PhotoCharacterToggled extends SessionEvent {
  const PhotoCharacterToggled({required this.character});

  final Asset character;

  @override
  List<Object> get props => [character];
}

class PhotoCharacterDragged extends SessionEvent {
  const PhotoCharacterDragged({required this.character, required this.update});

  final PhotoAsset character;
  final DragUpdate update;

  @override
  List<Object> get props => [character, update];
}

class PhotoStickerTapped extends SessionEvent {
  const PhotoStickerTapped({required this.sticker});

  final Asset sticker;

  @override
  List<Object> get props => [sticker];
}

class PhotoStickerDragged extends SessionEvent {
  const PhotoStickerDragged({required this.sticker, required this.update});

  final PhotoAsset sticker;
  final DragUpdate update;

  @override
  List<Object> get props => [sticker, update];
}

class PhotoClearStickersTapped extends SessionEvent {
  const PhotoClearStickersTapped();
}

class PhotoClearAllTapped extends SessionEvent {
  const PhotoClearAllTapped();
}

class PhotoDeleteSelectedStickerTapped extends SessionEvent {
  const PhotoDeleteSelectedStickerTapped();
}

class PhotoTapped extends SessionEvent {
  const PhotoTapped();
}
