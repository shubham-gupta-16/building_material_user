import 'package:building_material_user/models/demo_entity.dart';
import 'package:building_material_user/network/api_response.dart';
import 'package:building_material_user/network/service/api_service.dart';
import 'package:building_material_user/ui/compontents/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context)
          ? const _MainArea()
          : Row(
              children: const [
                _SideMenu(),
                Expanded(child: _MainArea()),
              ],
            ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isTablet(context) ? 60 : 250,
      color: Colors.greenAccent,
    );
  }
}

class _MainArea extends StatelessWidget {
  const _MainArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = context.read<ApiService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder<ApiResponse<DemoEntity>>(
        future: apiService.getDemoList(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.isSuccessful) {
            final demoEntity = snapshot.data!.data!;
            final data = demoEntity.data;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(item.name ?? "NO NAME"),
                  subtitle: Text(item.pantoneValue),
                  onTap: () {

                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData){
            final apiResponse = snapshot.data;
            return Center(child: Text(apiResponse?.errorMessage ?? "Null Api Response"),);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      bottomNavigationBar: Responsive.isMobile(context)
          ? Container(
              color: Colors.greenAccent,
              height: 60,
            )
          : null,
    );
  }
}
