
import 'package:flutter/material.dart';

class ButtonSubmitWidget extends StatelessWidget {
  const ButtonSubmitWidget(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.height,
      this.width,
      this.paddingHorizontal,
      this.paddingVertical,
      this.marginVertical,
      this.marginHorizontal,
      this.colorDefaultText,
      this.titleSize,
      this.backgroundColors = true,
      this.inactiveColor = false})
      : super(key: key);

  final String title;
  final Color? colorDefaultText;
  final VoidCallback? onPressed;
  final bool backgroundColors;
  final bool inactiveColor;
  final double? height;
  final double? width;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? titleSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? 0, vertical: paddingVertical ?? 0),
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal ?? 0, vertical: marginVertical ?? 0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: backgroundColors
                ? MaterialStateProperty.all(const Color(0xFFF28022))
                : MaterialStateProperty.all(inactiveColor
                    ? Color(0xFFCFCAC6)
                    : Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: inactiveColor
                  ? BorderSide.none
                  : const BorderSide(color: Color(0xFFF28022)),
            ))),
        child: Text(
          title,
          style: TextStyle(
              color: colorDefaultText,
              fontSize:
                  15,
              fontWeight: FontWeight.w700),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
