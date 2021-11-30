import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Catalogue extends StatefulWidget {
  Catalogue({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CatalogueState();

}

class _CatalogueState extends State<Catalogue> {

  // List scroll = List.empty(growable: true);
  // @override
  // void initState() {
  //   super.initState();
  //   scroll.add('SAMANTHA');
  //   scroll.add('ANGELICA');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Recomended',
                    style: GoogleFonts.actor(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(
                    width: 195,
                  ),
                  Container(
                    child: Card(
                      color: Colors.grey[900],
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 0.8),
                            Text(
                              'more',
                              style: GoogleFonts.actor(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    height: 30,
                    width: 60,
                    color: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 280,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 210,
                            width: 140,
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'SAMANTHA',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 43,
                              ),
                              Text(
                                '£400',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '  RUSSIA',
                            style: GoogleFonts.actor(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 37,
                    ),
                    Container(
                      height: 280,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 210,
                            width: 140,
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'ANGELICA',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 43,
                              ),
                              Text(
                                '£540',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '  RUSSIA',
                            style: GoogleFonts.actor(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 37,
                    ),
                    Container(
                      height: 280,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 210,
                            width: 140,
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'MONGOLIA',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 43,
                              ),
                              Text(
                                '£700',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '  CANADA',
                            style: GoogleFonts.actor(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 37,
                    ),
                    Container(
                      height: 280,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 210,
                            width: 140,
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'HIBISCUSA',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 43,
                              ),
                              Text(
                                '£340',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '  POLAND',
                            style: GoogleFonts.actor(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 280,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 210,
                            width: 140,
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'LOVERY',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 43,
                              ),
                              Text(
                                '£700',
                                style: GoogleFonts.actor(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '  SCOTLAND',
                            style: GoogleFonts.actor(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 35,
                        ),
                        Container(
                          height: 280,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 210,
                                width: 140,
                                child: Image(
                                  image: AssetImage('assets/logo.png'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'BRAILER',
                                    style: GoogleFonts.actor(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 43,
                                  ),
                                  Text(
                                    '£270',
                                    style: GoogleFonts.actor(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '  ENGLAND',
                                style: GoogleFonts.actor(
                                  fontSize: 11,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 35,
                        ),
                        Container(
                          height: 280,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 210,
                                width: 140,
                                child: Image(
                                  image: AssetImage('assets/logo.png'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'SNAPKY',
                                    style: GoogleFonts.actor(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 43,
                                  ),
                                  Text(
                                    '£350',
                                    style: GoogleFonts.actor(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '  POLAND',
                                style: GoogleFonts.actor(
                                  fontSize: 11,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 35,
                        ),
                        Container(
                          height: 280,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 210,
                                width: 140,
                                child: Image(
                                  image: AssetImage('assets/logo.png'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'POOLBERRY',
                                    style: GoogleFonts.actor(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 41,
                                  ),
                                  Text(
                                    '£700',
                                    style: GoogleFonts.actor(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '  SOUTH AFRICA',
                                style: GoogleFonts.actor(
                                  fontSize: 11,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

}