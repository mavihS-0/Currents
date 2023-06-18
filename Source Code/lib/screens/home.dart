import 'dart:convert';

import 'package:currents/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:country_picker/country_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //declaring variable
  String selectedCountry = 'null';
  String search = 'null';
  List <dynamic> articles = [];


  //api service to get the articles
  void getArticles() async {
    //dialog to show loading while waiting for response
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> Center(child: SpinKitThreeBounce(
        size: 30,
        color: DarkShade,
      )),
    );

    //setting url based on search and selected country's values
    var url = selectedCountry!='null' && search != 'null' ?
    Uri.https('newsapi.org','/v2/everything',{'q': '$search+$selectedCountry','apiKey':'YourApiKey','sortBy':'publishedAt'}) :
        search == 'null' ? selectedCountry!='null' ?Uri.https('newsapi.org','/v2/everything',{'q': selectedCountry,'apiKey':'YourApiKey','sortBy':'publishedAt'}) :
        Uri.https('newsapi.org','/v2/everything',{'q': 'world','apiKey':'YourApiKey','sortBy':'publishedAt'}) :
        Uri.https('newsapi.org','/v2/everything',{'q': search,'apiKey':'YourApiKey','sortBy':'publishedAt'});


    var response = await get(url);
    if(response.statusCode==200){
      var jsonResponse =jsonDecode(response.body) as Map <String, dynamic>;
        articles = jsonResponse['articles'];
    }
    else{
      //displaying error message
      Get.snackbar('Error', 'Request failed with error code ${response.statusCode}');
    }
    Get.back();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //calling api service on initial build
    Future.delayed(Duration.zero, () {
      getArticles();
    });  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: BgColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            //widget to reload the api service
            child: LiquidPullToRefresh(
              onRefresh: () async {
                getArticles();
                return Future(() => null);},
              showChildOpacityTransition: false,
              backgroundColor: LightShade,
              child: Container(
                padding: EdgeInsets.only(left: 20,right: 20,top: 30),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.06,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          filled: true,
                          fillColor: SuperLightShade,
                          contentPadding: EdgeInsets.all(10),
                          prefixIcon: Icon(Icons.search,color: TextColor,size: MediaQuery.of(context).size.height*0.025,),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: SuperLightShade),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: SuperLightShade),
                          )
                        ),
                        style: TextStyle(
                          color: TextColor,
                          fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                        onSubmitted: (value) async {
                          //print(value);
                          search= value;
                          getArticles();
                        },
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Top Stories',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TextColor,
                            fontSize: MediaQuery.of(context).size.height*0.025,
                          ),),
                        ),
                        //Filter country button
                        Container(
                          margin: EdgeInsets.symmetric(vertical:5, horizontal: 5),
                          padding: EdgeInsets.all(4),
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width*0.3,
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Country',style: TextStyle(color: TextColor),),
                                Icon(Icons.filter_alt_outlined,color: TextColor,),
                              ],
                            ),
                            onPressed: (){
                              showCountryPicker(
                                  context: context,
                                  onSelect: (Country country)async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context)=> Center(child: SpinKitThreeBounce(
                                        size: 30,
                                        color: DarkShade,
                                      )),
                                    );
                                    selectedCountry= await country.name;
                                    Get.back();
                                    getArticles();
                                  },
                                  countryListTheme: CountryListThemeData(
                                    borderRadius: BorderRadius.circular(30),
                                    backgroundColor: SuperLightShade,
                                    inputDecoration: InputDecoration(
                                        hintText: 'Search',
                                        filled: true,
                                        fillColor: LightShade,
                                        contentPadding: EdgeInsets.all(10),
                                        prefixIcon: Icon(Icons.search,color: TextColor,size: MediaQuery.of(context).size.height*0.025,),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color: SuperLightShade),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color: SuperLightShade),
                                        )
                                    ),
                                  ),
                              );
                            },

                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: LightShade,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1,thickness: 2,endIndent: MediaQuery.of(context).size.width*0.67, indent: 12,color: TextColor,),
                    SizedBox(height: 20,),
                    Container(
                      height: MediaQuery.of(context).size.height*0.68,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: articles.length,
                        shrinkWrap: true,
                        itemBuilder: (_,i){
                          return GestureDetector(
                            onTap: (){
                              //passing arguments to details page
                              Get.to(()=>DetailsPage(),arguments: {
                                'source_name' : articles[i]['source']['name'],
                                'title' : articles[i]['title'],
                                'author' : articles[i]['author'],
                                'desc': articles[i]['description'],
                                'image' : articles[i]['urlToImage'],
                                'publishedAt' : articles[i]['publishedAt'],
                                'content' : articles[i]['content'],
                                'url' : articles[i]['url'],
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height*0.3,
                              width: MediaQuery.of(context).size.width,
                              //null check for image url
                              child: articles[i]['urlToImage'] != null ? Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.2,
                                    width: MediaQuery.of(context).size.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          articles[i]['urlToImage'],
                                        fit: BoxFit.fill,
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
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.06,
                                    child: AutoSizeText(articles[i]['title'],
                                    //maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),),
                                  )
                                ],
                              ) :
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.1,
                                    child: AutoSizeText(articles[i]['title'],
                                      //maxLines: 3,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    child: AutoSizeText(articles[i]['description'],
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: SuperLightShade,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        )
    );
  }
}
