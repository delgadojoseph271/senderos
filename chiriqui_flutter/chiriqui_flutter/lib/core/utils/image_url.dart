String? rasterImageUrl(String? url) {
  if (url == null || url.isEmpty) return url;
  if (!url.contains('placehold.co/')) return url;
  if (RegExp(r'\.(png|jpe?g|gif|webp|avif)(\?|$)', caseSensitive: false).hasMatch(url)) {
    return url;
  }

  final parts = url.split('?');
  final base = '${parts.first}.png';
  return parts.length > 1 ? '$base?${parts[1]}' : base;
}
