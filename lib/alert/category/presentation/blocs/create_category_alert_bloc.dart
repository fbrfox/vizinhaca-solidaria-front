import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

abstract class CreateCategoryAlertState {}

class CreateCategoryAlertInitial extends CreateCategoryAlertState {}

class CreateCategoryAlertLoading extends CreateCategoryAlertState {}

class CreateCategoryAlertGetCategoriesSuccess extends CreateCategoryAlertState {
  List<Category> categories;
  CreateCategoryAlertGetCategoriesSuccess(this.categories);
}

class CreateCategoryAlertGetCategoriesError extends CreateCategoryAlertState {
  final String message;
  CreateCategoryAlertGetCategoriesError(this.message);
}

class UnauthorizerFailureState extends CreateCategoryAlertState {
  final String message;
  UnauthorizerFailureState(this.message);
}

abstract class CreateCategoryAlertEvent {}

class CreateCategoryAlertGetCategories extends CreateCategoryAlertEvent {}

class CreateCategoryAlertBloc
    extends Bloc<CreateCategoryAlertEvent, CreateCategoryAlertState> {
  GetAllCategoriesUsecase getAllCategoriesUsecase;

  CreateCategoryAlertBloc(this.getAllCategoriesUsecase)
      : super(CreateCategoryAlertInitial()) {
    on<CreateCategoryAlertGetCategories>((event, emit) async {
      emit(CreateCategoryAlertLoading());
      try {
        final result = await getAllCategoriesUsecase.call();
        result.fold((failure) {
          if (failure is UnauthorizerFailure) {
            emit(UnauthorizerFailureState('Usuário não autenticado'));
          } else {
            emit(CreateCategoryAlertGetCategoriesError(failure.message));
          }
        }, (alerts) => emit(CreateCategoryAlertGetCategoriesSuccess(alerts)));
      } catch (e) {
        emit(CreateCategoryAlertGetCategoriesError(e.toString()));
      }
    });
  }
}
