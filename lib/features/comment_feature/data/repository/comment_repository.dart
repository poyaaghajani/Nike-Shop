import 'package:nike/core/params/comment_params.dart';
import 'package:nike/core/utils/api_service.dart';
import 'package:nike/features/comment_feature/data/datasource/comment_datasource.dart';
import 'package:nike/features/comment_feature/data/model/comment.dart';

final commentrepository = CommentRepository(CommentRemoteDatasource(dio));

abstract class ICommentRepository {
  Future<List<Comment>> getComments(int productId);
  Future<void> addComment(CommentParams params);
}

class CommentRepository implements ICommentRepository {
  final ICommentDatasource commentDatasource;

  CommentRepository(this.commentDatasource);

  // get all comments
  @override
  Future<List<Comment>> getComments(int productId) {
    return commentDatasource.getComments(productId);
  }

  // add comment
  @override
  Future<void> addComment(CommentParams params) {
    return commentDatasource.addComment(params);
  }
}
