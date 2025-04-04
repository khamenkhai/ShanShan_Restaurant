import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';

class NumberButtons extends StatefulWidget {
  const NumberButtons({
    super.key,
    required this.numberController,
    this.gridHeight = 80,
    this.numberFontSize = 16,
    this.isForDialog = false,
    this.defaultText = "",
    required this.fullWidth,
    this.formatNumber = false,
    required this.enterClick,
  });
  final TextEditingController numberController;
  final double gridHeight;
  final double numberFontSize;
  final bool isForDialog;
  final bool formatNumber;
  final double fullWidth;
  final String defaultText;
  final Function() enterClick;

  @override
  State<NumberButtons> createState() => _NumberButtonsState();
}

class _NumberButtonsState extends State<NumberButtons> {
  @override
  Widget build(BuildContext context) {
    return _customNumberButtons(widget.fullWidth);
  }

  Widget _customNumberButtons(double screenSize) {
    return LayoutBuilder(builder: (context, constraint) {
      double totalButtonWidth = 4 * (screenSize / 4.2);

      double spaceBetweenButtonsRaw = constraint.maxWidth - totalButtonWidth;

      double spaceBetweenButtons = spaceBetweenButtonsRaw / 3;

      return Column(
        children: [
          Container(
            width: screenSize,
            padding: EdgeInsets.only(top: 15, bottom: 15, right: 30, left: 20),
            margin: EdgeInsets.only(
              top: SizeConst.kHorizontalPadding,
              bottom: SizeConst.kHorizontalPadding - 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: SizeConst.kBorderRadius,
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: Text(
              widget.numberController.text == ""
                  ? "${widget.defaultText}"
                  : widget.formatNumber
                      ? NumberFormat('#,##0')
                          .format(int.parse(widget.numberController.text))
                      : "${widget.numberController.text}",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          ///first row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 1);
                },
                child: Text(
                  "1",
                  style: TextStyle(
                    fontSize: widget.numberFontSize,
                    color: Colors.black,
                  ),
                ),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 2);
                },
                child: Text(
                  "2",
                  style: TextStyle(
                      fontSize: widget.numberFontSize, color: Colors.black),
                ),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 3);
                },
                child: Text("3",
                    style: TextStyle(
                        fontSize: widget.numberFontSize, color: Colors.black)),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  String currentText = widget.numberController.text;
                  if (currentText.isNotEmpty) {
                    String newText =
                        currentText.substring(0, currentText.length - 1);
                    widget.numberController.text = newText;
                    widget.numberController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                        offset: newText.length,
                      ),
                    );
                  }
                  setState(() {});
                },
                child: Icon(
                  Icons.backspace,
                  size: SizeConst.kHorizontalPadding,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          ///secon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 4);
                },
                child: Text("4",
                    style: TextStyle(
                        fontSize: widget.numberFontSize, color: Colors.black)),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 5);
                },
                child: Text("5",
                    style: TextStyle(
                        fontSize: widget.numberFontSize, color: Colors.black)),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 6);
                },
                child: Text(
                  "6",
                  style: TextStyle(
                    fontSize: widget.numberFontSize,
                    color: Colors.black,
                  ),
                ),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  if (widget.numberController.text.length <= 15) {
                    String barCode = widget.numberController.text;
                    widget.numberController.text = "${barCode}000";
                    setState(() {});
                  }
                },
                child: Text(
                  "000",
                  style: TextStyle(
                    fontSize: widget.numberFontSize,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          ///third row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 7);
                },
                child: Text(
                  "7",
                  style: TextStyle(
                      fontSize: widget.numberFontSize, color: Colors.black),
                ),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 8);
                },
                child: Text(
                  "8",
                  style: TextStyle(
                    fontSize: widget.numberFontSize,
                    color: Colors.black,
                  ),
                ),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  addNumber(numberAmount: 9);
                },
                child: Text("9",
                    style: TextStyle(
                        fontSize: widget.numberFontSize, color: Colors.black)),
              ),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  if (widget.numberController.text.length <= 15) {
                    String barCode = widget.numberController.text;
                    widget.numberController.text = "${barCode}00";
                    setState(() {});
                  }
                },
                child: Text("00",
                    style: TextStyle(
                        fontSize: widget.numberFontSize, color: Colors.black)),
              ),
            ],
          ),

          ///fourth row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  elevation: 0,
                  bgColor: Colors.grey.shade200,
                  height: widget.gridHeight,
                  onPressed: () {
                    addNumber(numberAmount: 0);
                  },
                  child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spaceBetweenButtons),
              CustomElevatedButton(
                width: screenSize / 4.2,
                bgColor: Colors.grey.shade200,
                elevation: 0,
                height: widget.gridHeight,
                onPressed: () {
                  widget.enterClick();
                },
                child: Text(
                  "Enter",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
        ],
      );
    });
  }

  ///adding number method
  addNumber({required int numberAmount}) {
    if (widget.numberController.text.length <= 15) {
      String barCode = widget.numberController.text;
      widget.numberController.text = "$barCode$numberAmount";
      setState(() {});
    } else {
      showCustomSnackbar(context: context, message: 'Limit length is 15');
    }
  }
}
