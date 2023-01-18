class UserAnswer {
  int? answerId;
  int? questionId;

  UserAnswer({this.answerId, this.questionId});

  UserAnswer.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer_id'] = answerId;
    data['question_id'] = questionId;
    return data;
  }
}