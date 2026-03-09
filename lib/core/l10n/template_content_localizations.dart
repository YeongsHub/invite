import 'package:flutter/material.dart';

/// Provides localized text content for each template element.
///
/// Keys follow the pattern `{templateId}_{elementIndex}`, matching the order
/// of [TemplateElement] entries in `template_data.dart`.
///
/// Usage:
/// ```dart
/// final text = TemplateContentLocalizations.get(
///   'wedding_rose', 0, Locale('ko'));
/// ```
class TemplateContentLocalizations {
  const TemplateContentLocalizations._();

  /// Returns the localized string for [templateId] at [elementIndex].
  ///
  /// Falls back to English when the requested language is unavailable,
  /// and to an empty string when the key itself is missing.
  static String get(String templateId, int elementIndex, Locale locale) {
    final lang = locale.languageCode;
    final key = '${templateId}_$elementIndex';
    return _translations[lang]?[key] ?? _translations['en']![key] ?? '';
  }

  static const Map<String, Map<String, String>> _translations = {
    // ------------------------------------------------------------------ en
    'en': {
      'wedding_rose_0': 'Together We Celebrate',
      'wedding_rose_1': 'Emma & James',
      'wedding_rose_2': 'Saturday, June 14 · 4:00 PM',
      'wedding_rose_3': 'The Grand Pavilion, Lake View',

      'wedding_gold_0': 'You Are Invited',
      'wedding_gold_1': 'Sophia & William',
      'wedding_gold_2': 'Friday, August 22 · 5:30 PM',
      'wedding_gold_3': 'Rose Hall Estate, Hillside',

      'funeral_navy_0': 'In Loving Memory',
      'funeral_navy_1': 'Robert James Henderson',
      'funeral_navy_2': '1942 – 2024',
      'funeral_navy_3': 'Memorial Service · Thursday, March 14',
      'funeral_navy_4': "St. Michael's Chapel, 2:00 PM",

      'funeral_silver_0': 'A Life Well Lived',
      'funeral_silver_1': 'Margaret Anne Collins',
      'funeral_silver_2': '1950 – 2024',
      'funeral_silver_3': 'Celebration of Life · Saturday, April 5',

      'birthday_confetti_0': 'Party Time!',
      'birthday_confetti_1': "You're Invited to Alex's",
      'birthday_confetti_2': '7th Birthday Bash!',
      'birthday_confetti_3': 'Saturday, July 12 · 3:00 PM',
      'birthday_confetti_4': '42 Maple Street, Sunnyside',

      'wedding_minimal_0': 'You Are Cordially Invited',
      'wedding_minimal_1': 'Olivia & Ethan',
      'wedding_minimal_2': 'Saturday, September 20 · 3:00 PM',
      'wedding_minimal_3': 'The White Orchid Ballroom, Maplewood',

      'birthday_coral_0': "Let's Celebrate!",
      'birthday_coral_1': 'Jordan turns 30!',
      'birthday_coral_2': 'Friday, October 3 · 7:00 PM',
      'birthday_coral_3': 'Rooftop Lounge, Downtown',

      'birthday_neon_0': "It's Going Down!",
      'birthday_neon_1': 'Happy Birthday, Sam!',
      'birthday_neon_2': 'Friday, Nov 7 · 8 PM · Club Neon, Downtown',
    },

    // ------------------------------------------------------------------ ko
    'ko': {
      'wedding_rose_0': '함께 축하합니다',
      'wedding_rose_1': '엠마 & 제임스',
      'wedding_rose_2': '토요일, 6월 14일 · 오후 4:00',
      'wedding_rose_3': '그랜드 파빌리온, 레이크 뷰',

      'wedding_gold_0': '청첩장을 드립니다',
      'wedding_gold_1': '소피아 & 윌리엄',
      'wedding_gold_2': '금요일, 8월 22일 · 오후 5:30',
      'wedding_gold_3': '로즈 홀 에스테이트, 힐사이드',

      'funeral_navy_0': '삼가 고인의 명복을 빕니다',
      'funeral_navy_1': '로버트 제임스 헨더슨',
      'funeral_navy_2': '1942 – 2024',
      'funeral_navy_3': '추도식 · 3월 14일 목요일',
      'funeral_navy_4': '성 미카엘 채플, 오후 2:00',

      'funeral_silver_0': '아름다운 삶을 사신 분',
      'funeral_silver_1': '마가렛 앤 콜린스',
      'funeral_silver_2': '1950 – 2024',
      'funeral_silver_3': '추모식 · 4월 5일 토요일',

      'birthday_confetti_0': '파티 시작!',
      'birthday_confetti_1': '알렉스의 생일 파티에 초대합니다',
      'birthday_confetti_2': '7번째 생일 축하해요!',
      'birthday_confetti_3': '토요일, 7월 12일 · 오후 3:00',
      'birthday_confetti_4': '써니사이드 메이플 가 42번지',

      'wedding_minimal_0': '정중히 초대합니다',
      'wedding_minimal_1': '올리비아 & 이단',
      'wedding_minimal_2': '토요일, 9월 20일 · 오후 3:00',
      'wedding_minimal_3': '화이트 오키드 볼룸, 메이플우드',

      'birthday_coral_0': '함께 축하해요!',
      'birthday_coral_1': '조던의 30번째 생일!',
      'birthday_coral_2': '금요일, 10월 3일 · 오후 7:00',
      'birthday_coral_3': '루프탑 라운지, 다운타운',

      'birthday_neon_0': '파티가 시작됩니다!',
      'birthday_neon_1': '생일 축하해, 샘!',
      'birthday_neon_2': '금요일, 11월 7일 · 오후 8시 · 클럽 네온, 다운타운',
    },

    // ------------------------------------------------------------------ ja
    'ja': {
      'wedding_rose_0': 'ご結婚のお祝いに',
      'wedding_rose_1': 'エマ & ジェームズ',
      'wedding_rose_2': '6月14日（土）午後4:00',
      'wedding_rose_3': 'グランドパビリオン・レイクビュー',

      'wedding_gold_0': 'ご招待申し上げます',
      'wedding_gold_1': 'ソフィア & ウィリアム',
      'wedding_gold_2': '8月22日（金）午後5:30',
      'wedding_gold_3': 'ローズホールエステート・ヒルサイド',

      'funeral_navy_0': '謹んでご冥福をお祈りします',
      'funeral_navy_1': 'ロバート・ジェームズ・ヘンダーソン',
      'funeral_navy_2': '1942 – 2024',
      'funeral_navy_3': '追悼式 · 3月14日（木）',
      'funeral_navy_4': '聖ミカエル礼拝堂、午後2:00',

      'funeral_silver_0': 'その生涯に感謝を込めて',
      'funeral_silver_1': 'マーガレット・アン・コリンズ',
      'funeral_silver_2': '1950 – 2024',
      'funeral_silver_3': '偲ぶ会 · 4月5日（土）',

      'birthday_confetti_0': 'パーティーの時間！',
      'birthday_confetti_1': 'アレックスの誕生日パーティーへようこそ',
      'birthday_confetti_2': '7歳のお誕生日おめでとう！',
      'birthday_confetti_3': '7月12日（土）午後3:00',
      'birthday_confetti_4': 'サニーサイド、メープルストリート42番地',

      'wedding_minimal_0': '謹んでご招待申し上げます',
      'wedding_minimal_1': 'オリビア & イーサン',
      'wedding_minimal_2': '9月20日（土）午後3:00',
      'wedding_minimal_3': 'ホワイトオーキッドボールルーム・メープルウッド',

      'birthday_coral_0': '一緒にお祝いしましょう！',
      'birthday_coral_1': 'ジョーダン、30歳のお誕生日！',
      'birthday_coral_2': '10月3日（金）午後7:00',
      'birthday_coral_3': 'ルーフトップラウンジ・ダウンタウン',

      'birthday_neon_0': 'パーティー開幕！',
      'birthday_neon_1': 'お誕生日おめでとう、サム！',
      'birthday_neon_2': '11月7日（金）午後8時・クラブネオン・ダウンタウン',
    },

    // ------------------------------------------------------------------ zh
    'zh': {
      'wedding_rose_0': '共同庆祝这美好时刻',
      'wedding_rose_1': '艾玛 & 詹姆斯',
      'wedding_rose_2': '6月14日（周六）· 下午4:00',
      'wedding_rose_3': '大型宴会厅，湖景',

      'wedding_gold_0': '诚邀您出席',
      'wedding_gold_1': '索菲亚 & 威廉',
      'wedding_gold_2': '8月22日（周五）· 下午5:30',
      'wedding_gold_3': '玫瑰庄园，山坡',

      'funeral_navy_0': '深切悼念',
      'funeral_navy_1': '罗伯特·詹姆斯·亨德森',
      'funeral_navy_2': '1942 – 2024',
      'funeral_navy_3': '追悼会 · 3月14日（周四）',
      'funeral_navy_4': '圣迈克尔教堂，下午2:00',

      'funeral_silver_0': '一生精彩，永远铭记',
      'funeral_silver_1': '玛格丽特·安·柯林斯',
      'funeral_silver_2': '1950 – 2024',
      'funeral_silver_3': '生命追思会 · 4月5日（周六）',

      'birthday_confetti_0': '派对时间！',
      'birthday_confetti_1': '诚邀您参加Alex的',
      'birthday_confetti_2': '7岁生日派对！',
      'birthday_confetti_3': '7月12日（周六）· 下午3:00',
      'birthday_confetti_4': '阳光区枫树街42号',

      'wedding_minimal_0': '诚挚邀请您出席',
      'wedding_minimal_1': '奥利维亚 & 伊森',
      'wedding_minimal_2': '9月20日（周六）· 下午3:00',
      'wedding_minimal_3': '白兰花宴会厅，枫木园',

      'birthday_coral_0': '一起来庆祝！',
      'birthday_coral_1': 'Jordan 30岁生日快乐！',
      'birthday_coral_2': '10月3日（周五）· 晚上7:00',
      'birthday_coral_3': '屋顶酒廊，市中心',

      'birthday_neon_0': '派对开始了！',
      'birthday_neon_1': '生日快乐，Sam！',
      'birthday_neon_2': '11月7日（周五）· 晚8点 · 霓虹夜店，市中心',
    },

    // ------------------------------------------------------------------ fr
    'fr': {
      'wedding_rose_0': 'Célébrons ensemble',
      'wedding_rose_1': 'Emma & James',
      'wedding_rose_2': 'Samedi 14 juin · 16h00',
      'wedding_rose_3': 'Le Grand Pavillon, Vue sur le Lac',

      'wedding_gold_0': 'Vous êtes invité',
      'wedding_gold_1': 'Sophia & William',
      'wedding_gold_2': 'Vendredi 22 août · 17h30',
      'wedding_gold_3': 'Domaine Rose Hall, Hillside',

      'funeral_navy_0': 'En chère mémoire',
      'funeral_navy_1': 'Robert James Henderson',
      'funeral_navy_2': '1942 – 2024',
      'funeral_navy_3': 'Cérémonie commémorative · Jeudi 14 mars',
      'funeral_navy_4': 'Chapelle Saint-Michel, 14h00',

      'funeral_silver_0': 'Une vie bien vécue',
      'funeral_silver_1': 'Margaret Anne Collins',
      'funeral_silver_2': '1950 – 2024',
      'funeral_silver_3': 'Célébration de vie · Samedi 5 avril',

      'birthday_confetti_0': "C'est la fête !",
      'birthday_confetti_1': "Vous êtes invité à la fête d'Alex",
      'birthday_confetti_2': '7e anniversaire !',
      'birthday_confetti_3': 'Samedi 12 juillet · 15h00',
      'birthday_confetti_4': '42 rue des Érables, Sunnyside',

      'wedding_minimal_0': 'Vous êtes cordialement invité',
      'wedding_minimal_1': 'Olivia & Ethan',
      'wedding_minimal_2': 'Samedi 20 septembre · 15h00',
      'wedding_minimal_3': 'La Salle de Bal Orchidée Blanche, Maplewood',

      'birthday_coral_0': 'Venez fêter ça !',
      'birthday_coral_1': 'Jordan fête ses 30 ans !',
      'birthday_coral_2': 'Vendredi 3 octobre · 19h00',
      'birthday_coral_3': 'Rooftop Lounge, Centre-ville',

      'birthday_neon_0': 'La fête commence !',
      'birthday_neon_1': 'Joyeux anniversaire, Sam !',
      'birthday_neon_2': 'Vendredi 7 nov · 20h · Club Neon, Centre-ville',
    },

    // ------------------------------------------------------------------ es
    'es': {
      'wedding_rose_0': 'Celebremos juntos',
      'wedding_rose_1': 'Emma & James',
      'wedding_rose_2': 'Sábado, 14 de junio · 4:00 PM',
      'wedding_rose_3': 'El Gran Pabellón, Vista al Lago',

      'wedding_gold_0': 'Estás invitado',
      'wedding_gold_1': 'Sophia & William',
      'wedding_gold_2': 'Viernes, 22 de agosto · 5:30 PM',
      'wedding_gold_3': 'Hacienda Rose Hall, Hillside',

      'funeral_navy_0': 'En amorosa memoria',
      'funeral_navy_1': 'Robert James Henderson',
      'funeral_navy_2': '1942 – 2024',
      'funeral_navy_3': 'Servicio memorial · Jueves, 14 de marzo',
      'funeral_navy_4': 'Capilla San Miguel, 2:00 PM',

      'funeral_silver_0': 'Una vida bien vivida',
      'funeral_silver_1': 'Margaret Anne Collins',
      'funeral_silver_2': '1950 – 2024',
      'funeral_silver_3': 'Celebración de vida · Sábado, 5 de abril',

      'birthday_confetti_0': '¡Es hora de la fiesta!',
      'birthday_confetti_1': 'Estás invitado a la fiesta de Alex',
      'birthday_confetti_2': '¡7.º cumpleaños!',
      'birthday_confetti_3': 'Sábado, 12 de julio · 3:00 PM',
      'birthday_confetti_4': 'Calle Maple 42, Sunnyside',

      'wedding_minimal_0': 'Tienes el honor de ser invitado',
      'wedding_minimal_1': 'Olivia & Ethan',
      'wedding_minimal_2': 'Sábado, 20 de septiembre · 3:00 PM',
      'wedding_minimal_3': 'Salón Orquídea Blanca, Maplewood',

      'birthday_coral_0': '¡Vamos a celebrar!',
      'birthday_coral_1': '¡Jordan cumple 30 años!',
      'birthday_coral_2': 'Viernes, 3 de octubre · 7:00 PM',
      'birthday_coral_3': 'Rooftop Lounge, Centro',

      'birthday_neon_0': '¡La fiesta empieza ya!',
      'birthday_neon_1': '¡Feliz cumpleaños, Sam!',
      'birthday_neon_2': 'Viernes, 7 nov · 8 PM · Club Neon, Centro',
    },

    // ------------------------------------------------------------------ ar
    'ar': {
      'wedding_rose_0': 'نحتفل معاً بهذه المناسبة السعيدة',
      'wedding_rose_1': 'إيما & جيمس',
      'wedding_rose_2': 'السبت، 14 يونيو · 4:00 مساءً',
      'wedding_rose_3': 'قاعة غراند بافيليون، إطلالة البحيرة',

      'wedding_gold_0': 'يسعدنا دعوتكم',
      'wedding_gold_1': 'صوفيا & ويليام',
      'wedding_gold_2': 'الجمعة، 22 أغسطس · 5:30 مساءً',
      'wedding_gold_3': 'قصر روز هول، هيلسايد',

      'funeral_navy_0': 'في ذكرى عطرة',
      'funeral_navy_1': 'روبرت جيمس هندرسون',
      'funeral_navy_2': '1942 – 2024',
      'funeral_navy_3': 'مراسم العزاء · الخميس، 14 مارس',
      'funeral_navy_4': 'كنيسة القديس ميخائيل، 2:00 مساءً',

      'funeral_silver_0': 'حياة حافلة بالعطاء',
      'funeral_silver_1': 'مارغريت آن كولينز',
      'funeral_silver_2': '1950 – 2024',
      'funeral_silver_3': 'تكريم الذكرى · السبت، 5 أبريل',

      'birthday_confetti_0': 'حفلة الآن!',
      'birthday_confetti_1': 'مدعوون لحفل عيد ميلاد أليكس',
      'birthday_confetti_2': 'الاحتفال بعيد الميلاد السابع!',
      'birthday_confetti_3': 'السبت، 12 يوليو · 3:00 مساءً',
      'birthday_confetti_4': 'شارع مابل 42، سانيسايد',

      'wedding_minimal_0': 'نتشرف بدعوتكم',
      'wedding_minimal_1': 'أوليفيا & إيثان',
      'wedding_minimal_2': 'السبت، 20 سبتمبر · 3:00 مساءً',
      'wedding_minimal_3': 'قاعة وايت أوركيد، مابلوود',

      'birthday_coral_0': 'هيا نحتفل!',
      'birthday_coral_1': 'جوردان يتم الثلاثين!',
      'birthday_coral_2': 'الجمعة، 3 أكتوبر · 7:00 مساءً',
      'birthday_coral_3': 'روفتوب لاونج، وسط المدينة',

      'birthday_neon_0': 'الحفلة على وشك البدء!',
      'birthday_neon_1': 'عيد ميلاد سعيد يا سام!',
      'birthday_neon_2': 'الجمعة، 7 نوف · 8 مساءً · كلوب نيون، وسط المدينة',
    },
  };
}
