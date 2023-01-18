class Answers {
  int? id;
  int? questionId;
  String? content;
  int? totalVote;
  int? order;

  Answers({this.id, this.questionId, this.content, this.totalVote, this.order});

  String? vote(int? selectId) {
    final substring = selectId == id ? "agreed":"disagreed";
    final String value;
    final voteValue = totalVote ?? 0;
    if(voteValue < 1000) {
      value = "$voteValue";
    } else if (voteValue >= 1000 && voteValue < 1000000){
      value = "${(voteValue.toDouble()/1000).toStringAsFixed(1)}k";
    } else {
      value = "${(voteValue.toDouble()/1000000).toStringAsFixed(1)}m";
    }
    return "$value $substring";
  }

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    content = json['content'];
    totalVote = json['total_vote'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_id'] = questionId;
    data['content'] = content;
    data['total_vote'] = totalVote;
    data['order'] = order;
    return data;
  }
}