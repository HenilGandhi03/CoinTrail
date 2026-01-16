import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/features/home/widgets/carousel_card/balance_card_expense.dart';
import 'package:cointrail/features/home/widgets/carousel_card/balance_card_monthly.dart';
import 'package:cointrail/features/home/widgets/carousel_card/balance_card_income.dart';
import 'package:flutter/material.dart';

class HomeBalanceCarousel extends StatefulWidget {
  const HomeBalanceCarousel({super.key});

  @override
  State<HomeBalanceCarousel> createState() => _HomeBalanceCarouselState();
}

class _HomeBalanceCarouselState extends State<HomeBalanceCarousel> {
  final PageController _controller = PageController(viewportFraction: 1.0);

  int _currentIndex = 0;

  // 🔑 SINGLE SOURCE OF TRUTH
  final List<Widget> _pages = const [
    _CarouselItem(child: BalanceCardMonthly()),
    _CarouselItem(child: BalanceCardExpense()),
    _CarouselItem(child: BalanceCardIncome()),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final itemCount = _pages.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --------------------------------------------------
        // Carousel (Swipe Gesture)
        // --------------------------------------------------
        SizedBox(
          height: TSizes.imageCarouselHeight,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _pages,
          ),
        ),

        const SizedBox(height: TSizes.sm),

        // --------------------------------------------------
        // Slick Segmented Line Indicator (Tap + Swipe Sync)
        // --------------------------------------------------
        SizedBox(
          width: 24.0 * itemCount,
          height: 6,
          child: Row(
            children: List.generate(
              itemCount,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () => _goToPage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? colors.primary
                          : colors.onSurface.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// Helper widget to add spacing between cards
// --------------------------------------------------
class _CarouselItem extends StatelessWidget {
  final Widget child;

  const _CarouselItem({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
      child: child,
    );
  }
}
