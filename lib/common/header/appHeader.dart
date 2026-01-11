import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:flutter/material.dart';

/// A custom app header that supports scrolling behavior with pinned elements
/// The title row stays fixed while other content scrolls away
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.bottom,
    this.home_carousel,
    this.bottom_analysis,
    this.bottom_alltx,
    this.extendedHeight = false,
    this.centerWidget,
    this.showBack = false,
    this.showNotification = false,
    this.onBack,
    this.onNotificationTap,
    this.pinnedWidgets = const [], // Widgets to pin
    this.scrollableWidgets = const [],
  });

  // Main title text shown at the top
  final String title;

  // Optional subtitle below the title
  final String? subtitle;

  // Legacy bottom widget (kept for compatibility)
  final Widget? home_carousel;

  // Whether to add extra height to the header
  final bool extendedHeight;

  // Legacy bottom content (kept for compatibility)
  final Widget? bottom;

  final Widget? bottom_analysis;
  final Widget? bottom_alltx;

  // Optional widget shown in the center (like a profile picture)
  final Widget? centerWidget;

  // Whether to show the back arrow button
  final bool showBack;

  // Whether to show the notification bell icon
  final bool showNotification;

  // Callback when back button is pressed
  final VoidCallback? onBack;

  // Callback when notification icon is tapped
  final VoidCallback? onNotificationTap;

  /// Widgets that stay visible longer below the title (fade slowly)
  final List<Widget> pinnedWidgets;

  /// Widgets that scroll away completely with page content
  final List<Widget> scrollableWidgets;

  @override
  Widget build(BuildContext context) {
    // Get the current theme for styling
    final theme = Theme.of(context);

    // Get the color scheme from the theme
    final colors = theme.colorScheme;

    // Get the status bar height (top system UI like battery, time)
    final statusBar = MediaQuery.of(context).padding.top;

    // Return a SliverPersistentHeader which enables pinning behavior
    // This widget works inside a CustomScrollView
    return SliverPersistentHeader(
      pinned: true, // Keep the header visible at the top when scrolling
      delegate: _AppHeaderDelegate(
        // Pass all parameters to the delegate that handles the actual rendering
        title: title,
        subtitle: subtitle,
        bottom: bottom,
        home_carousel: home_carousel,
        extendedHeight: extendedHeight,
        centerWidget: centerWidget,
        bottom_analysis: bottom_analysis,
        bottom_alltx: bottom_alltx,
        showBack: showBack,
        showNotification: showNotification,
        onBack: onBack,
        onNotificationTap: onNotificationTap,
        statusBar: statusBar,
        theme: theme,
        colors: colors,
        pinnedWidgets: pinnedWidgets,
        scrollableWidgets: scrollableWidgets,
      ),
    );
  }
}

/// The delegate that actually builds and manages the header's appearance
/// This controls how the header looks at different scroll positions
class _AppHeaderDelegate extends SliverPersistentHeaderDelegate {
  _AppHeaderDelegate({
    required this.title,
    this.subtitle,
    this.bottom,
    this.home_carousel,
    this.bottom_analysis,
    this.bottom_alltx,
    required this.extendedHeight,
    this.centerWidget,
    required this.showBack,
    required this.showNotification,
    this.onBack,
    this.onNotificationTap,
    required this.statusBar,
    required this.theme,
    required this.colors,
    required this.pinnedWidgets,
    required this.scrollableWidgets,
  });

  // All the same parameters from the parent widget
  final String title;
  final String? subtitle;
  final Widget? home_carousel;
  final Widget? bottom_analysis;
  final Widget? bottom_alltx;
  final bool extendedHeight;
  final Widget? bottom;
  final Widget? centerWidget;
  final bool showBack;
  final bool showNotification;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;
  final double statusBar;
  final ThemeData theme;
  final ColorScheme colors;
  final List<Widget> pinnedWidgets;
  final List<Widget> scrollableWidgets;

  // Minimum height when fully collapsed (just title + curve visible)
  // This is the smallest the header gets when you scroll down
  double get minHeight => 90 + statusBar;

  // Maximum height when fully expanded (all content visible)
  // This calculates the total height based on what content exists
  @override
  double get maxExtent {
    // Start with a reasonable base height for title area
    double height = 180 + statusBar;

    // Add height if subtitle exists
    if (subtitle != null) height += 35;

    // Add height if bottom widget exists
    if (bottom != null) height += 0;

    // Add height if home_carousel exists
    if (home_carousel != null) height += 140;
    if (bottom_analysis != null) height += 40;
    if (bottom_alltx != null) height += 0;

    // Add height for each pinned widget
    if (pinnedWidgets.isNotEmpty) height += 60 * pinnedWidgets.length;

    // Add height for each scrollable widget
    if (scrollableWidgets.isNotEmpty) height += 60 * scrollableWidgets.length;

    // Add extra height if extended height is enabled
    if (extendedHeight) height += 80;

    return height;
  }

  // Minimum height getter (same as minHeight)
  @override
  double get minExtent => minHeight;

  /// This method builds the header at any scroll position
  /// shrinkOffset: How much the header has shrunk (0 = fully expanded)
  /// overlapsContent: Whether the header overlaps scrollable content
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Calculate scroll progress (0.0 = fully expanded, 1.0 = fully collapsed)
    // This gives us a value between 0 and 1 representing the scroll state
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Calculate title opacity (title fades slightly when scrolling)
    // Reduces opacity by 30% maximum (1.0 to 0.7)
    final titleOpacity = 1.0 - (progress * 0.1);

    // Main container that holds all header elements
    return SizedBox(
      height: maxExtent, // Set to maximum height
      child: Stack(
        fit: StackFit.expand, // Make stack children fill the space
        children: [
          // ───────── BACKGROUND (Primary color at top) ─────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              // Height shrinks as you scroll (by half the shrink offset)
              // The .clamp ensures it doesn't shrink more than 90 pixels
              height: 180 + statusBar - (shrinkOffset * 0.5).clamp(0.0, 90.0),
              color: colors.primary, // Primary theme color
            ),
          ),

          // ───────── CURVED OVERLAY (White surface with rounded top) ─────────
          // This creates the curved "card" effect
          Positioned(
            // Position moves up as background shrinks, maintaining curve at edge
            top: (170 + statusBar - (shrinkOffset * 0.5).clamp(0.0, 40.0)) - 48,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface, // Background color (usually white)
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(48), // 48 pixel radius for smooth curve
                ),
              ),
            ),
          ),

          // ───────── PINNED TITLE ROW (Always visible at top) ─────────
          Positioned(
            top: TSizes.lg + statusBar, // Position below status bar
            left: TSizes.lg, // Left padding
            right: TSizes.lg, // Right padding
            child: Opacity(
              opacity: titleOpacity, // Apply calculated opacity
              child: Row(
                children: [
                  // Back button (if enabled)
                  if (showBack)
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded tap area
                      onTap:
                          onBack ??
                          () => Navigator.maybePop(context), // Go back
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: colors.onPrimary, // White/light color
                        size: 28,
                      ),
                    ),

                  // Spacing after back button
                  if (showBack) const SizedBox(width: TSizes.sm),

                  // Title text (takes remaining space)
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800, // Extra bold
                        color: colors.onPrimary, // Contrasts with primary color
                      ),
                    ),
                  ),

                  // Notification button (if enabled)
                  if (showNotification)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.onPrimary, // Light background
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: InkWell(
                        customBorder:
                            const CircleBorder(), // Circular tap effect
                        onTap: onNotificationTap,
                        child: Icon(
                          Icons.notifications_rounded,
                          color: colors.primary, // Primary color icon
                          size: 22,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ───────── SCROLLABLE CONTENT (Moves up when scrolling) ─────────
          Positioned(
            top: 50 + statusBar, // Position below title row
            left: TSizes.lg,
            right: TSizes.lg,
            child: Transform.translate(
              // Move content up by the shrink amount (creates scroll effect)
              offset: Offset(0, -shrinkOffset),
              child: Opacity(
                // Fade out completely as you scroll
                opacity: (1.0 - progress * 2.0).clamp(0.0, 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle section (if exists)
                    if (subtitle != null) ...[
                      const SizedBox(height: TSizes.sm),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                        child: Text(
                          subtitle!,
                          textAlign: TextAlign.left,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colors.onPrimary.withOpacity(
                              0.9,
                            ), // Slightly transparent
                          ),
                        ),
                      ),
                    ],

                    // Legacy bottom widget (if exists)
                    if (bottom != null) ...[
                      const SizedBox(height: TSizes.md),
                      bottom!,
                    ],

                    // Legacy home_carousel (if exists)
                    if (home_carousel != null) ...[
                      const SizedBox(height: TSizes.xxl),
                      home_carousel!,
                    ],

                    // Bottom analysis widget (if exists)
                    if (bottom_analysis != null) ...[
                      const SizedBox(height: TSizes.xxxl),
                      bottom_analysis!,
                    ],
                    // Bottom alltx widget (if exists)
                    if (bottom_alltx != null) ...[
                      const SizedBox(height: TSizes.xxxl),
                      bottom_alltx!,
                    ],

                    // Pinned widgets (fade slower - only 50% max fade)
                    // These stay visible longer than scrollable content
                    ...pinnedWidgets.map(
                      (widget) => Padding(
                        padding: const EdgeInsets.only(top: TSizes.sm),
                        child: Opacity(
                          // Only fade to 50% opacity maximum
                          opacity: (1.0 - progress * 0.5).clamp(0.0, 1.0),
                          child: widget,
                        ),
                      ),
                    ),

                    // Scrollable widgets (fade completely)
                    // These disappear as you scroll
                    ...scrollableWidgets.map(
                      (widget) => Padding(
                        padding: const EdgeInsets.only(top: TSizes.sm),
                        child: widget,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ───────── CENTER WIDGET (Like profile picture) ─────────
          // Optional widget shown in the center of the header
          if (centerWidget != null)
            Positioned(
              // Moves up faster than other content (0.8x multiplier)
              top: (40 + statusBar) - shrinkOffset * 0.8,
              left: 0,
              right: 0,
              child: Opacity(
                // Fades out as you scroll
                opacity: (1.0 - progress).clamp(0.0, 1.0),
                child: centerWidget!,
              ),
            ),
        ],
      ),
    );
  }

  /// Determines if the header should rebuild when parameters change
  /// Returns true if any key properties have changed
  @override
  bool shouldRebuild(covariant _AppHeaderDelegate oldDelegate) {
    return title != oldDelegate.title ||
        subtitle != oldDelegate.subtitle ||
        showBack != oldDelegate.showBack ||
        showNotification != oldDelegate.showNotification;
  }
}
