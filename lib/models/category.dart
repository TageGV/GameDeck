import 'package:equatable/equatable.dart';

class CategoryItem extends Equatable {

  int? id;
  String? name;
  int? creatorId;
  String? cover;
  int? order;
  int? isPremium;
  int? isVisible;
  int? userCategory;
  bool isSelected = false;
  int? totalQuestion;
  int? totalQuestionAnswer;
  int? totalQuestionAds;
  int? categoryOverview;
  int? userTotalVote;

  bool get isComplete => totalQuestionAnswer == totalQuestion;

  bool get hasQuestionAds => (totalQuestionAds ?? 0) != 0;

  bool get isPremiumCategory => isPremium == 1;

  CategoryItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    creatorId = json["creator_id"];
    cover = json["cover"];
    order = json["order"];
    isPremium = json["is_premium"];
    isVisible = json["is_visible"];
    userCategory = json["user_category"];
    totalQuestion = json["total_question"];
    totalQuestionAnswer = json["total_question_answer"];
    totalQuestionAds = json["total_question_ads"];
    categoryOverview = json["category_overview"];
    userTotalVote = json["user_total_vote"];
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
