// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:summify/bloc/authentication/authentication_bloc.dart';
// import 'package:summify/screens/auth/auth_screen.dart';
//
// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     void onPressSignOut() {
//       BlocProvider.of<AuthenticationBloc>(context).add(
//         SignOut(),
//       );
//     }
//
//     return BlocBuilder<AuthenticationBloc, AuthenticationState>(
//       builder: (context, authState) {
//         final user = authState.user;
//         if (user == null) {
//           return AuthScreen();
//         } else {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('adasdasd'),
//             ),
//             body: Center(
//               child: IconButton(
//                   onPressed: onPressSignOut,
//                   icon: Icon(Icons.follow_the_signs_outlined)),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
