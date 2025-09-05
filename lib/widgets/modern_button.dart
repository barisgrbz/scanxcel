import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isOutlined;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const ModernButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.isOutlined = false,
    this.borderRadius = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      width: width,
      height: height ?? (isMobile ? 56 : 64),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: (backgroundColor ?? const Color(0xFF2E3A59)).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: isOutlined ? Colors.transparent : (backgroundColor ?? const Color(0xFF2E3A59)),
              border: isOutlined 
                ? Border.all(
                    color: backgroundColor ?? const Color(0xFF2E3A59),
                    width: 2,
                  )
                : null,
            ),
            child: Center(
              child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOutlined 
                          ? (backgroundColor ?? const Color(0xFF2E3A59))
                          : (textColor ?? Colors.white),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: iconColor ?? (isOutlined 
                            ? (backgroundColor ?? const Color(0xFF2E3A59))
                            : (textColor ?? Colors.white)),
                          size: ResponsiveHelper.getResponsiveIconSize(context),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: isOutlined 
                            ? (backgroundColor ?? const Color(0xFF2E3A59))
                            : (textColor ?? Colors.white),
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
