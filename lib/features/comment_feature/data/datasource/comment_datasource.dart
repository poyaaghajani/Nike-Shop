import 'package:dio/dio.dart';
import 'package:nike/core/params/comment_params.dart';
import 'package:nike/core/utils/validator.dart';
import 'package:nike/features/comment_feature/data/model/comment.dart';

abstract class ICommentDatasource {
  Future<List<Comment>> getComments(int productId);
  Future<void> addComment(CommentParams params);
}

class CommentRemoteDatasource implements ICommentDatasource {
  final Dio dio;
  CommentRemoteDatasource(this.dio);

  // get all comments
  @override
  Future<List<Comment>> getComments(int productId) async {
    final response = await dio.get('comment/list?product_id=$productId');

    validateResponse(response);

    final List<Comment> comments = [];

    for (var element in (response.data as List)) {
      comments.add(Comment.fromJson(element));
    }

    return comments;
  }

  // add comment
  @override
  Future<void> addComment(CommentParams params) async {
    await dio.post('comment/add', data: {
      'title': params.title,
      'content': params.content,
      'product_id': params.productId,
    });
  }
}
