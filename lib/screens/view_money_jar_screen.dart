import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/apis/money_jar_services.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/edit_money_jar_screen.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

class ViewMoneyJarScreen extends StatefulWidget {
  const ViewMoneyJarScreen({super.key});

  @override
  State<ViewMoneyJarScreen> createState() => _ViewMoneyJarScreenState();
}

class _ViewMoneyJarScreenState extends State<ViewMoneyJarScreen> {
  late List<MoneyJarCard> _jarCardList;
  late MoneyJarService _moneyJarService;
  @override
  void initState() {
    super.initState();
    _jarCardList = [];
    _moneyJarService = MoneyJarService();
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
        child: ListView.separated(
          itemCount: _jarCardList.length,
          separatorBuilder: (context, index) => const Gap(10),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => EditMoneyJarScreen(
                            jarId: _jarCardList[index].moneyJar.id,
                          ),
                        ),
                      ),
                      child: _jarCardList[index],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _jarCardList[index].moneyJar.status
                            ? Colors.red
                            : Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: _getAction(_jarCardList[index].moneyJar),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconButton _getAction(MoneyJar jar) {
    return IconButton(
      onPressed: () => _handleChangeMoneyJarStatus(
        jar.id,
      ),
      icon: jar.status
          ? const Icon(
              IconlyLight.delete,
              color: Colors.red,
            )
          : Icon(
              IconlyLight.plus,
              color: Theme.of(context).colorScheme.secondary,
            ),
    );
  }

  void _handleChangeMoneyJarStatus(String jarId) {
    _moneyJarService.updateMoneyJarStatus(context: context, id: jarId);
  }
}
