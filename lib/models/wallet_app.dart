class WalletApp {
  final String appName;
  final String name;
  final String? bridgeUrl;
  final String image;
  final String? universalUrl;
  final String aboutUrl;

  const WalletApp({
    required this.appName,
    required this.name,
    required this.bridgeUrl,
    required this.image,
    required this.aboutUrl,
    this.universalUrl,
  });

  factory WalletApp.fromMap(Map<String, dynamic> json) {
    String? bridgeUrl = json.containsKey('bridge_url')
        ? json['bridge_url']
        : (json.containsKey('bridge')
            ? (json['bridge'] as List).firstWhere(
                (bridge) => bridge['type'] == 'sse',
                orElse: () => {'url': null})['url']
            : null);

    return WalletApp(
      appName: json['app_name'],
      name: json['name'].toString(),
      image: json['image'].toString(),
      bridgeUrl: bridgeUrl,
      aboutUrl: json['about_url'].toString(),
      universalUrl: json.containsKey('universal_url')
          ? json['universal_url'].toString()
          : null,
    );
  }

  @override
  String toString() {
    return 'WalletApp{name: $name, bridgeUrl: $bridgeUrl, image: $image, universalUrl: $universalUrl, aboutUrl: $aboutUrl}';
  }
}
