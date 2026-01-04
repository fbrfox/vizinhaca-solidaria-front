import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      bodyPadding: EdgeInsets.all(16),
      pages: [
        PageViewModel(
            title: "Bem vindo ao Vizinhança Solidária",
            body:
                "Aqui você encontra tudo o que precisa para se conectar com a sua vizinhança",
            image: Center(
                child: Image.asset("assets/images/logo.png", height: 100))
            // Substitua pelas suas imagens
            ),
        PageViewModel(
            title: "Receba alertas de segurança",
            body:
                "Receba notificações de segurança em tempo real e mantenha-se informado",
            image: Center(
                child: Image.asset("assets/images/logo.png", height: 100))
            // Substitua pelas suas imagens
            ),
        PageViewModel(
            title: "Crie alertas de segurança",
            body:
                "Crie alertas de segurança para manter a sua vizinhança informada",
            image: Center(
                child: Image.asset("assets/images/logo.png", height: 100))
            // Substitua pelas suas imagens
            ),
        PageViewModel(
            title: "Acompanhe o mapa de segurança",
            body:
                "Acompanhe o mapa de segurança da sua vizinhança e saiba o que está acontecendo",
            image: Center(
                child: Image.asset("assets/images/logo.png", height: 100))
            // Substitua pelas suas imagens
            ),
        PageViewModel(
            title: "As autoridades também estão aqui",
            body:
                "As autoridades locais tem acesso ao aplicativo e podem ajudar a manter a sua vizinhança segura",
            image: Center(
                child: Image.asset("assets/images/logo.png", height: 100))
            // Substitua pelas suas imagens
            ),
      ],
      onDone: () {
        // Ação quando o usuário clicar em "Concluir"
        Navigator.pushReplacementNamed(
            context, '/home'); // Navega para a tela home
      },
      onSkip: () {
        // Ação quando o usuário clicar em "Pular"
        Navigator.pushReplacementNamed(context, '/home');
      },
      showSkipButton: true,
      skip: const Text("Pular"),
      next: const Icon(Icons.arrow_forward),
      done:
          const Text("Concluir", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
