import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class UserTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isSelected;
  final double height;
  final double width;

  const UserTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isSelected = false,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenWidth * 0.04,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 3)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.16,
                height: screenWidth * 0.16,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: screenWidth * 0.08,
                  color: isSelected 
                      ? AppColors.surface 
                      : AppColors.primary,
                ),
              ),
              SizedBox(height: screenWidth * 0.03),
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(height: screenWidth * 0.015),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.cardSubtitle.copyWith(
                  fontSize: screenWidth * 0.03,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
