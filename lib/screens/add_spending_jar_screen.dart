import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/controllers/spending_jar_controller.dart';
import 'package:smart_fin/data/models/spending_jar.dart';
import 'package:smart_fin/data/services/apis/spending_jar_services.dart';
import 'package:smart_fin/data/services/providers/spending_jars_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/widgets/spending_jar_card.dart';

class AddSpendingJarScreen extends StatefulWidget {
  const AddSpendingJarScreen({super.key});

  @override
  State<AddSpendingJarScreen> createState() => _AddSpendingJarScreenState();
}

class _AddSpendingJarScreenState extends State<AddSpendingJarScreen> {
  late SpendingJarsProvider spendingJars;

  late GlobalKey<FormState> _formKey;
  late TextEditingController _jarNameCtrl, _currentAmountCtrl;

  late SpendingJarController _spendingJarController;
  late SpendingJarService _spendingJarService;
  late String icon, jarNameDemo;
  late double currentAmount;
  late int color, currentIconIndex, currentColorIndex;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _jarNameCtrl = TextEditingController();
    _currentAmountCtrl = TextEditingController();
    _spendingJarController = SpendingJarController();
    _spendingJarService = SpendingJarService();

    icon = Constant.categoryIcons[0];
    color = Constant.colors[0];

    currentIconIndex = 0;
    currentColorIndex = 0;
    jarNameDemo = "Jar name";
    currentAmount = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    spendingJars = Provider.of<SpendingJarsProvider>(context, listen: false);
  }

  void _processCreateSpendingJar() {
    if (_formKey.currentState!.validate()) {
      _spendingJarService.createNewJar(
        context: context,
        name: _jarNameCtrl.text,
        currentAmount: currentAmount,
        icon: icon,
        color: color,
      );
      // spendingJars.addSpendingJar(
      //   SpendingJar(
      //     id: "",
      //     name: _jarNameCtrl.text,
      //     currentAmount: currentAmount,
      //     icon: icon,
      //     color: color,
      //   ),
      // );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Add Spending Jar"),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SpendingJarCard(
                        spendingJar: SpendingJar(
                          id: "",
                          name: jarNameDemo,
                          currentAmount: currentAmount,
                          icon: icon,
                          color: color,
                        ),
                      ),
                    ),
                    const Gap(10),
                    TextFormField(
                      controller: _jarNameCtrl,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Jar Name",
                        prefixIcon: const Icon(IconlyLight.paper),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => setState(() {
                        jarNameDemo = value;
                      }),
                      validator: (value) =>
                          _spendingJarController.validateJarName(value),
                    ),
                    const Gap(10),
                    TextFormField(
                      controller: _currentAmountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Current amount",
                        // TODO: download and add to assets
                        prefixIcon: const Icon(IconlyLight.wallet),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => setState(() {
                        if (",".allMatches(value).length <= 1) {
                          currentAmount = (value.isEmpty)
                              ? 0
                              : double.parse(value.replaceAll(",", "."));
                        }
                      }),
                      validator: (value) =>
                          _spendingJarController.validateCurrentAmount(value),
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
                                  ? const Color(0xFF563D81)
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
                                  Constant.categoryIcons[index]),
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
                      onPressed: () => _processCreateSpendingJar(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF563D81),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Add Jar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
