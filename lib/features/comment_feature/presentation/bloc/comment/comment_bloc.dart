import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/comment_feature/data/model/comment.dart';
import 'package:nike/features/comment_feature/data/repository/comment_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ICommentRepository commentRepository;
  final int productId;

  CommentBloc({
    required this.commentRepository,
    required this.productId,
  }) : super(CommentLoadingState()) {
    on<CommentEvent>((event, emit) async {
      if (event is CommentRequest) {
        emit(CommentLoadingState());

        try {
          final comments = await commentRepository.getComments(productId);

          emit(CommentSuccessState(comments: comments));
        } catch (ex) {
          emit(
            CommentErrorState(
              exeption: ex is AppExeption ? ex : AppExeption(),
            ),
          );
        }
      }
    });
  }
}
