part of 'list_bloc.dart';

@immutable
sealed class ListEvent extends Equatable {
  const ListEvent();
  @override
  List<Object?> get props => [];
}

class ListsSubscribed extends ListEvent {
  final String userId;
  const ListsSubscribed(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ListCreated extends ListEvent {
  final String userId;
  final String title;
  const ListCreated(this.userId, this.title);
  @override
  List<Object?> get props => [userId, title];
}

class ListRenamed extends ListEvent {
  final String listId;
  final String newTitle;
  const ListRenamed(this.listId, this.newTitle);
  @override
  List<Object?> get props => [listId, newTitle];
}

class ListDeleted extends ListEvent {
  final String listId;
  const ListDeleted(this.listId);
  @override
  List<Object?> get props => [listId];
}

class _ListsUpdated extends ListEvent {
  final dynamic lists;
  const _ListsUpdated(this.lists);
}

class _ListsError extends ListEvent {
  const _ListsError();
}
