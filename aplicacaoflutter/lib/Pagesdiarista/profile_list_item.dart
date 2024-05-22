import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final bool isLastItemRed;
  final Function()? onTap; // Adiciona uma função de retorno de chamada para lidar com o clique

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
    this.isLastItemRed = false,
    this.onTap, // Adiciona a função de retorno de chamada ao construtor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Adiciona um GestureDetector em torno do conteúdo do Container
      onTap: onTap, // Define onTap como a função de retorno de chamada
      child: Container(
        height: 10 * 5.5,
        margin: EdgeInsets.symmetric(
          horizontal: 10 * 4,
        ).copyWith(
          bottom: 10 * 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10 * 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10 * 3),
          color: Color(0xFFF3F7FB),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: 10 * 2.5,
              color: isLastItemRed ? Colors.red : null,
            ),
            SizedBox(width: 10 * 1.5),
            Text(
              this.text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isLastItemRed ? Colors.red : null,
              ).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                LineAwesomeIcons.angle_right,
                size: 10 * 2.5,
                color: isLastItemRed ? Colors.red : null,
              ),
          ],
        ),
      ),
    );
  }
}
