import 'package:budget/src/service/database_service.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final priceController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

  int type = 0;

  var budgets = <dynamic>[];

  double currentPrice = 0;
  double gonePrice = 0;
  double comingPrice = 0;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    initBudgets();
    FlutterNativeSplash.remove();
  }

  void initBudgets() {
    DatabaseHelperService.getBudgets().then((value) {
      budgets = value;
      currentPrice = 0;
      gonePrice = 0;
      comingPrice = 0;
      totalPrice = 0;
      for (var item in budgets) {
        if (item['type'] == 0) {
          currentPrice += double.parse(item['price']);
        } else if (item['type'] == 1) {
          comingPrice += double.parse(item['price']);
        } else {
          gonePrice += double.parse(item['price']);
        }
      }
      totalPrice = currentPrice + comingPrice - gonePrice;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: budgets.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemBuilder: (context, index) {
                  final item = budgets[index];
                  return buildCard(item);
                },
              ),
              buildPrices('Current', currentPrice, Colors.black),
              const SizedBox(height: 16),
              buildPrices('Coming', comingPrice, const Color(0xff44B578)),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 10),
                child: buildPrices('Gone', gonePrice, Colors.red.shade800),
              ),
              const Divider(),
              const SizedBox(height: 10),
              buildPrices('Total', totalPrice, const Color(0xff0A152F)),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Budgets',
        style: TextStyle(color: Color(0xff14D1C5), fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      backgroundColor: const Color(0xff0A152F),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              buildDialog(context);
            },
            child: Image.asset(
              'assets/icons/plus.png',
              height: 20,
              color: const Color(0xff14D1C5),
            ),
          ),
        ),
      ],
    );
  }

  void buildDialog(BuildContext context, {item}) {
    showDialog(
      context: context,
      builder: (context) {
        if (item != null) {
          titleController.text = item['title'];
          descriptionController.text = item['description'];
          priceController.text = item['price'] + ',00';
          type = item['type'];
        } else {
          titleController.clear();
          descriptionController.clear();
          priceController.clear();
          type = 0;
        }
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              title: const Text(
                'New Budget',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0A152F),
                  fontSize: 14,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: TextFormField(
                        maxLines: 5,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      maxLines: 1,
                      controller: priceController,
                      decoration: InputDecoration(
                        hintText: 'Price',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                value: 0,
                                groupValue: type,
                                onChanged: (int? value) {
                                  setState(() {
                                    type = value!;
                                  });
                                },
                              ),
                              Text(
                                'Normal',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: type,
                                onChanged: (int? value) {
                                  setState(() {
                                    type = value!;
                                  });
                                },
                              ),
                              const Text(
                                'Coming',
                                style: TextStyle(color: Color(0xff44B578)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                value: 2,
                                groupValue: type,
                                onChanged: (int? value) {
                                  setState(() {
                                    type = value!;
                                  });
                                },
                              ),
                              Text(
                                'Gone',
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (item != null) {
                          await DatabaseHelperService.updateBudget(
                            titleController.text,
                            descriptionController.text,
                            priceController.text,
                            type,
                            item['id'],
                          );
                        } else {
                          await DatabaseHelperService.createBudget(
                            titleController.text,
                            descriptionController.text,
                            priceController.text,
                            type,
                          );
                        }
                        initBudgets();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xff0A152F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          item != null ? 'Update' : 'Create',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  GestureDetector buildCard(item) {
    return GestureDetector(
      onLongPress: () {
        buildDialog(context, item: item);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
                if (item['type'] == 0)
                  Text(
                    NumberFormat.simpleCurrency(locale: 'tr', decimalDigits: 2)
                        .format(double.parse(item['price']))
                        .substring(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0A152F),
                      fontSize: 15,
                    ),
                  )
                else if (item['type'] == 1)
                  Text(
                    '+${NumberFormat.simpleCurrency(locale: 'tr', decimalDigits: 2).format(double.parse(item['price'])).substring(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff44B578),
                      fontSize: 15,
                    ),
                  )
                else
                  Text(
                    '-${NumberFormat.simpleCurrency(locale: 'tr', decimalDigits: 2).format(double.parse(item['price'])).substring(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade800,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
            GestureDetector(
              onLongPress: () async {
                await DatabaseHelperService.deleteBudget(item['id']);
                initBudgets();
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildPrices(text, double price, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$text Price',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          '${text == 'Coming' ? '+' : text == 'Gone' ? '-' : ''} ${NumberFormat.simpleCurrency(locale: 'tr', decimalDigits: 2).format(price).substring(text == 'Total' ? 2 : 2)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
