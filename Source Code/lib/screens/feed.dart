import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:currents/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:url_launcher/url_launcher.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  //initializing variables
  late LiquidController liquidController;
  List <dynamic> articles = [];

  //Api  Service to get the articles
  void getArticles() async {
    //Loading dialog while waiting for response
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> Center(child: SpinKitThreeBounce(
        size: 30,
        //backgroundColor: SuperLightShade,
        color: DarkShade,
      )),
    );
    var url =  Uri.https('newsapi.org','/v2/everything',{'q': 'world','apiKey':'YourApiKey','sortBy':'publishedAt'});

    var response = await get(url);
    if(response.statusCode==200){
      var jsonResponse =jsonDecode(response.body) as Map <String, dynamic>;
      articles = jsonResponse['articles'];
    }
    else{
      //Displaying error message
      Get.snackbar('Error', 'Request failed with error code ${response.statusCode}');
    }
    Get.back();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    liquidController = LiquidController();
    super.initState();
    //calling api service on initial build
    Future.delayed(Duration.zero, () {
      getArticles();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BgColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('My Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: SuperLightShade,
      ),
      //Display a sized box of height 1 if articles.length ==0 to avoid null error
      body: articles.length != 0 ? LiquidSwipe.builder(
        itemCount: articles.length,
        waveType: WaveType.liquidReveal,
        liquidController: liquidController,
        fullTransitionValue: 900,
        slideIconWidget: Icon(Icons.arrow_back_ios),
        positionSlideIcon: 0.5,
        enableSideReveal: true,
        preferDragFromRevealedArea: true,
        enableLoop: true,
        ignoreUserGestureWhileAnimating: true,
        itemBuilder: (context,index){
          return Scaffold(
            backgroundColor: index%2==0 ? BgColor : SuperLightShade,
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.057,
                      child: AutoSizeText(articles[index]['title'],
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    articles[index]['author'] != null ? Row(children: [
                      Text('Author: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(articles[index]['author'])
                    ],) : SizedBox(height: 1,),
                    SizedBox(height: 10,),
                    articles[index]['urlToImage'] != null ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: MediaQuery.of(context).size.height*0.24,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          articles[index]['urlToImage'],
                          fit: BoxFit.fill,
                          //loading widget while the image loads
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network('https://www.pngall.com/wp-content/uploads/4/Exclamation-Mark.png',
                                    height: MediaQuery.of(context).size.height*0.1,
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Error loading image')
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ) : SizedBox(height: 1),
                    Row(children: [
                      Text('Published At: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(articles[index]['publishedAt'])
                    ],),
                    SizedBox(height: 40,),
                    Text(articles[index]['description'],
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),),
                    SizedBox(height: 20,),
                    Text(articles[index]['content'].toString().length <200 ?
                    articles[index]['content'] :
                    articles[index]['content'].toString().substring(0,200),
                      style: TextStyle(
                          fontSize: 17
                      ),),
                    SizedBox(height: 10,),
                    Text('Visit the website to learn more:',style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                    TextButton(
                      onPressed: ()async {
                        String url = '${articles[index]['url']}';
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(articles[index]['url'],
                        style: TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.underline,
                        ),),
                    )

                  ],
                ),
              ),
            ),
          );
        },
      ) : SizedBox() ,
    );
  }
}
