import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/controllers/income_source_controller.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/data/services/apis/income_source_services.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/widgets/cards/income_source_card.dart';

class AddIncomeSourceScreen extends StatefulWidget {
  const AddIncomeSourceScreen({super.key});

  @override
  State<AddIncomeSourceScreen> createState() => _AddIncomeSourceScreenState();
}

class _AddIncomeSourceScreenState extends State<AddIncomeSourceScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _sourceNameCtrl;

  late IncomeSourceController _incomeSourceCtrl;
  late IncomeSourceService _incomeSourceService;
  late String selectedIcon;
  late int selectedColor, currentIconIndex, currentColorIndex;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _sourceNameCtrl = TextEditingController();
    _incomeSourceCtrl = IncomeSourceController();
    _incomeSourceService = IncomeSourceService();

    selectedIcon = Constant.categoryIcons[0];
    selectedColor = Constant.colors[0];

    currentIconIndex = 0;
    currentColorIndex = 0;
  }

  _processCreateIncomeSource() {
    if (_formKey.currentState!.validate()) {
      _incomeSourceService.createNewSource(
        context: context,
        name: _sourceNameCtrl.text,
        icon: Constant.categoryIcons[currentIconIndex],
        color: Constant.colors[currentColorIndex],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add income source"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IncomeSourceCard(
                      incomeSource: IncomeSource(
                        id: "",
                        name: _sourceNameCtrl.text,
                        icon: selectedIcon,
                        color: selectedColor,
                      ),
                    ),
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _sourceNameCtrl,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(IconlyLight.paper),
                    ),
                    onChanged: (value) => setState(() {}),
                    validator: (value) =>
                        _incomeSourceCtrl.validateSourceName(value),
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
                                ? Color(selectedColor)
                                : Colors.transparent,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            currentIconIndex = index;
                            selectedIcon = Constant.categoryIcons[index];
                          }),
                          child: IconButton(
                            onPressed: null,
                            icon:
                                SvgPicture.asset(Constant.categoryIcons[index]),
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
                          selectedColor = Constant.colors[index];
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
                    onPressed: () => _processCreateIncomeSource(),
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
