String getArabicFormattedDate() {
  final now = DateTime.now();

  const days = ["الاثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت", "الأحد"];
  const months = [
    "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
  ];

  String dayName = days[now.weekday - 1];
  String monthName = months[now.month - 1];

  return "$dayName، ${now.day} $monthName ${now.year}";
}