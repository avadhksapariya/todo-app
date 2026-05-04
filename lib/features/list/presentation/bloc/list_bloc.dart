import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/todo_list_entity.dart';
import '../../domain/repositories/list_repository.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final TodoListRepository _repo;
  StreamSubscription? _sub;

  ListBloc(this._repo) : super(ListInitial()) {
    on<ListsSubscribed>(_onSubscribed);
    on<ListCreated>(_onCreate);
    on<ListRenamed>(_onRename);
    on<ListDeleted>(_onDelete);
    on<_ListsUpdated>(_onUpdated);
  }

  void _onSubscribed(ListsSubscribed event, Emitter<ListState> emit) {
    emit(ListsLoading());
    _sub?.cancel();
    _sub = _repo
        .getLists(event.userId)
        .listen(
          (lists) => add(_ListsUpdated(lists)),
          onError: (_) => add(const _ListsError()),
        );
  }

  void _onUpdated(_ListsUpdated event, Emitter<ListState> emit) {
    emit(ListsLoaded(event.lists));
  }

  Future<void> _onCreate(ListCreated event, Emitter<ListState> emit) async {
    try {
      await _repo.createList(event.userId, event.title);
    } catch (e) {
      emit(ListsFailure(e.toString()));
    }
  }

  Future<void> _onRename(ListRenamed event, Emitter<ListState> emit) async {
    try {
      await _repo.renameList(event.listId, event.newTitle);
    } catch (e) {
      emit(ListsFailure(e.toString()));
    }
  }

  Future<void> _onDelete(ListDeleted event, Emitter<ListState> emit) async {
    try {
      await _repo.deleteList(event.listId);
    } catch (e) {
      emit(ListsFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
