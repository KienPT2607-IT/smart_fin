import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/utilities/widgets/cards/income_source_card.dart';

class ViewIncomeSourceScreen extends StatefulWidget {
  const ViewIncomeSourceScreen({super.key});

  @override
  State<ViewIncomeSourceScreen> createState() => _ViewIncomeSourceScreenState();
}

class _ViewIncomeSourceScreenState extends State<ViewIncomeSourceScreen> {
  late List<IncomeSourceCard> _sourceCardList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sourceCardList = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sourceCardList = Provider.of<IncomeSourceProvider>(context)
        .incomeSourceList
        .map((source) => IncomeSourceCard(incomeSource: source))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My income sources"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Expanded(
          child: ListView.separated(
            itemCount: _sourceCardList.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _sourceCardList[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
