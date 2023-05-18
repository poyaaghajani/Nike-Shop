import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/custom_buton.dart';
import 'package:nike/core/widgets/custom_snackbar.dart';
import 'package:nike/core/widgets/loading_widget.dart';
import 'package:nike/features/comment_feature/data/repository/comment_repository.dart';
import 'package:nike/features/comment_feature/presentation/bloc/add_comment/add_comment_bloc.dart';
import 'package:nike/features/comment_feature/presentation/bloc/comment/comment_bloc.dart';

class CommentList extends StatefulWidget {
  const CommentList({super.key, required this.productId});

  final int productId;

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  late StreamSubscription<AddCommentState>? commentSubscription;

  late CommentBloc? commentBloc;

  @override
  void dispose() {
    commentSubscription?.cancel();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentBloc>(
      create: (context) {
        commentBloc = CommentBloc(
          commentRepository: commentrepository,
          productId: widget.productId,
        );
        commentBloc!.add(CommentRequest());
        return commentBloc!;
      },
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is CommentLoadingState) {
            return const SliverToBoxAdapter(
              child: LoadingWidget(),
            );
          }
          if (state is CommentSuccessState) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = state.comments[index];
                  if (index == 0) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'نظرت کاربران',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  commentButton(context);
                                },
                                child: const Text(
                                  'ثبت نظر',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Divider(
                            color: LightThemeColors.navy,
                            thickness: 1,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: index == state.comments.length - 1 ? 85 : 20),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title),
                                  Text(
                                    item.email,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              Text(
                                item.date,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(item.content),
                        ],
                      ),
                    );
                  }
                },
                childCount: state.comments.length,
              ),
            );
          }
          if (state is CommentErrorState) {
            return SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exeption.message),
                    SizedBox(height: DeviseSize.getHeight(context) / 85),
                    CustomButton(
                      onPressed: () {
                        BlocProvider.of<CommentBloc>(context)
                            .add(CommentRequest());
                      },
                      text: 'تلاش دوباره',
                      color: LightThemeColors.secondaryColor,
                    )
                  ],
                ),
              ),
            );
          } else {
            return SliverToBoxAdapter(
              child: Container(),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> commentButton(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: LightThemeColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'نظر خود را وارد کنید',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                textAlign: TextAlign.end,
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'عنوان',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: LightThemeColors.primaryColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: DeviseSize.getHeight(context) / 85),
              TextField(
                textAlign: TextAlign.end,
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'کامنت',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: LightThemeColors.primaryColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocProvider(
                  create: (context) {
                    final addCommentBloc = AddCommentBloc(commentrepository);

                    commentSubscription = addCommentBloc.stream.listen((state) {
                      if (state is AddCommentSuccessState) {
                        Navigator.pop(context);
                        titleController.clear();
                        contentController.clear();
                        CustomSnackbar.showSnack(
                          context,
                          'کامنت شما اضافه شد',
                          Colors.white,
                          LightThemeColors.deepNavy,
                        );
                        commentBloc!.add(CommentRequest());
                      } else if (state is AddCommentErrorState) {
                        Navigator.pop(context);
                        titleController.clear();
                        contentController.clear();
                        CustomSnackbar.showSnack(
                          context,
                          'مشکلی در اضافه شدن کامنت پیش آمده',
                          Colors.white,
                          LightThemeColors.deepNavy,
                        );
                      }
                    });

                    return addCommentBloc;
                  },
                  child: BlocBuilder<AddCommentBloc, AddCommentState>(
                    builder: (context, state) {
                      if (state is AddCommentInitState) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: LightThemeColors.green),
                          onPressed: () async {
                            BlocProvider.of<AddCommentBloc>(context).add(
                              AddCommentButtonPressed(
                                productId: widget.productId,
                                title: titleController.text,
                                content: contentController.text,
                              ),
                            );
                          },
                          child: const Text('ارسال'),
                        );
                      }
                      if (state is AddCommentErrorState) {
                        return const Text('');
                      }

                      if (state is AddCommentSuccessState) {
                        return const Text('');
                      }
                      if (state is AddCommetLoadingState) {
                        return const CupertinoActivityIndicator();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('کنسل'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
