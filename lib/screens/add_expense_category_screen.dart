import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/controllers/expense_category_controller.dart';
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
  late TextEditingController _nameCtrl;
  late CategoryService _categoryService;
  late ExpenseCategoryController _categoryController;

  late String _icon, _nameDemo;
  late int _color, _currentIconIndex, _currentColorIndex;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _nameCtrl = TextEditingController();
    _categoryService = CategoryService();
    _categoryController = ExpenseCategoryController();

    _icon = Constant.categoryIcons[0];
    _color = Constant.colors[0];

    _nameDemo = _nameCtrl.text;
    _currentIconIndex = 0;
    _currentColorIndex = 0;
  }

  void _processCreateCategory() {
    if (_formKey.currentState!.validate()) {
      _categoryService.createNewCategory(
        context: context,
        name: _nameCtrl.text,
        icon: _icon,
        color: _color,
      );
      if (mounted) {
        showCustomSnackBar(
          context,
          "New category created!",
          Constant.contentTypes["success"]!,
        );
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
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
                      name: _nameDemo,
                      icon: _icon,
                      color: _color,
                      status: true,
                    ),
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(IconlyLight.paper),
                    ),
                    onChanged: (value) => setState(() {
                      _nameDemo = value;
                    }),
                    validator: (value) =>
                        _categoryController.validateName(value),
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
                            color: _currentIconIndex == index
                                ? Color(_color)
                                : Colors.transparent,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _currentIconIndex = index;
                            _icon = Constant.categoryIcons[index];
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
                          _currentColorIndex = index;
                          _color = Constant.colors[index];
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _currentColorIndex == index
                                    ? Color(Constant.colors[index])
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(Constant.colors[index]),
                              border: Border.all(
                                color: _currentColorIndex == index
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
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
