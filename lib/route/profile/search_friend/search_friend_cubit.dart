import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'search_friend_cubit.freezed.dart';

// enum SearchStatus { idle, waiting, error, success }

// @freezed
// class SearchFriendState with _$SearchFriendState {
//   const factory SearchFriendState({
//     required String search,
//     required SearchStatus status,
//   }) = _SearchFriendState;
// }

// class SearchFriendCubit extends Cubit<SearchFriendState> {
//   SearchFriendCubit()
//       : super(
//           const SearchFriendState(
//             search: '',
//             status: SearchStatus.idle,
//           ),
//         );

//   Future<void> search(String search) async {
//     emit(state.copyWith(search: search, status: SearchStatus.waiting));
//   }
// }

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void search(String string) => emit(string);
}
