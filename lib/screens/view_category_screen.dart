import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/category.dart';
import 'package:smart_fin/data/services/apis/category_services.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/screens/edit_expense_category_screen.dart';
import 'package:smart_fin/utilities/widgets/cards/category_card_model.dart';

class ViewCategoryScreen extends StatefulWidget {
  const ViewCategoryScreen({super.key});

  @override
  State<ViewCategoryScreen> createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  late List<CategoryModelCard> _categoryCardList;
  late CategoryService _categoryService;
  @override
  void initState() {
    super.initState();
    _categoryCardList = [];
    _categoryService = CategoryService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoryCardList = Provider.of<CategoryProvider>(context)
        .categoryList
        .map((each) => CategoryModelCard(category: each))
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
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => EditExpenseCategoryScreen(
                                id: _categoryCardList[index].category.id,
                              ),
                            ),
                          );
                        },
                        child: _categoryCardList[index],
                      ),
                    ),
                    const Gap(10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _categoryCardList[index].category.status
                              ? Colors.red
                              : Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _getAction(_categoryCardList[index].category),
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

  IconButton _getAction(Category category) {
    return IconButton(
      onPressed: () => _handleChangeMoneyJarStatus(
        category.id,
      ),
      icon: category.status
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

  void _handleChangeMoneyJarStatus(String id) {
    _categoryService.updateCategoryStatus(context: context, id: id);
  }
}
