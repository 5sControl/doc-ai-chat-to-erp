import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/saved_cards/saved_cards_bloc.dart';

class BookmarksButton extends StatelessWidget {
  final Function() onPressBookmarks;
  const BookmarksButton({super.key, required this.onPressBookmarks});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedCardsBloc, SavedCardsState>(
      builder: (context, state) {
        final count = state.count;
        
        return GestureDetector(
          onTap: onPressBookmarks,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(right: 4),
            child: Stack(
              children: [
                Icon(
                  Icons.bookmark,
                  size: 28,
                  color: Theme.of(context).cardColor,
                ),
                
                // Badge with count
                if (count > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 186, 195, 1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
