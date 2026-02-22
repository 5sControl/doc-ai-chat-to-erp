import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.email ?? 'No display name';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Material(
            color: Theme.of(context).primaryColor.withOpacity(0),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SvgPicture.asset(
                            Assets.icons.settings,
                            height: 35,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).textTheme.bodySmall!.color!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello!',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall!.color,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              displayName,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall!.color,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/login'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SvgPicture.asset(
                            Assets.icons.settings,
                            height: 35,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).textTheme.bodySmall!.color!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Never lose your data!',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall!.color,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Log in',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall!.color,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
