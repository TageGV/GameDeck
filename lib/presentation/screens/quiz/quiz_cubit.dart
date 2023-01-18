
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/snackbar/snackbar_cubit.dart';
import 'package:mx_exchange/common/routes/routes.dart';
import 'package:mx_exchange/models/category.dart';
import 'package:mx_exchange/models/user_answer.dart';
import 'package:mx_exchange/presentation/screens/overview/overview_state.dart';
import 'package:mx_exchange/presentation/screens/quiz/quiz_state.dart';
import 'package:mx_exchange/respostory/datasources.dart';

class QuizCubit extends Cubit<QuizState> {

  final DataSources dataSources;
  final SnackBarCubit snackBarCubit;
  final LoadingCubit loadingCubit;

  QuizCubit(this.dataSources, this.loadingCubit, this.snackBarCubit):super(QuizState());

  void initCategories(List<CategoryItem> items) {
    emit(state.copyWith(categories: items));
  }

  void getQuestion() async {
    loadingCubit.showLoading();
    final ids = state.categories.map((e) => e.id!).toList();
    final response = await dataSources.getQuestionsWith(ids: ids);
    int position = 0;
    final questions = response.where((element) => (element.userAnswer ?? []).isEmpty).toList();
    if(questions.isNotEmpty) {
      final item = questions.map((e) => e.id!).first;
      position = response.map((e) => e.id!).toList().indexOf(item);
    }
    emit(state.copyWith(questions: response, position: position));
    loadingCubit.hideLoading();
  }

  void selectAnswer( int? id) {
    final question = state.questions[state.position];
    question.userAnswer = [UserAnswer(questionId: question.id!, answerId: id!)];
    emit(state.copyWith());
  }


  void skip() async {
    final question = state.questions[state.position];
    loadingCubit.showLoading();
    try {
      await dataSources.skip(question.categoryId!, question.id!);
      loadingCubit.hideLoading();
    } catch (e){
      loadingCubit.hideLoading();
    }
    _handleNextQuestion();
  }

  void onPressBottomButton() async {
    final question = state.questions[state.position];
    int? answerId = 0;
    if (question.userAnswer != null && question.userAnswer!.isNotEmpty) {
      answerId = question.userAnswer?.first.answerId;
    }
    loadingCubit.showLoading();
    try {
      await dataSources.answer(question.categoryId ?? 0, question.id ?? 0, answerId ?? 0);
      loadingCubit.hideLoading();
    } catch (e){
      loadingCubit.hideLoading();
      return;
    }

    _handleNextQuestion();

  }

  void _handleNextQuestion() {
    /// Show review when complete all question.
    if (state.position == state.totalQuestion - 1) {
      Routes.instance.navigateAndReplace(R.review, arguments: state.categories.map((e) => e.id ?? 0).toList());
      return;
    }

    if(state.hasPremium && state.position == state.getNumberQuestion() - 1) {
      // TODO: - show popup view videos.

    }

    /// Handle position show overview on answer ten question.
    if ((state.position + 1)%10 == 0) {
      int relate = 0;
      int totalRelate = 0;

      for ( var i = state.position + 1 ; i >= 0 && i >= state.position - 10; i-- ) {
        relate = relate + state.questions[i].getRelate();
        totalRelate = totalRelate + state.questions[i].totalRelate;
      }
      final value = (relate.toDouble()/totalRelate.toDouble())*100;
      Routes.instance.navigateTo(R.overview, arguments: OverviewArguments(relate: value.toInt(), totalQuestion: state.questions.length, current: state.position + 1));
    }

    /// Check current question position.
    if (state.position < state.questions.length - 1) {
      emit(state.copyWith(position: state.position + 1));
    }
  }
  /// Handle back action bottom button.
  void onBack() {
    if (state.position == 0) {
      Routes.instance.pop(result: "Reset Deck");
    } else {
      emit(state.copyWith(position: state.position - 1));
    }
  }

}