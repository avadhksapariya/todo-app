import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_utils.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TasksState> {
  final TaskRepository _repo;
  StreamSubscription? _sub;

  TaskBloc(this._repo) : super(const TasksState()) {
    on<TasksSubscribed>(_onSubscribed);
    on<TaskCreated>(_onCreate);
    on<TaskUpdated>(_onUpdate);
    on<TaskDeleted>(_onDelete);
    on<TaskToggled>(_onToggle);
    on<TaskFilterChanged>(_onFilterChange);
    on<TaskSortChanged>(_onSortChange);
    on<_TasksUpdated>(_onUpdated);
  }

  void _onSubscribed(TasksSubscribed event, Emitter<TasksState> emit) {
    emit(state.copyWith(isLoading: true));
    _sub?.cancel();
    _sub = _repo
        .getTasks(event.listId)
        .listen((tasks) => add(_TasksUpdated(tasks)));
  }

  void _onUpdated(_TasksUpdated event, Emitter<TasksState> emit) {
    emit(state.copyWith(tasks: event.tasks, isLoading: false));
  }

  Future<void> _onCreate(TaskCreated event, Emitter<TasksState> emit) async {
    try {
      await _repo.createTask(event.listId, event.title, event.description);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdate(TaskUpdated event, Emitter<TasksState> emit) async {
    try {
      await _repo.updateTask(event.task);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(TaskDeleted event, Emitter<TasksState> emit) async {
    try {
      await _repo.deleteTask(event.taskId, event.listId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggle(TaskToggled event, Emitter<TasksState> emit) async {
    try {
      await _repo.toggleTask(event.taskId, event.listId, event.isCompleted);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onFilterChange(TaskFilterChanged event, Emitter<TasksState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onSortChange(TaskSortChanged event, Emitter<TasksState> emit) {
    emit(state.copyWith(sort: event.sort));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
