class ReviewState {

  final bool loadingComplete;
  final int? relate;

  const ReviewState({ this.loadingComplete = false, this.relate });

  ReviewState copyWith(bool? loaded, int? relate) {
    return ReviewState(loadingComplete: loaded ?? loadingComplete, relate: relate ?? this.relate);
  }

}