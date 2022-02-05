import 'package:app_developer_assignment/Service/recommendationService.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/HeaderData.dart';
import '../model/customRecommendationModel.dart';
import 'event.dart';
import 'state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState().init());

  List<Tournaments> list = [];
  bool isEndData = false;
  String cursor = "";
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  FirebaseAuth fa = FirebaseAuth.instance;
  late HeaderData hd;

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is LoadData) {
      isEndData = false;
      await getData(cursor);
      hd = await getHeaderData();
      yield InitialPageLoadedState(
          hd: hd, dataNotFound: isEndData, listOfTournaments: list);
    } else if (event is GetNextPageEvent) {
      isEndData = false;
      await getData(cursor);
      event.controller.loadComplete();
      yield PageLoadedState(
          dataNotFound: isEndData, listOfTournaments: list, hd: hd);
    } else if (event is LogoutEvent) {
      await fa.signOut();
      yield LogoutState(isSuccess: true);
    }
  }

  Future<void> getData(String cursor) async {
    RecommendationService rs = RecommendationService();
    List<Tournaments>? tournamentsList = await rs.getTournaments(cursor, "10");
    this.cursor = rs.cursor;
    if (tournamentsList != null) {
      list.addAll(tournamentsList);
    } else {
      isEndData = true;
    }
  }

  Future<DashboardState> init() async {
    return state.clone();
  }

  Future<HeaderData> getHeaderData() async {
    var user = await fa.currentUser;
    String? uid = user?.uid;
    print(uid);
    final CollectionReference _mainCollection = await fs.collection('Users');
    var data = await _mainCollection.doc(uid).get();
    var objData = await data.data();
    if (objData != null) {
      Map<String, dynamic> actualData = objData as Map<String, dynamic>;
      if (actualData != null) {
        String name = await actualData['Name'];
        String imgUrl = await actualData['ProfileImage'];
        String rating = await actualData['Rating'];
        String tp = await actualData['Tp'];
        String tw = await actualData['Tw'];
        String percentage = await actualData['Percentage'];
        HeaderData hd = HeaderData(
            name: name,
            rating: rating,
            tp: tp,
            tw: tw,
            imageUrl: imgUrl,
            percentage: percentage);

        return hd;
      }
    }
    return HeaderData(
        name: 'Not Found',
        rating: 'Not Found',
        tp: 'Not Found',
        percentage: 'Not Found',
        imageUrl: 'Not Found',
        tw: 'Not Found');
  }
}
