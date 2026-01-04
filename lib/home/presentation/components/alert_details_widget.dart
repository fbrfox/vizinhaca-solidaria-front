import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';

class AlertaDetalhesWidget extends StatelessWidget {
  final Alert alerta;
  final VoidCallback onClose;

  const AlertaDetalhesWidget(
      {super.key, required this.alerta, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                    // Widget para deixar a imagem redonda
                    child: CachedNetworkImage(
                  imageUrl:
                      '${dotenv.env['API_URL'] ?? ''}/users/avatar/${alerta.userId}',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  cacheManager: CachedNetworkImageProvider.defaultCacheManager,
                  fit: BoxFit.fill,
                  width: 40,
                  height: 40,
                )),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${alerta.userName}', // Nome do usuário
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
                child: CachedNetworkImage(
              imageUrl:
                  '${dotenv.env['API_URL'] ?? ''}/alerts/photo/${alerta.id}',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              cacheManager: CachedNetworkImageProvider.defaultCacheManager,
              fit: BoxFit.fill,
              width: 300,
              height: 200,
            )),
            const SizedBox(height: 16),
            Text(alerta.description), // Descrição do alerta
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  alerta.createAt, // Data de criação
                  style: TextStyle(fontSize: 12),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
