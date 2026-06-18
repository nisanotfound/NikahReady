// lib/models/quiz_model.dart

class QuizTopic {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final List<QuizQuestion> questions;

  const QuizTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.questions,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class QuizResult {
  final String topicId;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;

  const QuizResult({
    required this.topicId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
  });

  int get score => ((correctAnswers / totalQuestions) * 100).round();

  String get grade {
    if (score >= 90) return 'Mumtaz (Excellent)';
    if (score >= 70) return 'Jayyid Jiddan (Very Good)';
    if (score >= 50) return 'Jayyid (Good)';
    return 'Needs Improvement';
  }
}

// ─── Question Bank ────────────────────────────────────────────────────────────

final List<QuizTopic> quizTopics = [
  QuizTopic(
    id: 'syarat_nikah',
    title: 'Conditions of Nikah',
    subtitle: 'Pillars & validity conditions of marriage',
    icon: '📜',
    questions: [
      QuizQuestion(
        question: 'How many pillars (rukun) of nikah are obligatory to fulfil in Islam?',
        options: ['3 pillars', '4 pillars', '5 pillars', '6 pillars'],
        correctIndex: 2,
        explanation:
            'There are 5 pillars of nikah: the groom, the bride, the wali (guardian), two witnesses, and the ijab-qabul (offer and acceptance). All five must be present for the marriage contract to be valid.',
      ),
      QuizQuestion(
        question: 'What is the primary condition for the bride in a marriage contract?',
        options: [
          'She must be at least 18 years old',
          'She must be Muslim, not a mahram, and not in the iddah period',
          'She must obtain permission from her employer',
          'She must own her own property',
        ],
        correctIndex: 1,
        explanation:
            'The bride must be a Muslim, must not be a mahram (forbidden relative) to the groom, and must not currently be in an iddah (waiting period) from a previous marriage.',
      ),
      QuizQuestion(
        question: 'Who is NOT eligible to act as a wali (marriage guardian)?',
        options: [
          'Biological father',
          'Paternal grandfather',
          'Full brother',
          'Maternal uncle',
        ],
        correctIndex: 3,
        explanation:
            'The wali of nikah must come from the paternal lineage (nasab patrilineal). A maternal uncle is not included in the order of wali because he is from the mother\'s side.',
      ),
      QuizQuestion(
        question: 'What does "ijab" refer to in the marriage contract?',
        options: [
          'The acceptance statement by the groom',
          'The offer statement by the bride\'s guardian',
          'The prayer recited by the imam',
          'The giving of the mahr (dowry)',
        ],
        correctIndex: 1,
        explanation:
            'Ijab is the offer statement made by the bride\'s wali (guardian) to initiate the marriage contract. Qabul is the groom\'s acceptance statement that follows.',
      ),
      QuizQuestion(
        question: 'What is the minimum number of witnesses required for a valid nikah?',
        options: ['1 witness', '2 witnesses', '3 witnesses', '4 witnesses'],
        correctIndex: 1,
        explanation:
            'A nikah requires at least 2 male witnesses who are Muslim, of adult age, of sound mind, and of upright character (adil). Without witnesses, the marriage contract is invalid.',
      ),
    ],
  ),

  QuizTopic(
    id: 'wali_saksi',
    title: 'Wali & Witnesses',
    subtitle: 'Role of the guardian and witness conditions',
    icon: '🤝',
    questions: [
      QuizQuestion(
        question: 'Who is the first in the order of wali (guardian) in an Islamic marriage?',
        options: ['Grandfather', 'Father', 'Elder brother', 'Judge (Hakim)'],
        correctIndex: 1,
        explanation:
            'The biological father is the primary wali (wali aqrab). The order after him is: paternal grandfather, full brothers, paternal uncles, and so on through the paternal line.',
      ),
      QuizQuestion(
        question: 'When can a wali hakim (judge) substitute the wali nasab (blood guardian)?',
        options: [
          'When the wali nasab demands payment',
          'When the wali nasab is absent, refuses, or is unqualified',
          'When the bride dislikes her wali nasab',
          'When the ceremony is held abroad',
        ],
        correctIndex: 1,
        explanation:
            'A wali hakim (typically the Qadi/judge) may act as wali when the wali nasab is deceased, absent, refuses without valid reason (adhal), or does not meet the conditions to serve as wali.',
      ),
      QuizQuestion(
        question: 'Which condition is NOT required of a nikah witness?',
        options: ['Muslim', 'Adult (baligh)', 'Male', 'Unmarried'],
        correctIndex: 3,
        explanation:
            'The conditions for a nikah witness are: Muslim, adult (baligh), of sound mind (berakal), male, free, and of upright character (adil). Marital status — whether single or married — is not a condition.',
      ),
      QuizQuestion(
        question: 'What is the ruling on a nikah conducted without the consent of the wali for a woman who has a wali?',
        options: [
          'Valid but disliked (makruh)',
          'Valid under certain conditions',
          'Invalid (void)',
          'Depends on the state\'s ruling',
        ],
        correctIndex: 2,
        explanation:
            'According to the Shafi\'i school (practised in Malaysia), a nikah conducted without a wali is invalid and void. This is based on the hadith: "There is no nikah except with a wali."',
      ),
      QuizQuestion(
        question: 'Can a woman serve as a witness in a nikah contract?',
        options: [
          'Yes, fully permitted',
          'Yes, if no male witnesses are available',
          'No, witnesses must be male',
          'Yes, with the permission of the Qadi',
        ],
        correctIndex: 2,
        explanation:
            'According to the Shafi\'i school, nikah witnesses must be male. Women are not permitted to serve as witnesses in the marriage contract, even in exceptional circumstances.',
      ),
    ],
  ),

  QuizTopic(
    id: 'hak_suami_isteri',
    title: 'Rights of Husband & Wife',
    subtitle: 'Rights & responsibilities after marriage',
    icon: '⚖️',
    questions: [
      QuizQuestion(
        question: 'What is the primary financial obligation of a husband towards his wife?',
        options: [
          'To give the mahr only',
          'To provide nafaqah (food, clothing, and shelter)',
          'To open a joint bank account',
          'To pay all of his wife\'s debts',
        ],
        correctIndex: 1,
        explanation:
            'A husband is obligated to provide nafaqah to his wife, which includes the basic needs of food, clothing, and appropriate housing according to his financial capability. This is a right guaranteed to the wife by Islamic law.',
      ),
      QuizQuestion(
        question: 'What is the wife\'s right regarding the mahr (dowry)?',
        options: [
          'The mahr only needs to be paid if the wife requests it',
          'The mahr is the wife\'s absolute right and becomes her sole property',
          'The husband may reclaim the mahr in the event of divorce',
          'The mahr is merely symbolic and not obligatory',
        ],
        correctIndex: 1,
        explanation:
            'The mahr is the wife\'s absolute right and becomes her full personal property upon marriage. The husband cannot reclaim it unless the wife voluntarily gifts it back to him.',
      ),
      QuizQuestion(
        question: 'What is the husband\'s right that the wife is obligated to uphold?',
        options: [
          'The wife must work to support the family financially',
          'The wife must obey in matters that do not contradict Islamic law',
          'The wife must live with the husband\'s family',
          'The wife must surrender all her wealth to the husband',
        ],
        correctIndex: 1,
        explanation:
            'The wife is obligated to obey her husband in matters that do not contradict the commands of Allah. This obedience does not extend to sinful acts or anything that causes harm to the wife.',
      ),
      QuizQuestion(
        question: 'What is the iddah period for a divorced wife who is not pregnant?',
        options: ['1 month', '2 months', '3 menstrual cycles (quru\')', '6 months'],
        correctIndex: 2,
        explanation:
            'The iddah for a divorced wife who is not pregnant is 3 menstrual cycles (quru\'). This period ensures there is no pregnancy and also provides an opportunity for reconciliation (rujuk).',
      ),
      QuizQuestion(
        question: 'What right does a wife have if her husband fails to provide nafaqah?',
        options: [
          'The wife has no right to seek divorce on this ground',
          'The wife may apply for fasakh through the Syariah court',
          'The wife must wait 3 years before she can apply for divorce',
          'The wife may only obtain khul\' by returning the mahr',
        ],
        correctIndex: 1,
        explanation:
            'If a husband fails to provide nafaqah without a valid reason, the wife has the right to apply for fasakh (dissolution of marriage) through the Syariah court. This is a protective right granted under Islamic law.',
      ),
    ],
  ),
];