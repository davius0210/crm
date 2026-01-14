import 'package:crm_apps/diskondetail_page.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'controller/diskon_cont.dart' as cdisc;
import 'models/globalparam.dart' as param;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/diskon.dart' as mdisc;
import 'style/css.dart' as css;

class DiskonPage extends StatefulWidget {
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final String endTimeVisit;
  final String startDayDate;

  const DiskonPage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.routeName,
      required this.endTimeVisit,
      required this.startDayDate});

  @override
  State<DiskonPage> createState() => LayerDiskonPage();
}

class LayerDiskonPage extends State<DiskonPage> {
  bool isLoading = false;
  bool isComplete = false;
  List<mdisc.KodeHarga> listKodeHarga = [];
  List<mdisc.Diskon> listDiskon = [];
  TextEditingController txtStartDate = TextEditingController();
  TextEditingController txtEndDate = TextEditingController();
  TextEditingController txtKeterangan = TextEditingController();
  Map<String, TextEditingController> textEditingControllers = {};
  String fdDiskon = '';
  String fdAktivitas = '';
  String stateKodeBarang = '';
  String stateKodeGroup = '';
  int stateDelete = 0;
  double totalTagihan = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    initLoadPage();

    super.initState();
  }

  void initLoadPage() async {
    try {
      setState(() {
        isLoading = true;
      });

      listKodeHarga = await cdisc.getListKodeHarga(widget.lgn.fdKodeHarga!);
      listDiskon = await cdisc.getDiskon(widget.lgn.fdKodeHarga!);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Diskon dan Promo'),
        ),
        body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            backgroundColor: Colors.yellow,
            color: Colors.red,
            strokeWidth: 2,
            onRefresh: () async {
              initLoadPage();

              return Future.delayed(const Duration(milliseconds: 500));
            },
            child: isLoading
                ? Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(5),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: css.boxDecorMenuHeader(),
                            child: Text(
                                '${widget.lgn.fdKodeLangganan} - ${widget.lgn.fdNamaLangganan}',
                                style: css.textHeaderBold())),
                        const Padding(padding: EdgeInsets.all(5)),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'Price group : ${widget.lgn.fdKodeHarga} - ${listDiskon.isNotEmpty ? listDiskon[0].fdNamaHarga : 'N/A'}',
                            style: css.textNormalBold(),
                          ),
                        ),
                        Flexible(
                            child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: listDiskon.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          settings: const RouteSettings(
                                              name: 'diskondetail'),
                                          builder: (context) =>
                                              DiskonDetailPage(
                                                  lgn: widget.lgn,
                                                  user: widget.user,
                                                  routeName: 'diskondetail',
                                                  endTimeVisit:
                                                      widget.endTimeVisit,
                                                  startDayDate:
                                                      widget.startDayDate,
                                                  fdNoEntryDiskon: listDiskon[
                                                          index]
                                                      .fdNoEntryDiskon!))).then(
                                      (value) {
                                    initLoadPage();

                                    setState(() {});
                                  });
                                },
                                child: Card(
                                    elevation: 3,
                                    shadowColor: Colors.blue,
                                    shape: css.boxStyle(),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Type Discount : ${listDiskon[index].fdTipeDiskon} - ${listDiskon[index].fdNamaTipeDiskon}',
                                                        softWrap: true,
                                                        style: css
                                                            .textNormalBold()),
                                                    Text(
                                                        'Based On : ${listDiskon[index].fdBaseOn}',
                                                        softWrap: true),
                                                    Text(
                                                        'Max On : ${listDiskon[index].fdMaxDiscV!.toStringAsFixed(listDiskon[index].fdMaxDiscV! % 1 == 0 ? 0 : 2)}',
                                                        softWrap: true),
                                                    Text(
                                                        'Disc Percentage : ${listDiskon[index].fdDiscP1 != null && listDiskon[index].fdDiscP1! > 0 ? '${listDiskon[index].fdDiscP1!.toStringAsFixed(listDiskon[index].fdDiscP1! % 1 == 0 ? 0 : 2)} %' : ''}${listDiskon[index].fdDiscP2 != null && listDiskon[index].fdDiscP2! > 0 ? ' + ${listDiskon[index].fdDiscP2!.toStringAsFixed(listDiskon[index].fdDiscP2! % 1 == 0 ? 0 : 2)} %' : ''}${listDiskon[index].fdDiscP3 != null && listDiskon[index].fdDiscP3! > 0 ? ' + ${listDiskon[index].fdDiscP3!.toStringAsFixed(listDiskon[index].fdDiscP3! % 1 == 0 ? 0 : 2)} %' : ''}',
                                                        softWrap: true),
                                                    Text(
                                                        'Value Disc : ${listDiskon[index].fdDiscV!.toStringAsFixed(listDiskon[index].fdDiscV! % 1 == 0 ? 0 : 2)}',
                                                        softWrap: true),
                                                    Text(
                                                        'Periode : ${param.dtFormatViewMMM.format(DateTime.parse(listDiskon[index].fdStartDate!))} s/d ${param.dtFormatViewMMM.format(DateTime.parse(listDiskon[index].fdEndDate!))}',
                                                        softWrap: true),
                                                  ]),
                                            ),
                                          ],
                                        ))));
                          },
                        )),
                      ])),
      ),
    );
  }
}
