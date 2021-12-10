import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

part 'session_event.dart';
part 'session_state.dart';

typedef UuidGetter = String Function();

const _debounceDuration = Duration(milliseconds: 16);

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc([UuidGetter? uuid])
      : uuid = uuid ?? const Uuid().v4,
        super(const SessionState());

  final UuidGetter uuid;

  bool _isDragEvent(SessionEvent e) {
    return e is PhotoCharacterDragged || e is PhotoStickerDragged;
  }

  bool _isNotDragEvent(SessionEvent e) {
    return e is! PhotoCharacterDragged && e is! PhotoStickerDragged;
  }

  @override
  Stream<Transition<SessionEvent, SessionState>> transformEvents(
    Stream<SessionEvent> events,
    TransitionFunction<SessionEvent, SessionState> transitionFn,
  ) {
    return Rx.merge([
      events.where(_isDragEvent).debounceTime(_debounceDuration),
      events.where(_isNotDragEvent),
    ]).asyncExpand(transitionFn);
  }

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) async* {
    if (event is PhotoCaptured) {
      yield state.copyWith(
        aspectRatio: event.aspectRatio,
        image: event.image,
        imageId: uuid(),
        selectedAssetId: emptyAssetId,
      );
    } else if (event is PhotoCharacterToggled) {
      yield _mapCharacterToggledToState(event, state);
    } else if (event is PhotoCharacterDragged) {
      yield _mapCharacterDraggedToState(event, state);
    } else if (event is PhotoStickerTapped) {
      yield _mapStickerTappedToState(event, state);
    } else if (event is PhotoStickerDragged) {
      yield _mapStickerDraggedToState(event, state);
    } else if (event is PhotoClearStickersTapped) {
      yield state.copyWith(
        stickers: const <PhotoAsset>[],
        selectedAssetId: emptyAssetId,
      );
    } else if (event is PhotoClearAllTapped) {
      yield state.copyWith(
        characters: const <PhotoAsset>[],
        stickers: const <PhotoAsset>[],
        selectedAssetId: emptyAssetId,
      );
    } else if (event is PhotoDeleteSelectedStickerTapped) {
      yield _mapDeleteSelectedStickerTappedToState(
        event,
        state,
      );
    } else if (event is PhotoTapped) {
      yield state.copyWith(selectedAssetId: emptyAssetId);
    }
  }

  SessionState _mapCharacterToggledToState(
    PhotoCharacterToggled event,
    SessionState state,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters);
    final index = characters.indexWhere((c) => c.asset.name == asset.name);
    final characterExists = index != -1;

    if (characterExists) {
      characters.removeAt(index);
      return state.copyWith(characters: characters);
    }

    final newCharacter = PhotoAsset(id: uuid(), asset: asset);
    characters.add(newCharacter);
    return state.copyWith(
      characters: characters,
      selectedAssetId: newCharacter.id,
    );
  }

  SessionState _mapCharacterDraggedToState(
    PhotoCharacterDragged event,
    SessionState state,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters);
    final index = characters.indexWhere((element) => element.id == asset.id);
    final character = characters.removeAt(index);
    characters.add(
      character.copyWith(
        angle: event.update.angle,
        position: PhotoAssetPosition(
          dx: event.update.position.dx,
          dy: event.update.position.dy,
        ),
        size: PhotoAssetSize(
          width: event.update.size.width,
          height: event.update.size.height,
        ),
        constraint: PhotoConstraint(
          width: event.update.constraints.width,
          height: event.update.constraints.height,
        ),
      ),
    );
    return state.copyWith(characters: characters, selectedAssetId: asset.id);
  }

  SessionState _mapStickerTappedToState(
    PhotoStickerTapped event,
    SessionState state,
  ) {
    final asset = event.sticker;
    final newSticker = PhotoAsset(id: uuid(), asset: asset);
    return state.copyWith(
      stickers: List.of(state.stickers)..add(newSticker),
      selectedAssetId: newSticker.id,
    );
  }

  SessionState _mapStickerDraggedToState(
    PhotoStickerDragged event,
    SessionState state,
  ) {
    final asset = event.sticker;
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere((element) => element.id == asset.id);
    final sticker = stickers.removeAt(index);
    stickers.add(
      sticker.copyWith(
        angle: event.update.angle,
        position: PhotoAssetPosition(
          dx: event.update.position.dx,
          dy: event.update.position.dy,
        ),
        size: PhotoAssetSize(
          width: event.update.size.width,
          height: event.update.size.height,
        ),
        constraint: PhotoConstraint(
          width: event.update.constraints.width,
          height: event.update.constraints.height,
        ),
      ),
    );
    return state.copyWith(stickers: stickers, selectedAssetId: asset.id);
  }

  SessionState _mapDeleteSelectedStickerTappedToState(
    PhotoDeleteSelectedStickerTapped event,
    SessionState state,
  ) {
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere(
      (element) => element.id == state.selectedAssetId,
    );
    final stickerExists = index != -1;

    if (stickerExists) {
      stickers.removeAt(index);
    }

    return state.copyWith(
      stickers: stickers,
      selectedAssetId: emptyAssetId,
    );
  }
}
