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
  late TextEditingController _codeController;
  late FocusNode _nodes;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _codeController =  TextEditingController();
    _nodes = FocusNode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nodes.dispose();
    super.dispose();
  }

  void _focusInput() {
    setState(() {
      _isActive = true;
    });

    _nodes.requestFocus();
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
      onTap: _focusInput,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _codeController,
              focusNode: _nodes,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.length, (index) {
              String digit = '';
              if (index < _codeController.text.length) {
                digit = _codeController.text[index];
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        digit,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Container(
                    width: 40,
                    height: 2,
                    color: _isActive
                    ? Colors.transparent
                    : Colors.black,
                  ),
                ],
              );
              // return SizedBox(
              //   width: 40,
              //   child: TextFormField(
              //     controller: _codeController[index],
              //     focusNode: _nodes[index],
              //     keyboardType: TextInputType.number,
              //     textAlign: TextAlign.center,
              //     maxLength: 1,
              //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //     style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     decoration: InputDecoration(
              //       counterText: "",
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: _isActive ? Colors.transparent : Colors.black),
              //         ),
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.transparent),
              //       ),
              //     ),
              //     onChanged: (value) {
              //       if (value.length == _nodes) {
              //         //
              //       }
              //     },
              //   ),
              // );
            }),
          ),
        ],
      ),
    );
  }
}