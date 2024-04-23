// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../bloc/authentication/authentication_bloc.dart';
//
// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});
//
//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();
//
//     void onPressSignUp() {
//       BlocProvider.of<AuthenticationBloc>(context).add(
//         SignInUserWithEmail(
//           emailController.text.trim(),
//           passwordController.text.trim(),
//         ),
//       );
//     }
//     //
//     // void onPressSignOut() {
//     //   BlocProvider.of<AuthenticationBloc>(context).add(
//     //     SignOut(),
//     //   );
//     // }
//
//     void onPressGoogle() {
//       BlocProvider.of<AuthenticationBloc>(context).add(
//         SignInUserWithGoogle(),
//       );
//     }
//
//     void onPressApple() {
//       BlocProvider.of<AuthenticationBloc>(context).add(
//         SignInUserWithApple(),
//       );
//     }
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: const Text('Account'),
//       ),
//       body: Container(
//         margin:
//             EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 15),
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'SummiShare for iPhone',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400),
//                 ),
//                 Text(
//                   'Sign up to',
//                   maxLines: 2,
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 36,
//                       height: 1.2,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 Text(
//                   'get free summary!',
//                   maxLines: 2,
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 36,
//                       height: 1.2,
//                       fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Divider(
//                   color: Colors.transparent,
//                   height: 20,
//                 ),
//                 EmailInput(controller: emailController),
//                 const Divider(
//                   color: Colors.transparent,
//                   height: 20,
//                 ),
//                 PasswordInput(controller: passwordController),
//               ],
//             ),
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               child: const Text(
//                 'Forgot password?',
//                 style: TextStyle(color: Colors.white),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//             SignUpButton(
//               onPress: onPressSignUp,
//             ),
//             const SizedBox(
//               width: double.infinity,
//               child: Text(
//                 'Already have an account? Sign in',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             const DividerRow(),
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 InkWell(
//                   onTap: onPressGoogle,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white, width: 2),
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(10))),
//                     child: SvgPicture.asset('assets/icons/google.svg'),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: onPressApple,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white, width: 2),
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(10))),
//                     child: SvgPicture.asset('assets/icons/apple.svg'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               width: double.infinity,
//               child: Text(
//                 'By using this app, you agree to the Terms and Conditions and Privacy Policy ',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class EmailInput extends StatelessWidget {
//   final TextEditingController controller;
//   const EmailInput({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       textAlignVertical: TextAlignVertical.top,
//       controller: controller,
//       cursorWidth: 3,
//       cursorColor: Colors.black54,
//       cursorHeight: 20,
//       style: const TextStyle(color: Colors.black, fontSize: 20),
//       decoration: InputDecoration(
//           filled: true,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//           floatingLabelAlignment: FloatingLabelAlignment.start,
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//           label: const Padding(
//             padding: EdgeInsets.only(bottom: 25),
//             child: Text(
//               'Email',
//               style: TextStyle(),
//             ),
//           ),
//           border: OutlineInputBorder(
//               gapPadding: 10,
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none),
//           floatingLabelStyle: const TextStyle(
//               color: Colors.white,
//               // height: -2,
//               fontSize: 18,
//               fontWeight: FontWeight.w500)),
//     );
//   }
// }
//
// class PasswordInput extends StatefulWidget {
//   final TextEditingController controller;
//   const PasswordInput({super.key, required this.controller});
//
//   @override
//   State<PasswordInput> createState() => _PasswordInputState();
// }
//
// class _PasswordInputState extends State<PasswordInput> {
//   late bool _passwordVisible;
//
//   @override
//   void initState() {
//     super.initState();
//     _passwordVisible = false;
//   }
//
//   void onPressEye() {
//     setState(() {
//       _passwordVisible = !_passwordVisible;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       textAlignVertical: TextAlignVertical.top,
//       cursorWidth: 3,
//       cursorColor: Colors.black54,
//       cursorHeight: 20,
//       style: const TextStyle(color: Colors.black, fontSize: 20),
//       controller: widget.controller,
//       obscureText: !_passwordVisible,
//       enableSuggestions: false,
//       autocorrect: false,
//       decoration: InputDecoration(
//           filled: true,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//           floatingLabelAlignment: FloatingLabelAlignment.start,
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//           label: const Padding(
//             padding: EdgeInsets.only(bottom: 25),
//             child: Text(
//               'Password',
//               style: TextStyle(),
//             ),
//           ),
//           border: OutlineInputBorder(
//               gapPadding: 10,
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none),
//           floatingLabelStyle: const TextStyle(
//               color: Colors.white,
//               // height: -2,
//               fontSize: 18,
//               fontWeight: FontWeight.w500)),
//     );
//   }
// }
//
// class SignUpButton extends StatelessWidget {
//   final VoidCallback onPress;
//   const SignUpButton({super.key, required this.onPress});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPress,
//       child: Container(
//         alignment: Alignment.center,
//         // height: 50,
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         width: double.infinity,
//         decoration: BoxDecoration(
//             color: Colors.teal.shade300,
//             borderRadius: BorderRadius.circular(8)),
//         child: const Text(
//           'Sign up',
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
//
// class DividerRow extends StatelessWidget {
//   const DividerRow({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 20),
//       width: double.infinity,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Container(
//               // width: 20,
//               height: 1,
//               color: Colors.white,
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               'OR',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               // width: 20,
//               height: 1,
//               color: Colors.white,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
