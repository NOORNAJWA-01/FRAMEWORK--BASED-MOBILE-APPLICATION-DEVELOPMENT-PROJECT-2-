import 'package:flutter/material.dart';

class menu_tile extends StatefulWidget {
  final icon;
  final String menuTile;
  final color;
  final VoidCallback onPressed;

  const menu_tile({
    Key? key,
    required this.icon,
    required this.menuTile,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<menu_tile> createState() => _menu_tileState();
}

class _menu_tileState extends State<menu_tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        color: widget.color,
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    // ignore: prefer_const_constructors
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.menuTile,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
