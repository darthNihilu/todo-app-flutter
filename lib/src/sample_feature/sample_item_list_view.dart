import 'package:flutter/material.dart';
import 'package:jectis_todo/src/TaskListItem/TaskListItem.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

class Section {
  final String title;
  final List<SampleItem> items;

  Section(this.title, this.items);
}

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});

  static const String routeName = '/';

  @override
  SampleItemListViewState createState() => SampleItemListViewState();
}

class SampleItemListViewState extends State<SampleItemListView> {
  late List<Section> sections;

  @override
  void initState() {
    super.initState();

    sections = [
      Section("Прошедшие", [
        const SampleItem(1),
        const SampleItem(2),
        const SampleItem(3),
      ]),
      Section("Сегодня", [
        const SampleItem(1),
        const SampleItem(2),
        const SampleItem(3),
        const SampleItem(3),
        const SampleItem(3),
        const SampleItem(3),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0.0), // Adjust the height as needed
            child: TabBar(
              tabs: <Widget>[
                Tab(text: 'Основные'),
                Tab(text: 'Покупки'),
                Tab(text: 'Видео'),
              ],
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 16), // Adjust the font size
              labelPadding: EdgeInsets.zero, // Remove padding around labels
              indicatorWeight: 2.0, // Adjust the indicator thickness
            ),
          ),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: sections.length,
            itemBuilder: (BuildContext context, int index) {
              final section = sections[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 28.0,
                      right: 8.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    restorationId: 'listView_$index',
                    itemCount: section.items.length,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      final item = section.items[itemIndex];
                      return TaskListItem(
                        title:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit${item.id}',
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Add task',
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
