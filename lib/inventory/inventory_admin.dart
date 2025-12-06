import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewinventoryWidget extends StatefulWidget {
  @override
  _NewinventoryWidgetState createState() => _NewinventoryWidgetState();
}

class _NewinventoryWidgetState extends State<NewinventoryWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator NewinventoryWidget - FRAME

    return Container(
      width: 363,
      height: 1978,
      decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(249, 250, 251, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                      color: Color.fromRGBO(21, 93, 252, 1),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.98011589050293,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: <Widget>[
                        Container(
                          width: 66.46685791015625,
                          height: 24.0002498626709,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: -1.716796875,
                                left: 0,
                                child: Text(
                                  'Inventory',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Arimo',
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 228.77430725097656),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Color.fromRGBO(20, 71, 230, 1),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.98004150390625,
                            vertical: 7.9801025390625,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[
                              Container(
                                width: 19.990182876586914,
                                height: 19.990182876586914,
                                decoration: BoxDecoration(),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      top: 2.4987728595733643,
                                      left: 2.4987728595733643,
                                      child: SvgPicture.asset(
                                        'lib/images/dashboard_icon.svg',
                                        semanticsLabel: 'dashboard',
                                      ),
                                    ),
                                    Positioned(
                                      top: 7.496318817138672,
                                      left: 14.992637634277344,
                                      child: SvgPicture.asset(
                                        'lib/images/search.svg',
                                        semanticsLabel: 'search',
                                      ),
                                    ),
                                    Positioned(
                                      top: 4.164621353149414,
                                      left: 10.828015327453613,
                                      child: SvgPicture.asset(
                                        'lib/images/filter.svg',
                                        semanticsLabel: 'filter',
                                      ),
                                    ),
                                    Positioned(
                                      top: 11.660940170288086,
                                      left: 6.663394451141357,
                                      child: SvgPicture.asset(
                                        'lib/images/sorticon.svg',
                                        semanticsLabel: 'sort',
                                      ),
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
                  SizedBox(height: 0),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.98011589050293,
                      vertical: 11.990099906921387,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: <Widget>[
                        Container(
                          width: 331.19140625,
                          height: 42.486656188964844,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 238.19796752929688,
                                  height: 42.486656188964844,
                                  decoration: BoxDecoration(),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                208,
                                                213,
                                                219,
                                                1,
                                              ),
                                              width: 1.2832200527191162,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Text(
                                                'Search inventory...',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                    10,
                                                    10,
                                                    10,
                                                    0.5,
                                                  ),
                                                  fontFamily: 'Arimo',
                                                  fontSize: 16,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 11.238211631774902,
                                        left: 11.99009895324707,
                                        child: Container(
                                          width: 19.990182876586914,
                                          height: 19.990182876586914,
                                          decoration: BoxDecoration(),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 13.876520156860352,
                                                left: 13.876518249511719,
                                                child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector',
                                                ),
                                              ),
                                              Positioned(
                                                top: 2.4987728595733643,
                                                left: 2.4987728595733643,
                                                child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2.099395751953125,
                                left: 249.019775390625,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    border: Border.all(
                                      color: Color.fromRGBO(208, 213, 219, 1),
                                      width: 1.2832200527191162,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9.26324462890625,
                                    vertical: 9.263254165649414,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: <Widget>[
                                      Container(
                                        width: 33,
                                        height: 33,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            1,
                                          ),
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              top: 3.73675537109375,
                                              left: 1.73681640625,
                                              child: SvgPicture.asset(
                                                'assets/images/vector.svg',
                                                semanticsLabel: 'vector',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2.099395751953125,
                                left: 292.019775390625,
                                child: Container(
                                  width: 38.516693115234375,
                                  height: 38.516693115234375,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    border: Border.all(
                                      color: Color.fromRGBO(208, 213, 219, 1),
                                      width: 1.2832200527191162,
                                    ),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 9.263254165649414,
                                        left: 9.26324462890625,
                                        child: Container(
                                          width: 19.990182876586914,
                                          height: 19.990182876586914,
                                          decoration: BoxDecoration(),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 13.326786994934082,
                                                left: 10.828015327453613,
                                                child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector',
                                                ),
                                              ),
                                              Positioned(
                                                top: 3.3316972255706787,
                                                left: 14.159712791442871,
                                                child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector',
                                                ),
                                              ),
                                              Positioned(
                                                top: 3.3316972255706787,
                                                left: 2.4987728595733643,
                                                child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector',
                                                ),
                                              ),
                                              Positioned(
                                                top: 3.3316972255706787,
                                                left: 5.830470085144043,
                                                child: SvgPicture.asset(
                                                  'assets/images/vector.svg',
                                                  semanticsLabel: 'vector',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Container(
                    width: 363,
                    height: 1844.6507568359375,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 15.9801025390625,
                          left: 15.98011589050293,
                          child: Container(
                            width: 331.19140625,
                            height: 336.94586181640625,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.10000000149011612,
                                  ),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(242, 244, 246, 1),
                                width: 1.2832200527191162,
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 161.26483154296875,
                                  left: 1.2832221984863281,
                                  child: Container(
                                    width: 328.6249694824219,
                                    height: 174.39779663085938,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 15.98016357421875,
                                          left: 15.98011589050293,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical: 0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,

                                              children: <Widget>[
                                                Container(
                                                  width: 296.66473388671875,
                                                  height: 24.0002498626709,
                                                  decoration: BoxDecoration(),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        top: -1.716796875,
                                                        left: 0,
                                                        child: Text(
                                                          'Wheelchair',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                  16,
                                                                  23,
                                                                  39,
                                                                  1,
                                                                ),
                                                            fontFamily: 'Arimo',
                                                            fontSize: 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.9899845123291016,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,

                                                    children: <Widget>[
                                                      Text(
                                                        'Mobility Aid',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                            105,
                                                            114,
                                                            130,
                                                            1,
                                                          ),
                                                          fontFamily: 'Arimo',
                                                          fontSize: 14,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height:
                                                              1.4285714285714286,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 71.94061279296875,
                                          left: 15.98011589050293,
                                          child: Container(
                                            width: 128.18177795410156,
                                            height: 26.526592254638672,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                topRight: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomRight: Radius.circular(
                                                  43057800,
                                                ),
                                              ),
                                              color: Color.fromRGBO(
                                                220,
                                                252,
                                                231,
                                                1,
                                              ),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                  184,
                                                  247,
                                                  207,
                                                  1,
                                                ),
                                                width: 1.2832200527191162,
                                              ),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  top: 4.27325439453125,
                                                  left: 13.273319244384766,
                                                  child: Text(
                                                    'Excellent Condition',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        0,
                                                        130,
                                                        53,
                                                        1,
                                                      ),
                                                      fontFamily: 'Arimo',
                                                      fontSize: 12,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.3333333333333333,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 110.45733642578125,
                                          left: 15.98011589050293,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical: 0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,

                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,

                                                    children: <Widget>[
                                                      Container(
                                                        width:
                                                            15.98011589050293,
                                                        height:
                                                            15.98011589050293,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top:
                                                                  1.3316763639450073,
                                                              left:
                                                                  2.6633527278900146,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  4.660867214202881,
                                                              left:
                                                                  5.9925432205200195,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            7.980031967163086,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0,
                                                            ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,

                                                          children: <Widget>[
                                                            Text(
                                                              'Ward A - Room 101',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color:
                                                                    Color.fromRGBO(
                                                                      73,
                                                                      85,
                                                                      101,
                                                                      1,
                                                                    ),
                                                                fontFamily:
                                                                    'Arimo',
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height:
                                                                    1.4285714285714286,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 7.980031967163086,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,

                                                    children: <Widget>[
                                                      Container(
                                                        width:
                                                            15.98011589050293,
                                                        height:
                                                            15.98011589050293,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top:
                                                                  1.3330581188201904,
                                                              left:
                                                                  1.9975144863128662,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  7.990057945251465,
                                                              left:
                                                                  7.990057945251465,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  4.660867214202881,
                                                              left:
                                                                  2.190608263015747,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  2.843142032623291,
                                                              left:
                                                                  4.993786334991455,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            7.980031967163086,
                                                      ),
                                                      Container(
                                                        width:
                                                            67.60972595214844,
                                                        height:
                                                            19.990182876586914,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top: -2,
                                                              left: 0,
                                                              child: Text(
                                                                'Quantity:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                        73,
                                                                        85,
                                                                        101,
                                                                        1,
                                                                      ),
                                                                  fontFamily:
                                                                      'Arimo',
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  height:
                                                                      1.4285714285714286,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              left:
                                                                  60.05074691772461,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(),
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          0,
                                                                      vertical:
                                                                          0,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,

                                                                  children: <Widget>[
                                                                    Text(
                                                                      '5',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                          16,
                                                                          23,
                                                                          39,
                                                                          1,
                                                                        ),
                                                                        fontFamily:
                                                                            'Arimo',
                                                                        fontSize:
                                                                            14,
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        height:
                                                                            1.4285714285714286,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 1.28326416015625,
                                  left: 1.2832221984863281,
                                  child: Container(
                                    width: 328.6249694824219,
                                    height: 159.9816131591797,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(243, 244, 246, 1),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            width: 328.6249694824219,
                                            height: 159.9816131591797,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  'assets/images/Imagewithfallback.png',
                                                ),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            child: Stack(children: <Widget>[
          
        ]
      ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 13.1329345703125,
                                          left: 245.1353759765625,
                                          child: Container(
                                            width: 71.4994888305664,
                                            height: 23.37868881225586,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                topRight: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomRight: Radius.circular(
                                                  43057800,
                                                ),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    0.10000000149011612,
                                                  ),
                                                  offset: Offset(0, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                              color: Color.fromRGBO(
                                                0,
                                                201,
                                                80,
                                                1,
                                              ),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  top: 2.99005126953125,
                                                  left: 11.9901123046875,
                                                  child: Text(
                                                    'Available',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1,
                                                      ),
                                                      fontFamily: 'Arimo',
                                                      fontSize: 12,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.3333333333333333,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 364.91607666015625,
                          left: 15.98011589050293,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.10000000149011612,
                                  ),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(242, 244, 246, 1),
                                width: 1.2832200527191162,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 1.2832221984863281,
                              vertical: 1.283203125,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: <Widget>[
                                Container(
                                  width: 328.6249694824219,
                                  height: 159.9816131591797,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(243, 244, 246, 1),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: 328.6249694824219,
                                          height: 159.9816131591797,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/Imagewithfallback.png',
                                              ),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          child: Stack(children: <Widget>[
          
        ]
      ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 13.13299560546875,
                                        left: 255.34100341796875,
                                        child: Container(
                                          width: 61.29386901855469,
                                          height: 23.37868881225586,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                43057800,
                                              ),
                                              topRight: Radius.circular(
                                                43057800,
                                              ),
                                              bottomLeft: Radius.circular(
                                                43057800,
                                              ),
                                              bottomRight: Radius.circular(
                                                43057800,
                                              ),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  0.10000000149011612,
                                                ),
                                                offset: Offset(0, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                            color: Color.fromRGBO(
                                              255,
                                              105,
                                              0,
                                              1,
                                            ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 2.989990234375,
                                                left: 11.9901123046875,
                                                child: Text(
                                                  'Rented',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      255,
                                                      255,
                                                      255,
                                                      1,
                                                    ),
                                                    fontFamily: 'Arimo',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3333333333333333,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 0.0000457763671875),
                                Container(
                                  width: 328.6249694824219,
                                  height: 174.39779663085938,
                                  decoration: BoxDecoration(),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 15.9801025390625,
                                        left: 15.98011589050293,
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Container(
                                                width: 296.66473388671875,
                                                height: 24.0002498626709,
                                                decoration: BoxDecoration(),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Positioned(
                                                      top: -1.716766357421875,
                                                      left: 0,
                                                      child: Text(
                                                        'Walker',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                            16,
                                                            23,
                                                            39,
                                                            1,
                                                          ),
                                                          fontFamily: 'Arimo',
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.9900150299072266,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Text(
                                                      'Mobility Aid',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                          105,
                                                          114,
                                                          130,
                                                          1,
                                                        ),
                                                        fontFamily: 'Arimo',
                                                        fontSize: 14,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        height:
                                                            1.4285714285714286,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 71.94058227539062,
                                        left: 15.98011589050293,
                                        child: Container(
                                          width: 111.21920013427734,
                                          height: 26.526592254638672,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                43057800,
                                              ),
                                              topRight: Radius.circular(
                                                43057800,
                                              ),
                                              bottomLeft: Radius.circular(
                                                43057800,
                                              ),
                                              bottomRight: Radius.circular(
                                                43057800,
                                              ),
                                            ),
                                            color: Color.fromRGBO(
                                              219,
                                              234,
                                              254,
                                              1,
                                            ),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                189,
                                                218,
                                                255,
                                                1,
                                              ),
                                              width: 1.2832200527191162,
                                            ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 4.273223876953125,
                                                left: 13.273319244384766,
                                                child: Text(
                                                  'Good Condition',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      20,
                                                      71,
                                                      230,
                                                      1,
                                                    ),
                                                    fontFamily: 'Arimo',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3333333333333333,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 110.457275390625,
                                        left: 15.98011589050293,
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Container(
                                                      width: 15.98011589050293,
                                                      height: 15.98011589050293,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top:
                                                                1.3316763639450073,
                                                            left:
                                                                2.6633527278900146,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                4.660867214202881,
                                                            left:
                                                                5.9925432205200195,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.980031967163086,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,

                                                        children: <Widget>[
                                                          Text(
                                                            'Ward B - Room 205',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color:
                                                                  Color.fromRGBO(
                                                                    73,
                                                                    85,
                                                                    101,
                                                                    1,
                                                                  ),
                                                              fontFamily:
                                                                  'Arimo',
                                                              fontSize: 14,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height:
                                                                  1.4285714285714286,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7.980031967163086,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Container(
                                                      width: 15.98011589050293,
                                                      height: 15.98011589050293,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top:
                                                                1.3330377340316772,
                                                            left:
                                                                1.9975144863128662,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                7.990057945251465,
                                                            left:
                                                                7.990057945251465,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                4.660867214202881,
                                                            left:
                                                                2.190608263015747,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                2.8431215286254883,
                                                            left:
                                                                4.993786334991455,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.980031967163086,
                                                    ),
                                                    Container(
                                                      width: 67.60972595214844,
                                                      height:
                                                          19.990182876586914,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top: -2,
                                                            left: 0,
                                                            child: Text(
                                                              'Quantity:',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color:
                                                                    Color.fromRGBO(
                                                                      73,
                                                                      85,
                                                                      101,
                                                                      1,
                                                                    ),
                                                                fontFamily:
                                                                    'Arimo',
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height:
                                                                    1.4285714285714286,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            left:
                                                                60.05074691772461,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical: 0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,

                                                                children: <Widget>[
                                                                  Text(
                                                                    '3',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                      color:
                                                                          Color.fromRGBO(
                                                                            16,
                                                                            23,
                                                                            39,
                                                                            1,
                                                                          ),
                                                                      fontFamily:
                                                                          'Arimo',
                                                                      fontSize:
                                                                          14,
                                                                      letterSpacing:
                                                                          0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      height:
                                                                          1.4285714285714286,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 713.85205078125,
                          left: 15.98011589050293,
                          child: Container(
                            width: 331.19140625,
                            height: 336.94586181640625,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.10000000149011612,
                                  ),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(242, 244, 246, 1),
                                width: 1.2832200527191162,
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 161.26483154296875,
                                  left: 1.2832221984863281,
                                  child: Container(
                                    width: 328.6249694824219,
                                    height: 174.39779663085938,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 15.980117797851562,
                                          left: 15.98011589050293,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical: 0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,

                                              children: <Widget>[
                                                Container(
                                                  width: 296.66473388671875,
                                                  height: 24.0002498626709,
                                                  decoration: BoxDecoration(),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        top:
                                                            -1.7167816162109375,
                                                        left: 0,
                                                        child: Text(
                                                          'Blood Pressure Monitor',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                  16,
                                                                  23,
                                                                  39,
                                                                  1,
                                                                ),
                                                            fontFamily: 'Arimo',
                                                            fontSize: 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.9900150299072266,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,

                                                    children: <Widget>[
                                                      Text(
                                                        'Medical Device',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                            105,
                                                            114,
                                                            130,
                                                            1,
                                                          ),
                                                          fontFamily: 'Arimo',
                                                          fontSize: 14,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height:
                                                              1.4285714285714286,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 71.94059753417969,
                                          left: 15.98011589050293,
                                          child: Container(
                                            width: 128.18177795410156,
                                            height: 26.526592254638672,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                topRight: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomRight: Radius.circular(
                                                  43057800,
                                                ),
                                              ),
                                              color: Color.fromRGBO(
                                                220,
                                                252,
                                                231,
                                                1,
                                              ),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                  184,
                                                  247,
                                                  207,
                                                  1,
                                                ),
                                                width: 1.2832200527191162,
                                              ),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  top: 4.2732391357421875,
                                                  left: 13.273319244384766,
                                                  child: Text(
                                                    'Excellent Condition',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        0,
                                                        130,
                                                        53,
                                                        1,
                                                      ),
                                                      fontFamily: 'Arimo',
                                                      fontSize: 12,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.3333333333333333,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 110.45729064941406,
                                          left: 15.98011589050293,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical: 0,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,

                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,

                                                    children: <Widget>[
                                                      Container(
                                                        width:
                                                            15.98011589050293,
                                                        height:
                                                            15.98011589050293,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top:
                                                                  1.3316763639450073,
                                                              left:
                                                                  2.6633527278900146,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  4.660867214202881,
                                                              left:
                                                                  5.9925432205200195,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            7.980031967163086,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0,
                                                            ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,

                                                          children: <Widget>[
                                                            Text(
                                                              'Clinic Room 3',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color:
                                                                    Color.fromRGBO(
                                                                      73,
                                                                      85,
                                                                      101,
                                                                      1,
                                                                    ),
                                                                fontFamily:
                                                                    'Arimo',
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height:
                                                                    1.4285714285714286,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 7.980032920837402,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,

                                                    children: <Widget>[
                                                      Container(
                                                        width:
                                                            15.98011589050293,
                                                        height:
                                                            15.98011589050293,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top:
                                                                  1.3330415487289429,
                                                              left:
                                                                  1.9975144863128662,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  7.9900593757629395,
                                                              left:
                                                                  7.990057945251465,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  4.660867214202881,
                                                              left:
                                                                  2.190608263015747,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top:
                                                                  2.8431291580200195,
                                                              left:
                                                                  4.993786334991455,
                                                              child: SvgPicture.asset(
                                                                'assets/images/vector.svg',
                                                                semanticsLabel:
                                                                    'vector',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            7.980031967163086,
                                                      ),
                                                      Container(
                                                        width:
                                                            67.60972595214844,
                                                        height:
                                                            19.990182876586914,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top: -2,
                                                              left: 0,
                                                              child: Text(
                                                                'Quantity:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                        73,
                                                                        85,
                                                                        101,
                                                                        1,
                                                                      ),
                                                                  fontFamily:
                                                                      'Arimo',
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  height:
                                                                      1.4285714285714286,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              left:
                                                                  60.05074691772461,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(),
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          0,
                                                                      vertical:
                                                                          0,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,

                                                                  children: <Widget>[
                                                                    Text(
                                                                      '8',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                          16,
                                                                          23,
                                                                          39,
                                                                          1,
                                                                        ),
                                                                        fontFamily:
                                                                            'Arimo',
                                                                        fontSize:
                                                                            14,
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        height:
                                                                            1.4285714285714286,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 1.283233642578125,
                                  left: 1.2832221984863281,
                                  child: Container(
                                    width: 328.6249694824219,
                                    height: 159.9816131591797,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(243, 244, 246, 1),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            width: 328.6249694824219,
                                            height: 159.9816131591797,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  'assets/images/Imagewithfallback.png',
                                                ),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            child: Stack(children: <Widget>[
          
        ]
      ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 13.132965087890625,
                                          left: 245.1353759765625,
                                          child: Container(
                                            width: 71.4994888305664,
                                            height: 23.37868881225586,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                topRight: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  43057800,
                                                ),
                                                bottomRight: Radius.circular(
                                                  43057800,
                                                ),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    0.10000000149011612,
                                                  ),
                                                  offset: Offset(0, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                              color: Color.fromRGBO(
                                                0,
                                                201,
                                                80,
                                                1,
                                              ),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  top: 2.989990234375,
                                                  left: 11.9901123046875,
                                                  child: Text(
                                                    'Available',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1,
                                                      ),
                                                      fontFamily: 'Arimo',
                                                      fontSize: 12,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.3333333333333333,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 1062.7879638671875,
                          left: 15.98011589050293,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.10000000149011612,
                                  ),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(242, 244, 246, 1),
                                width: 1.2832200527191162,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 1.2832221984863281,
                              vertical: 1.2832183837890625,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: <Widget>[
                                Container(
                                  width: 328.6249694824219,
                                  height: 159.9816131591797,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(243, 244, 246, 1),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: 328.6249694824219,
                                          height: 159.9816131591797,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/Imagewithfallback.png',
                                              ),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          child: Stack(children: <Widget>[
          
        ]
      ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 13.132972717285156,
                                        left: 224.22288513183594,
                                        child: Container(
                                          width: 92.4119873046875,
                                          height: 23.37868881225586,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                43057800,
                                              ),
                                              topRight: Radius.circular(
                                                43057800,
                                              ),
                                              bottomLeft: Radius.circular(
                                                43057800,
                                              ),
                                              bottomRight: Radius.circular(
                                                43057800,
                                              ),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  0.10000000149011612,
                                                ),
                                                offset: Offset(0, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                            color: Color.fromRGBO(
                                              106,
                                              114,
                                              130,
                                              1,
                                            ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 2.9900131225585938,
                                                left: 11.990097045898438,
                                                child: Text(
                                                  'Maintenance',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      255,
                                                      255,
                                                      255,
                                                      1,
                                                    ),
                                                    fontFamily: 'Arimo',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3333333333333333,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 0),
                                Container(
                                  width: 328.6249694824219,
                                  height: 174.39779663085938,
                                  decoration: BoxDecoration(),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 15.980117797851562,
                                        left: 15.98011589050293,
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Container(
                                                width: 296.66473388671875,
                                                height: 24.0002498626709,
                                                decoration: BoxDecoration(),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Positioned(
                                                      top: -1.7167816162109375,
                                                      left: 0,
                                                      child: Text(
                                                        'Hospital Bed',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                            16,
                                                            23,
                                                            39,
                                                            1,
                                                          ),
                                                          fontFamily: 'Arimo',
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.9900150299072266,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Text(
                                                      'Furniture',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                          105,
                                                          114,
                                                          130,
                                                          1,
                                                        ),
                                                        fontFamily: 'Arimo',
                                                        fontSize: 14,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        height:
                                                            1.4285714285714286,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 71.94059753417969,
                                        left: 15.98011589050293,
                                        child: Container(
                                          width: 100.49227142333984,
                                          height: 26.526592254638672,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                43057800,
                                              ),
                                              topRight: Radius.circular(
                                                43057800,
                                              ),
                                              bottomLeft: Radius.circular(
                                                43057800,
                                              ),
                                              bottomRight: Radius.circular(
                                                43057800,
                                              ),
                                            ),
                                            color: Color.fromRGBO(
                                              254,
                                              249,
                                              194,
                                              1,
                                            ),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                254,
                                                239,
                                                133,
                                                1,
                                              ),
                                              width: 1.2832200527191162,
                                            ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 4.27325439453125,
                                                left: 13.273319244384766,
                                                child: Text(
                                                  'Fair Condition',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      166,
                                                      95,
                                                      0,
                                                      1,
                                                    ),
                                                    fontFamily: 'Arimo',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3333333333333333,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 110.45729064941406,
                                        left: 15.98011589050293,
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Container(
                                                      width: 15.98011589050293,
                                                      height: 15.98011589050293,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top:
                                                                1.3316763639450073,
                                                            left:
                                                                2.6633527278900146,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                4.660867214202881,
                                                            left:
                                                                5.9925432205200195,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.980031967163086,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,

                                                        children: <Widget>[
                                                          Text(
                                                            'Storage Room A',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color:
                                                                  Color.fromRGBO(
                                                                    73,
                                                                    85,
                                                                    101,
                                                                    1,
                                                                  ),
                                                              fontFamily:
                                                                  'Arimo',
                                                              fontSize: 14,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height:
                                                                  1.4285714285714286,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7.980031967163086,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Container(
                                                      width: 15.98011589050293,
                                                      height: 15.98011589050293,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top:
                                                                1.3330377340316772,
                                                            left:
                                                                1.9975144863128662,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                7.990057945251465,
                                                            left:
                                                                7.990057945251465,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                4.660867214202881,
                                                            left:
                                                                2.190608263015747,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                2.8431215286254883,
                                                            left:
                                                                4.993786334991455,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.980031967163086,
                                                    ),
                                                    Container(
                                                      width: 67.60972595214844,
                                                      height:
                                                          19.990182876586914,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top: -2,
                                                            left: 0,
                                                            child: Text(
                                                              'Quantity:',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color:
                                                                    Color.fromRGBO(
                                                                      73,
                                                                      85,
                                                                      101,
                                                                      1,
                                                                    ),
                                                                fontFamily:
                                                                    'Arimo',
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height:
                                                                    1.4285714285714286,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            left:
                                                                60.05074691772461,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical: 0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,

                                                                children: <Widget>[
                                                                  Text(
                                                                    '2',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                      color:
                                                                          Color.fromRGBO(
                                                                            16,
                                                                            23,
                                                                            39,
                                                                            1,
                                                                          ),
                                                                      fontFamily:
                                                                          'Arimo',
                                                                      fontSize:
                                                                          14,
                                                                      letterSpacing:
                                                                          0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      height:
                                                                          1.4285714285714286,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 1411.7239990234375,
                          left: 15.98011589050293,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.10000000149011612,
                                  ),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(242, 244, 246, 1),
                                width: 1.2832200527191162,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 1.2832221984863281,
                              vertical: 1.283233642578125,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: <Widget>[
                                Container(
                                  width: 328.6249694824219,
                                  height: 159.9816131591797,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(243, 244, 246, 1),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: 328.6249694824219,
                                          height: 159.9816131591797,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/Imagewithfallback.png',
                                              ),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          child: Stack(children: <Widget>[
          
        ]
      ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 13.132965087890625,
                                        left: 245.1353759765625,
                                        child: Container(
                                          width: 71.4994888305664,
                                          height: 23.37868881225586,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                43057800,
                                              ),
                                              topRight: Radius.circular(
                                                43057800,
                                              ),
                                              bottomLeft: Radius.circular(
                                                43057800,
                                              ),
                                              bottomRight: Radius.circular(
                                                43057800,
                                              ),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  0.10000000149011612,
                                                ),
                                                offset: Offset(0, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                            color: Color.fromRGBO(
                                              0,
                                              201,
                                              80,
                                              1,
                                            ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 2.990020751953125,
                                                left: 11.9901123046875,
                                                child: Text(
                                                  'Available',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      255,
                                                      255,
                                                      255,
                                                      1,
                                                    ),
                                                    fontFamily: 'Arimo',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3333333333333333,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 0.0000152587890625),
                                Container(
                                  width: 328.6249694824219,
                                  height: 174.39779663085938,
                                  decoration: BoxDecoration(),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 15.9801025390625,
                                        left: 15.98011589050293,
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Container(
                                                width: 296.66473388671875,
                                                height: 24.0002498626709,
                                                decoration: BoxDecoration(),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Positioned(
                                                      top: -1.716796875,
                                                      left: 0,
                                                      child: Text(
                                                        'Thermometer',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                            16,
                                                            23,
                                                            39,
                                                            1,
                                                          ),
                                                          fontFamily: 'Arimo',
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.9899845123291016,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Text(
                                                      'Medical Device',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                          105,
                                                          114,
                                                          130,
                                                          1,
                                                        ),
                                                        fontFamily: 'Arimo',
                                                        fontSize: 14,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        height:
                                                            1.4285714285714286,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 71.9405517578125,
                                        left: 15.98011589050293,
                                        child: Container(
                                          width: 128.18177795410156,
                                          height: 26.526592254638672,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                43057800,
                                              ),
                                              topRight: Radius.circular(
                                                43057800,
                                              ),
                                              bottomLeft: Radius.circular(
                                                43057800,
                                              ),
                                              bottomRight: Radius.circular(
                                                43057800,
                                              ),
                                            ),
                                            color: Color.fromRGBO(
                                              220,
                                              252,
                                              231,
                                              1,
                                            ),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                184,
                                                247,
                                                207,
                                                1,
                                              ),
                                              width: 1.2832200527191162,
                                            ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 4.27325439453125,
                                                left: 13.273319244384766,
                                                child: Text(
                                                  'Excellent Condition',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      0,
                                                      130,
                                                      53,
                                                      1,
                                                    ),
                                                    fontFamily: 'Arimo',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3333333333333333,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 110.457275390625,
                                        left: 15.98011589050293,
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Container(
                                                      width: 15.98011589050293,
                                                      height: 15.98011589050293,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top:
                                                                1.3316763639450073,
                                                            left:
                                                                2.6633527278900146,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                4.660867214202881,
                                                            left:
                                                                5.9925432205200195,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.980031967163086,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,

                                                        children: <Widget>[
                                                          Text(
                                                            'Clinic Room 1',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color:
                                                                  Color.fromRGBO(
                                                                    73,
                                                                    85,
                                                                    101,
                                                                    1,
                                                                  ),
                                                              fontFamily:
                                                                  'Arimo',
                                                              fontSize: 14,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height:
                                                                  1.4285714285714286,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7.980031967163086,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: <Widget>[
                                                    Container(
                                                      width: 15.98011589050293,
                                                      height: 15.98011589050293,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top:
                                                                1.3330581188201904,
                                                            left:
                                                                1.9975144863128662,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                7.990057945251465,
                                                            left:
                                                                7.990057945251465,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                4.660867214202881,
                                                            left:
                                                                2.190608263015747,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top:
                                                                2.843142032623291,
                                                            left:
                                                                4.993786334991455,
                                                            child: SvgPicture.asset(
                                                              'assets/images/vector.svg',
                                                              semanticsLabel:
                                                                  'vector',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.980031967163086,
                                                    ),
                                                    Container(
                                                      width: 75.14865112304688,
                                                      height:
                                                          19.990182876586914,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            top: -2,
                                                            left: 0,
                                                            child: Text(
                                                              'Quantity:',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color:
                                                                    Color.fromRGBO(
                                                                      73,
                                                                      85,
                                                                      101,
                                                                      1,
                                                                    ),
                                                                fontFamily:
                                                                    'Arimo',
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height:
                                                                    1.4285714285714286,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            left:
                                                                60.05074691772461,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical: 0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,

                                                                children: <Widget>[
                                                                  Text(
                                                                    '15',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                      color:
                                                                          Color.fromRGBO(
                                                                            16,
                                                                            23,
                                                                            39,
                                                                            1,
                                                                          ),
                                                                      fontFamily:
                                                                          'Arimo',
                                                                      fontSize:
                                                                          14,
                                                                      letterSpacing:
                                                                          0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      height:
                                                                          1.4285714285714286,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 1898.78662109375,
            left: 197.89678955078125,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(43057800),
                  topRight: Radius.circular(43057800),
                  bottomLeft: Radius.circular(43057800),
                  bottomRight: Radius.circular(43057800),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
                color: Color.fromRGBO(21, 93, 252, 1),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 23.980209350585938,
                vertical: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  Container(
                    width: 19.990182876586914,
                    height: 19.990182876586914,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 9.995091438293457,
                          left: 4.164621353149414,
                          child: SvgPicture.asset(
                            'assets/images/vector.svg',
                            semanticsLabel: 'vector',
                          ),
                        ),
                        Positioned(
                          top: 4.164621353149414,
                          left: 9.995091438293457,
                          child: SvgPicture.asset(
                            'assets/images/vector.svg',
                            semanticsLabel: 'vector',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 7.980031967163086),
                  Container(
                    width: 65.34403991699219,
                    height: 24.0002498626709,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: -1.716796875,
                          left: 1,
                          child: Text(
                            'Add Item',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Arimo',
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
