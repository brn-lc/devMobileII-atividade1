import 'package:flutter/material.dart';
import 'features/localizacoes/presentation/screens/tela_coleta.dart';

class AplicativoLocalizacoes extends StatelessWidget {
  const AplicativoLocalizacoes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coleta de Localizações',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TelaColeta(),
    );
  }
}
