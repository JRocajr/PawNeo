import 'package:flutter/material.dart';
import '../../data/mock_repo.dart';
import '../../widgets/loan_card.dart';
import '../../data/models/loan.dart';

enum _Filter { all, active, funded }

enum _Sort { newest, amount, interest }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _Filter filter = _Filter.all;
  _Sort sort = _Sort.newest;

  List<Loan> _apply(List<Loan> input) {
    var list = input;
    if (filter == _Filter.active)
      list = list.where((l) => !l.isFunded).toList();
    if (filter == _Filter.funded) list = list.where((l) => l.isFunded).toList();

    switch (sort) {
      case _Sort.newest:
        list = List.of(list.reversed);
        break;
      case _Sort.amount:
        list.sort((a, b) => b.requested.compareTo(a.requested));
        break;
      case _Sort.interest:
        list.sort((a, b) => b.interest.compareTo(a.interest));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final loans = _apply(MockRepo.loans);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Pawneo — All Loans'),
          floating: true,
          actions: const [
            Padding(
                padding: EdgeInsets.only(right: 12), child: Icon(Icons.public))
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All Loans'),
                  selected: filter == _Filter.all,
                  onSelected: (_) => setState(() => filter = _Filter.all),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Active'),
                  selected: filter == _Filter.active,
                  onSelected: (_) => setState(() => filter = _Filter.active),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Funded'),
                  selected: filter == _Filter.funded,
                  onSelected: (_) => setState(() => filter = _Filter.funded),
                ),
                const Spacer(),
                const Text('Sort: '),
                const SizedBox(width: 6),
                DropdownButton<_Sort>(
                  value: sort,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                        value: _Sort.newest, child: Text('Newest')),
                    DropdownMenuItem(
                        value: _Sort.amount, child: Text('Amount')),
                    DropdownMenuItem(
                        value: _Sort.interest, child: Text('Interest')),
                  ],
                  onChanged: (v) => setState(() => sort = v ?? _Sort.newest),
                ),
              ],
            ),
          ),
        ),
        // DESPUÉS (compatible con todas las versiones estables recientes)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => LoanCard(loan: loans[i]),
            childCount: loans.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
