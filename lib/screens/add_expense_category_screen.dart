import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/category.dart';
import 'package:smart_fin/data/services/apis/category_services.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/cards/category_card.dart';

class AddExpenseCategoryScreen extends StatefulWidget {
  const AddExpenseCategoryScreen({super.key});

  @override
  State<AddExpenseCategoryScreen> createState() =>
      _AddExpenseCategoryScreenState();
}

class _AddExpenseCategoryScreenState extends State<AddExpenseCategoryScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameCtl;
  late CategoryService _categoryService;

  late String icon, nameDemo;
  late int color, currentIconIndex, currentColorIndex;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _nameCtl = TextEditingController();
    _categoryService = CategoryService();

    icon = Constant.categoryIcons[0];
    color = Constant.colors[0];

    nameDemo = _nameCtl.text;
    currentIconIndex = 0;
    currentColorIndex = 0;
  }

  void _processCreateCategory() {
    if (_formKey.currentState!.validate()) {
      _categoryService.createNewCategory(
        context: context,
        name: _nameCtl.text,
        icon: icon,
        color: color,
      );
      if (mounted) {
        showCustomSnackBar(context, "New category created!", Constant.contentTypes["success"]!);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  String? _validateCategoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a category name";
    }
    if (!RegExp(Constant.nameRegex).hasMatch(value)) {
      return "Jar name must contain only letters and spaces";
    }
    if (value.length < 3) {
      return "Jar name must have at least than 3 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add expense category"),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CategoryCard(
                    Category(
                      id: "",
                      name: nameDemo,
                      icon: icon,
                      color: color,
                    ),
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _nameCtl,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(IconlyLight.paper),
                    ),
                    onChanged: (value) => setState(() {
                      nameDemo = value;
                    }),
                    validator: (value) => _validateCategoryName(value),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GridView.builder(
                      itemCount: Constant.categoryIcons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: currentIconIndex == index
                                ? Color(color)
                                : Colors.transparent,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            currentIconIndex = index;
                            icon = Constant.categoryIcons[index];
                          }),
                          child: IconButton(
                            onPressed: null,
                            icon: SvgPicture.asset(
                              Constant.categoryIcons[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GridView.builder(
                      itemCount: Constant.colors.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => setState(() {
                          currentColorIndex = index;
                          color = Constant.colors[index];
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(Constant.colors[index]),
                            border: Border.all(
                              color: currentColorIndex == index
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _processCreateCategory(),
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
