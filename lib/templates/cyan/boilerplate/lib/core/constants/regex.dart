final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#])[A-Za-z\d@$!%*?&#.]{8,}$');
final instagramRegex = RegExp(r'^(https?:\/\/)?(www\.)?instagram\.com\/[A-Za-z0-9._%-]+(\/[A-Za-z0-9._%-]+)*(\/)?(\?.*)?$', caseSensitive: false);
final facebookRegEx = RegExp(r'^(https?:\/\/)?(www\.)?(facebook\.com)\/[A-Za-z0-9\.]+(\/[A-Za-z0-9\.]+)*(\/)?(\?.*)?$', caseSensitive: false);
final whatsappRegex = RegExp(r'^(https?:\/\/)?(www\.)?(wa\.me\/\d+|api\.whatsapp\.com\/send\?phone=\d+.*)$', caseSensitive: false);
