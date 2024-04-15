import '../Pages/DeleteAccountButton.dart';
import '../Pages/EditButton.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            'Informações do Usuário',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://images.unsplash.com/photo-1525357816819-392d2380d821?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8cHJvZmlsZSUyMGljb258ZW58MHx8fHwxNzEyNTM1NTA2fDA&ixlib=rb-4.0.3&q=80&w=1080',
                  width: 152,
                  height: 152,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const Text(
              'Erasmo Vieira',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: 264,
              height: 239,
              decoration: const BoxDecoration(
                color: Colors.white24,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Telefone: (63)98877-6655',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Text(
                        'Email: erasmo@email.com',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Endereço: 108 Norte Al02 Lt11',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              Padding(
                padding: EdgeInsets.all(40),
                child: EditButton(),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: DeleteAccountButton(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
