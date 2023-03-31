import 'dart:developer';

class QuestionnaireData {
  int id;
  int childId;
  int age;
  String questionareTitle;
  List<QuestionPageData> questionList = [];
  String author;
  String authorPosition;
  int likes;
  int views;
  bool isLiked;
  bool inBookmarks;
  String bookmarkFolder;
  int createdAt;
  QuestionaireAnswers questionaireAnswers;

  QuestionnaireData({
    this.id,
    this.age,
    this.childId,
    this.questionareTitle,
    this.questionList,
    this.author,
    this.authorPosition,
    this.likes,
    this.views,
    this.isLiked,
    this.inBookmarks,
    this.bookmarkFolder,
    this.createdAt,
  });

  QuestionnaireData.fromJson(Map<String, dynamic> json, int childId) {
    Map<dynamic, dynamic> questionsJson = json['questions'];

    int i = 0;

    List<QuestionPageData> _questionList = [];
    Map<dynamic, dynamic> questions = questionsJson["questions"];

    Map<dynamic, dynamic> answers = questionsJson["answers"];

    QuestionaireAnswers questionaireAnswers = QuestionaireAnswers.fromJson(
      answers,
      childId,
    );

    questions.forEach(
      (key, value) {
        QuestionPageData tempQuestion = QuestionPageData.fromJson(value, i);
        _questionList.add(tempQuestion);
        i++;
      },
    );

    answers.entries.map(
      (question) {
        QuestionPageData tempQuestion =
            QuestionPageData.fromJson(question.value, i);
        _questionList.add(tempQuestion);
        i++;
      },
    ).toList();

    QuestionaireAnswers.fromJson(json['answers'], childId);
    
    id = json['id'];
    age = json['age'];
    childId = childId;
    questionareTitle = json['title'];
    questionList = _questionList;
    author = json['author'];
    authorPosition = json['author_position'];
    likes = json['likes'];
    views = json['views'];
    isLiked = json['is_liked'];
    inBookmarks = json['in_bookmarks'];
    bookmarkFolder = json['bookmark_folder'];
    createdAt = json['created_at'];
  }
}

class QuestionPageData {
  String title;
  int questionIndex;
  List<dynamic> questions = [];
  Map<String, String> ranges;

  QuestionPageData({
    this.title,
    this.questions,
    this.ranges,
    this.questionIndex,
  });
  factory QuestionPageData.fromJson(
      Map<dynamic, dynamic> questionJson, int questionIndex) {
    return QuestionPageData(
      questions: questionJson['questions'],
      questionIndex: questionIndex,
      ranges: questionJson['ranges'] != null
          ? Map<String, String>.from(questionJson['ranges'])
          : null,
    );
  }
}

class QuestionaireAnswers {
  int childId;
  List<QuestionaireAnswer> answers = [];

  QuestionaireAnswers({this.childId, this.answers});

  Map<String, dynamic> toJson(QuestionaireAnswers answer) {
    // preprocessing our answer such that it will be in the right order
    answer.answers.sort(
      (a, b) => a.questionIndex.compareTo(b.questionIndex),
    );

    var answersToSubmit = [];
    answer.answers.forEach(
      (element) {
        answersToSubmit.add(element.toJson());
      },
    );

    return {
      "child_id": answer.childId,
      "answers": answersToSubmit,
    };
  }

  factory QuestionaireAnswers.fromJson(
    Map<dynamic, dynamic> jsonData,
    int childId,
  ) {
    List<QuestionaireAnswer> answers = [];
    jsonData.forEach(
      (key, value) {
        answers.add(QuestionaireAnswer.fromJson(value, key));
      },
    );

    return QuestionaireAnswers(
      childId: childId,
      answers: answers,
    );
  }
}

class QuestionaireAnswer {
  int questionIndex;
  var answers;

  QuestionaireAnswer({
    this.questionIndex,
    this.answers,
  });

  factory QuestionaireAnswer.withAnswerType(int questionIndex) {
    // our questionare has 5 questions with numerical answers and 1 question with text answers it is static

    if (questionIndex == 5) {
      List answerList = [];
      // creating a list of five answers with comments

      for (int i = 0; i <= 5; i++) {
        answerList.add(AnswerWithComment());
      }

      return QuestionaireAnswer(
        questionIndex: questionIndex,
        answers: answerList,
      );
    } else {
      List answerList = [];
      for (int i = 0; i <= 5; i++) {
        answerList.add(AnswerWithoutComment());
      }
      return QuestionaireAnswer(
        questionIndex: questionIndex,
        answers: answerList,
      );
    }
  }

  factory QuestionaireAnswer.fromJson(Map<String, dynamic> json,int questionIndex) {
    final Map<String, dynamic> answerList = json;

    var answers = [];
    json.forEach(
      (key, value) {
        if (questionIndex == 5) {
          // if the question is the last one, it will have a comment
          answers.add(AnswerWithComment.fromJson(value));
        } else {
          answers.add(AnswerWithoutComment.fromJson(value));
        }
      },
    );

    return QuestionaireAnswer(answers: answers);
  }

  List<dynamic> toJson() {
    final List<dynamic> answerList = [];

    // Convert the map to a list, making sure the answers are in order
    for (int i = 0; i < answers.length; i++) {
      if (questionIndex == 5) {
        // will return a {"value": false, "comment": "Комментарии"},
        answerList.add(answers[i].toJson());
      } else {
        // should return a list of answer values
        answerList.add(answers[i].value);
      }
    }

    return answerList;
  }
}

class AnswerWithoutComment {
  int value;

  AnswerWithoutComment({this.value});

  factory AnswerWithoutComment.fromJson(Map<String, dynamic> json) {
    return AnswerWithoutComment(
      value: json['value'],
    );
  }
}

class AnswerWithComment {
  bool value;
  String comment;

  AnswerWithComment({this.value, this.comment});

  factory AnswerWithComment.fromJson(Map<String, dynamic> json) {
    return AnswerWithComment(
      value: json['value'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "value": value,
      "comment": comment,
    };
  }
}

mixin ComputeOperations {
  static List<QuestionnaireData> parseQuestionare(
    dynamic responseBody,
    int childId,
  ) {
    final List<dynamic> questionareJson = responseBody as List<dynamic>;
    final List<QuestionnaireData> questionares = questionareJson
        .map((json) => QuestionnaireData.fromJson(json, childId))
        .toList();
    return questionares;
  }
}
