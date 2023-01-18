import 'package:equatable/equatable.dart';

class HomeEventState extends Equatable{
  final bool chooseOtherDeck;
  const HomeEventState({this.chooseOtherDeck = false});
  HomeEventState copyWith({bool? chooseOtherDeck}) {
    return HomeEventState(chooseOtherDeck: chooseOtherDeck ?? this.chooseOtherDeck);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [chooseOtherDeck];
}