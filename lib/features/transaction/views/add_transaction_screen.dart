import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/core/widgets/custom_text_field.dart';
import 'package:kipcount/core/widgets/custom_button.dart';
import 'package:kipcount/features/transaction/controllers/transaction_controller.dart';

class AddTransactionScreen extends GetView<TransactionController> {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 24),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Income / Expense Toggle
                  _buildTypeToggle(),
                  const SizedBox(height: 28),
                  // Transaction Details
                  Text(
                    'Transaction Details',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  // Category Dropdown
                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),
                  // Title
                  CustomTextField(
                    label: 'Title',
                    hintText: 'e.g., Groceries, Rent',
                    onChanged: (val) => controller.title.value = val,
                  ),
                  const SizedBox(height: 16),
                  // Amount
                  CustomTextField(
                    label: 'Amount',
                    hintText: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: Icons.attach_money_rounded,
                    onChanged: (val) => controller.amount.value = val,
                  ),
                  const SizedBox(height: 16),
                  // Date
                  CustomTextField(
                    label: 'Date',
                    hintText: '08/15/2024',
                    readOnly: true,
                    suffixIcon: Icons.calendar_today_rounded,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        controller.date.value =
                            '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  // Additional Information
                  Text(
                    'Additional Information (Optional)',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  // Notes
                  CustomTextField(
                    label: 'Notes',
                    hintText: 'Add a note...',
                    maxLines: 3,
                    onChanged: (val) => controller.notes.value = val,
                  ),
                  const SizedBox(height: 16),
                  // Tags
                  CustomTextField(
                    label: 'Tags',
                    hintText: 'e.g., #urgent',
                    onChanged: (val) => controller.tags.value = val,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Save Button
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Obx(
              () => CustomButton(
                text: 'Save Transaction',
                isLoading: controller.isLoading.value,
                onPressed: controller.saveTransaction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    final types = ['Income', 'Expense'];
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(2, (index) {
            final isSelected = controller.selectedType.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeType(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    types[index],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.label),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.category.value.isEmpty
                    ? null
                    : controller.category.value,
                hint: Text(
                  'Select category',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textGrey,
                ),
                style: AppTextStyles.bodyMedium,
                isExpanded: true,
                items: controller.categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) controller.category.value = val;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
