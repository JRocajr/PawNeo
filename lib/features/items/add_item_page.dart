import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../data/models/collateral_item.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  ItemCategory _category = ItemCategory.phone;
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _value = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _value.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Item submitted for valuation. We\'ll notify you within 24 hours.'),
      ),
    );
    _formKey.currentState!.reset();
    setState(() => _category = ItemCategory.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help center coming soon.')),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AddHero(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Select category',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                _CategoryGrid(
                  selected: _category,
                  onChanged: (c) => setState(() => _category = c),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
                          offset: Offset(0, 22)),
                    ],
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withOpacity(0.6)),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item details',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(letterSpacing: -0.2),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Item name',
                          hintText: 'e.g. iPhone 15 Pro Max 256GB',
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
                          labelText: 'Description & condition',
                          hintText:
                              'Describe your item: model, condition, accessories included, etc.',
                        ),
                        validator: (v) => (v == null || v.trim().length < 10)
                            ? 'Add more details (at least 10 characters)'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _value,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          labelText: 'Estimated market value',
                          hintText: 'Your best estimate',
                        ),
                        validator: (v) {
                          final d =
                              double.tryParse((v ?? '').replaceAll(',', ''));
                          if (d == null || d <= 0) return 'Enter a value';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color:
                                    Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Our team will verify and appraise your item. The accepted collateral value may differ from your estimate.',
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('Submit for valuation'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'By submitting, you agree to ship or deliver the item for custody once valued. Items remain your property until executed.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _AddHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.primary,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monetize your idle objects',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white, letterSpacing: -0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'Submit an item to be valued and used as collateral. Earn yield without selling it.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              _HeroStep(index: 1, label: 'Submit'),
              SizedBox(width: 10),
              _HeroStep(index: 2, label: 'Valuate'),
              SizedBox(width: 10),
              _HeroStep(index: 3, label: 'Custody'),
              SizedBox(width: 10),
              _HeroStep(index: 4, label: 'Earn'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStep extends StatelessWidget {
  final int index;
  final String label;
  const _HeroStep({required this.index, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Text('$index',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 13)),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
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
        final bool isSel = c == selected;
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
                color: isSel
                    ? Colors.transparent
                    : const Color(0xFFE7E9EF),
                width: 1.5,
              ),
              boxShadow: isSel
                  ? AppShadows.primary
                  : const [
                      BoxShadow(
                          color: Color(0x08243153),
                          blurRadius: 16,
                          offset: Offset(0, 10)),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  c.icon,
                  size: 26,
                  color: isSel
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  c.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSel ? Colors.white : Colors.black87,
                        fontWeight:
                            isSel ? FontWeight.w700 : FontWeight.w600,
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
