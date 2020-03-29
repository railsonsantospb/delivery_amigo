import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jonasbebidas/pages/product_detail.dart';

class Building {
  final String produt_name;
  final String produt_price;
  final String produt_picture;

  Building({
    this.produt_name,
    this.produt_price,
    this.produt_picture
  });
}



class SearchList extends StatefulWidget {
  final header;


  SearchList({Key key, this.header}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();


}


class _SearchListState extends State<SearchList> {



  var product_list = [
    {
      "name": "Burguesa",
      "picture": "images/products/bear1.jpg",
      "price": "8,00"
    },
    {
      "name": "Guaraná",
      "picture": "images/products/refri1.jpg",
      "price": "6,00"
    },
    {
      "name": "Crystal",
      "picture": "images/products/water1.jpg",
      "price": "1,50"
    },
    {
      "name": "Vinho Tinto",
      "picture": "images/products/wine1.jpg",
      "price": "15,00"
    },
    {
      "name": "Heineken",
      "picture": "images/products/bear2.jpg",
      "price": "5,00"
    },{
      "name": "CocaCola",
      "picture": "images/products/refri2.jpg",
      "price": "6,00"
    },
    {
      "name": "Crystal",
      "picture": "images/products/water2.jpg",
      "price": "2,00"
    },
    {
      "name": "Cristalle",
      "picture": "images/products/wine2.png",
      "price": "16,00"
    }
  ];


  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List<Building> _list;
  List<Building> _searchList = List();


  bool _IsSearching;
  String _searchText = "";

  _SearchListState() {

    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {

          _IsSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {

          _IsSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });


  }

  Widget appBarTitle = Text(

    "Jonas Bebidas",

  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    init();
  }

  void init() {
    _list = List();

    for(int i = 0; i < product_list.length; i++){
      _list.add(
        Building(produt_name: product_list[i]["name"],
          produt_picture: product_list[i]["picture"],
          produt_price: product_list[i]["price"],
        )
      );
    }
    _searchList = _list;
  }

  @override
  Widget build(BuildContext context) {

    //SizeConfig().init(context);
    return Scaffold(
        key: key,
        appBar: buildBar(context),
        body: GridView.builder(
            itemCount: _searchList.length,
            itemBuilder: (context, index) {
              return Uiitem(_searchList[index]);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            )

        ));
  }

  List<Building> _buildList() {
    return _list; //_list.map((contact) =>  Uiitem(contact)).toList();
  }

  List<Building> _buildSearchList() {

    if (_searchText.isEmpty) {
      return _searchList =
          _list; //_list.map((contact) =>  Uiitem(contact)).toList();
    } else {
      /*for (int i = 0; i < _list.length; i++) {
        String name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }*/

      _searchList = _list
          .where((element) =>
      element.produt_name.toLowerCase().contains(_searchText.toLowerCase()) ||
          element.produt_price.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      print('${_searchList.length}');
      return _searchList; //_searchList.map((contact) =>  Uiitem(contact)).toList();
    }
  }

  Widget buildBar(BuildContext context) {

    return AppBar(

        centerTitle: true,
        title: appBarTitle,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = TextField(
                    controller: _searchQuery,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        hintText: "Procure pela marca ("+widget.header+")",
                        hintStyle: TextStyle(color: Colors.white)),
                  );

                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        widget.header,
        style: TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }
}

class Uiitem extends StatelessWidget {
  final Building building;
  Uiitem(this.building);

  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text("hero 1"),
        child: Material(
          child: InkWell(
            onTap: ()=>
                Navigator
                    .of(context)
                    .push(new MaterialPageRoute(
                  // here we are passing the values of the products
                  // to the product details
                    builder: (context)=> new ProductDetails(
                      produt_detail_name: building.produt_name,
                      produt_detail_new_price: building.produt_name,
                      produt_detail_picture: building.produt_picture,
                    ))),
            child: GridTile(
              footer: Container(
                padding: const EdgeInsets.all(9.0),
                color: Colors.white70,
                child: new Row(

                  children: <Widget>[
                    Expanded(
                      child: Text(building.produt_name,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 16.0),),
                    ),
                    new Text("R\$${building.produt_price}",
                      style: TextStyle(color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              child: Image.asset(building.produt_picture,
                fit: BoxFit.cover,),
            ),
          ),
        ),
      ),
    );

  }
}

//void main() {
//  runApp(MyApp());
//}

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: SearchList(),
//    );
//  }
//}