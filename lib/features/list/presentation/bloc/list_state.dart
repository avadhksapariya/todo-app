part of 'list_bloc.dart';

@immutable
sealed class ListState extends Equatable {
  const ListState();
  @override
  List<Object?> get props => [];
}

final class ListInitial extends ListState {}

final class ListsLoading extends ListState {}

final class ListsLoaded extends ListState {
  final List<TodoListEntity> lists;
  const ListsLoaded(this.lists);
  @override
  List<Object?> get props => [lists];
}

final class ListsFailure extends ListState {
  final String message;
  const ListsFailure(this.message);
  @override
  List<Object?> get props => [message];
}
