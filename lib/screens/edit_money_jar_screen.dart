import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/controllers/money_jar_controller.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/apis/money_jar_services.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

class EditMoneyJarScreen extends StatefulWidget {
  final String jarId;
  const EditMoneyJarScreen({super.key, required this.jarId});

  @override
  State<EditMoneyJarScreen> createState() => _EditMoneyJarScreenState();
}

class _EditMoneyJarScreenState extends State<EditMoneyJarScreen> {
  late GlobalKey<FormState> _key;
  late MoneyJarController _moneyJarCtrl;
  late MoneyJarService _moneyJarService;
  late MoneyJar _moneyJar;
  late int _currentIconIndex, _currentColorIndex;
  late String _jarName;
  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    _moneyJarService = MoneyJarService();
    _moneyJarCtrl = MoneyJarController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moneyJar = Provider.of<MoneyJarProvider>(
      context,
      listen: false,
    ).getJarById(widget.jarId);
    _jarName = _moneyJar.name;
    _currentColorIndex =
        Constant.colors.indexWhere((each) => each == _moneyJar.color);
    _currentIconIndex =
        Constant.categoryIcons.indexWhere((each) => each == _moneyJar.icon);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Money Jar"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MoneyJarCard(
                      moneyJar: MoneyJar(
                        id: "",
                        name: _jarName,
                        balance: _moneyJar.balance,
                        icon: Constant.categoryIcons[_currentIconIndex],
                        color: Constant.colors[_currentColorIndex],
                        status: true,
                      ),
                    ),
                  ),
                  const Gap(10),
                  TextFormField(
                    initialValue: _jarName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Jar Name",
                      prefixIcon: Icon(IconlyLight.paper),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _jarName = value;
                      });
                    },
                    validator: (value) => _moneyJarCtrl.validateJarName(value),
                  ),
                  const Gap(10),
                  TextFormField(
                    initialValue: _moneyJar.balance.toString(),
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Current balance",
                      prefixIcon: Icon(IconlyLight.wallet),
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
                  const Gap(20),
                  ElevatedButton(
                    onPressed: () => _processUpdate(),
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

  void _processUpdate() async {
    if (_key.currentState!.validate()) {
      bool result = await _moneyJarService.updateJarDetail(
        context: context,
        id: widget.jarId,
        newName: _jarName,
        newIcon: Constant.categoryIcons[_currentIconIndex],
        newColor: Constant.colors[_currentColorIndex],
      );

      if (mounted) {
        if (!result) {
          showCustomSnackBar(
            context,
            "Failed to update money jar!",
            Constant.contentTypes["failure"]!,
          );
        }
        Navigator.of(context).pop();
      }
    }
  }
}
