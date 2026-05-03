import 'package:flutter/material.dart';
import '../../../../core/models/nav_item.dart';
import '../../../../core/constants/colors.dart';

class DashboardUpwardMenu {
  static void show(BuildContext context, NavigationItem item, {required Function(SubItem) onSubItemTap}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(item.icon, color: AppColors.primary, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              ...item.children!.map((subItem) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: Icon(subItem.icon, color: AppColors.primary, size: 20),
                    title: Text(
                      subItem.label,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSubItemTap(subItem);
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
