import 'package:app_developer_assignment/Resources/WidgetConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/HeaderData.dart';
import '../model/customRecommendationModel.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  static String id = "DashboardPage";

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc dashboardBloc = DashboardBloc();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // This has been done to handle memory leaks
    dashboardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      listener: (BuildContext context, state) {
        if (state is LoadData) {}
      },
      builder: (BuildContext context, state) {
        if (state is PageLoadedState) {
          return buildUI(
              context, state.dataNotFound, state.listOfTournaments, state.hd);
        } else if (state is InitialPageLoadedState) {
          return buildUI(
              context, state.dataNotFound, state.listOfTournaments, state.hd);
        } else {
          dashboardBloc.add(LoadData());
          return loadingWidget();
        }
      },
    );
  }

  Widget buildUI(BuildContext context, bool dataNotFound,
      List<Tournaments> list, HeaderData hd) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xfff9f9f9),
        leading: Image.asset('assets/menu.png'),
        title: Center(
            child: Text(
          'appBarText'.i18n(),
          style: TextStyle(color: Colors.black),
        )),
      ),
      body: Container(
        color: Color(0xfff9f9f9),
        padding: EdgeInsets.all(25),
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          controller: refreshController,
          onLoading: () async {
            dashboardBloc.add(GetNextPageEvent(refreshController));
          },
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: Image.network(hd.imageUrl).image,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (hd.name),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              (hd.rating),
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text('Elo Rating'),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffeb9e03),
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      child: Column(
                        children: [
                          Text(
                            (hd.tp),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'PillCompartment1'.i18n(),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xff924cb7),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Column(
                        children: [
                          Text(
                            (hd.tp),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'PillCompartment2'.i18n(),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffee744d),
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          Text(
                            '26%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'PillCompartment3'.i18n(),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'RecommendationHeader'.i18n(),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
              ),
              SizedBox(
                height: 15,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecommendationCard(
                    imageUrl: list[index].cover_url,
                    name: list[index].name,
                    game_name: list[index].game_name,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 5,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String game_name;

  const RecommendationCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.game_name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: GestureDetector(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        game_name,
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
                Image.asset(
                  'assets/arrow.png',
                  height: 20,
                  width: 20,
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
