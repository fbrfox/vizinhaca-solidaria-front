import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/alert/category/presentation/blocs/create_category_alert_bloc.dart';
import 'package:vizinhanca_solidaria/core/ui/colors.dart';

class CreateCategoryAlertPage extends StatefulWidget {
  const CreateCategoryAlertPage({super.key});

  @override
  State<CreateCategoryAlertPage> createState() =>
      _CreateCategoryAlertPageState();
}

class _CreateCategoryAlertPageState extends State<CreateCategoryAlertPage> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context
        .read<CreateCategoryAlertBloc>()
        .add(CreateCategoryAlertGetCategories());
  }

  _onSelectCategory(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<CreateCategoryAlertBloc, CreateCategoryAlertState>(
            listener: (context, state) {
      if (state is CreateCategoryAlertGetCategoriesError) {
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
    }, child: BlocBuilder<CreateCategoryAlertBloc, CreateCategoryAlertState>(
                builder: (context, state) {
      if (state is CreateCategoryAlertLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is CreateCategoryAlertGetCategoriesSuccess) {
        return Column(children: [
          const SizedBox(height: 16),
          const Text(
            'Selecione a categoria do alerta',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          Expanded(
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Duas colunas
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final categoria = state.categories[index];
              return CategoriaItem(
                  categoria: categoria,
                  onSelectCategory: _onSelectCategory,
                  isSelected: _selectedCategory == categoria);
            },
          )),
          const SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedCategory != null) {
                    Navigator.of(context).pushNamed("alert/create",
                        arguments: _selectedCategory);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecione uma categoria'),
                      ),
                    );
                  }
                },
                child: const Text('Continuar'),
              )),
        ]);
      } else {
        return const Center(
          child: Text('Erro ao carregar categorias'),
        );
      }
    })));
  }
}

class CategoriaItem extends StatelessWidget {
  final Category categoria;
  final void Function(Category) onSelectCategory;
  final bool isSelected;

  const CategoriaItem(
      {super.key,
      required this.categoria,
      required this.onSelectCategory,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: !isSelected ? null : primaryColor,
      child: InkWell(
        onTap: () {
          onSelectCategory(categoria);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage("assets/images/${categoria.icon}.png"),
                width: 40,
                height: 40), // Ícone da categoria
            const SizedBox(height: 8),
            Text(categoria.name), // Nome da categoria
          ],
        ),
      ),
    );
  }
}
