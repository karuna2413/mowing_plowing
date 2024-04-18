import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TotalScore extends StatefulWidget {
  final String responseOnTime;
  final String totalScore;
  final String completeJobsPerc;
  final String cancelJobsPerc;
  final String totalEarnings;
  final String totalJobs;
  final String totalRatings;
  const TotalScore({
    required this.responseOnTime,
    required this.totalScore,
    required this.completeJobsPerc,
    required this.cancelJobsPerc,
    required this.totalEarnings,
    required this.totalJobs,
    required this.totalRatings,
  });

  @override
  State<TotalScore> createState() => _TotalScoreState();
}

class _TotalScoreState extends State<TotalScore> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Score",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Image.asset("images/image27.png"),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                children: [
                  const Text(
                    "Score Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  const Text(
                    "Good work this week John!",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor("#0275D8"),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Reponse on time",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor("#7CC0FB"),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Cancel Jobs",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor("#24B550"),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Completed jobs",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          LinearPercentIndicator(
                            width: 100,
                            lineHeight: 15,
                            percent: double.parse(widget.responseOnTime),
                            barRadius: const Radius.circular(20),
                            backgroundColor: HexColor("#EAE7F0"),
                            progressColor: HexColor("#0275D8"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          LinearPercentIndicator(
                            width: 100.0,
                            lineHeight: 13.0,
                            percent: double.parse(widget.cancelJobsPerc),
                            barRadius: const Radius.circular(16),
                            backgroundColor: HexColor("#EAE7F0"),
                            progressColor: HexColor("#7CC0FB"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          LinearPercentIndicator(
                            width: 100.0,
                            lineHeight: 13.0,
                            percent: double.parse(widget.completeJobsPerc),
                            barRadius: const Radius.circular(16),
                            backgroundColor: HexColor("#EAE7F0"),
                            progressColor: HexColor("#24B550"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "${widget.totalScore} %",
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Total score",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "Total Ratings",
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              'images/thumb.png',
                              height: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${widget.totalRatings} out of 5",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: HexColor("#24B550"),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "Total Earnings",
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              'images/earning.png',
                              height: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "\$${widget.totalEarnings}",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: HexColor("#0275D8"),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "Total Jobs",
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              'images/job.png',
                              height: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${widget.totalJobs} Jobs",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
