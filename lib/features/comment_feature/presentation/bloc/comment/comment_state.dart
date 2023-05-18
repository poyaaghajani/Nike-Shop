part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentLoadingState extends CommentState {}

class CommentSuccessState extends CommentState {
  final List<Comment> comments;
  const CommentSuccessState({required this.comments});

  @override
  List<Object> get props => [comments];
}

class CommentErrorState extends CommentState {
  final AppExeption exeption;
  const CommentErrorState({required this.exeption});

  @override
  List<Object> get props => [exeption];
}
