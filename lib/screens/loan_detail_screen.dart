import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/friend.dart';
import 'package:smart_fin/data/models/loan.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/apis/loan_note_services.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/data/services/providers/loan_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/customs/custom_divider.dart';

class LoanDetailScreen extends StatefulWidget {
  final String loanId;
  const LoanDetailScreen({super.key, required this.loanId});

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  late Loan _loan;
  late Friend _friend;
  late MoneyJar _moneyJar;
  late bool _isDataFetched;

  late TextEditingController _noteCtrl;
  late LoanNoteService _loanNoteService;

  @override
  void initState() {
    super.initState();
    _isDataFetched = false;
    _noteCtrl = TextEditingController();
    _loanNoteService = LoanNoteService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _loan = Provider.of<LoanProvider>(context).getLoanById(widget.loanId);
      _friend = Provider.of<FriendProvider>(context, listen: false)
          .getFriendById(_loan.participantId);
      _moneyJar = Provider.of<MoneyJarProvider>(context, listen: false)
          .getJarById(_loan.moneyJar);
      _isDataFetched = true;
    }
  }

  SizedBox _customTitle(String title) {
    return SizedBox(
      width: 50,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Container _customJarCard(
    String name,
    int color,
    String icon,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(color),
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            icon,
            width: 24,
            color: Color(color),
          ),
          const Gap(10),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 150,
            ),
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showParticipantInfor(bool isLender) {
    if (isLender) {
      return _customJarCard(_moneyJar.name, _moneyJar.color, _moneyJar.icon);
    }
    return Column(
      children: [
        Text(_friend.name),
        (_friend.phoneNumber.isEmpty) ? Container() : Text(_friend.phoneNumber),
        (_friend.email.isEmpty) ? Container() : Text(_friend.email),
      ],
    );
  }

  void _updateLoanNote() {
    _loanNoteService.updateNote(
      context: context,
      loanId: widget.loanId,
      note: _noteCtrl.text,
    );
    showCustomSnackBar(context, "Note updated");
    Navigator.of(context).pop();
  }

  void _showEditNoteDialog() {
    _noteCtrl.text = _loan.note;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit note"),
          content: TextFormField(
            autofocus: true,
            minLines: 1,
            maxLines: 4,
            // initialValue: _expense.note,
            controller: _noteCtrl,
            decoration: const InputDecoration(hintText: "Note"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () => _updateLoanNote(),
            ),
          ],
        );
      },
    );
  }

  void _changeRepaidStatus() {
    _loanNoteService.updateRepaidStatus(
        context: context, loanId: widget.loanId);
    showCustomSnackBar(context, "Repaid changed");
    Navigator.pop(context);
  }

  void _showEditStatusConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Repaid changed"),
          content: const Text("Are you sure to remark this loan!"),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    onPressed: () => _changeRepaidStatus(),
                    child: const Text('Remark'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _deleteLoan() {}

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete confirmation"),
          content: const Text("Are you sure to delete this loan!"),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _deleteLoan(),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan detail"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFD5D5D7),
                        blurRadius: 16,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: (_loan.isRepaid)
                              ? Theme.of(context).colorScheme.secondary
                              : const Color(0XFFFFA400),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              (_loan.isRepaid)
                                  ? Constant.defaultRegularIcons["check"]!
                                  : Constant.defaultRegularIcons["uncheck"]!,
                              color: Colors.white,
                              width: 16,
                            ),
                            const Gap(10),
                            Center(
                              child: Text(
                                (_loan.isCreatorLender) ? "Lend" : "Borrow",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat("dd/MM/yyyy HH:mm")
                                        .format(_loan.createAt),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    (_loan.isCreatorLender)
                                        ? "-${_loan.amount}"
                                        : "+${_loan.amount}",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const CustomDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  _customTitle("FROM"),
                                  const Gap(10),
                                  _showParticipantInfor(_loan.isCreatorLender),
                                ],
                              ),
                            ),
                            const CustomDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  _customTitle("TO"),
                                  const Gap(10),
                                  _showParticipantInfor(!_loan.isCreatorLender),
                                ],
                              ),
                            ),
                            const CustomDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  _customTitle("NOTE"),
                                  const Gap(10),
                                  Flexible(
                                    child: Text(_loan.note),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _showEditNoteDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                Constant.defaultLightIcons["edit"]!),
                            const Gap(20),
                            const Text("Edit note"),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showEditStatusConfirmDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                Constant.defaultLightIcons["repaid"]!),
                            const Gap(20),
                            const Text("Edit repaid status"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                // height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Back"),
                      ),
                    ),
                    const Gap(32),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showDeleteConfirmDialog(),
                        child: const Text("Remove"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
