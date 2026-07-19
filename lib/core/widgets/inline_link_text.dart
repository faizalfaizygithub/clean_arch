import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class InlineLinkText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final Map<String, VoidCallback> actions;

  const InlineLinkText({
    super.key,
    required this.text,
    required this.actions,
    this.style,
    this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle =
        style ?? theme.textTheme.bodyMedium ?? const TextStyle();
    final defaultLinkStyle = linkStyle ??
        defaultStyle.copyWith(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
        );

    // Regular expression to find patterns like [link text](action_key)
    final regExp = RegExp(r'\[(.*?)\]\((.*?)\)');
    final List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in regExp.allMatches(text)) {
      // Add the text before the link
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: defaultStyle));
      }

      final String linkText = match.group(1)!;
      final String actionKey = match.group(2)!;

      // Add the tappable link text
      spans.add(TextSpan(
        text: linkText,
        style: defaultLinkStyle,
        recognizer: TapGestureRecognizer()..onTap = actions[actionKey],
      ));

      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last link
    if (lastMatchEnd < text.length) {
      spans.add(
          TextSpan(text: text.substring(lastMatchEnd), style: defaultStyle));
    }

    return RichText(text: TextSpan(children: spans));
  }
}

// --- How to Use It ---
// InlineLinkText(
//   text: 'By continuing, you agree to the [Terms of Service](terms) and our [Privacy Policy](privacy).',
//   actions: {
//     'terms': () => print('Navigate to Terms screen'),
//     'privacy': () => print('Navigate to Privacy screen'),
//   },
// )
