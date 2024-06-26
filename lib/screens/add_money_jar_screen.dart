import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/controllers/money_jar_controller.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/apis/money_jar_services.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

class AddMoneyJarScreen extends StatefulWidget {
  const AddMoneyJarScreen({super.key});

  @override
  State<AddMoneyJarScreen> createState() => _AddMoneyJarScreenState();
}

class _AddMoneyJarScreenState extends State<AddMoneyJarScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _jarNameCtrl, _balanceCtrl;

  late MoneyJarController _moneyJarCtrl;
  late MoneyJarService _moneyJarService;
  late String _selectedIcon, jarNameDemo;
  late double balance;
  late int color, _currentIconIndex, _currentColorIndex;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _jarNameCtrl = TextEditingController();
    _balanceCtrl = TextEditingController();
    _moneyJarCtrl = MoneyJarController();
    _moneyJarService = MoneyJarService();

    _selectedIcon = Constant.categoryIcons[0];
    color = Constant.colors[0];

    _currentIconIndex = 0;
    _currentColorIndex = 0;
    jarNameDemo = "Jar name";
    balance = 0;
  }

  void _processCreateMoneyJar() {
    if (_formKey.currentState!.validate()) {
      _moneyJarService.createNewJar(
        context: context,
        name: _jarNameCtrl.text,
        balance: balance,
        icon: _selectedIcon,
        color: color,
      );
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
          title: const Text("Add money jar"),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    child: MoneyJarCard(
                      moneyJar: MoneyJar(
                        id: "",
                        name: jarNameDemo,
                        balance: balance,
                        icon: _selectedIcon,
                        color: color,
                        status: true,
                      ),
                    ),
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _jarNameCtrl,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Jar Name",
                      prefixIcon: Icon(IconlyLight.paper),
                    ),
                    onChanged: (value) => setState(() {
                      jarNameDemo = value;
                    }),
                    validator: (value) => _moneyJarCtrl.validateJarName(value),
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _balanceCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: "Current balance",
                      prefixIcon: Icon(IconlyLight.wallet),
                    ),
                    onChanged: (value) => setState(() {
                      if (",".allMatches(value).length <= 1) {
                        balance = (value.isEmpty)
                            ? 0
                            : double.parse(value.replaceAll(",", "."));
                      }
                    }),
                    validator: (value) => _moneyJarCtrl.validateBalance(value),
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
                                ? Color(color)
                                : Colors.transparent,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _currentIconIndex = index;
                            _selectedIcon = Constant.categoryIcons[index];
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
                          _currentColorIndex = index;
                          color = Constant.colors[index];
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
                    onPressed: () => _processCreateMoneyJar(),
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
