import 'package:flutter/widgets.dart';

class FormStateBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool canSubmit) builder;
  final Widget child;

  const FormStateBuilder({
    super.key,
    required this.builder,
    required this.child,
  });

  @override
  State<FormStateBuilder> createState() => _FormStateBuilderState();
}

class _FormStateBuilderState extends State<FormStateBuilder> {
  final _formKey = GlobalKey<FormState>();
  bool _isDirty = false;
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        final wasValid = _isValid;
        final isValidNow = _formKey.currentState?.validate() ?? false;

        if (!_isDirty || wasValid != isValidNow) {
          setState(() {
            _isDirty = true;
            _isValid = isValidNow;
          });
        }
      },
      child: Column(
        children: [
          widget.child,
          widget.builder(context, _isDirty && _isValid),
        ],
      ),
    );
  }
}
