import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/controllers/expense_category_controller.dart';
import 'package:smart_fin/data/models/category.dart';
import 'package:smart_fin/data/services/apis/category_services.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/cards/category_card.dart';

class EditExpenseCategoryScreen extends StatefulWidget {
  final String id;
  const EditExpenseCategoryScreen({super.key, required this.id});

  @override
  State<EditExpenseCategoryScreen> createState() =>
      _EditExpenseCategoryScreenState();
}

class _EditExpenseCategoryScreenState extends State<EditExpenseCategoryScreen> {
  late Category _category;
  late CategoryService _categoryService;
  late GlobalKey<FormState> _formKey;
  late ExpenseCategoryController _categoryController;

  late int _currentIconIndex, _currentColorIndex;
  late String _categoryName;

  @override
  void initState() {
    super.initState();
    _categoryService = CategoryService();
    _formKey = GlobalKey();
    _categoryController = ExpenseCategoryController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _category = Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).getCategoryById(widget.id);
    _categoryName = _category.name;
    _currentColorIndex =
        Constant.colors.indexWhere((each) => each == _category.color);
    _currentIconIndex =
        Constant.categoryIcons.indexWhere((each) => each == _category.icon);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit expense category"),
          centerTitle: true,
        ),
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
                      name: _categoryName,
                      icon: Constant.categoryIcons[_currentIconIndex],
                      color: Constant.colors[_currentColorIndex],
                      status: true,
                    ),
                  ),
                  const Gap(10),
                  TextFormField(
                    initialValue: _categoryName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(IconlyLight.paper),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _categoryName = value;
                      });
                    },
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
                                ? Color(Constant.colors[_currentColorIndex])
                                : Colors.transparent,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _currentIconIndex = index;
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
                    onPressed: () => _processEditCategory(),
                    child: const Text("Edit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _processEditCategory() async {
    if (_formKey.currentState!.validate()) {
      bool result = await _categoryService.updateCategoryDetail(
        context: context,
        id: widget.id,
        newName: _categoryName,
        newIcon: Constant.categoryIcons[_currentIconIndex],
        newColor: Constant.colors[_currentColorIndex],
      );
      if (mounted) {
        if (!result) {
          showCustomSnackBar(
            context,
            "Failed to update!",
            Constant.contentTypes["failure"]!,
          );
        }
        Navigator.pop(context);
      }
    }
  }
}
