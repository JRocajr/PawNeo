import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../widgets/purpose_grid.dart';
import '../../data/models/loan.dart';

class CreateLoanPage extends StatefulWidget {
  const CreateLoanPage({super.key});

  @override
  State<CreateLoanPage> createState() => _CreateLoanPageState();
}

class _CreateLoanPageState extends State<CreateLoanPage> {
  final _formKey = GlobalKey<FormState>();
  LoanPurpose _purpose = LoanPurpose.business;

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _amount = TextEditingController();
  final _interest = TextEditingController();
  final _term = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _amount.dispose();
    _interest.dispose();
    _term.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loan request submitted. We\'ll review it before publishing.'),
      ),
    );
    _formKey.currentState!.reset();
    _purpose = LoanPurpose.business;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create loan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Support chat coming soon.')),
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
                children: const [
                  _CreateHero(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select loan purpose',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                PurposeGrid(
                  selected: _purpose,
                  onChanged: (p) => setState(() => _purpose = p),
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
                      BoxShadow(color: Color(0x0F1B2B5B), blurRadius: 32, offset: Offset(0, 22)),
                    ],
                    border:
                        Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6)),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loan details',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(letterSpacing: -0.2),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _title,
                        decoration: const InputDecoration(
                          labelText: 'Loan title',
                          hintText: 'Expand my bakery business',
                        ),
                        validator: (v) => (v == null || v.trim().length < 6)
                            ? 'Add a descriptive title'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _desc,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Describe your plan',
                          hintText:
                              'Tell investors how this loan will accelerate your project and how funds are used.',
                        ),
                        validator: (v) => (v == null || v.trim().length < 20)
                            ? 'Give more details (at least 20 characters)'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _amount,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                prefixText: '\$ ',
                                labelText: 'Requested amount',
                              ),
                              validator: (v) {
                                final d = double.tryParse((v ?? '').replaceAll(',', ''));
                                if (d == null || d <= 0) return 'Enter amount';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _interest,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                suffixText: '%',
                                labelText: 'Interest rate',
                              ),
                              validator: (v) {
                                final d = double.tryParse((v ?? '').replaceAll(',', ''));
                                if (d == null || d <= 0) return 'Enter %';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _term,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          labelText: 'Repayment term (months)',
                        ),
                        validator: (v) {
                          final i = int.tryParse(v ?? '');
                          if (i == null || i <= 0) return 'Enter months';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tip: keep interest between 6% and 15% to maximise investor demand.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      FilledButton(
                        onPressed: _submit,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Submit loan request'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'By submitting, you agree to our terms and conditions. Your request will be reviewed before being published to investors.',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateHero extends StatelessWidget {
  const _CreateHero();

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
            'Launch your loan',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white, letterSpacing: -0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'We\'ll guide you every step of the way. Complete the form below and our team will review within 24 hours.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              _HeroStep(index: 1, label: 'Loan info'),
              SizedBox(width: 12),
              _HeroStep(index: 2, label: 'Verification'),
              SizedBox(width: 12),
              _HeroStep(index: 3, label: 'Publish'),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Text(
                '$index',
                style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
