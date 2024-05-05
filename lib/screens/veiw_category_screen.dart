import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/utilities/widgets/cards/category_card.dart';

class ViewCategoryScreen extends StatefulWidget {
  const ViewCategoryScreen({super.key});

  @override
  State<ViewCategoryScreen> createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  late List<CategoryCard> _categoryCardList;
  @override
  void initState() {
    super.initState();
    _categoryCardList = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoryCardList = Provider.of<CategoryProvider>(context, listen: false)
        .categoryList
        .map((each) => CategoryCard(each))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My categories"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Expanded(
          child: ListView.separated(
            itemCount: _categoryCardList.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _categoryCardList[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
