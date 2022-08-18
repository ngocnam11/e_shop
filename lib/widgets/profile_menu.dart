import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          width: MediaQuery.of(context).size.width - 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline3!,
                  ),
                ],
              ),
              const Icon(
                Icons.navigate_next,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
