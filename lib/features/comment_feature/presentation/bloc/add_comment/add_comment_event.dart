part of 'add_comment_bloc.dart';

abstract class AddCommentEvent extends Equatable {
  const AddCommentEvent();

  @override
  List<Object> get props => [];
}

class AddCommentButtonPressed extends AddCommentEvent {
  final int productId;
  final String title;
  final String content;

  const AddCommentButtonPressed({
    required this.productId,
    required this.title,
    required this.content,
  });
}
