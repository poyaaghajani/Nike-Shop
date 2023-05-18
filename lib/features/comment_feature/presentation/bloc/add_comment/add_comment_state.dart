part of 'add_comment_bloc.dart';

abstract class AddCommentState extends Equatable {
  const AddCommentState();

  @override
  List<Object> get props => [];
}

class AddCommentInitState extends AddCommentState {}

class AddCommetLoadingState extends AddCommentState {}

class AddCommentSuccessState extends AddCommentState {}

class AddCommentErrorState extends AddCommentState {
  final AppExeption exeption;
  const AddCommentErrorState(this.exeption);

  @override
  List<Object> get props => [exeption];
}
