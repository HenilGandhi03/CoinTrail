import 'package:cointrail/features/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:cointrail/features/settings/widgets/common/settings_card.dart';

class ExportDataSection extends StatelessWidget {
  final SettingsController controller;

  const ExportDataSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.download, title: 'Export Data'),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _ExportButton(
                  icon: Icons.insert_drive_file,
                  label: 'Export CSV',
                  onTap: () => controller.exportData(ExportType.csv),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ExportButton(
                  icon: Icons.picture_as_pdf,
                  label: 'Export PDF',
                  onTap: () => controller.exportData(ExportType.pdf),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Export your expense data for backup or analysis in other tools.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ExportButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
