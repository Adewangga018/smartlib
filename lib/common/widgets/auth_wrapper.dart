// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/auth_service.dart';

// class AuthWrapper extends StatelessWidget {
//   final WidgetBuilder loggedInBuilder;
//   final WidgetBuilder loggedOutBuilder;

//   const AuthWrapper({
//     super.key,
//     required this.loggedInBuilder,
//     required this.loggedOutBuilder,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     return StreamBuilder<User?>(
//       stream: authService.userStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final user = snapshot.data;
//           return user != null
//               ? Builder(builder: loggedInBuilder)
//               : Builder(builder: loggedOutBuilder);
//         }
//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }
// }