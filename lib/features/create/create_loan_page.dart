import 'package:flutter/material.dart';
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
          content: Text(
              'Loan request submitted. We\'ll review it before publishing.')),
    );
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Loan')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Loan Purpose',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          PurposeGrid(
              selected: _purpose,
              onChanged: (p) => setState(() => _purpose = p)),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text('Loan Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                      labelText:
                          'Loan title (e.g., Expand my bakery business)'),
                  validator: (v) => (v == null || v.trim().length < 6)
                      ? 'Add a descriptive title'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _desc,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText:
                        'Describe your loan purpose and how you plan to use the funds...',
                  ),
                  validator: (v) => (v == null || v.trim().length < 20)
                      ? 'Give more details (at least 20 chars)'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          prefixText: '\$ ', labelText: 'Amount'),
                      validator: (v) {
                        final d =
                            double.tryParse((v ?? '').replaceAll(',', ''));
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
                          suffixText: '%', labelText: 'Interest Rate'),
                      validator: (v) {
                        final d =
                            double.tryParse((v ?? '').replaceAll(',', ''));
                        if (d == null || d <= 0) return 'Enter %';
                        return null;
                      },
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _term,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      labelText: 'Repayment term (months)'),
                  validator: (v) {
                    final i = int.tryParse(v ?? '');
                    if (i == null || i <= 0) return 'Enter months';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Submit Loan Request',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'By submitting this request, you agree to our terms and conditions. '
                  'Your request will be reviewed before being published to investors.',
                  style: TextStyle(color: Colors.black54),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
