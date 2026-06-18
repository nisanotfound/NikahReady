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
    return 'Perlu Peningkatan (Needs Improvement)';
  }
}

// ─── Question Bank ────────────────────────────────────────────────────────────

final List<QuizTopic> quizTopics = [
  QuizTopic(
    id: 'syarat_nikah',
    title: 'Syarat Nikah',
    subtitle: 'Rukun & syarat sah perkahwinan',
    icon: '📜',
    questions: [
      QuizQuestion(
        question: 'Berapakah bilangan rukun nikah yang wajib dipenuhi dalam Islam?',
        options: ['3 rukun', '4 rukun', '5 rukun', '6 rukun'],
        correctIndex: 2,
        explanation:
            'Terdapat 5 rukun nikah: calon suami, calon isteri, wali, dua orang saksi, dan ijab qabul. Kesemua rukun ini mesti dipenuhi untuk sah sesuatu akad nikah.',
      ),
      QuizQuestion(
        question: 'Apakah syarat utama bagi calon isteri dalam akad nikah?',
        options: [
          'Mesti berumur 18 tahun ke atas',
          'Mesti seorang Islam, bukan mahram, dan tidak dalam iddah',
          'Mesti mendapat kebenaran majikan',
          'Mesti memiliki harta sendiri',
        ],
        correctIndex: 1,
        explanation:
            'Calon isteri mestilah seorang Islam, bukan mahram kepada calon suami, dan tidak sedang dalam tempoh iddah perkahwinan terdahulu.',
      ),
      QuizQuestion(
        question: 'Siapakah yang tidak boleh menjadi wali nikah?',
        options: [
          'Bapa kandung',
          'Datuk sebelah bapa',
          'Abang kandung',
          'Bapa saudara sebelah ibu',
        ],
        correctIndex: 3,
        explanation:
            'Wali nikah hanya boleh dari kalangan keluarga sebelah bapa (nasab patrilineal). Bapa saudara sebelah ibu tidak termasuk dalam urutan wali nikah.',
      ),
      QuizQuestion(
        question: 'Apakah yang dimaksudkan dengan "ijab" dalam akad nikah?',
        options: [
          'Ucapan penerimaan oleh pengantin lelaki',
          'Ucapan penyerahan oleh wali pihak perempuan',
          'Doa yang dibaca oleh imam',
          'Pemberian mas kahwin',
        ],
        correctIndex: 1,
        explanation:
            'Ijab ialah lafaz yang diucapkan oleh wali pihak perempuan untuk menyerahkan/menawarkan perkahwinan. Qabul pula ialah lafaz penerimaan oleh pengantin lelaki.',
      ),
      QuizQuestion(
        question: 'Berapakah bilangan minimum saksi yang diperlukan untuk sah akad nikah?',
        options: ['1 orang', '2 orang', '3 orang', '4 orang'],
        correctIndex: 1,
        explanation:
            'Akad nikah memerlukan sekurang-kurangnya 2 orang saksi lelaki yang Islam, baligh, berakal, dan adil. Tanpa saksi, akad nikah tidak sah.',
      ),
    ],
  ),

  QuizTopic(
    id: 'wali_saksi',
    title: 'Wali & Saksi',
    subtitle: 'Peranan wali dan syarat saksi',
    icon: '🤝',
    questions: [
      QuizQuestion(
        question: 'Apakah urutan wali yang pertama sekali dalam perkahwinan Islam?',
        options: ['Datuk', 'Bapa', 'Abang', 'Hakim'],
        correctIndex: 1,
        explanation:
            'Bapa kandung ialah wali yang paling utama (wali aqrab). Urutan selepasnya: datuk sebelah bapa, abang/adik lelaki, bapa saudara sebelah bapa, dan seterusnya.',
      ),
      QuizQuestion(
        question: 'Bilakah wali hakim boleh menggantikan wali nasab?',
        options: [
          'Apabila wali nasab meminta bayaran',
          'Apabila wali nasab tiada, enggan, atau tidak layak',
          'Apabila pengantin perempuan tidak suka wali nasab',
          'Apabila majlis diadakan di luar negara',
        ],
        correctIndex: 1,
        explanation:
            'Wali hakim (biasanya Kadi) boleh bertindak sebagai wali apabila wali nasab tiada, telah meninggal dunia, enggan berkerjasama tanpa sebab munasabah (adhal), atau tidak memenuhi syarat menjadi wali.',
      ),
      QuizQuestion(
        question: 'Apakah syarat yang TIDAK diperlukan daripada saksi nikah?',
        options: ['Islam', 'Baligh', 'Lelaki', 'Bujang'],
        correctIndex: 3,
        explanation:
            'Syarat saksi nikah ialah Islam, baligh, berakal, lelaki, merdeka, dan adil. Status perkahwinan (bujang atau sudah berkahwin) tidak menjadi syarat.',
      ),
      QuizQuestion(
        question: 'Apakah hukum nikah tanpa kebenaran wali bagi perempuan yang mempunyai wali?',
        options: [
          'Sah tetapi makruh',
          'Sah dengan syarat tertentu',
          'Tidak sah (batal)',
          'Hukumnya bergantung kepada negeri',
        ],
        correctIndex: 2,
        explanation:
            'Mengikut mazhab Syafii (yang dipakai di Malaysia), nikah tanpa wali adalah tidak sah dan batal. Ini berdasarkan hadis: "Tidak sah nikah melainkan dengan wali."',
      ),
      QuizQuestion(
        question: 'Adakah seorang perempuan boleh menjadi saksi dalam akad nikah?',
        options: [
          'Ya, boleh sepenuhnya',
          'Ya, jika tiada saksi lelaki',
          'Tidak, saksi mesti lelaki',
          'Ya, jika mendapat kebenaran kadi',
        ],
        correctIndex: 2,
        explanation:
            'Mengikut mazhab Syafii, saksi nikah mestilah terdiri daripada lelaki. Wanita tidak boleh menjadi saksi dalam akad nikah walaupun dalam keadaan darurat.',
      ),
    ],
  ),

  QuizTopic(
    id: 'hak_suami_isteri',
    title: 'Hak Suami & Isteri',
    subtitle: 'Hak & tanggungjawab selepas berkahwin',
    icon: '⚖️',
    questions: [
      QuizQuestion(
        question: 'Apakah kewajipan utama suami terhadap isteri dari segi kewangan?',
        options: [
          'Memberi mas kahwin sahaja',
          'Membayar nafkah (makan, pakai, tempat tinggal)',
          'Membuka akaun bank bersama',
          'Membayar semua hutang isteri',
        ],
        correctIndex: 1,
        explanation:
            'Suami wajib memberi nafkah kepada isteri merangkumi keperluan makanan, pakaian, dan tempat tinggal yang bersesuaian dengan kemampuan suami. Ini adalah hak isteri yang dijamin oleh syarak.',
      ),
      QuizQuestion(
        question: 'Apakah hak isteri berkenaan mas kahwin (mahr)?',
        options: [
          'Mas kahwin hanya perlu dibayar jika isteri meminta',
          'Mas kahwin adalah hak mutlak isteri dan menjadi miliknya sepenuhnya',
          'Mas kahwin boleh diambil semula oleh suami jika berlaku perceraian',
          'Mas kahwin hanya simbol dan tidak wajib dibayar',
        ],
        correctIndex: 1,
        explanation:
            'Mas kahwin (mahr) adalah hak mutlak isteri. Ia menjadi milik isteri sepenuhnya dan tidak boleh diambil semula oleh suami melainkan isteri menghadiahkannya dengan rela hati.',
      ),
      QuizQuestion(
        question: 'Apakah hak suami yang wajib ditaati oleh isteri?',
        options: [
          'Isteri wajib bekerja untuk membantu kewangan keluarga',
          'Isteri wajib taat dalam perkara yang tidak melanggar hukum syarak',
          'Isteri wajib tinggal bersama keluarga suami',
          'Isteri wajib menyerahkan semua harta kepada suami',
        ],
        correctIndex: 1,
        explanation:
            'Isteri wajib taat kepada suami dalam perkara yang tidak bertentangan dengan hukum Allah. Ketaatan ini tidak meliputi perkara maksiat atau yang memudaratkan diri isteri.',
      ),
      QuizQuestion(
        question: 'Berapakah tempoh iddah bagi isteri yang diceraikan dan belum hamil?',
        options: ['1 bulan', '2 bulan', '3 kali suci (quru\')', '6 bulan'],
        correctIndex: 2,
        explanation:
            'Tempoh iddah bagi isteri yang diceraikan dan tidak hamil ialah 3 kali suci (quru\'). Ini memberi masa untuk memastikan tiada kehamilan dan memberi peluang rujuk.',
      ),
      QuizQuestion(
        question: 'Apakah hak isteri untuk mendapatkan cerai jika suami gagal memberi nafkah?',
        options: [
          'Isteri tiada hak untuk menuntut cerai atas alasan ini',
          'Isteri boleh menuntut fasakh melalui mahkamah syariah',
          'Isteri mesti tunggu 3 tahun sebelum boleh menuntut cerai',
          'Isteri hanya boleh mendapat khul\' dengan mengembalikan mas kahwin',
        ],
        correctIndex: 1,
        explanation:
            'Jika suami gagal memberi nafkah tanpa sebab yang sah, isteri berhak menuntut fasakh (pembubaran nikah) melalui mahkamah syariah. Ini adalah hak perlindungan yang diberikan oleh undang-undang Islam.',
      ),
    ],
  ),
];