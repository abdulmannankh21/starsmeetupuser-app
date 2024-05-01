import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Apis/faqs_apis.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/faq_model.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List opened = [];

  List<PoliciesModel>? faqs;
  @override
  void initState() {
    super.initState();
    getFaqs();
  }

  getFaqs() async {
    opened.clear();
    faqs = await FaqsService().getFAQs();
    if (faqs != null) {
      for (int i = 0; i < faqs!.length; i++) {
        opened.add(false);
      }
    }
    if (kDebugMode) {
      print(faqs);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  Text(
                    "FAQs",
                    style: twentyTwo700TextStyle(color: purpleColor),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              faqs == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: CupertinoActivityIndicator(),
                        )
                      ],
                    )
                  : faqs!.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 300,
                            ),
                            Center(
                              child: Text(
                                "No FAQs Available",
                                style: sixteen700TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i < faqs!.length; i++)
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        opened[i] = !opened[i];
                                        setState(() {});
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: darkGreyColor,
                                            width: 0.8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    faqs![i].title,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: eighteen600TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  opened[i] == true
                                                      ? Icons.remove
                                                      : Icons.add,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            opened[i] == true
                                                ? Text(
                                                    faqs![i].description,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
