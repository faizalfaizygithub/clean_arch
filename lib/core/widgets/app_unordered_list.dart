import 'package:flutter/material.dart';

enum SymbolType { bullet, numbered, custom }

/// Add AppUnorderedList to its children
class AppUnorderedList extends StatelessWidget {
  const AppUnorderedList({
    this.children,
    this.padding = 8,
    this.spacing = 8,
    this.symbolType = SymbolType.bullet,
    this.symbolColor,
    this.textColor,
    this.customSymbol,
    this.edgeInsets,
    this.symbolCrossAxisAlignment,
    super.key,
  });

  final List<Widget>? children;
  final double padding;
  final double spacing;
  final SymbolType symbolType;
  final Color? symbolColor;
  final Color? textColor;
  final EdgeInsets? edgeInsets;
  final Widget? customSymbol;
  final CrossAxisAlignment? symbolCrossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children?.length ?? 0, (index) {
        return Padding(
          padding: edgeInsets ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment:
                symbolCrossAxisAlignment ?? CrossAxisAlignment.start,
            children: [
              symbolWidget(index),
              SizedBox(width: padding),
              Expanded(
                child: children?[index] ?? const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Returns a symbol widget
  Widget symbolWidget(int index) {
    if (symbolType == SymbolType.numbered && customSymbol != null) {
      return customSymbol!;
    } else if (symbolType == SymbolType.bullet) {
      return Text(
        '•',
        style: TextStyle(
          color: symbolColor,
          //size: 24,
        ),
      );
    } else if (symbolType == SymbolType.numbered) {
      return Text(
        '${index + 1}.',
        style: TextStyle(
          color: symbolColor,
        ),
      );
    }

    return const Offstage();
  }
}
