import 'package:flutter/material.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  bool _senhaVisivel = false;
  String nome = 'Fulano de Tal da Silva';
  String email = 'fulanodetal@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C1E01),
        title: Text('FastFVS', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('Editar foto'),
                      ],
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE0D7F5),
                  child: Icon(
                    Icons.person_outline,
                    size: 60,
                    color: Color(0xFF4A3728),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Olá, Fulano de Tal!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3728),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: nome),
                    decoration: InputDecoration(border: OutlineInputBorder(), ),
                    onTap: () {
                      TextEditingController controller = TextEditingController(
                        text: nome,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Center(child: Text('Editar Nome')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () {
                                    setState(() => nome = controller.text);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Confirmar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: email),
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onTap: () {
                      TextEditingController controller = TextEditingController(
                        text: email,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Center(child: Text('Editar Email')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () {
                                    setState(() => email = controller.text);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Confirmar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Senha:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    obscureText: !_senhaVisivel,
                    controller: TextEditingController(text: 'minhasenha123'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaVisivel
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _senhaVisivel = !_senhaVisivel),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Center(child: Text('Editar Senha')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Senha atual:'),
                              SizedBox(height: 8),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text('Nova senha:'),
                              SizedBox(height: 8),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text('Cofirmar senha:'),
                              SizedBox(height: 8),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Confirmar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFF3C1E01),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
