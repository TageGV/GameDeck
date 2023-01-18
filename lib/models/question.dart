import 'package:mx_exchange/models/answer.dart';
import 'package:mx_exchange/models/user_answer.dart';

class Question {
  int? id;
  int? categoryId;
  int? creatorId;
  String? content;
  int? order;
  List<Answers>? answers;
  List<UserAnswer>? userAnswer;

  int get totalRelate => (answers ?? []).map((e) => e.totalVote ?? 0 ).reduce((value, element) => value + element);

  int getRelate() {
    if(userAnswer != null && userAnswer!.isNotEmpty) {
      final id = userAnswer!.first.answerId;
      final index = answers!.map((e) => e.id).toList().indexOf(id);
      final relate = answers![index].totalVote ?? 0;
      return relate;
    }else{
      return 0;
    }
  }

  Question(
      {this.id,
        this.categoryId,
        this.creatorId,
        this.content,
        this.order,
        this.answers,
        this.userAnswer});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    creatorId = json['creator_id'];
    content = json['content'];
    order = json['order'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    if (json['user_answer'] != null) {
      userAnswer = <UserAnswer>[];
      json['user_answer'].forEach((v) {
        userAnswer!.add(UserAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['creator_id'] = creatorId;
    data['content'] = content;
    data['order'] = order;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    if (userAnswer != null) {
      data['user_answer'] = userAnswer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}