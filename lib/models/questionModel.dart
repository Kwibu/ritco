class Question {
  final String id;
  final String questonName;
  
  //bins all are identifiers of the weight based on modulo 5
  //{1 : weight = 5, 2: weight = 2, 3: weight:0 }
  // final int bin;
  Question({
    required this.id,
    required this.questonName,
  });
}

final List QUESTIONS = [
  Question(id: "1", questonName: "Very Satisfied"),
  Question(id: "2", questonName: "Somewhat Satisfied"),
  Question(
    id: "3",
    questonName: "Neither Satisfied nor Satisfied",
  ),
  Question(id: "4", questonName: "Somewhat dissatisfied"),
  Question(id: "5", questonName: "Very  dissatisfied"),
];
