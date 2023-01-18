class Onboard {
  final String title;
  final String subtitle;

  Onboard({required this.title, required this.subtitle});
}

List<Onboard> getOnboards() {
  return [
    Onboard(
        title: "2000+ Unique questions in 10 Decks.",
        subtitle:
            "We are regularly coming up with new and challenging questions. "),
    Onboard(
        title: "Caution! Hot questions included.",
        subtitle:
            "When you mix in your dirty deck things will get sexual and chaotic very quickly.  "),
    Onboard(
        title: "Mix and Match \nDecks",
        subtitle:
            "Mix and Match your decks for a different kind of party every time.")
  ];
}
