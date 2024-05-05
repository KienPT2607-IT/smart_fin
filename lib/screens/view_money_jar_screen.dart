import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

class ViewMoneyJarScreen extends StatefulWidget {
  const ViewMoneyJarScreen({super.key});

  @override
  State<ViewMoneyJarScreen> createState() => _ViewMoneyJarScreenState();
}

class _ViewMoneyJarScreenState extends State<ViewMoneyJarScreen> {
  late List<MoneyJarCard> _jarCardList;

  @override
  void initState() {
    super.initState();
    _jarCardList = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jarCardList = Provider.of<MoneyJarProvider>(context)
        .moneyJarList
        .map((jar) => MoneyJarCard(moneyJar: jar))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Money jar"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Expanded(
          child: ListView.separated(
            itemCount: _jarCardList.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _jarCardList[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
