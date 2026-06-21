import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../theme/app_theme.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key});

  Future<void> _openUrl(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir: $url')),
        );
      }
    }
  }

  Widget _linkRow(
    IconData icon,
    String label,
    String url,
    BuildContext context,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _openUrl(url, context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: SetansTheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(Icons.info_outline, color: SetansTheme.primary),
          const SizedBox(width: 8),
          const Text('Acerca de Setans'),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: SetansTheme.primary,
                    child: Icon(Icons.school, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Setans',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: SetansTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Sistema de Asistencias',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Versión 1.0.0+1',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade400, height: 1),
            const SizedBox(height: 16),
            Text(
              'Desarrollado por',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: SetansTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Adolfo Núñez'),
            const SizedBox(height: 12),
            Text(
              'Enlaces',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: SetansTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _linkRow(Icons.people, 'segso', 'https://github.com/segso', context),
            _linkRow(
              Icons.folder,
              'segso/setans',
              'https://github.com/segso/setans',
              context,
            ),
            _linkRow(
              Icons.email,
              'segdev.mx@gmail.com',
              'mailto:segdev.mx@gmail.com',
              context,
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade400, height: 1),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
