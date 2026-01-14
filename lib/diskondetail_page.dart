import 'package:flutter/material.dart';
import 'main.dart';
import 'controller/diskon_cont.dart' as cdisc;
import 'models/globalparam.dart' as param;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/diskon.dart' as mdisc;
import 'style/css.dart' as css;

class DiskonDetailPage extends StatefulWidget {
  final mlgn.Langganan lgn;
  final msf.Salesman user;
  final String routeName;
  final String endTimeVisit;
  final String startDayDate;
  final String fdNoEntryDiskon;

  const DiskonDetailPage(
      {super.key,
      required this.lgn,
      required this.user,
      required this.routeName,
      required this.endTimeVisit,
      required this.startDayDate,
      required this.fdNoEntryDiskon});

  @override
  State<DiskonDetailPage> createState() => LayerDiskonDetailPage();
}

class LayerDiskonDetailPage extends State<DiskonDetailPage> {
  bool isLoading = false;
  bool isComplete = false;
  List<mdisc.KodeHarga> listKodeHarga = [];
  List<mdisc.DiskonDetail> listDiskonDetail = [];
  TextEditingController txtStartDate = TextEditingController();
  TextEditingController txtEndDate = TextEditingController();
  TextEditingController txtKeterangan = TextEditingController();
  Map<String, TextEditingController> textEditingControllers = {};
  String fdDiskonDetail = '';
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

      listDiskonDetail = await cdisc.getDiskonDetail(widget.fdNoEntryDiskon);
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
          title: const Text('Diskon Detail'),
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
                        Flexible(
                            child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: listDiskonDetail.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
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
                                                  'Product Group : ${listDiskonDetail[index].fdKodeGroup} - ${listDiskonDetail[index].fdNamaGroup}',
                                                  softWrap: true,
                                                ),
                                                Text(
                                                    'Product : ${listDiskonDetail[index].fdKodeBarang} - ${listDiskonDetail[index].fdNamaBarang}',
                                                    softWrap: true),
                                                Text(
                                                    'Range : ${param.enNumberFormatQty.format(listDiskonDetail[index].fdRangeStart)} - ${param.enNumberFormatQty.format(listDiskonDetail[index].fdRangeEnd)}',
                                                    softWrap: true),
                                                Text(
                                                    'Mandatory : ${listDiskonDetail[index].fdMandatory}',
                                                    softWrap: true),
                                                Text(
                                                    'Include : ${listDiskonDetail[index].fdInclude}',
                                                    softWrap: true),
                                              ]),
                                        ),
                                      ],
                                    )));
                          },
                        )),
                      ])),
      ),
    );
  }
}
