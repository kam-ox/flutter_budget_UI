import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/data/data.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/widgets/bar_chart.dart';

import '../helpers/color_helper.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _buildCategory(Category category, double totalAmountSpent) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryScreen(category),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(20),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)} / \$${category.maxAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxBarWidth = constraints.maxWidth;
                final double percent = (category.maxAmount - totalAmountSpent) /
                    category.maxAmount;
                double barWidth = percent * maxBarWidth;

                if (barWidth < 0) {
                  barWidth = 0;
                }
                return Stack(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: getColor(context, percent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // pinned: true, //* appbar always stays at the top of the screen
            expandedHeight: 100.0, //* height of the appbar
            forceElevated: true, //* shadow down the appbar
            centerTitle: true, //todo doesn't work
            floating: true, // * appbar like expands when scrolling up
            leading: IconButton(
              // * to set button on the left top corner
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                size: 30,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              //? what is this?
              title: Text('Simple Budget'),
            ),
            actions: [
              // * to set button on the right top corner
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                onPressed: () {},
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              //* just like ListView.builder()
              (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: BarChart(weeklySpending),
                  );
                } else {
                  final Category category = categories[index - 1];
                  double totalAmountSpent = 0;
                  category.expenses.forEach((Expense expense) {
                    totalAmountSpent += expense.cost;
                  });
                  return _buildCategory(category, totalAmountSpent);
                }
              },
              childCount: 1 + categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
