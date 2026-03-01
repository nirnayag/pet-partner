import 'package:intl/intl.dart';

/// Centralised date/time formatting utilities.
class AppDateUtils {
  /// "Feb 27, 2026"
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  /// "2:30 PM"
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// "Feb 27, 2026 at 2:30 PM"
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} at '
        '${formatTime(date)}';
  }

  /// "2:30 PM - 3:00 PM"
  static String formatTimeRange(
    DateTime start,
    DateTime end,
  ) {
    return '${formatTime(start)} - '
        '${formatTime(end)}';
  }

  /// "2 years 3 months" (for pet age).
  static String calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    var years = now.year - dateOfBirth.year;
    var months = now.month - dateOfBirth.month;

    if (now.day < dateOfBirth.day) {
      months--;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    if (years > 0 && months > 0) {
      return '$years ${years == 1 ? 'year' : 'years'} '
          '$months ${months == 1 ? 'month' : 'months'}';
    } else if (years > 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    } else if (months > 0) {
      return '$months '
          '${months == 1 ? 'month' : 'months'}';
    }

    final days = now.difference(dateOfBirth).inDays;
    if (days > 0) {
      return '$days ${days == 1 ? 'day' : 'days'}';
    }
    return 'Newborn';
  }

  /// "Today", "Tomorrow", "Yesterday", or formatted.
  static String friendlyDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final target = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return formatDate(date);
  }

  /// "3 hours ago", "2 days ago" (relative time).
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return '$years '
          '${years == 1 ? 'year' : 'years'} ago';
    }
    if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return '$months '
          '${months == 1 ? 'month' : 'months'} ago';
    }
    if (diff.inDays > 0) {
      return '${diff.inDays} '
          '${diff.inDays == 1 ? 'day' : 'days'} ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours} '
          '${diff.inHours == 1 ? 'hour' : 'hours'} '
          'ago';
    }
    if (diff.inMinutes > 0) {
      return '${diff.inMinutes} '
          '${diff.inMinutes == 1 ? 'minute' : 'minutes'}'
          ' ago';
    }
    return 'Just now';
  }

  /// "In 2 days", "In 3 hours" (upcoming).
  static String timeUntil(DateTime date) {
    final diff = date.difference(DateTime.now());

    if (diff.isNegative) return timeAgo(date);

    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return 'In $years '
          '${years == 1 ? 'year' : 'years'}';
    }
    if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return 'In $months '
          '${months == 1 ? 'month' : 'months'}';
    }
    if (diff.inDays > 0) {
      return 'In ${diff.inDays} '
          '${diff.inDays == 1 ? 'day' : 'days'}';
    }
    if (diff.inHours > 0) {
      return 'In ${diff.inHours} '
          '${diff.inHours == 1 ? 'hour' : 'hours'}';
    }
    if (diff.inMinutes > 0) {
      return 'In ${diff.inMinutes} '
          '${diff.inMinutes == 1 ? 'minute' : 'minutes'}';
    }
    return 'Now';
  }
}
