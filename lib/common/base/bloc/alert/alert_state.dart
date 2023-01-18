class AppAlertState {
  final String? title;
  final String? message;

  AppAlertState({
    this.title,
    this.message,
  });
}

class ShowAlertState extends AppAlertState {
  ShowAlertState({String? title, String? message})
      : super(title: title, message: message);
}
