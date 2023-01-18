import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/models/question.dart';

class QuizState {
  final List<CategoryItem> categories;
  final List<Question> questions;
  final int position;

  int getNumberQuestion() {
    return questions.length;
  }

  int get totalQuestion => categories.map((e) => e.totalQuestion ?? 0).reduce((value, element) => value + element);

  bool get hasPremium => categories.map((e) => e.isPremium == 1).contains(true);


  String getPercentSelect() {
    String value = "OR";
    if (questions.isNotEmpty) {
      final question = questions[position];
      int? answerId;
      if (question.userAnswer!.isNotEmpty) {
        answerId = question.userAnswer!.first.answerId;
      }
      if (answerId != null && answerId != 0) {
        final totalVote = question.answers!
            .map((e) => e.totalVote ?? 0)
            .reduce((value, element) => value + element) + 1;
        final voteValue = question.answers!
            .where((element) => element.id == answerId)
            .toList()
            .map((e) => e.totalVote ?? 0);
        if (voteValue.isNotEmpty) {
          int percent = (((voteValue.first + 1) / totalVote) * 100).round();
          value = "$percent%";
        }
      }
    }
    return value;
  }

  String getQuestContent() {
    String content = "";
    if (questions.isNotEmpty) {
      content = questions[position].content!;
    }
    return content;
  }

  int? getUserAnswerId() {
    int? id;
    if (questions.isNotEmpty) {
      final userAnswers = questions[position].userAnswer;
      if (userAnswers != null && userAnswers.isNotEmpty) {
        id = userAnswers.first.answerId == 0 ? null:userAnswers.first.answerId;
      }
    }
    return id;
  }

  String getAnswerContent({required bool isLast}) {
    String question = "";
    if (questions.isNotEmpty) {
      final answers = questions[position].answers;
      if (answers != null && answers.isNotEmpty) {
        question =
            isLast ? answers.last.content ?? "" : answers.first.content ?? "";
      }
    }
    return question;
  }

  String getAnswerVote({required bool isLast}) {
    String question = "";
    if (questions.isNotEmpty) {
      final answers = questions[position].answers;
      if (answers != null && answers.isNotEmpty) {
        question =
        isLast ? answers.last.vote(getUserAnswerId()) ?? "" : answers.first.vote(getUserAnswerId()) ?? "";
      }
    }
    return question;
  }

  int? getAnswerId({required bool isLast}) {
    int? id;
    if (questions.isNotEmpty) {
      final answers = questions[position].answers;
      if (answers != null && answers.isNotEmpty) {
        id = isLast ? answers.last.id : answers.first.id;
      }
    }
    return id;
  }

  QuizState(
      {this.questions = const [],
      this.position = 0,
      this.categories = const []});

  QuizState copyWith(
      {int? position,
      List<Question>? questions,
      List<CategoryItem>? categories,
      int? answerId}) {
    return QuizState(
        position: position ?? this.position,
        questions: questions ?? this.questions,
        categories: categories ?? this.categories);
  }
}
