import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/category.dart';
import '../../../data/repositories/category/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryLoading()) {
    on<LoadCategories>((event, emit) {
      try {
        _categoryRepository.getCategories().listen(
              (categories) => add(UpdateCategories(categories)),
            );
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
    on<UpdateCategories>((event, emit) {
      emit(CategoryLoading());
      try {
        emit(CategoryLoaded(categories: event.categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
