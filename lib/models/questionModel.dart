class Question {
  final String id;
  final String questonName;
  final int questionMarks;
  Question(
      {required this.id,
      required this.questonName,
      required this.questionMarks});
}

final List QUESTIONS = [
  Question(id: "1", questonName: "Very Satisfied", questionMarks: 1),
  Question(id: "2", questonName: "Somewhat Satisfied", questionMarks: 2),
  Question(
      id: "3",
      questonName: "Neither Satisfied nor Satisfied",
      questionMarks: 3),
  Question(id: "4", questonName: "Somewhat dissatisfied", questionMarks: 4),
  Question(id: "5", questonName: "Very  dissatisfied", questionMarks: 5),
];
