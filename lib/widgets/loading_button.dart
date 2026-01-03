import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final String? text;
  final VoidCallback onPressed;
  final Duration loadingDuration;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final ButtonType buttonType;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const LoadingButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.loadingDuration = const Duration(seconds: 2),
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.buttonType = ButtonType.elevated,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

enum ButtonType { elevated, icon, text, outlined }

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Show loading for specified duration
    await Future.delayed(widget.loadingDuration);

    // Execute the actual action
    widget.onPressed();

    // Hide loading
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.buttonType) {
      case ButtonType.icon:
        return _buildIconButton();
      case ButtonType.text:
        return _buildTextButton();
      case ButtonType.outlined:
        return _buildOutlinedButton();
      case ButtonType.elevated:
      default:
        return _buildElevatedButton();
    }
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handlePress,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? const Color(0xFF1E3A5F),
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.textColor ?? Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.textColor ?? Colors.white),
                    const SizedBox(width: 8),
                  ],
                  if (widget.text != null)
                    Text(
                      widget.text!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor ?? Colors.white,
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildIconButton() {
    return _isLoading
        ? SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.textColor ?? const Color(0xFF1E3A5F),
            ),
          )
        : IconButton(
            icon: Icon(widget.icon ?? Icons.check),
            onPressed: _handlePress,
            color: widget.textColor,
          );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: _isLoading ? null : _handlePress,
      child: _isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: widget.textColor ?? const Color(0xFF1E3A5F),
              ),
            )
          : Text(
              widget.text ?? '',
              style: TextStyle(color: widget.textColor ?? const Color(0xFF1E3A5F)),
            ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: _isLoading ? null : _handlePress,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: widget.backgroundColor ?? const Color(0xFF1E3A5F)),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: widget.backgroundColor ?? const Color(0xFF1E3A5F),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: widget.backgroundColor ?? const Color(0xFF1E3A5F)),
                  const SizedBox(width: 8),
                ],
                if (widget.text != null)
                  Text(
                    widget.text!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.backgroundColor ?? const Color(0xFF1E3A5F),
                    ),
                  ),
              ],
            ),
    );
  }
}
