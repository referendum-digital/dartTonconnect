import 'package:logger/logger.dart';

String encodeTelegramUrlParameters(String parameters) {
  return parameters
      .replaceAll('.', '%2E')
      .replaceAll('-', '%2D')
      .replaceAll('_', '%5F')
      .replaceAll('&', '-')
      .replaceAll('=', '__')
      .replaceAll('%', '--');
}

bool isTelegramURL(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return (uri.host == "t.me" || uri.scheme == "tg");
}

final logger = Logger();
