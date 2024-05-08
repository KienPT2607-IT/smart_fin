import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/data/services/apis/income_source_services.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/screens/edit_income_source_screen.dart';
import 'package:smart_fin/utilities/widgets/cards/income_source_card.dart';

class ViewIncomeSourceScreen extends StatefulWidget {
  const ViewIncomeSourceScreen({super.key});

  @override
  State<ViewIncomeSourceScreen> createState() => _ViewIncomeSourceScreenState();
}

class _ViewIncomeSourceScreenState extends State<ViewIncomeSourceScreen> {
  late List<IncomeSourceCard> _sourceCardList;
  late IncomeSourceService _incomeSourceService;

  @override
  void initState() {
    super.initState();
    _sourceCardList = [];
    _incomeSourceService = IncomeSourceService();
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
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => EditIncomeSourceScreen(
                              id: _sourceCardList[index].incomeSource.id,
                            ),
                          ),
                        ),
                        child: _sourceCardList[index],
                      ),
                    ),
                    const Gap(10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _sourceCardList[index].incomeSource.status
                              ? Colors.red
                              : Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _getAction(_sourceCardList[index].incomeSource),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconButton _getAction(IncomeSource source) {
    return IconButton(
      onPressed: () => _handleChangeIncomeSourceStatus(
        source.id,
      ),
      icon: source.status
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

  void _handleChangeIncomeSourceStatus(String id) {
    _incomeSourceService.updateSourceStatus(context: context, id: id);
  }
}
