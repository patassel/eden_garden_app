import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eden_garden/controllers/dataBase_controller.dart';
import 'package:eden_garden/controllers/route_management.dart';
import 'package:eden_garden/controllers/slide_animation_controller.dart';
import 'package:eden_garden/model/button/button_circle.dart';
import 'package:eden_garden/model/button/button_rect.dart';
import 'package:eden_garden/model/dialog/show_dialog.dart';
import 'package:eden_garden/model/user_db.dart';
import 'package:eden_garden/view/user/user_family_screen.dart';
import 'package:flutter/material.dart';

import 'package:eden_garden/controllers/globals.dart' as global;

class UserCommunityScreen extends StatefulWidget {
  final String from;
  final UserDB user;
  final Function()? function;

  const UserCommunityScreen(
      {Key? key, required this.from, required this.user, this.function})
      : super(key: key);

  @override
  State<UserCommunityScreen> createState() => _UserCommunityScreenState();
}

class _UserCommunityScreenState extends State<UserCommunityScreen> {
  late String from;

  late double screenWidth;

  late double screenHeight;

  late bool orientationPortrait = false;

  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController controllerView = ScrollController();

  /// Flag  --------------------------------------------------------------

  late bool flagFamily = true;
  late bool flagRequest = false;
  late bool flagGroups = false;

  late bool flagReturnDialog = false;
  late List<bool> flagRequestList = [];
  late List<bool> flagDeleteUser =
      List.filled(global.currentUser.myCommunityObject.length, false);

  /// Flag  --------------------------------------------------------------

  /// Show dialog --------------------------------------------------------------
  final TextEditingController _textFieldControllerEmail =
      TextEditingController();
  late FocusNode textFocusNodeEmail = FocusNode();
  late bool focusEmail = false;

  final TextEditingController _textFieldControllerMessage =
      TextEditingController();
  late FocusNode textFocusNodeMessage = FocusNode();
  late bool focusMessage = false;

  late Color colorTextSave = global.ColorTheme().colorFromLight;
  late Color colorTextCancel = global.ColorTheme().colorFromLight;

  /// Show dialog --------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    from = widget.from;
  }

  initiateSetState() {
    setState(() {});
  }

  void initializeAllValue() {
    flagDeleteUser =
        List.filled(global.currentUser.myCommunityObject.length, false);
  }

  Future acceptRequest(
      Map<String, dynamic> request, bool typeGroup, int index) async {
    await Future.delayed(const Duration(milliseconds: 200), () {});

    String id = typeGroup ? request['group']['by'] : request['family']['by'];
    UserDB userSender = await dataBaseGetUser(id);
    await Future.delayed(const Duration(milliseconds: 200), () {});

    if (id != '0' && !global.currentUser.myCommunity['family'].contains(id)) {
      global.currentUser
          .addEdenCommunity(userSender); // add family to currentUser
      userSender
          .addEdenCommunity(global.currentUser); // add family to Sender User
      await Future.delayed(const Duration(milliseconds: 200), () {});

      global.currentUser.myCommunity['request'].removeAt(index);
      dataBaseUpdate(
          global.currentUser.id, 'community', global.currentUser.myCommunity);
      dataBaseUpdate(userSender.id, 'community', userSender.myCommunity);

      initiateSetState();
      await Future.delayed(const Duration(milliseconds: 300), () {});
    } else {
      // return dialog newUser already exist
    }
  }

  Future declineRequest(Map<String, dynamic> request, int index) async {
    global.currentUser.myCommunity['request'].removeAt(index);
    dataBaseUpdate(
        global.currentUser.id, 'community', global.currentUser.myCommunity);

    initiateSetState();
    await Future.delayed(const Duration(milliseconds: 200), () {});
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    controllerView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientationPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: global.themeAppDark ? Colors.black : Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.greenAccent.shade100),
            onPressed: () {
              Navigator.of(context).pop(context);
              setState(() {
                widget.function!();
              });
            },
          ),
          centerTitle: true,
          title: Text(
            'My community',
            style: TextStyle(
                fontSize: 34,
                color: Colors.greenAccent.shade100,
                fontWeight: FontWeight.w400,
                fontFamily: 'meri'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SlideAnimationController(
          delay: 800,
          child: Container(
              height: 100,
              width: screenWidth,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Stack(
                children: [
                  flagGroups
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: 'Groups',
                            autofocus: true,
                            focusElevation: 5,
                            backgroundColor: global.themeAppDark
                                ? Colors.white12
                                : Colors.white,
                            tooltip: 'Create a new group',
                            child: Icon(
                              Icons.group_add,
                              color: global.themeAppDark
                                  ? global.ColorTheme().colorFromDarkSub
                                  : global.ColorTheme().colorDeepDark,
                            ),

                            /*shape: StadiumBorder(
                            side: BorderSide(
                                color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorFromLight,
                                width: 4)),

                         */
                            onPressed: () {},
                          ))
                      : const SizedBox(),
                  flagFamily
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: 'Action',
                            autofocus: true,
                            focusElevation: 5,
                            backgroundColor: global.themeAppDark
                                ? Colors.white12
                                : Colors.white,
                            tooltip:'Add new Eden member',
                            /*shape: StadiumBorder(
                            side: BorderSide(
                                color: global.themeAppDark ? global.ColorTheme().colorFromDarkSub : global.ColorTheme().colorFromLight,
                                width: 4)),
                         */
                            onPressed: () async {
                              final result =
                                  await (Connectivity().checkConnectivity());

                              if (result == ConnectivityResult.none) {
                                // No internet
                                showDialogErrorNetworkActivity();
                              } else {
                                displaySendRequestDialog();
                              }
                            },
                            child: Icon(
                              Icons.add_circle,
                              color: global.themeAppDark
                                  ? global.ColorTheme().colorFromDarkSub
                                  : global.ColorTheme().colorDeepDark,
                            ),
                          ))
                      : const SizedBox(),
                ],
              )),
        ),
        body:

            /// BODY view ----------------------------------------------------------

            /// BACKGROUND DECORATION VIEW
            Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            // DEEP BLUE DARK
            colors: global.themeAppDark
                ? global.ColorTheme().colorsViewBackgroundDark
                : global.ColorTheme().colorsViewModernBackgroundLight,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
          child: SingleChildScrollView(
              controller: controllerView,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  /// Top View -----------------------------------------------
                  /// List family - request - groups
                  buildTopView(),

                  /// Top View -------------------------------------------------

                  const SizedBox(
                    height: 30,
                  ),

                  /// Family
                  /// Grid view of family members -----------------------------------
                  (flagFamily &&
                          global.currentUser.myCommunityObject.isNotEmpty)
                      ? buildGridViewFamily()
                      : const SizedBox(),

                  /// Grid view of family members ------------------------------

                  /// Request
                  /// List of request ------------------------------------------
                  (flagRequest &&
                          global.currentUser.myCommunity['request'].isNotEmpty)
                      ? buildListViewRequest()
                      : const SizedBox(),

                  /// List of request ------------------------------------------

                  const SizedBox(
                    height: 10,
                  ),

                  ///-----------------------------------------------------------
                ],
              )),
        ));
  }

  Container buildTopView() {
    return Container(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        height: 100,
        color: global.themeAppDark
            ? Colors.black12
            : global.ColorTheme().colorFromDark,
        child: Center(
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
                left: orientationPortrait ? 50 : 150,
                right: orientationPortrait ? 50 : 150,
                top: 20),
            children: <Widget>[
              GestureDetector(
                  onTap: () async {
                    flagFamily = !flagFamily;
                    flagRequest = false;
                    flagGroups = false;

                    initializeAllValue();

                    await Future.delayed(
                        const Duration(milliseconds: 100), () {});
                    initiateSetState();

                    await Future.delayed(
                        const Duration(milliseconds: 900), () {});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      global.themeAppDark
                          ? Icon(
                              Icons.tag_faces_rounded,
                              size: 35,
                              color:
                                  flagFamily ? Colors.lightGreen : Colors.white,
                            )
                          : Icon(
                              Icons.tag_faces_rounded,
                              size: 35,
                              color:
                                  flagFamily ? Colors.lightGreen : Colors.black,
                            ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        child: Text("Eden Family",
                            style: TextStyle(
                              color: (global.themeAppDark && flagFamily)
                                  ? Colors.lightGreen
                                  : (!global.themeAppDark && flagFamily)
                                      ? Colors.lightGreen
                                      : (!global.themeAppDark && !flagFamily)
                                          ? Colors.black
                                          : Colors.white,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'RobotMono',
                              fontSize: flagFamily ? 24 : 18,
                            )),
                      )
                    ],
                  )),
              SizedBox(
                width:
                    orientationPortrait ? screenWidth * 0.3 : screenWidth * 0.4,
              ),
              GestureDetector(
                  onTap: () async {
                    flagRequest = !flagRequest;
                    flagFamily = false;
                    flagGroups = false;

                    initializeAllValue();

                    await Future.delayed(
                        const Duration(milliseconds: 100), () {});
                    initiateSetState();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          global.themeAppDark
                              ? Icon(
                                  Icons.people_alt_rounded,
                                  size: 35,
                                  color: flagRequest
                                      ? Colors.lightGreen
                                      : Colors.white,
                                )
                              : Icon(
                                  Icons.people_alt_rounded,
                                  size: 35,
                                  color: flagRequest
                                      ? Colors.lightGreen
                                      : Colors.black,
                                ),
                          global.currentUser.myCommunity['request'].isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, bottom: 10),
                                  padding: const EdgeInsets.all(3),
                                  color: Colors.red.shade400,
                                  child: Center(
                                    child: Text(
                                        global.currentUser
                                            .myCommunity['request'].length
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'RobotMono',
                                          fontSize: 16,
                                        )),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          child: Text("Request",
                              style: TextStyle(
                                color: (global.themeAppDark && flagRequest)
                                    ? Colors.lightGreen
                                    : (!global.themeAppDark && flagRequest)
                                        ? Colors.lightGreen
                                        : (!global.themeAppDark && !flagRequest)
                                            ? Colors.black
                                            : Colors.white,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'RobotMono',
                                fontSize: flagRequest ? 24 : 18,
                              ))),
                    ],
                  )),
              SizedBox(
                width: screenWidth * 0.38,
              ),
              GestureDetector(
                  onTap: () async {
                    flagGroups = !flagGroups;
                    flagFamily = false;
                    flagRequest = false;

                    initializeAllValue();

                    await Future.delayed(
                        const Duration(milliseconds: 100), () {});
                    initiateSetState();

                    if (flagGroups) {
                      controllerView
                          .jumpTo(controllerView.position.maxScrollExtent);
                    } else {
                      controllerView
                          .jumpTo(controllerView.position.minScrollExtent);
                    }
                    await Future.delayed(
                        const Duration(milliseconds: 900), () {});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      global.themeAppDark
                          ? Icon(
                              Icons.groups,
                              size: 35,
                              color:
                                  flagGroups ? Colors.lightGreen : Colors.white,
                            )
                          : Icon(
                              Icons.groups,
                              size: 35,
                              color:
                                  flagGroups ? Colors.lightGreen : Colors.black,
                            ),
                      AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          child: Text("Groups",
                              style: TextStyle(
                                color: (global.themeAppDark && flagGroups)
                                    ? Colors.lightGreen
                                    : (!global.themeAppDark && flagGroups)
                                        ? Colors.lightGreen
                                        : (!global.themeAppDark && !flagGroups)
                                            ? Colors.black
                                            : Colors.white,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'RobotMono',
                                fontSize: flagGroups ? 24 : 18,
                              ))),
                    ],
                  )),
            ],
          ),
        ));
  }

  GridView buildGridViewFamily() {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: orientationPortrait ? 2 : 3,
      mainAxisSpacing: orientationPortrait ? 30 : 0,
      crossAxisSpacing: orientationPortrait ? 30 : 0,
      shrinkWrap: true,
      physics: const ScrollPhysics(),

      children:
          List.generate(global.currentUser.myCommunityObject.length, (index) {
        UserDB userFamily = global.currentUser.myCommunityObject[index];
        return SlideAnimationController(
            delay: 1000 + (index * 100),
            child: SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    flagDeleteUser[index]
                        ? Align(
                            alignment: const Alignment(0.8, -1),
                            child: ButtonCircle(
                              tag: 'Remove $index',
                              tip: 'Remove family',
                              icon: Icon(
                                Icons.person_remove_alt_1,
                                color: Colors.red.shade400,
                              ),
                              colorBackground: global.themeAppDark
                                  ? Colors.white12
                                  : Colors.white,
                              colorBorder: Colors.transparent,
                              onPressed: () {
                                /// TODO Confirm delete the userFamily
                                AlertDialogApp(
                                  context: context,
                                  onAccept: () async {
                                    global.currentUser
                                        .removeEdenCommunity(userFamily);
                                    userFamily.removeEdenCommunity(
                                        global.currentUser);
                                    await Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      initializeAllValue();
                                      initiateSetState();
                                    });
                                  },
                                  onRefuse: () {
                                    initializeAllValue();
                                    initiateSetState();
                                  },
                                  title: 'Remove Family confirmation ',
                                  body:
                                      'Are you sure to remove ${userFamily.pseudo} ?',
                                  accept: 'CONFIRM',
                                  refuse: 'CANCEL',
                                ).normalShowDialog();
                              },
                            ),
                          )
                        : const SizedBox(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,

                                /// ZOOM profile
                                onTap: () async {
                                  Navigator.push(
                                    // push -> Add route on stack
                                    context,
                                    FadeInRoute(
                                      // FadeInRoute  // ZoomInRoute  // RotationInRoute
                                      page: UserFamilyScreen(
                                        user: userFamily,
                                        function: initiateSetState,
                                      ),
                                      //ContactScreen(),
                                      routeName:
                                          '/home/community/${userFamily.fullName}',
                                    ),
                                  );
                                  initiateSetState();
                                },
                                onLongPress: () {
                                  flagDeleteUser[index] =
                                      !flagDeleteUser[index];
                                  initiateSetState();
                                },

                                onDoubleTap: () {
                                  if (userFamily.profileUrl.isNotEmpty) {
                                    showFullImage(userFamily.profileUrl);
                                  }
                                },
                                child: Hero(
                                    tag: 'user $index',
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: userFamily.profileUrl.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    userFamily.profileUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    'assets/freeAvatar.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                        border: Border.all(
                                            color: userFamily.status == 0
                                                ? Colors.grey
                                                : userFamily.status == 1
                                                    ? Colors.green
                                                    : userFamily.status == 2
                                                        ? Colors.red.shade400
                                                        : Colors.white,
                                            width: 5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(120.0)),
                                      ),
                                    )),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 10),
                                  child: SlideAnimationController(
                                    delay: 800,
                                    child: Text(
                                      userFamily.fullName.isNotEmpty
                                          ? userFamily.fullName
                                          : userFamily.email,
                                      style: TextStyle(
                                        letterSpacing: 0.25,
                                        color: global.themeAppDark
                                            ? global.ColorTheme().colorFromDark
                                            : global.ColorTheme()
                                                .colorFromLight,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'RobotMono',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ))
                            ]))
                  ],
                )));
      }),
    );
  }

  ListView buildListViewRequest() {
    return ListView.builder(
        shrinkWrap: true,
        controller: controllerView,
        itemCount: global.currentUser.myCommunity['request'].length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> request =
              global.currentUser.myCommunity['request'][index];
          bool typeGroup = request.containsKey('group') ? true : false;
          DateTime date = typeGroup
              ? request['group']['date'].toDate()
              : request['family']['date'].toDate();
          String message = typeGroup
              ? request['group']['message']
              : request['family']['message'];
          String hour = date.minute < 10
              ? '${date.hour}:0${date.minute}'
              : '${date.hour}:${date.minute}';
          String dateString = "${date.day}/${date.month}/${date.year} at $hour";
          String pictureUrl = typeGroup
              ? request['group']['urlPicture']
              : request['family']['urlPicture'];
          String name =
              typeGroup ? request['group']['name'] : request['family']['name'];
          String email = typeGroup
              ? request['group']['email']
              : request['family']['email'];
          flagRequestList.add(false);
          return Center(
              child: Dismissible(
                  key: Key(typeGroup
                      ? request['group']['by'] + index.toString()
                      : request['family']['by'] + index.toString()),
                  movementDuration: const Duration(milliseconds: 800),
                  onDismissed: (direction) async {
                    if (direction.name == 'startToEnd') {
                      await acceptRequest(request, typeGroup, index);
                    } else {
                      await declineRequest(request, index);
                    }
                  },
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.check),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.cancel),
                  ),
                  child: SlideAnimationController(
                      delay: 500 + (200 * index),
                      child: AnimatedSize(
                          duration: const Duration(milliseconds: 800),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    width: orientationPortrait
                                        ? screenWidth * 0.9
                                        : screenWidth * 0.7,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: flagRequestList[index]
                                            ? const BorderRadius.vertical(
                                                top: Radius.circular(10.0))
                                            : const BorderRadius.all(
                                                Radius.circular(10.0))),
                                    child: Center(
                                        child: ListTile(
                                      minLeadingWidth: 10,
                                      title: Text(typeGroup
                                          ? 'Group request'
                                          : 'Eden family request'),
                                      subtitle: Text(
                                        (typeGroup && name.isNotEmpty)
                                            ? '\nSend by $name With ${request['group']['members'].length}\nReceived the $dateString'
                                            : (typeGroup && name.isEmpty)
                                                ? '\nSend by $email With ${request['group']['members'].length}\nReceived the $dateString'
                                                : (!typeGroup &&
                                                        name.isNotEmpty)
                                                    ? '\nSend by $name\nReceived the $dateString'
                                                    : '\nSend by $email\nReceived the $dateString',
                                        style: TextStyle(
                                            color: global.ColorTheme()
                                                .colorFromDarkSub,
                                            fontSize: 8),
                                      ),
                                      leading: Icon(
                                        typeGroup
                                            ? Icons.group
                                            : Icons.people_alt_rounded,
                                        color: Colors.black54,
                                      ),
                                      trailing: GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                              // push -> Add route on stack
                                              context,
                                              FadeInRoute(
                                                // FadeInRoute  // ZoomInRoute  // RotationInRoute
                                                page: UserFamilyScreen(
                                                  user: await dataBaseGetUser(
                                                      typeGroup
                                                          ? request['group']
                                                              ['by']
                                                          : request['family']
                                                              ['by']),
                                                  function: initiateSetState,
                                                ),
                                                //ContactScreen(),
                                                routeName:
                                                    '/home/community/$name',
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  Align(
                                                      alignment:
                                                          const Alignment(
                                                              -0.4, 0),
                                                      child: Hero(
                                                          tag: 'user',
                                                          child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              image: pictureUrl
                                                                      .isNotEmpty
                                                                  ? DecorationImage(
                                                                      image: NetworkImage(
                                                                          pictureUrl),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : const DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/freeAvatar.jpg'),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          120.0)),
                                                            ),
                                                          ))),
                                                  message.isNotEmpty
                                                      ? Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                                Icons.message,
                                                                color: Colors
                                                                    .green),
                                                            onPressed: () {
                                                              flagRequestList[
                                                                      index] =
                                                                  !flagRequestList[
                                                                      index];
                                                              initiateSetState();
                                                            },
                                                          ))
                                                      : const SizedBox(),
                                                ],
                                              ))),
                                      onTap: () {
                                        flagRequestList[index] =
                                            !flagRequestList[index];
                                        initiateSetState();
                                      },
                                    ))),
                                flagRequestList[index]
                                    ? Container(
                                        width: orientationPortrait
                                            ? screenWidth * 0.9
                                            : screenWidth * 0.7,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(10.0))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: screenWidth,
                                              child: const Divider(
                                                color: Colors.black12,
                                                thickness: 10,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            message.isNotEmpty
                                                ? Center(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                top: 30,
                                                                bottom: 30,
                                                                right: 20),
                                                        child: Text(
                                                          message,
                                                          style: TextStyle(
                                                              color: global
                                                                      .ColorTheme()
                                                                  .colorFromLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16),
                                                        )),
                                                  )
                                                : const SizedBox(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ButtonRect(
                                                    title: "Accept",
                                                    colorBorder:
                                                        Colors.transparent,
                                                    colorBackground:
                                                        Colors.transparent,
                                                    colorHover: Colors.black,
                                                    colorText:
                                                        global.ColorTheme()
                                                            .colorDeepDark,
                                                    onclickButton: () async {
                                                      await acceptRequest(
                                                          request,
                                                          typeGroup,
                                                          index);
                                                    },
                                                    onHoverMouse: (val) {}),
                                                ButtonRect(
                                                    title: "Refuse",
                                                    colorBorder:
                                                        Colors.transparent,
                                                    colorBackground:
                                                        Colors.transparent,
                                                    colorHover: Colors.black,
                                                    colorText:
                                                        global.ColorTheme()
                                                            .colorDeepDark,
                                                    onclickButton: () async {
                                                      await declineRequest(
                                                          request, index);
                                                    },
                                                    onHoverMouse: (val) {}),
                                              ],
                                            )
                                          ],
                                        ))
                                    : const SizedBox(),
                                const SizedBox(height: 10)
                              ])))));
        });
  }

  /// Show dialog Send friend request
  Future<void> displaySendRequestDialog() async {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  title: Center(
                      child: Text(
                    flagFamily
                        ? "Scan direct or send Eden request"
                        : "Scan direct or send Eden group request",
                    style: TextStyle(
                        color: global.ColorTheme().colorFromLight,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'RobotMono',
                        fontSize: 16),
                  )),
                  content: SizedBox(
                    width: orientationPortrait
                        ? screenWidth * 0.8
                        : screenWidth * 0.5,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                              onSubmitted: (val) {
                                textFocusNodeEmail.unfocus();
                                setState(() {});
                              },
                              onTap: () {
                                setState(() {
                                  if (textFocusNodeEmail.hasFocus) {
                                    textFocusNodeEmail.unfocus();
                                    focusEmail = false;
                                  } else {
                                    textFocusNodeEmail.requestFocus();
                                    focusEmail = true;
                                  }
                                });
                              },
                              controller: _textFieldControllerEmail,
                              decoration: InputDecoration(
                                  hintText: "Enter the email of the new member",
                                  labelText: "Email*",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10),
                                  labelStyle: TextStyle(
                                    color: global.themeAppDark
                                        ? Colors.blue
                                        : global.ColorTheme().colorFromLight,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  //hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ))),
                          TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              onSubmitted: (val) {
                                textFocusNodeMessage.unfocus();
                                setState(() {});
                              },
                              onTap: () {
                                setState(() {
                                  if (textFocusNodeMessage.hasFocus) {
                                    textFocusNodeMessage.unfocus();
                                    focusMessage = false;
                                  } else {
                                    textFocusNodeMessage.requestFocus();
                                    focusMessage = true;
                                  }
                                });
                              },
                              controller: _textFieldControllerMessage,
                              decoration: InputDecoration(
                                  hintText: "Enter your message",
                                  labelText: "Message",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10),
                                  labelStyle: TextStyle(
                                    color: global.themeAppDark
                                        ? Colors.blue
                                        : global.ColorTheme().colorFromLight,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  //hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )))
                        ]),
                  ),
                  actions: <Widget>[
                    (!orientationPortrait && !textFocusNodeEmail.hasFocus) ||
                            (orientationPortrait &&
                                !textFocusNodeEmail.hasFocus)
                        ? ButtonRect(
                            title: "CANCEL",
                            colorBorder: Colors.transparent,
                            colorBackground: Colors.transparent,
                            colorHover: Colors.black,
                            colorText: global.ColorTheme().colorDeepDark,
                            onclickButton: () {
                              _textFieldControllerEmail.clear();
                              _textFieldControllerMessage.clear();
                              setState(() => Navigator.pop(context));
                            },
                            onHoverMouse: (val) {
                              if (val) {
                                colorTextCancel = Colors.white;
                              } else {
                                colorTextCancel =
                                    global.ColorTheme().colorFromLight;
                              }
                              setState(() {});
                            },
                          )
                        : const SizedBox(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.green,
                      ),
                    ),
                    (!orientationPortrait && !textFocusNodeEmail.hasFocus) ||
                            (orientationPortrait &&
                                !textFocusNodeEmail.hasFocus)
                        ? ButtonRect(
                            title: "Send",
                            colorBorder: Colors.transparent,
                            colorBackground: Colors.transparent,
                            colorHover: Colors.black,
                            colorText: global.ColorTheme().colorFromDarkSub,
                            onclickButton: () async {
                              var newUserEmail =
                                  _textFieldControllerEmail.value.text;

                              if (newUserEmail != global.currentUser.email) {
                                if (await dataBaseCheckUserId(newUserEmail)) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 400), () {});

                                  String id =
                                      await dataBaseGetUserID(newUserEmail);
                                  await Future.delayed(
                                      const Duration(milliseconds: 400), () {});

                                  if (id != '0') {
                                    UserDB userReceiver =
                                        await dataBaseGetUser(id);

                                    if (flagFamily) {
                                      // Send friend request
                                      if (!global
                                          .currentUser.myCommunity['family']
                                          .contains(id)) {
                                        userReceiver.receiveRequestCommunity(
                                            'family',
                                            global.currentUser.id,
                                            global.currentUser.email,
                                            global.currentUser.fullName,
                                            global.currentUser.profileUrl,
                                            _textFieldControllerMessage.text,
                                            []);
                                      }
                                    } else {
                                      // Send group request

                                    }
                                  }
                                }
                              }

                              await Future.delayed(
                                  const Duration(milliseconds: 400), () {
                                _textFieldControllerEmail.clear();
                                _textFieldControllerMessage.clear();
                                Navigator.pop(context);
                              });

                              initiateSetState();
                            },
                            onHoverMouse: (val) {
                              if (val) {
                                colorTextSave = Colors.white;
                              } else {
                                colorTextSave =
                                    global.ColorTheme().colorFromLight;
                              }
                              setState(() {});
                            },
                          )
                        : const SizedBox(),
                  ],
                )));
  }

  Future<dynamic> showFullImage(String profileUserUrl) async {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
                child: Container(
                    //padding: const EdgeInsets.only(bottom: 30,),
                    height: screenHeight,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(profileUserUrl),
                          fit: BoxFit.cover),
                    ))),
          );
        });
  }

  Future<void> showDialogErrorNetworkActivity() {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                actionsAlignment: MainAxisAlignment.spaceBetween,
                title: const Center(
                  child: SlideAnimationController(
                      delay: 300,
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 38,
                      )),
                ),
                content: const SlideAnimationController(
                    delay: 800,
                    child: Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          '\nPlease check your\ninternet connection...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ))),
                actions: <Widget>[
                  ButtonRect(
                      title: "Ok",
                      colorBorder: Colors.transparent,
                      colorBackground: Colors.transparent,
                      colorHover: Colors.black,
                      colorText: global.ColorTheme().colorDeepDark,
                      onclickButton: () {
                        setState(() => Navigator.pop(context));
                      },
                      onHoverMouse: (val) {}),
                ],
              )),
    );
  }
}
