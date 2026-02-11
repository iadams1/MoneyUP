import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  final int length;
  
  const OtpInput({
    super.key,
    this.length = 6,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> _codeController;
  late List<FocusNode> _nodes;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _codeController = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _codeController) {
      c.dispose();
    }
    for (final f in _nodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _focusFirst() {
    setState(() {
      _isActive = true;
    });

    for (int i = 0; i < _codeController.length; i++) {
      if (_codeController[i].text.isEmpty) {
        _nodes[0].requestFocus();
        return;
      }
    }
    _nodes.last.requestFocus();
  }

  // void _handleChange(String value, int index) {
  //   setState(() {
  //     _isActive = true;
  //   });

    // if (value.isNotEmpty) {
    //   if (index < widget.length - 1) {
    //     _nodes[index + 1].requestFocus();
    //   }
    // }
    // else {
    //   if (index > 0) {
    //     _nodes[index - 1].requestFocus();
    //   }
    // }
    // final code = _codeController.map((c) => c.text).join();
    // if (code.length == widget.length) {
    //   //
    // }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _focusFirst,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.length, (index) {
          return SizedBox(
            width: 40,
            child: TextFormField(
              controller: _codeController[index],
              focusNode: _nodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                counterText: "",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _isActive ? Colors.transparent : Colors.black),
                  ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              onChanged: (value) {
                if (value.length == _nodes) {
                  //
                }
              },
            ),
          );
        }),
      ),
    );
  }
}