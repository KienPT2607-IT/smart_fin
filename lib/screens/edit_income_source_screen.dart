import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/controllers/income_source_controller.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/data/services/apis/income_source_services.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/cards/income_source_card.dart';

class EditIncomeSourceScreen extends StatefulWidget {
  final String id;
  const EditIncomeSourceScreen({super.key, required this.id});

  @override
  State<EditIncomeSourceScreen> createState() => _EditIncomeSourceScreenState();
}

class _EditIncomeSourceScreenState extends State<EditIncomeSourceScreen> {
  late GlobalKey<FormState> _key;
  late IncomeSourceService _incomeSourceService;
  late IncomeSourceController _incomeSourceCtrl;
  late IncomeSource _incomeSource;
  late String _sourceName;
  late int _currentColorIndex, _currentIconIndex;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    _incomeSourceService = IncomeSourceService();
    _incomeSourceCtrl = IncomeSourceController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _incomeSource = Provider.of<IncomeSourceProvider>(
      context,
      listen: false,
    ).getSourceById(widget.id);
    _sourceName = _incomeSource.name;
    _currentColorIndex =
        Constant.colors.indexWhere((each) => each == _incomeSource.color);
    _currentIconIndex =
        Constant.categoryIcons.indexWhere((each) => each == _incomeSource.icon);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Income Source"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
                  child: IncomeSourceCard(
                    incomeSource: IncomeSource(
                      id: "",
                      name: _sourceName,
                      icon: Constant.categoryIcons[_currentIconIndex],
                      color: Constant.colors[_currentColorIndex],
                      status: true,
                    ),
                  ),
                ),
                const Gap(10),
                TextFormField(
                  initialValue: _sourceName,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(IconlyLight.paper),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _sourceName = value;
                    });
                  },
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
                          icon: SvgPicture.asset(Constant.categoryIcons[index]),
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
    );
  }

  void _processUpdate() async {
    if (_key.currentState!.validate()) {
      bool result = await _incomeSourceService.updateSourceDetail(
        context: context,
        id: widget.id,
        newName: _sourceName,
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
