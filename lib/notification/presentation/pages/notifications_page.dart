import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vizinhanca_solidaria/notification/presentation/blocs/notifications_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(GetNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<NotificationsBloc, NotificationsState>(
      listener: (context, state) => {
        if (state is NotificationsError)
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            ),
          }
        else if (state is UnauthorizerNotificationFailureState)
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            ),
            Navigator.of(context).pushReplacementNamed('/login'),
          }
      },
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NotificationsSuccess) {
            return Column(children: [
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            ClipOval(
                                // Widget para deixar a imagem redonda
                                child: CachedNetworkImage(
                              imageUrl:
                                  '${dotenv.env['API_URL'] ?? ''}/users/avatar/${notification.alert.userId}',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              cacheManager: CachedNetworkImageProvider
                                  .defaultCacheManager,
                              fit: BoxFit.fill,
                              width: 60,
                              height: 60,
                            )),
                            const SizedBox(width: 8),
                            Expanded(
                              // Make the text take up the remaining space
                              child: Wrap(children: [
                                Text(
                                  notification.title,
                                  overflow: TextOverflow.clip,
                                )
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ]);
          } else {
            return const Center(
              child: Text('Erro ao carregar as notificações'),
            );
          }
        },
      ),
    ));
  }
}
