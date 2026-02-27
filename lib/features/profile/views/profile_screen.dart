import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/features/profile/controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 22),
            onPressed: () => controller.showChangeNameDialog(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 32),
            // Account Settings
            Text('ACCOUNT SETTINGS', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _SettingsItem(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                onTap: () => controller.showChangeNameDialog(),
              ),
              _SettingsItem(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.link_rounded,
                title: 'Linked Accounts',
                onTap: () {},
                showDivider: false,
              ),
            ]),
            const SizedBox(height: 24),
            // Preferences
            Text('PREFERENCES', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.shield_outlined,
                title: 'Privacy & Security',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.language_rounded,
                title: 'Language',
                trailing: Obx(
                  () => Text(
                    controller.selectedLanguage.value,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                onTap: () {},
                showDivider: false,
              ),
            ]),
            const SizedBox(height: 28),
            // Logout Button
            _buildLogoutButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 44,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => Text(
              controller.userName.value,
              style: AppTextStyles.headingSmall,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(controller.email.value, style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: AppColors.textDark, size: 22),
                title: Text(item.title, style: AppTextStyles.bodyMedium),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.trailing != null) ...[
                      item.trailing!,
                      const SizedBox(width: 4),
                    ],
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textGrey,
                      size: 22,
                    ),
                  ],
                ),
                onTap: item.onTap,
              ),
              if (item.showDivider)
                const Divider(height: 1, indent: 56, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: controller.logout,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.logoutBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.logoutText, size: 20),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.logoutText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });
}
