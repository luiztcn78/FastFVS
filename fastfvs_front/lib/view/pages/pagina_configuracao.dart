import 'package:flutter/material.dart';

class PaginaConfiguracao extends StatelessWidget {
  const PaginaConfiguracao({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "DarkMode",
                    style: TextStyle(
                      color: Color.fromRGBO(3, 1, 0, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Switch(
                    value: true,
                    onChanged: null,
                    activeColor: Colors.white,
                    activeTrackColor: Color.fromRGBO(3, 1, 0, 1),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(height: 40.0),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "      Perfil",
                    style: TextStyle(
                      color: Color.fromRGBO(3, 1, 0, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.account_circle_outlined,
                    size: 24.0,
                    color: Color.fromRGBO(3, 1, 0, 1),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "      Trocar de conta",
                    style: TextStyle(
                      color: Color.fromRGBO(3, 1, 0, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.switch_account_outlined,
                    size: 24.0,
                    color: Color.fromRGBO(3, 1, 0, 1),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "      Excluir conta",
                    style: TextStyle(
                      color: Color.fromRGBO(3, 1, 0, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.delete_outline,
                    size: 24.0,
                    color: Color.fromRGBO(3, 1, 0, 1),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "      Sair",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 0, 0, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.logout,
                    size: 24.0,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
