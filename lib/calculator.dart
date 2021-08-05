import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class MyCalculator extends StatefulWidget {
  MyCalculator({Key key}) : super(key: key);

  @override
  _MyCalculatorState createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  String text = '';
  String operand;
  String number = '';
  String sum = '';
  var division = utf8.decode([0xC3, 0xB7]);

  BannerAd banner;
  bool _isBannerAdReady = false;
  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  onTapAction(String no) {
    if (no == '=') {
      _showInterstitialAd();
      return;
    }
    if (no == 'AC') {
      setState(() {
        text = '';
        operand = null;
        sum = '';
        number = '';
      });
      return;
    }
    if (no == 'X') {
      String newText = text.substring(0, text.length - 1);
      if (number.isNotEmpty) {
        setState(() {
          number = number.substring(0, number.length - 1);
        });
      } else {
        if (text.endsWith('$operand') == true) {
          setState(() {
            text = newText;
            operand = null;
          });
        } else {
          setState(() {
            text = newText;
          });
        }
      }
      return;
    }
    if (no == '%') {
      if (text.isEmpty) {
        return null;
      } else {
        if (sum.isNotEmpty) {
          setState(() {
            text = sum;
            sum = '';
            number = '';
            operand = null;
          });
        }
        if (text.endsWith('$operand') == false) {
          double _number = double.tryParse(text) / 100;
          setState(() {
            text = _number.toString();
          });
        }
      }
      return;
    }
    if (no == '.') {
      if (text.isEmpty) {
        setState(() {
          text = '0.';
        });
        return;
      } else {
        if (text.endsWith('$operand') && number.isEmpty) {
          setState(() {
            number = '0.';
          });
          return;
        }
        if (number.contains('.') == false && number.isNotEmpty) {
          setState(() {
            number = number + '.';
          });
        } else {
          if (text.endsWith('$operand') == false &&
              text.contains('.') == false) {
            String newText = text + '$no';
            setState(() {
              text = newText;
            });
          }
        }
      }
      return;
    }
    if (no == '+') {
      if (text.isEmpty) {
        return;
      } else {
        if (text.endsWith('.')) {
          setState(() {
            text = text + '0';
          });
        }
        if (sum.isNotEmpty && operand != null) {
          setState(() {
            text = sum + no;
            operand = no;
            number = '';
          });
        } else {
          if (text.endsWith('$operand') == false) {
            setState(() {
              text = text + no;
              operand = no;
            });
          }
        }
      }
      return;
    }
    if (no == '-') {
      if (text.isEmpty) {
        return;
      } else {
        if (text.endsWith('.')) {
          setState(() {
            text = text + '0';
          });
        }
        if (sum.isNotEmpty && operand != null) {
          setState(() {
            text = sum + no;
            operand = no;
            number = '';
          });
        } else {
          if (text.endsWith('$operand') == false) {
            setState(() {
              text = text + no;
              operand = no;
            });
          }
        }
      }
      return;
    }
    if (no == 'x') {
      if (text.isEmpty) {
        return;
      } else {
        if (text.endsWith('.')) {
          setState(() {
            text = text + '0';
          });
        }
        if (sum.isNotEmpty && operand != null) {
          setState(() {
            text = sum + no;
            operand = no;
            number = '';
          });
        } else {
          if (text.endsWith('$operand') == false) {
            setState(() {
              text = text + no;
              operand = no;
            });
          }
        }
      }
      return;
    }
    if (no == '$division') {
      if (text.isEmpty) {
        return;
      } else {
        if (text.endsWith('.')) {
          setState(() {
            text = text + '0';
          });
        }
        if (sum.isNotEmpty && operand != null) {
          setState(() {
            text = sum + division;
            operand = no;
            number = '';
          });
        } else {
          if (text.endsWith('$operand') == false) {
            setState(() {
              text = text + division;
              operand = no;
            });
          }
        }
      }
      return;
    }
    if (text.isEmpty) {
      if (no == '00' || no == '0') {
        return null;
      } else {
        setState(() {
          text = no;
        });
        return null;
      }
    } else {
      if (operand == null) {
        String newText = text + '$no';
        setState(() {
          text = newText;
        });
        return;
      } else {
        if (sum.isNotEmpty) {
          setState(() {
            number = number + '$no';
          });
          if (operand == '$division') {
            double _number = double.tryParse(text.replaceAll('$division', '')) /
                double.tryParse(number);
            if (_number.toString().endsWith('.0') == true) {
              setState(() {
                sum = _number
                    .toString()
                    .substring(0, _number.toString().length - 2);
              });
            } else {
              setState(() {
                sum = _number.toString();
              });
            }
            return;
          }
          if (operand == 'x') {
            double _number = double.tryParse(text.replaceAll('x', '')) *
                double.tryParse('$number');
            if (_number.toString().endsWith('.0') == true) {
              setState(() {
                sum = _number
                    .toString()
                    .substring(0, _number.toString().length - 2);
              });
            } else {
              setState(() {
                sum = _number.toString();
              });
            }
            return;
          }
          if (operand == '-') {
            double _number = double.tryParse(text.replaceAll('-', '')) -
                double.tryParse(number);
            if (_number.toString().endsWith('.0') == true) {
              setState(() {
                sum = _number
                    .toString()
                    .substring(0, _number.toString().length - 2);
              });
            } else {
              setState(() {
                sum = _number.toString();
              });
            }
            return;
          }
          if (operand == '+') {
            double _number = double.tryParse(text.replaceAll('+', '')) +
                double.tryParse(number);
            if (_number.toString().endsWith('.0') == true) {
              setState(() {
                sum = _number
                    .toString()
                    .substring(0, _number.toString().length - 2);
              });
            } else {
              setState(() {
                sum = _number.toString();
              });
            }
            return;
          }
        }
        if (operand == division) {
          setState(() {
            number = number + '$no';
          });
          double _number = double.tryParse(text.replaceAll('$division', '')) /
              double.tryParse(number);
          if (_number.toString().endsWith('.0') == true) {
            setState(() {
              sum = _number
                  .toString()
                  .substring(0, _number.toString().length - 2);
            });
          } else {
            setState(() {
              sum = _number.toString();
            });
          }
          return;
        }
        if (operand == 'x') {
          setState(() {
            number = number + '$no';
          });
          double _number = double.tryParse(text.replaceAll('x', '')) *
              double.tryParse(number);
          if (_number.toString().endsWith('.0') == true) {
            setState(() {
              sum = _number
                  .toString()
                  .substring(0, _number.toString().length - 2);
            });
          } else {
            setState(() {
              sum = _number.toString();
            });
          }
          return;
        }
        if (operand == '-') {
          setState(() {
            number = number + '$no';
          });
          double _number = double.tryParse(text.replaceAll('-', '')) -
              double.tryParse(number);
          if (_number.toString().endsWith('.0') == true) {
            setState(() {
              sum = _number
                  .toString()
                  .substring(0, _number.toString().length - 2);
            });
          } else {
            setState(() {
              sum = _number.toString();
            });
          }
          return;
        }
        if (operand == '+') {
          setState(() {
            number = number + '$no';
          });
          double _number = double.tryParse(text.replaceAll('+', '')) +
              double.tryParse(number);
          if (_number.toString().endsWith('.0') == true) {
            setState(() {
              sum = _number
                  .toString()
                  .substring(0, _number.toString().length - 2);
            });
          } else {
            setState(() {
              sum = _number.toString();
            });
          }
          return;
        }
      }
    }
  }

  _no(String no, double width, double height, [Color color]) {
    return Container(
      width: width,
      height: height,
      child: GestureDetector(
        onLongPressEnd: (details) {
          setState(() {});
          return null;
        },
        onLongPress: () {
          if (no == 'X') {
            if (operand == null) {
              setState(() {
                text = '';
              });
            } else {
              setState(() {
                operand = null;
              });
            }
            return null;
          }
        },
        onTap: () {
          onTapAction(no);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Material(
            elevation: 10,
            shadowColor: Colors.green,
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child: Text(
                no,
                style: color != null
                    ? TextStyle(color: color, fontSize: 30)
                    : TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // static final AdRequest request = AdRequest(
  //   keywords: <String>['foo', 'bar'],
  //   contentUrl: 'http://foo.com/bar.html',
  //   nonPersonalizedAds: true,
  // );

  RewardedAd _rewardedAd;

  BannerAd _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    _createAnchoredBanner(context);
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-4771455812622447/7679825413',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  Future<void> _createAnchoredBanner(BuildContext context) async {
    // final AnchoredAdaptiveBannerAdSize size =
    //     await AdSize.getAnchoredAdaptiveBannerAdSize(
    //   Orientation.portrait,
    //   MediaQuery.of(context).size.width.truncate(),
    // );

    // if (size == null) {
    //   print('Unable to get height of anchored banner.');
    //   return;
    // }

    banner = BannerAd(
      size: AdSize.banner,
      request: AdRequest(),
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4771455812622447/3284257168'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _isBannerAdReady = true;
            _anchoredBanner = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
    _rewardedAd.dispose();
    _anchoredBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceheight = MediaQuery.of(context).size.height - 50;
    final double _containerWidth =
        deviceWidth > 768.0 ? 500.0 : deviceWidth - 25;
    final double _containerheight =
        deviceheight > 768.0 ? 220.0 : deviceheight / 4.5;
    final width = _containerWidth / 4;
    final height = _containerheight / 2.5;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: Container(
          height: deviceheight,
          width: deviceWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Material(
                      elevation: 10,
                      color: Colors.white70,
                      borderOnForeground: true,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                width: _containerWidth,
                                height: _containerheight,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(color: Colors.red),
                                    BoxShadow(spreadRadius: 10, blurRadius: 5)
                                  ],
                                  shape: BoxShape.rectangle,
                                ),
                                alignment: Alignment.bottomRight,
                                child: SingleChildScrollView(
                                  reverse: true,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        text == '' ? '0' : '$text' + '$number',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: sum.isEmpty
                                                ? Colors.white
                                                : Colors.white60,
                                            fontSize: sum.isEmpty ? 50 : 20),
                                      ),
                                      sum.isEmpty
                                          ? Container(height: 0)
                                          : Text(
                                              '$sum',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 50),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    _no('AC', width, height, Colors.green),
                                    _no('X', width, height, Colors.green),
                                    _no('%', width, height, Colors.red),
                                    _no('$division', width, height, Colors.red)
                                  ],
                                ),
                                Row(
                                  children: [
                                    _no('7', width, height),
                                    _no('8', width, height),
                                    _no('9', width, height),
                                    _no('x', width, height, Colors.red)
                                  ],
                                ),
                                Row(
                                  children: [
                                    _no('4', width, height),
                                    _no('5', width, height),
                                    _no('6', width, height),
                                    _no('-', width, height, Colors.red)
                                  ],
                                ),
                                Row(
                                  children: [
                                    _no('1', width, height),
                                    _no('2', width, height),
                                    _no('3', width, height),
                                    _no('+', width, height, Colors.red)
                                  ],
                                ),
                                Row(
                                  children: [
                                    _no('00', width, height),
                                    _no('0', width, height),
                                    _no('.', width, height),
                                    _no('=', width, height, Colors.red)
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _isBannerAdReady == true
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(top: 10),
                      width: _anchoredBanner.size.width.toDouble(),
                      height: _anchoredBanner.size.height.toDouble(),
                      child: AdWidget(ad: banner),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
