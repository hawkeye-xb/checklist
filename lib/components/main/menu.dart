import 'package:flutter/material.dart';

class MenuItem {
  final String label;
  final String value;

  MenuItem({required this.label, required this.value});
}

class MainHeadMenu extends StatelessWidget {
  final Icon icon;
  final List<MenuItem> menuItems;
  final Function(String) onItemSelected;

  const MainHeadMenu({
    super.key,
    required this.icon,
    required this.menuItems,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: Offset(-16, AppBar().preferredSize.height - 10), // 设置偏移量
      icon: icon,
      onSelected: onItemSelected,
      itemBuilder: (BuildContext context) {
        return menuItems.map((MenuItem menuItem) {
          return PopupMenuItem<String>(
            value: menuItem.value,
            child: Text(menuItem.label),
          );
        }).toList();
      },
    );
  }
}