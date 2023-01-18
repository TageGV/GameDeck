import 'package:equatable/equatable.dart';

class OnboardState extends Equatable {
  final int currentIndex;
  const OnboardState({required this.currentIndex});

  OnboardState copyWith( int index) {
    return OnboardState(currentIndex: index);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [currentIndex];



}