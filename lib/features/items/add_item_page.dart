import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_theme.dart';
import '../../data/models/collateral_item.dart';
import '../../widgets/pawneo_system_sheet.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _name = TextEditingController(text: 'MacBook Pro 14” M3');
  final _desc = TextEditingController(
    text: '16 GB RAM, 512 GB SSD, Space Gray. Excellent condition, original charger and box included.',
  );
  final _value = TextEditingController(text: '1620');

  ItemCategory _category = ItemCategory.laptop;
  Uint8List? _photoBytes;
  String? _photoName;
  bool _isAnalyzing = false;
  bool _valuationReady = false;
  double _pawneoScore = 8.8;
  double _marketValue = 1620;

  double get _creditLine => _marketValue * 0.75;
  double get _monthlyYield => _creditLine * 0.0074;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _value.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 82,
        maxWidth: 1600,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      setState(() {
        _photoBytes = bytes;
        _photoName = image.name;
        _isAnalyzing = true;
        _valuationReady = false;
      });
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _valuationReady = true;
        _marketValue = double.tryParse(_value.text.replaceAll(',', '')) ?? 1620;
        _pawneoScore = _scoreFor(_category, _marketValue);
      });
      _showValuationSheet();
    } catch (_) {
      if (!mounted) return;
      PawneoSystemSheet.show(
        context,
        type: PawneoNoticeType.warning,
        title: 'Camera access needs a nudge',
        message:
            'Android may ask for camera or gallery permissions. Grant access and try again to create an instant valuation.',
        primaryLabel: 'Understood',
      );
    }
  }

  double _scoreFor(ItemCategory category, double value) {
    final base = switch (category) {
      ItemCategory.watch => 9.1,
      ItemCategory.jewelry => 8.6,
      ItemCategory.laptop => 8.8,
      ItemCategory.phone => 8.4,
      ItemCategory.camera => 8.2,
      ItemCategory.bike => 7.8,
      ItemCategory.console => 7.6,
      ItemCategory.other => 7.1,
    };
    final valueBoost = value > 1200 ? 0.25 : value > 650 ? 0.12 : 0.0;
    return (base + valueBoost).clamp(6.5, 9.6);
  }

  void _refreshValuation() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _marketValue = double.tryParse(_value.text.replaceAll(',', '')) ?? 1620;
      _pawneoScore = _scoreFor(_category, _marketValue);
      _valuationReady = true;
    });
    _showValuationSheet();
  }

  void _showValuationSheet() {
    PawneoSystemSheet.show(
      context,
      type: PawneoNoticeType.action,
      title: 'Ready to pawnear',
      message:
          '${_name.text.trim().isEmpty ? 'Your object' : _name.text.trim()} has an instant Pawneo Score of ${_pawneoScore.toStringAsFixed(1)}. You can unlock ${money(_creditLine)} while keeping ownership.',
      primaryLabel: 'Confirm pawning',
      secondaryLabel: 'Share score later',
      onPrimary: _submit,
      bullets: [
        PawneoBullet(
          icon: Icons.auto_awesome_rounded,
          title: 'AI valuation',
          subtitle: 'Market range: ${money(_marketValue * .92)} - ${money(_marketValue * 1.08)}',
        ),
        PawneoBullet(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Instant line',
          subtitle: 'Estimated collateral credit: ${money(_creditLine)}',
        ),
        PawneoBullet(
          icon: Icons.ios_share_rounded,
          title: 'Viral card',
          subtitle: 'A shareable Pawneo Score card is prepared after confirmation.',
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    PawneoSystemSheet.show(
      context,
      type: PawneoNoticeType.success,
      title: 'Object pawneoed',
      message:
          'Your valuation is locked. Pawneo will now prepare custody instructions, insurance coverage and pool-matching for this object.',
      primaryLabel: 'Amazing',
      bullets: [
        PawneoBullet(
          icon: Icons.local_shipping_rounded,
          title: 'Custody kit',
          subtitle: 'Shipping or drop-off instructions will appear in My Items.',
        ),
        PawneoBullet(
          icon: Icons.map_rounded,
          title: 'Pool matching',
          subtitle: 'The object will be matched with the best active loan portfolios.',
        ),
        PawneoBullet(
          icon: Icons.verified_user_rounded,
          title: 'Ownership protected',
          subtitle: 'You keep ownership unless the collateral agreement is executed.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan & pawneo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => PawneoSystemSheet.show(
              context,
              type: PawneoNoticeType.info,
              title: 'How instant pawning works',
              message:
                  'Take a photo, let Pawneo estimate value and liquidity, then choose whether to activate collateral. This demo uses mock valuation logic but keeps the real camera/gallery flow.',
              primaryLabel: 'Got it',
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _ScanHero(
                isAnalyzing: _isAnalyzing,
                photoBytes: _photoBytes,
                photoName: _photoName,
                valuationReady: _valuationReady,
                onCamera: () => _pick(ImageSource.camera),
                onGallery: () => _pick(ImageSource.gallery),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Object profile',
                      style: theme.textTheme.titleLarge?.copyWith(letterSpacing: -0.2),
                    ),
                  ),
                  if (_valuationReady)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Score ${_pawneoScore.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _CategoryGrid(
              selected: _category,
              onChanged: (c) => setState(() {
                _category = c;
                _pawneoScore = _scoreFor(c, _marketValue);
              }),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F1B2B5B),
                        blurRadius: 32,
                        offset: Offset(0, 22),
                      ),
                    ],
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Valuation details',
                        style: theme.textTheme.titleLarge?.copyWith(letterSpacing: -0.2),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                          labelText: 'Item name',
                          hintText: 'e.g. MacBook Pro 14 M3',
                        ),
                        validator: (v) => (v == null || v.trim().length < 4)
                            ? 'Give a descriptive name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _desc,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.notes_rounded),
                          labelText: 'Condition & accessories',
                          hintText: 'Model, condition, box, invoices, accessories...',
                        ),
                        validator: (v) => (v == null || v.trim().length < 10)
                            ? 'Add more details'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _value,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          prefixIcon: Icon(Icons.sell_outlined),
                          labelText: 'AI market value',
                          hintText: 'Estimated value',
                        ),
                        validator: (v) {
                          final d = double.tryParse((v ?? '').replaceAll(',', ''));
                          if (d == null || d <= 0) return 'Enter a value';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _ValuationSummary(
                        score: _pawneoScore,
                        marketValue: _marketValue,
                        creditLine: _creditLine,
                        monthlyYield: _monthlyYield,
                        ready: _valuationReady,
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _refreshValuation,
                          icon: const Icon(Icons.pets_rounded),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('Pawnear this object'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Demo mode: values are simulated. In production, Pawneo would connect to pricing, fraud, custody and insurance services.',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 92)),
        ],
      ),
    );
  }
}

class _ScanHero extends StatelessWidget {
  final bool isAnalyzing;
  final Uint8List? photoBytes;
  final String? photoName;
  final bool valuationReady;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _ScanHero({
    required this.isAnalyzing,
    required this.photoBytes,
    required this.photoName,
    required this.valuationReady,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppShadows.primary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              right: -60,
              top: -70,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scan to Pawneo',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AI valuation, score and collateral line in seconds.',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _CameraPreviewFrame(
                    isAnalyzing: isAnalyzing,
                    photoBytes: photoBytes,
                    photoName: photoName,
                    valuationReady: valuationReady,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onCamera,
                          icon: const Icon(Icons.photo_camera_rounded),
                          label: const Text('Camera'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF182052),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onGallery,
                          icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
                          label: const Text('Gallery'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withOpacity(0.32)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraPreviewFrame extends StatelessWidget {
  final bool isAnalyzing;
  final Uint8List? photoBytes;
  final String? photoName;
  final bool valuationReady;

  const _CameraPreviewFrame({
    required this.isAnalyzing,
    required this.photoBytes,
    required this.photoName,
    required this.valuationReady,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.04,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111827).withOpacity(0.58),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (photoBytes != null)
                Image.memory(photoBytes!, fit: BoxFit.cover)
              else
                const _SyntheticCameraSurface(),
              Container(color: Colors.black.withOpacity(photoBytes == null ? 0 : 0.16)),
              const _CornerFrame(alignment: Alignment.topLeft),
              const _CornerFrame(alignment: Alignment.topRight),
              const _CornerFrame(alignment: Alignment.bottomLeft),
              const _CornerFrame(alignment: Alignment.bottomRight),
              if (isAnalyzing) const _ScanLine(),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isAnalyzing
                            ? Icons.auto_awesome_rounded
                            : valuationReady
                                ? Icons.verified_rounded
                                : Icons.center_focus_strong_rounded,
                        color: valuationReady ? const Color(0xFF7DF5D0) : Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isAnalyzing
                              ? 'Analyzing object, condition and liquidity...'
                              : valuationReady
                                  ? 'Valuation locked from ${photoName ?? 'captured photo'}'
                                  : 'Point at an object or upload a photo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyntheticCameraSurface extends StatelessWidget {
  const _SyntheticCameraSurface();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.05, -0.2),
          radius: 0.9,
          colors: [Color(0xFF4EDBFF), Color(0xFF334155), Color(0xFF0F172A)],
        ),
      ),
      child: Center(
        child: Container(
          width: 150,
          height: 104,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.24)),
          ),
          child: const Icon(Icons.laptop_mac_rounded, color: Colors.white70, size: 72),
        ),
      ),
    );
  }
}

class _CornerFrame extends StatelessWidget {
  final Alignment alignment;
  const _CornerFrame({required this.alignment});

  @override
  Widget build(BuildContext context) {
    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    return Align(
      alignment: alignment,
      child: Container(
        width: 52,
        height: 52,
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: Color(0xFF7DF5D0), width: 4) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: Color(0xFF7DF5D0), width: 4) : BorderSide.none,
            left: isLeft ? const BorderSide(color: Color(0xFF7DF5D0), width: 4) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: Color(0xFF7DF5D0), width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ScanLine extends StatefulWidget {
  const _ScanLine();

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Positioned(
        left: 22,
        right: 22,
        top: 42 + (MediaQuery.of(context).size.width * 0.48 * _controller.value),
        child: Container(
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            gradient: const LinearGradient(
              colors: [Colors.transparent, Color(0xFF7DF5D0), Colors.transparent],
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x997DF5D0), blurRadius: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValuationSummary extends StatelessWidget {
  final double score;
  final double marketValue;
  final double creditLine;
  final double monthlyYield;
  final bool ready;

  const _ValuationSummary({
    required this.score,
    required this.marketValue,
    required this.creditLine,
    required this.monthlyYield,
    required this.ready,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ready ? const Color(0xFFF0FFFB) : Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ready ? const Color(0xFFB9F3E4) : const Color(0xFFE3E7F4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _ScoreRing(score: score),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pawneo Score', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      ready
                          ? 'High-liquidity object. Eligible for fast collateralization.'
                          : 'Capture or upload a photo to generate the score.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Metric(label: 'Market value', value: money(marketValue))),
              Expanded(child: _Metric(label: 'Credit line', value: money(creditLine))),
              Expanded(child: _Metric(label: 'Yield/mo', value: '+${money(monthlyYield)}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final double score;
  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 10,
            strokeWidth: 8,
            backgroundColor: const Color(0xFFE5EAF7),
            color: Colors.teal.shade600,
          ),
          Text(score.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 3),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: Colors.black87),
        ),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final ItemCategory selected;
  final ValueChanged<ItemCategory> onChanged;
  const _CategoryGrid({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = ItemCategory.values;
    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, i) {
        final c = items[i];
        final isSel = c == selected;
        return InkWell(
          onTap: () => onChanged(c),
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: isSel ? AppGradients.accent : null,
              color: isSel ? null : Colors.white,
              border: Border.all(
                color: isSel ? Colors.transparent : const Color(0xFFE7E9EF),
                width: 1.5,
              ),
              boxShadow: isSel
                  ? AppShadows.primary
                  : const [
                      BoxShadow(
                        color: Color(0x08243153),
                        blurRadius: 16,
                        offset: Offset(0, 10),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  c.icon,
                  size: 26,
                  color: isSel ? Colors.white : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  c.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSel ? Colors.white : Colors.black87,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
