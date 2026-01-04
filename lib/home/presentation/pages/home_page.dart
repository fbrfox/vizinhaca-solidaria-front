import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/alert/category/presentation/blocs/create_category_alert_bloc.dart'
    as createCategory;
import 'package:vizinhanca_solidaria/alert/category/presentation/pages/create_category_alert_page.dart';
import 'package:vizinhanca_solidaria/core/ui/colors.dart';
import 'package:vizinhanca_solidaria/home/presentation/blocs/home_bloc.dart';
import 'package:vizinhanca_solidaria/home/presentation/components/drawer.dart';
import 'package:vizinhanca_solidaria/home/presentation/pages/vizinhaca_page.dart';
import 'package:vizinhanca_solidaria/notification/presentation/blocs/notifications_bloc.dart';
import 'package:vizinhanca_solidaria/notification/presentation/pages/notifications_page.dart';

import '../../../core/di/injection_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Ín
  String _title = 'Sua Vizinhança';
  var items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Vizinhança',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Criar Alerta',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'Histórico',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notificações',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _title = items[index].label!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          leading: Builder(
            builder: (BuildContext context) {
              // This context is under the Scaffold
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeGetAlertsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is UnauthorizerFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );

              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          child: _buildBody(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          currentIndex: _selectedIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: tabBarItemColor,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ));
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: // Aba "Vizinhança"
        return const VizinhacaPage(); // Substitua pelo seu widget
      case 1: // Aba "Criar Alerta"
        return BlocProvider<createCategory.CreateCategoryAlertBloc>(
          create: (context) => sl<createCategory.CreateCategoryAlertBloc>(),
          child: const CreateCategoryAlertPage(),
        );
      case 2: // Aba "Histórico"
        return const Center(
            child: Text('Em construção')); // Substitua pelo seu widget
      case 3: // Aba "Notificações"
        return BlocProvider<NotificationsBloc>(
          create: (context) => sl<NotificationsBloc>(),
          child: NotificationsPage(),
        );
      default:
        return const Center(child: Text('Erro'));
    }
  }
}
