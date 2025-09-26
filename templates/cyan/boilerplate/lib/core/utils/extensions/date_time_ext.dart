part of '../extensions.dart';

extension UtcToLocal on DateTime {
  String format(String format) {
    return DateFormat(format).format(this);
  }

  String get timeOnly {
    return DateFormat('h:mm a').format(this);
  }

  String get easyReadableDate {
    return DateFormat("EEEE, MMM d").format(this);
  }

  DateTime get cleaned {
    return copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  String get tryDayOfWeek {
    final now = DateTime.now();
    if (DateUtils.isSameDay(this, now)) return "Today";
    if (DateUtils.isSameDay(this, now.add(const Duration(days: 1)))) return "Tomorrow";
    if (DateUtils.isSameDay(this, now.subtract(const Duration(days: 1)))) return "Yesterday";
    return DateFormat('dd MMM').format(this);
  }

  TimeOfDay get toTimeOfDay {
    return TimeOfDay(hour: hour, minute: minute);
  }

  String get dateOnly => DateFormat('dd/MM/yyyy').format(this);

  String get dayDateTime => DateFormat('EEEE, MMM d | h:mm a').format(this);

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return 'Just now';
    }

    if (diff.inMinutes == 1) {
      return '1 minute ago';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    }

    if (diff.inHours == 1) {
      return '1 hour ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    }

    if (diff.inDays == 1) {
      return '1 day ago';
    }

    if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    }

    if (diff.inDays == 7) {
      return '1 week ago';
    }

    if (diff.inDays < 30) {
      return '${diff.inDays ~/ 7} weeks ago';
    }

    if (diff.inDays > 30 && diff.inDays < 60) {
      return '1 month ago';
    }

    if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30} months ago';
    }

    return '${diff.inDays ~/ 365} years ago';
  }

  int get differenceInSecondsFromNow {
    return difference(DateTime.now()).inSeconds;
  }
}
