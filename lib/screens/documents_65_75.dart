import '../../models/models.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';
import '../../services/ai_service.dart';
import '../../widgets/components.dart';

class DocumentCenterScreen extends StatelessWidget {
  const DocumentCenterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.read(context);
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LbEyebrow('DOCUMENTS'),
              const SizedBox(height: 8),
              const LbH1('Document center'),
              const SizedBox(height: 8),
              LbBody("Organized for Ramakrishna's cardiac case.", color: LbColors.muted),
              const SizedBox(height: 16),
              LbButton(
                label: 'Upload a document',
                leadingIcon: Icons.add,
                onTap: () => Navigator.pushNamed(context, '/docs/upload'),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    LbPill(label: 'ALL · 4', variant: PillVariant.accent),
                    SizedBox(width: 8),
                    LbPill(label: 'ID PROOF', variant: PillVariant.neutral),
                    SizedBox(width: 8),
                    LbPill(label: 'MEDICAL', variant: PillVariant.neutral),
                    SizedBox(width: 8),
                    LbPill(label: 'FINANCIAL', variant: PillVariant.neutral),
                    SizedBox(width: 8),
                    LbPill(label: 'INSURANCE', variant: PillVariant.neutral),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LbEyebrow('RECENT'),
              const SizedBox(height: 8),
              for (final d in s.documents) ...[
                LbCard(
                  onTap: () => Navigator.pushNamed(context, '/docs/preview'),
                  child: Row(
                    children: [
                      LbIconSquare(icon: Icons.description_outlined, background: LbColors.infoBg, foreground: LbColors.accent, size: 40, iconSize: 20, radius: 12),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('${d.categoryLabel} · ${d.size} · ${d.fileType}', style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 12),
              const LbEyebrow('MISSING'),
              const SizedBox(height: 8),
              _MissingDocRow(name: 'Income certificate', meta: 'Needed by 3 programs', onTap: () => Navigator.pushNamed(context, '/docs/missing')),
              const SizedBox(height: 8),
              _MissingDocRow(name: 'Cost breakdown', meta: 'Needed by 2 programs', onTap: () => Navigator.pushNamed(context, '/docs/missing')),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingDocRow extends StatelessWidget {
  final String name;
  final String meta;
  final VoidCallback onTap;
  const _MissingDocRow({required this.name, required this.meta, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LbColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: LbColors.warn, width: 1.5, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: LbColors.warnBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(Icons.description_outlined, color: LbColors.warn, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(meta, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                ],
              ),
            ),
            const Text('Upload →', style: TextStyle(fontSize: 13, color: LbColors.fg, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class MissingDocumentsScreen extends StatelessWidget {
  const MissingDocumentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('MISSING · 2'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('A few documents to add.'),
              const SizedBox(height: 8),
              LbBody('Adding these will help more programs accept your case.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbInfoBanner(
                title: '',
                body: "These are needed by programs you've already matched.",
                background: LbColors.warnBg,
                borderColor: Colors.transparent,
                icon: Icons.warning_amber_outlined,
                iconColor: LbColors.warn,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 16),
              _MissingDocRow(name: 'Income certificate', meta: 'Required by 3 programs', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
              const SizedBox(height: 8),
              LbCard(
                onTap: () => Navigator.pushNamed(context, '/docs/upload'),
                child: Row(
                  children: [
                    const LbIconTile(icon: Icons.description_outlined, background: LbColors.surface2, foreground: LbColors.fg, size: 40, iconSize: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Cost breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              SizedBox(width: 8),
                              LbPill(label: 'MEDIUM IMPACT', variant: PillVariant.neutral),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text('Required by 2 programs', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Upload first document', onTap: () => Navigator.pushNamed(context, '/docs/upload')),
              const SizedBox(height: 8),
              LbButton(label: 'Do it later', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});
  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  int _sel = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('NEW UPLOAD'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Upload a document'),
              const SizedBox(height: 8),
              LbBody("We'll auto-categorize and extract the key fields.", color: LbColors.muted),
              const SizedBox(height: 20),
              const LbEyebrow('DOCUMENT TYPE'),
              const SizedBox(height: 8),
              for (int i = 0; i < 3; i++) ...[
                LbChoice(
                  title: ['Income certificate', 'Cost breakdown', 'Other'][i],
                  selected: _sel == i,
                  onTap: () => setState(() => _sel = i),
                ),
                if (i < 2) const SizedBox(height: 8),
              ],
              const SizedBox(height: 20),
              const LbEyebrow('WHERE IS IT?'),
              const SizedBox(height: 8),
              _SourceRow(icon: Icons.camera_alt_outlined, title: 'Take a photo', subtitle: 'Use your camera · best for paper', onTap: () => Navigator.pushNamed(context, '/docs/source')),
              const SizedBox(height: 8),
              _SourceRow(icon: Icons.folder_outlined, title: 'Choose a file', subtitle: 'PDF, image, or scan from your device', onTap: () => Navigator.pushNamed(context, '/docs/source')),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/docs/error'),
                  child: const Text.rich(
                    TextSpan(
                      text: 'Upload not working? ',
                      style: TextStyle(fontSize: 12, color: LbColors.muted),
                      children: [TextSpan(text: 'Get help', style: TextStyle(color: LbColors.accent, fontWeight: FontWeight.w600))],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/docs/source')),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SourceRow({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return LbCard(
      onTap: onTap,
      child: Row(
        children: [
          LbIconTile(icon: icon, background: LbColors.infoBg, foreground: LbColors.accent, size: 36, iconSize: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
        ],
      ),
    );
  }
}

class SelectUploadSourceScreen extends StatelessWidget {
  const SelectUploadSourceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.camera_alt_outlined, 'Take a photo', 'Use camera · recommended for paper documents'),
      (Icons.folder_outlined, 'Choose from device', 'Photos, files, or downloads'),
      (Icons.cloud_download_outlined, 'From email or cloud', 'Gmail, Drive, Dropbox · link your account later'),
    ];
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('SOURCE'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Where should we get the file?'),
              const SizedBox(height: 8),
              LbBody('The file is encrypted and never shared without your tap.', color: LbColors.muted),
              const SizedBox(height: 16),
              for (final it in items) ...[
                LbCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () => Navigator.pushNamed(context, '/docs/camera'),
                  child: Row(
                    children: [
                      LbIconTile(icon: it.$1, background: LbColors.infoBg, foreground: LbColors.accent, size: 44, iconSize: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(it.$2, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(it.$3, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: LbColors.muted, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              LbButton(label: 'Cancel', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/docs/center', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraFileUploadScreen extends StatelessWidget {
  const CameraFileUploadScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                LbCircleButton(icon: Icons.chevron_left, size: 44, background: Color(0x33FFFFFF), foreground: LbColors.surface, onTap: () => Navigator.pop(context)),
                const Spacer(),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: LbColors.surface, width: 2), borderRadius: BorderRadius.circular(20)),
                    ),
                    Positioned(
                      top: 24, left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 60, height: 1, color: LbColors.surface.withValues(alpha: 0.3)),
                        ],
                      ),
                    ),
                    const Center(
                      child: Icon(Icons.description_outlined, color: LbColors.surface, size: 60),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            LbBody('Position the document within the frame and tap shutter.', color: LbColors.surface.withValues(alpha: 0.85), align: TextAlign.center),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LbCircleButton(icon: Icons.image_outlined, background: Color(0x33FFFFFF), foreground: LbColors.surface, size: 44),
                  LbCircleButton(icon: Icons.circle, background: LbColors.surface, foreground: LbColors.fg, size: 64, onTap: () => Navigator.pushNamed(context, '/docs/preview')),
                  LbCircleButton(icon: Icons.flip_camera_android, background: Color(0x33FFFFFF), foreground: LbColors.surface, size: 44),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const LbBody("LifeBridge will auto-detect edges and enhance text.", color: LbColors.muted, size: 12, align: TextAlign.center),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LbButton(
                label: 'Capture & preview',
                background: LbColors.surface,
                foreground: LbColors.fg,
                onTap: () => Navigator.pushNamed(context, '/docs/preview'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class DocumentPreviewScreen extends StatelessWidget {
  const DocumentPreviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('DOCUMENT'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Income certificate'),
              const SizedBox(height: 4),
              LbMeta('Uploaded just now · PDF · 1.2 MB'),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Container(
                  decoration: BoxDecoration(color: LbColors.surface2, borderRadius: BorderRadius.circular(16), border: Border.all(color: LbColors.border)),
                  alignment: Alignment.center,
                  child: const Text('Document preview', style: TextStyle(color: LbColors.muted, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: LbButton(label: 'Replace', variant: LbButtonVariant.secondary, fontSize: 13, height: 44, onTap: () => Navigator.pushNamed(context, '/docs/source'))),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Share', variant: LbButtonVariant.secondary, fontSize: 13, height: 44, onTap: () {})),
                  const SizedBox(width: 8),
                  Expanded(child: LbButton(label: 'Delete', variant: LbButtonVariant.secondary, fontSize: 13, height: 44, foreground: LbColors.danger, onTap: () {})),
                ],
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: '',
                body: 'This document is required by 3 programs. Ready to use in applications.',
                background: LbColors.infoBg,
                borderColor: LbColors.cardWarnBorder,
                icon: Icons.info_outline,
                iconColor: LbColors.accent,
                iconBg: LbColors.surface,
              ),
              const SizedBox(height: 24),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/docs/category')),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentCategoryScreen extends StatefulWidget {
  const DocumentCategoryScreen({super.key});
  @override
  State<DocumentCategoryScreen> createState() => _DocumentCategoryScreenState();
}

class _DocumentCategoryScreenState extends State<DocumentCategoryScreen> {
  int _sel = 0;
  final items = const ['Income certificate', 'Government ID', 'Medical record', 'Financial statement', 'Insurance document', 'Other'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('CATEGORY'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('What type of document is this?'),
              const SizedBox(height: 8),
              LbBody('AI suggested "Income certificate" — confirm or change.', color: LbColors.muted),
              const SizedBox(height: 16),
              const LbAIBubble(
                title: 'AI suggestion',
                message: 'Income certificate — based on document title and structure.',
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < items.length; i++) ...[
                LbChoice(title: items[i], selected: _sel == i, onTap: () => setState(() => _sel = i)),
                if (i < items.length - 1) const SizedBox(height: 8),
              ],
              const SizedBox(height: 24),
              LbButton(label: 'Continue', onTap: () => Navigator.pushNamed(context, '/docs/extraction')),
            ],
          ),
        ),
      ),
    );
  }
}

class AIDocumentExtractionScreen extends StatefulWidget {
  const AIDocumentExtractionScreen({super.key});
  @override
  State<AIDocumentExtractionScreen> createState() => _AIDocumentExtractionScreenState();
}

class _AIDocumentExtractionScreenState extends State<AIDocumentExtractionScreen> {
  bool _started = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _run();
  }

  Future<void> _run() async {
    final s = AppScope.read(context);
    try {
      final doc = s.documents.isNotEmpty ? s.documents.first : null;
      final extraction = await s.askAiJson(
        task: 'Propose the field-review checklist for the uploaded document described below.',
        userContent: 'Uploaded document: "${doc?.name ?? 'document'}"'
            '${doc != null ? ' (${doc.categoryLabel}, ${doc.size})' : ''}. '
            'Propose the field checklist for reviewing it. Reply with ONLY valid JSON shaped exactly like: '
            '{"docName":"...","confidence":"e.g. 92%","fields":[{"label":"...","value":"...","confidence":"e.g. 95%"}] (3-5 items),"note":"... or empty"}. '
            'Fill "value" ONLY from the case data; use "" when unknown and set its confidence low. '
            'Never invent ID numbers, dates, amounts, or authority names.',
        maxTokens: 1000,
      );
      if (!mounted) return;
      if (extraction['fields'] is! List) {
        setState(() => _error = 'The AI returned a response this app could not understand. Try again.');
        return;
      }
      Navigator.pushReplacementNamed(context, '/docs/review-extraction', arguments: {'extraction': extraction});
    } on AiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Something went wrong reaching the AI. Check your connection and settings, then try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('EXTRACTING…'),
                ],
              ),
              const SizedBox(height: 60),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const LbSpinner(size: 48, color: LbColors.accent),
              ),
              const SizedBox(height: 24),
              const LbH1('Reading your document…', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody('Your AI model is extracting key details.', color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbProcessingRow(text: 'Document type identified', done: true, spinner: false),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Reading fields…', done: false, spinner: true),
                    SizedBox(height: 12),
                    LbProcessingRow(text: 'Verifying against your case', done: false, spinner: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LbBody('AI will suggest fields. You can edit any of them.', color: LbColors.muted, size: 12, align: TextAlign.center),
              if (_error != null) ...[
                const SizedBox(height: 16),
                LbAIBubble(title: 'Something went wrong', message: _error!),
              ],
              const SizedBox(height: 24),
              if (_error != null)
                LbButton(label: 'Try again', onTap: () {
                  setState(() => _error = null);
                  _run();
                })
              else
                LbButton(label: 'Cancel', variant: LbButtonVariant.secondary, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewExtractionScreen extends StatelessWidget {
  const ReviewExtractionScreen({super.key});

  static String _str(Map m, String key) => m[key] is String ? (m[key] as String) : '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final extraction = args is Map && args['extraction'] is Map<String, dynamic>
        ? args['extraction'] as Map<String, dynamic>
        : null;
    final fields = extraction == null
        ? const <Map<String, dynamic>>[]
        : [for (final e in (extraction['fields'] as List)) if (e is Map<String, dynamic>) e];
    if (extraction == null || fields.isEmpty) {
      return Scaffold(
        backgroundColor: LbColors.bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                    const SizedBox(width: 12),
                    const LbEyebrow('REVIEW'),
                  ],
                ),
                const SizedBox(height: 12),
                const LbAIBubble(
                  title: 'Nothing to review yet',
                  message: 'Extract a document first — the fields to review appear here.',
                ),
                const SizedBox(height: 16),
                LbButton(label: 'Extract a document', onTap: () => Navigator.pushReplacementNamed(context, '/docs/extraction')),
              ],
            ),
          ),
        ),
      );
    }
    final docName = _str(extraction, 'docName');
    final confidence = _str(extraction, 'confidence');
    final note = _str(extraction, 'note');
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  LbCircleButton(icon: Icons.chevron_left, size: 44, background: LbColors.surface, foreground: LbColors.fg, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const LbEyebrow('REVIEW'),
                ],
              ),
              const SizedBox(height: 12),
              const LbH1('Review what we read.'),
              const SizedBox(height: 8),
              LbBody('Tap any field to edit. We use this to fill applications.', color: LbColors.muted),
              const SizedBox(height: 16),
              LbAIBubble(
                title: 'AI extracted',
                message: '${fields.length} fields${docName.isEmpty ? '' : ' from "$docName"'}${confidence.isEmpty ? '.' : ' — confidence $confidence.'}',
              ),
              const SizedBox(height: 12),
              LbCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (int i = 0; i < fields.length; i++) ...[
                      if (i > 0) const Divider(color: LbColors.borderSoft, height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LbEyebrow(_str(fields[i], 'label').isEmpty ? 'FIELD ${i + 1}' : _str(fields[i], 'label').toUpperCase()),
                                  const SizedBox(height: 4),
                                  Text(
                                    _str(fields[i], 'value').isEmpty ? '—' : _str(fields[i], 'value'),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            LbPill(label: _str(fields[i], 'confidence').isEmpty ? '?' : _str(fields[i], 'confidence'), variant: _str(fields[i], 'value').isEmpty ? PillVariant.warn : PillVariant.success),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (note.isNotEmpty) ...[
                const SizedBox(height: 12),
                LbInfoBanner(
                  title: 'Note.',
                  body: note,
                  background: LbColors.warnBg,
                  borderColor: Colors.transparent,
                  icon: Icons.warning_amber_outlined,
                  iconColor: LbColors.warn,
                  iconBg: LbColors.surface,
                ),
              ],
              const SizedBox(height: 24),
              LbButton(label: 'Confirm and save', onTap: () => Navigator.pushReplacementNamed(context, '/docs/added')),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentAddedScreen extends StatelessWidget {
  const DocumentAddedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: LbColors.successBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check_circle, color: LbColors.emerald, size: 40),
              ),
              const SizedBox(height: 24),
              const LbH1('Document added.', align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("Income certificate is now in Ramakrishna's case.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 24),
              LbCard(
                child: Row(
                  children: const [
                    LbIconTile(icon: Icons.check, background: LbColors.successBg, foreground: LbColors.emerald, size: 40, iconSize: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Income certificate', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('4 fields extracted · PDF · 1.2 MB', style: TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LbInfoBanner(
                title: 'Unlocked:',
                body: '3 programs can now be applied to — Heart Care Trust, Seva Community Fund, State Treatment Scheme.',
                background: LbColors.successBg,
                borderColor: Colors.transparent,
                icon: Icons.check_circle_outline,
                iconColor: LbColors.emerald,
                iconBg: LbColors.surface,
              ),
              const Spacer(),
              LbButton(label: 'Back to home', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
              const SizedBox(height: 8),
              LbButton(label: 'Start an application', variant: LbButtonVariant.secondary, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/app/create', (_) => false)),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentErrorScreen extends StatelessWidget {
  const DocumentErrorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LbColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: LbColors.dangerBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.error_outline, color: LbColors.danger, size: 36),
              ),
              const SizedBox(height: 24),
              const LbH1("Upload didn't go through.", align: TextAlign.center),
              const SizedBox(height: 8),
              LbBody("We couldn't read the file. Try again with a clearer photo or a different format.", color: LbColors.muted, align: TextAlign.center),
              const SizedBox(height: 20),
              LbCard(
                background: LbColors.dangerBg,
                borderColor: Colors.transparent,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.4),
                    children: [
                      TextSpan(text: 'What we know: ', style: TextStyle(fontWeight: FontWeight.w600, color: LbColors.danger)),
                      TextSpan(text: 'The file appears to be password-protected or corrupted. Error code: '),
                      TextSpan(text: '#DOC-4102', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LbCard(
                background: LbColors.surface2,
                borderColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LbEyebrow('TRY THIS'),
                    SizedBox(height: 8),
                    _TipRow(n: 1, text: 'Re-take the photo in good light'),
                    SizedBox(height: 6),
                    _TipRow(n: 2, text: 'Make sure the whole page is in frame'),
                    SizedBox(height: 6),
                    _TipRow(n: 3, text: 'Use JPG or PDF, under 25 MB'),
                  ],
                ),
              ),
              const Spacer(),
              LbButton(label: 'Try again', onTap: () => Navigator.pushReplacementNamed(context, '/docs/upload')),
              const SizedBox(height: 8),
              LbButton(label: 'Contact support', variant: LbButtonVariant.ghost, onTap: () => Navigator.pushNamed(context, '/ai/human')),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final int n;
  final String text;
  const _TipRow({required this.n, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text('$n', style: const TextStyle(color: LbColors.accent, fontSize: 10, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}
