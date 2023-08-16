import 'package:flutter/material.dart';

import 'apidoa.dart'; // Import your Apidoa class

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _doaData = []; // List to store fetched data
  List<dynamic> _filteredData = []; // List to store filtered data
  final String _newDoaName = ''; // Store the new doa name

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    Apidoa apiDoa = Apidoa();
    final List<dynamic> data = await apiDoa.getdataDoa();
    setState(() {
      _doaData = data;
      _filteredData = data;
    });
  }

  void _filterData(String keyword) {
    setState(() {
      _filteredData = _doaData.where((item) {
        String doa = item['doa'].toString().toLowerCase();
        String latin = item['latin'].toString().toLowerCase();
        String artinya = item['artinya'].toString().toLowerCase();
        return doa.contains(keyword) ||
            latin.contains(keyword) ||
            artinya.contains(keyword);
      }).toList();
    });
  }

  void _showDoaDetails(Map<String, dynamic> doaData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(doaData['doa']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ayat: ${doaData['ayat']}'),
              const SizedBox(height: 8),
              Text('Latin: ${doaData['latin']}'),
              const SizedBox(height: 8),
              Text('Artinya: ${doaData['artinya']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doa-doa'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _filterData(value.toLowerCase()),
                decoration: const InputDecoration(
                  labelText: 'Search Doa',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = _filteredData[index];
                  return ListTile(
                    title: Text(item['doa']),
                    subtitle: Text(item['latin']),
                    onTap: () => _showDoaDetails(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
