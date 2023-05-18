import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/params/comment_params.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/comment_feature/data/repository/comment_repository.dart';

part 'add_comment_event.dart';
part 'add_comment_state.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  final ICommentRepository commentRepository;
  AddCommentBloc(this.commentRepository) : super(AddCommentInitState()) {
    on<AddCommentEvent>((event, emit) async {
      if (event is AddCommentButtonPressed) {
        try {
          emit(AddCommetLoadingState());

          await commentRepository.addComment(CommentParams(
            title: event.title,
            content: event.content,
            productId: event.productId,
          ));

          emit(AddCommentSuccessState());
        } catch (ex) {
          emit(AddCommentErrorState(AppExeption()));
        }
      }
    });
  }
}
