import 'package:flutter/material.dart';

void main() {
  runApp(const PersonalizedLearningApp());
}

// =====================================================
// GLOBAL LEARNING DATA
// =====================================================

class LearningData {
  static int lastScore = 0;
  static int lastTotal = 5;

  static int quizzesCompleted = 0;
  static int totalScore = 0;
  static int totalQuestions = 0;

  static double progress = 0.0;

  static void saveQuizResult(int score, int total) {
    lastScore = score;
    lastTotal = total;

    quizzesCompleted++;
    totalScore += score;
    totalQuestions += total;

    if (totalQuestions > 0) {
      progress = totalScore / totalQuestions;
    }
  }

  static String getRecommendation() {
    double percentage = 0;

    if (lastTotal > 0) {
      percentage = (lastScore / lastTotal) * 100;
    }

    if (percentage >= 80) {
      return 'Excellent performance! '
          'You are ready to move to the next topic.';
    } else if (percentage >= 60) {
      return 'Good performance! '
          'Revise this topic once and continue learning.';
    } else {
      return 'You need more practice. '
          'Revise the topic and take the quiz again.';
    }
  }

  static String getPerformanceLevel() {
    double percentage = 0;

    if (lastTotal > 0) {
      percentage = (lastScore / lastTotal) * 100;
    }

    if (percentage >= 80) {
      return 'Excellent';
    } else if (percentage >= 60) {
      return 'Good';
    } else {
      return 'Needs Improvement';
    }
  }
}

// =====================================================
// MAIN APP
// =====================================================

class PersonalizedLearningApp extends StatelessWidget {
  const PersonalizedLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personalized Learning System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// =====================================================
// LOGIN PAGE
// =====================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  void login() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: username),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username and password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Learning'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            const Icon(
              Icons.school,
              size: 100,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            const Text(
              'Welcome to Personalized Learning',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Learn according to your performance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 35),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: login,
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Personalized Learning System',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    int progressPercentage =
        (LearningData.progress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // WELCOME
            Text(
              'Welcome, $username 👋',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Continue your personalized learning journey.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // PROGRESS CARD
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Overall Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    LinearProgressIndicator(
                      value: LearningData.progress,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '$progressPercentage% Completed',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Your Learning',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // SUBJECTS
            dashboardCard(
              context,
              'My Subjects',
              'View subjects and topics',
              Icons.book,
              Colors.blue,
              const SubjectsPage(),
            ),

            // QUIZ
            dashboardCard(
              context,
              'Take Quiz',
              'Test your knowledge',
              Icons.quiz,
              Colors.green,
              const QuizPage(),
            ),

            // PROGRESS
            dashboardCard(
              context,
              'My Progress',
              'Check your learning progress',
              Icons.bar_chart,
              Colors.orange,
              const ProgressPage(),
            ),

            // RECOMMENDATIONS
            dashboardCard(
              context,
              'Recommendations',
              'Get personalized recommendations',
              Icons.recommend,
              Colors.purple,
              const RecommendationPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Widget page,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 25,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// SUBJECTS PAGE
// =====================================================

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subjects'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            'Select a Subject',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          subjectCard(
            context,
            'Java Programming',
            'Learn Java programming concepts',
            Icons.code,
          ),

          subjectCard(
            context,
            'Data Structures',
            'Learn arrays, stacks, queues and trees',
            Icons.account_tree,
          ),

          subjectCard(
            context,
            'Machine Learning',
            'Learn basic machine learning concepts',
            Icons.smart_toy,
          ),

          subjectCard(
            context,
            'Computer Networks',
            'Learn networking concepts',
            Icons.network_check,
          ),
        ],
      ),
    );
  }

  Widget subjectCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: Icon(
          icon,
          size: 40,
          color: Colors.blue,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicPage(
                subject: title,
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// TOPIC PAGE
// =====================================================

class TopicPage extends StatelessWidget {
  final String subject;

  const TopicPage({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    List<String> topics = [
      'Introduction',
      'Basic Concepts',
      'Important Topics',
      'Practice Problems',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              contentPadding: const EdgeInsets.all(12),

              leading: CircleAvatar(
                child: Text(
                  '${index + 1}',
                ),
              ),

              title: Text(
                topics[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyMaterialPage(
                      subject: subject,
                      topic: topics[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// STUDY MATERIAL PAGE
// =====================================================

class StudyMaterialPage extends StatelessWidget {
  final String subject;
  final String topic;

  const StudyMaterialPage({
    super.key,
    required this.subject,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              subject,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              topic,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Study Material',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'This section contains learning material, '
              'examples, explanations and important notes '
              'for the selected topic.',
              style: TextStyle(
                fontSize: 17,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Learning Objectives',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              '• Understand the basic concepts\n'
              '• Learn important definitions\n'
              '• Study examples\n'
              '• Practice problems\n'
              '• Test your knowledge using the quiz',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.quiz),

                label: const Text(
                  'Take Quiz',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// QUIZ PAGE
// =====================================================

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  int currentQuestion = 0;
  int score = 0;

  final List<Map<String, dynamic>> questions = [

    {
      'question': 'Which language is used by Flutter?',
      'options': [
        'Java',
        'Dart',
        'Python',
        'C++',
      ],
      'answer': 'Dart',
    },

    {
      'question': 'Which keyword creates a class in Java?',
      'options': [
        'class',
        'create',
        'object',
        'new',
      ],
      'answer': 'class',
    },

    {
      'question': 'Which data structure uses FIFO?',
      'options': [
        'Stack',
        'Queue',
        'Tree',
        'Graph',
      ],
      'answer': 'Queue',
    },

    {
      'question': 'What does ML stand for?',
      'options': [
        'Machine Learning',
        'Manual Language',
        'Machine Logic',
        'Model Language',
      ],
      'answer': 'Machine Learning',
    },

    {
      'question': 'Which device connects computers in a network?',
      'options': [
        'Switch',
        'Keyboard',
        'Monitor',
        'Printer',
      ],
      'answer': 'Switch',
    },
  ];

  void answerQuestion(String answer) {

    if (answer == questions[currentQuestion]['answer']) {
      score++;
    }

    if (currentQuestion < questions.length - 1) {

      setState(() {
        currentQuestion++;
      });

    } else {

      // SAVE RESULT
      LearningData.saveQuizResult(
        score,
        questions.length,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: score,
            total: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> question =
        questions[currentQuestion];

    double questionProgress =
        (currentQuestion + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Question ${currentQuestion + 1} / ${questions.length}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: questionProgress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 30),

            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ...List<String>.from(
              question['options'],
            ).map(
              (option) {

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: ElevatedButton(
                    onPressed: () {
                      answerQuestion(option);
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// RESULT PAGE
// =====================================================

class ResultPage extends StatelessWidget {

  final int score;
  final int total;

  const ResultPage({
    super.key,
    required this.score,
    required this.total,
  });

  String getRecommendation() {

    double percentage =
        (score / total) * 100;

    if (percentage >= 80) {
      return 'Excellent! You can move to the next topic.';
    } else if (percentage >= 60) {
      return 'Good job! Revise this topic once.';
    } else {
      return 'You need more practice. Please revise this topic.';
    }
  }

  String getPerformance() {

    double percentage =
        (score / total) * 100;

    if (percentage >= 80) {
      return 'Excellent';
    } else if (percentage >= 60) {
      return 'Good';
    } else {
      return 'Needs Improvement';
    }
  }

  @override
  Widget build(BuildContext context) {

    double percentage =
        (score / total) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.emoji_events,
                size: 90,
                color: Colors.orange,
              ),

              const SizedBox(height: 20),

              const Text(
                'Your Score',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '$score / $total',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '${percentage.round()}%',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                getPerformance(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Card(
                elevation: 3,

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      const Icon(
                        Icons.recommend,
                        size: 40,
                        color: Colors.purple,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Personalized Recommendation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        getRecommendation(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const ProgressPage(),
                    ),

                    (route) => false,
                  );
                },

                child: const Text(
                  'View My Progress',
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const RecommendationPage(),
                    ),

                    (route) => false,
                  );
                },

                child: const Text(
                  'View Recommendations',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// PROGRESS PAGE
// =====================================================

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {

    int percentage =
        (LearningData.progress * 100).round();

    String performance =
        LearningData.getPerformanceLevel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const Text(
              'Learning Progress',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(25),

                child: Column(
                  children: [

                    SizedBox(
                      height: 150,
                      width: 150,

                      child: Stack(
                        alignment: Alignment.center,

                        children: [

                          SizedBox(
                            height: 150,
                            width: 150,

                            child: CircularProgressIndicator(
                              value: LearningData.progress,
                              strokeWidth: 14,
                            ),
                          ),

                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Overall Learning Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.quiz,
                  color: Colors.green,
                ),

                title: const Text(
                  'Quizzes Completed',
                ),

                trailing: Text(
                  '${LearningData.quizzesCompleted}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),

                title: const Text(
                  'Last Quiz Score',
                ),

                trailing: Text(
                  '${LearningData.lastScore}/${LearningData.lastTotal}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.assessment,
                  color: Colors.blue,
                ),

                title: const Text(
                  'Performance',
                ),

                trailing: Text(
                  performance,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              LearningData.getRecommendation(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// RECOMMENDATION PAGE
// =====================================================

class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {

    String recommendation =
        LearningData.getRecommendation();

    String performance =
        LearningData.getPerformanceLevel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Personalized Recommendations',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Based on your latest quiz performance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Icon(
                      Icons.analytics,
                      size: 40,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Your Performance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      performance,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      recommendation,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (LearningData.lastScore <
                LearningData.lastTotal * 0.6)

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.refresh,
                    color: Colors.orange,
                  ),

                  title: const Text(
                    'Revise the Topic',
                  ),

                  subtitle: const Text(
                    'Your score indicates that you need more practice.',
                  ),
                ),
              ),

            if (LearningData.lastScore >=
                LearningData.lastTotal * 0.6)

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                  ),

                  title: const Text(
                    'Continue Learning',
                  ),

                  subtitle: const Text(
                    'Your performance is good. Continue to the next topic.',
                  ),
                ),
              ),

            if (LearningData.lastScore >=
                LearningData.lastTotal * 0.8)

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.emoji_events,
                    color: Colors.orange,
                  ),

                  title: const Text(
                    'Advanced Learning',
                  ),

                  subtitle: const Text(
                    'You performed very well. Try more advanced topics.',
                  ),
                ),
              ),

            const SizedBox(height: 25),

            const Text(
              'Recommended Learning Path',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            recommendationItem(
              Icons.book,
              'Review Study Material',
            ),

            recommendationItem(
              Icons.quiz,
              'Take Practice Quiz',
            ),

            recommendationItem(
              Icons.trending_up,
              'Track Your Progress',
            ),
          ],
        ),
      ),
    );
  }

  Widget recommendationItem(
    IconData icon,
    String title,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),

        title: Text(title),

        trailing: const Icon(
          Icons.check_circle,
        ),
      ),
    );
  }
}