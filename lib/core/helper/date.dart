String formatDate(String dateString) {
  try {
    String cleanedDate = dateString.replaceAll(RegExp(r'[^\d\s:-]'), '');

    DateTime? dateTime;

    if (cleanedDate.contains('-') && cleanedDate.contains(':')) {
      try {
        dateTime = DateTime.parse(cleanedDate);
      } catch (e) {
        final parts = cleanedDate.split(' ');
        if (parts.length >= 2) {
          final datePart = parts[0].split('-');
          final timePart = parts[1].split(':');

          if (datePart.length == 3 && timePart.length >= 2) {
            dateTime = DateTime(
              int.parse(datePart[0]),
              int.parse(datePart[1]),
              int.parse(datePart[2]),
              int.parse(timePart[0]),
              int.parse(timePart[1]),
              timePart.length > 2 ? int.parse(timePart[2]) : 0,
            );
          }
        }
      }
    }

    if (dateTime != null) {
      final localDate = dateTime.toLocal();

      final days = [
        'Minggu',
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu'
      ];
      final months = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];

      final dayName = days[localDate.weekday % 7];
      final monthName = months[localDate.month];

      return '$dayName, ${localDate.day.toString().padLeft(2, '0')} $monthName ${localDate.year} - ${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
    }

    return cleanedDate.isNotEmpty ? cleanedDate : dateString;
  } catch (e) {
    return dateString.replaceAll(RegExp(r'[^\d\s:-]'), '').trim();
  }
}
