import 'package:flutter/material.dart';
import '../core/theme/theme.dart';
import '../models/models.dart';

class LbScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Color? background;
  final Widget? bottomNav;
  final Widget? bottomBar;
  final bool padTop;

  const LbScaffold({
    super.key,
    required this.child,
    this.title = '',
    this.leading,
    this.actions,
    this.showBack = false,
    this.onBack,
    this.background,
    this.bottomNav,
    this.bottomBar,
    this.padTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background ?? LbColors.bg,
      body: SafeArea(
        top: padTop,
        child: Column(
          children: [
            if (title.isNotEmpty || showBack || leading != null || actions != null)
              _Header(
                title: title,
                showBack: showBack,
                onBack: onBack,
                leading: leading,
                actions: actions,
              ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: child,
                  ),
                  if (bottomBar != null)
                    Positioned(left: 0, right: 0, bottom: 0, child: bottomBar!),
                ],
              ),
            ),
            ?bottomNav,
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final List<Widget>? actions;

  const _Header({
    required this.title,
    required this.showBack,
    required this.onBack,
    required this.leading,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty && leading == null && (actions == null || actions!.isEmpty) && !showBack) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          if (showBack)
            _CircleButton(
              icon: Icons.chevron_left,
              onTap: onBack ?? () => Navigator.maybePop(context),
            ),
          if (showBack) const SizedBox(width: 8),
          ?leading,
          if (title.isNotEmpty)
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: LbColors.fg),
              ),
            )
          else
            const Spacer(),
          ...?actions,
        ],
      ),
    );
  }
}

class LbCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;
  final double size;
  final Widget? badge;
  final String? semanticLabel;
  const LbCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.background = LbColors.fg,
    this.foreground = LbColors.surface,
    this.size = 48,
    this.badge,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: foreground, size: size * 0.45),
              ),
              if (badge != null) Positioned(top: 8, right: 9, child: badge!),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LbCircleButton(
      icon: icon,
      size: 44,
      background: LbColors.surface,
      foreground: LbColors.fg,
      onTap: onTap ?? () => Navigator.maybePop(context),
    );
  }
}

class LbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color background;
  final Color? borderColor;
  final double radius;
  final VoidCallback? onTap;
  final String? semanticLabel;
  const LbCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.background = LbColors.surface,
    this.borderColor = LbColors.border,
    this.radius = 28,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: child,
    );
    if (onTap == null) return Semantics(label: semanticLabel, child: body);
    return Semantics(
      label: semanticLabel,
      button: true,
      child: GestureDetector(onTap: onTap, child: body),
    );
  }
}

class LbEyebrow extends StatelessWidget {
  final String text;
  final Color? color;
  const LbEyebrow(this.text, {super.key, this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        color: color ?? LbColors.muted,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
  }
}

class LbH1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final double? size;
  const LbH1(this.text, {super.key, this.color, this.align, this.size});
  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    final fontSize = size ?? (shortest < 360 ? 24.0 : (shortest < 420 ? 26.0 : 28.0));
    return Text(
      text,
      textAlign: align,
      softWrap: true,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? LbColors.fg,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.15,
      ),
    );
  }
}

class LbH2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const LbH2(this.text, {super.key, this.color, this.align});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      softWrap: true,
      style: TextStyle(
        fontSize: 22,
        color: color ?? LbColors.fg,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.25,
      ),
    );
  }
}

class LbH3 extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? weight;
  const LbH3(this.text, {super.key, this.color, this.weight});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      style: TextStyle(
        fontSize: 18,
        color: color ?? LbColors.fg,
        fontWeight: weight ?? FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      ),
    );
  }
}

class LbBody extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final FontWeight? weight;
  final TextAlign? align;
  final double? height;
  const LbBody(this.text, {super.key, this.color, this.size = 15, this.weight, this.align, this.height});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      softWrap: true,
      style: TextStyle(
        fontSize: size,
        color: color ?? LbColors.fg2,
        fontWeight: weight ?? FontWeight.w400,
        height: height ?? 1.55,
      ),
    );
  }
}

class LbMeta extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  const LbMeta(this.text, {super.key, this.color, this.size = 12});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color ?? LbColors.muted,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    );
  }
}

class LbNumber extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  const LbNumber(this.text, {super.key, this.color, this.size = 28});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color ?? LbColors.fg,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class LbPill extends StatelessWidget {
  final String label;
  final PillVariant variant;
  final IconData? icon;
  const LbPill({super.key, required this.label, required this.variant, this.icon});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (variant) {
      case PillVariant.success:
        bg = LbColors.successBg;
        fg = LbColors.pillSuccessFg;
        break;
      case PillVariant.warn:
        bg = LbColors.warnBg;
        fg = LbColors.pillWarnFg;
        break;
      case PillVariant.danger:
        bg = LbColors.dangerBg;
        fg = LbColors.pillDangerFg;
        break;
      case PillVariant.info:
        bg = LbColors.infoBg;
        fg = LbColors.pillInfoFg;
        break;
      case PillVariant.neutral:
        bg = LbColors.surface2;
        fg = LbColors.fg2;
        break;
      case PillVariant.accent:
        bg = LbColors.accentSoft;
        fg = LbColors.accent;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}

class LbBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final bool showDot;
  const LbBadge({super.key, required this.label, required this.variant, this.showDot = true});
  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (variant) {
      case BadgeVariant.draft:
        bg = LbColors.surface2;
        fg = LbColors.muted;
        break;
      case BadgeVariant.review:
        bg = LbColors.warnBg;
        fg = LbColors.pillWarnFg;
        break;
      case BadgeVariant.submitted:
        bg = LbColors.infoBg;
        fg = LbColors.pillInfoFg;
        break;
      case BadgeVariant.approved:
        bg = LbColors.successBg;
        fg = LbColors.pillSuccessFg;
        break;
      case BadgeVariant.rejected:
        bg = LbColors.dangerBg;
        fg = LbColors.pillDangerFg;
        break;
      case BadgeVariant.attention:
        bg = LbColors.warnBg;
        fg = LbColors.pillWarnFg;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class LbButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final LbButtonVariant variant;
  final IconData? leadingIcon;
  final double height;
  final Color? background;
  final Color? foreground;
  final double fontSize;
  const LbButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = LbButtonVariant.primary,
    this.leadingIcon,
    this.height = 52,
    this.background,
    this.foreground,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    Color? border;
    switch (variant) {
      case LbButtonVariant.primary:
        bg = background ?? LbColors.fg;
        fg = foreground ?? LbColors.surface;
        break;
      case LbButtonVariant.secondary:
        bg = LbColors.surface;
        fg = LbColors.fg;
        border = LbColors.border;
        break;
      case LbButtonVariant.danger:
        bg = LbColors.danger;
        fg = LbColors.surface;
        break;
      case LbButtonVariant.success:
        bg = LbColors.success;
        fg = LbColors.surface;
        break;
      case LbButtonVariant.warn:
        bg = LbColors.warn;
        fg = LbColors.surface;
        break;
      case LbButtonVariant.ghost:
        bg = Colors.transparent;
        fg = LbColors.fg;
        break;
    }
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: border == null ? null : Border.all(color: border),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: fg, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(color: fg, fontSize: fontSize, fontWeight: FontWeight.w600, letterSpacing: -0.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum LbButtonVariant { primary, secondary, danger, success, warn, ghost }

class LbTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final IconData? icon;
  const LbTextButton({super.key, required this.label, this.onTap, this.color, this.icon});
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 16, color: color ?? LbColors.fg), const SizedBox(width: 6)],
              Text(label, style: TextStyle(color: color ?? LbColors.fg, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class LbField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? value;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscure;
  final int maxLines;
  final IconData? leadingIcon;
  final String? helper;
  final Color? helperColor;
  final bool autofocus;
  final TextEditingController? controller;
  const LbField({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.onChanged,
    this.keyboardType,
    this.obscure = false,
    this.maxLines = 1,
    this.leadingIcon,
    this.helper,
    this.helperColor,
    this.autofocus = false,
    this.controller,
  });

  @override
  State<LbField> createState() => _LbFieldState();
}

class _LbFieldState extends State<LbField> {
  TextEditingController? _internal;

  TextEditingController? get _controller {
    if (widget.controller != null) return widget.controller;
    _internal ??= TextEditingController(text: widget.value);
    return _internal;
  }

  @override
  void didUpdateWidget(covariant LbField old) {
    super.didUpdateWidget(old);
    if (widget.controller == null &&
        old.value != widget.value &&
        _internal != null &&
        _internal!.text != (widget.value ?? '')) {
      _internal!.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _internal?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: const TextStyle(fontSize: 13, color: LbColors.fg2, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: LbColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LbColors.border),
          ),
          child: Row(
            children: [
              if (widget.leadingIcon != null) ...[
                Padding(padding: const EdgeInsets.only(left: 14), child: Icon(widget.leadingIcon, color: LbColors.muted, size: 18)),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscure,
                  maxLines: widget.obscure ? 1 : widget.maxLines,
                  autofocus: widget.autofocus,
                  style: const TextStyle(fontSize: 15, color: LbColors.fg),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: widget.leadingIcon != null ? 8 : 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: const TextStyle(color: LbColors.muted, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.helper != null) ...[
          const SizedBox(height: 6),
          Text(widget.helper!, style: TextStyle(fontSize: 12, color: widget.helperColor ?? LbColors.muted)),
        ],
      ],
    );
  }
}

class LbSearch extends StatelessWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const LbSearch({super.key, this.hint = 'Search', this.onChanged, this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: LbColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LbColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: LbColors.muted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: LbColors.muted, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LbChoice extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final bool checkStyle;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  const LbChoice({
    super.key,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.checkStyle = false,
    this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? LbColors.accent : LbColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? LbColors.accent : LbColors.border),
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: selected ? LbColors.surface : LbColors.fg, size: 22),
                const SizedBox(width: 12),
              ],
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selected ? LbColors.surface : Colors.transparent,
                  shape: checkStyle ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: checkStyle ? BorderRadius.circular(6) : null,
                  border: Border.all(
                    color: selected ? LbColors.surface : LbColors.border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        color: LbColors.accent,
                        size: 14,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        color: selected ? LbColors.surface : LbColors.fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? LbColors.surface.withValues(alpha: 0.85) : LbColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LbCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color color;
  const LbCheckbox({super.key, required this.label, this.value = false, this.onChanged, this.color = LbColors.accent});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: value,
      child: GestureDetector(
        onTap: () => onChanged?.call(!value),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: value ? color : LbColors.border, width: 2),
              ),
              alignment: Alignment.center,
              child: value ? const Icon(Icons.check, color: LbColors.surface, size: 14) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: LbColors.fg2, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LbSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  const LbSwitch({super.key, this.value = false, this.onChanged, this.activeColor = LbColors.accent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 42,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? activeColor : LbColors.surface2,
          borderRadius: BorderRadius.circular(999),
          border: value ? null : Border.all(color: LbColors.border),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(color: LbColors.surface, shape: BoxShape.circle, boxShadow: [
              BoxShadow(color: Color(0x22000000), blurRadius: 4, offset: Offset(0, 2)),
            ]),
          ),
        ),
      ),
    );
  }
}

class LbToggleRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final ValueChanged<bool>? onChanged;
  const LbToggleRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.value = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LbColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LbColors.border),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: value ? LbColors.accentSoft : LbColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: value ? LbColors.accent : LbColors.fg),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: LbColors.fg, fontWeight: FontWeight.w500)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                ],
              ],
            ),
          ),
          LbSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class LbListRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? trailing;
  final VoidCallback? onTap;
  final Widget? trailingWidget;
  const LbListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: LbColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: LbColors.border),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: LbColors.fg),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, color: LbColors.fg, fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                  ],
                ],
              ),
            ),
            ?trailingWidget,
            if (trailing case final t?) Text(t, style: const TextStyle(fontSize: 13, color: LbColors.muted)),
            if (trailingWidget == null && trailing == null)
              const Icon(Icons.chevron_right, color: LbColors.muted, size: 20),
          ],
        ),
      ),
    );
  }
}

class LbProgress extends StatelessWidget {
  final double value;
  final Color color;
  final Color background;
  final double height;
  const LbProgress({
    super.key,
    required this.value,
    this.color = LbColors.accent,
    this.background = LbColors.borderSoft,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
        ),
      ),
    );
  }
}

class LbStepProgress extends StatelessWidget {
  final int current;
  final int total;
  final List<bool> done;
  const LbStepProgress({super.key, required this.current, required this.total, this.done = const []});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        Color c;
        if (done.length > i && done[i]) {
          c = LbColors.fg;
        } else if (i == current - 1) {
          c = LbColors.accent;
        } else {
          c = LbColors.borderSoft;
        }
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
            height: 4,
            decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
          ),
        );
      }),
    );
  }
}

class LbIconTile extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color foreground;
  final double size;
  final double iconSize;
  const LbIconTile({
    super.key,
    required this.icon,
    this.background = LbColors.accentSoft,
    this.foreground = LbColors.accent,
    this.size = 48,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: foreground, size: iconSize),
    );
  }
}

class LbIconSquare extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color foreground;
  final double size;
  final double iconSize;
  final double radius;
  const LbIconSquare({
    super.key,
    required this.icon,
    this.background = LbColors.accentSoft,
    this.foreground = LbColors.accent,
    this.size = 40,
    this.iconSize = 20,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: foreground, size: iconSize),
    );
  }
}

class LbTimelineItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool done;
  final bool active;
  final bool danger;
  final Widget? trailing;
  final bool isLast;
  const LbTimelineItem({
    super.key,
    required this.title,
    this.subtitle,
    this.done = false,
    this.active = false,
    this.danger = false,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = done
        ? LbColors.fg
        : active
            ? LbColors.accent
            : danger
                ? LbColors.danger
                : LbColors.surface;
    final borderColor = done
        ? LbColors.fg
        : active
            ? LbColors.accent
            : danger
                ? LbColors.danger
                : LbColors.border;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: done ? LbColors.fg : LbColors.borderSoft,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LbColors.fg)),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(subtitle!, style: const TextStyle(fontSize: 12, color: LbColors.muted)),
                        ],
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LbAIBubble extends StatelessWidget {
  final String? title;
  final String message;
  final bool isUser;
  final Widget? extra;
  const LbAIBubble({super.key, this.title, required this.message, this.isUser = false, this.extra});

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(color: LbColors.fg, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(6))),
          child: Text(message, style: const TextStyle(color: LbColors.surface, fontSize: 15, height: 1.45)),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LbColors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(20)).copyWith(bottomLeft: const Radius.circular(6)),
        border: Border.all(color: LbColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: LbColors.accent, size: 12),
                const SizedBox(width: 6),
                Text(title!, style: const TextStyle(fontSize: 11, color: LbColors.accent, fontWeight: FontWeight.w600, letterSpacing: 0.2)),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Text(message, style: const TextStyle(fontSize: 14, color: LbColors.fg, height: 1.5)),
          if (extra != null) ...[const SizedBox(height: 12), extra!],
        ],
      ),
    );
  }
}

class LbCtaCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color background;
  final Color foreground;
  const LbCtaCircle({super.key, required this.icon, this.onTap, this.size = 52, this.background = LbColors.fg, this.foreground = LbColors.surface});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, color: foreground, size: size * 0.42),
      ),
    );
  }
}

class LbAvatar extends StatelessWidget {
  final String text;
  final double size;
  final Color? background;
  final Color? foreground;
  const LbAvatar({super.key, required this.text, this.size = 44, this.background, this.foreground});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? LbColors.accentSoft,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: foreground ?? LbColors.accent,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class LbTabBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  final List<LbTabItem> items;
  const LbTabBar({super.key, required this.activeIndex, required this.onTap, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: LbColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LbColors.border),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final active = i == activeIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 22, color: active ? LbColors.fg : LbColors.muted, weight: active ? 600 : 400),
                    const SizedBox(height: 3),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: active ? LbColors.fg : LbColors.muted,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class LbTabItem {
  final IconData icon;
  final String label;
  const LbTabItem(this.icon, this.label);
}

class LbSpinner extends StatefulWidget {
  final double size;
  final Color color;
  const LbSpinner({super.key, this.size = 24, this.color = LbColors.accent});

  @override
  State<LbSpinner> createState() => _LbSpinnerState();
}

class _LbSpinnerState extends State<LbSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Transform.rotate(
          angle: _c.value * 6.28,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: widget.color.withValues(alpha: 0.2), width: 2.5),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: widget.size / 2,
                height: widget.size / 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [widget.color, widget.color.withValues(alpha: 0)],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LbEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  const LbEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.ctaLabel,
    this.onCta,
    this.icon = Icons.inbox_outlined,
    this.iconColor = LbColors.accent,
    this.iconBg = LbColors.infoBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 36),
          ),
          const SizedBox(height: 20),
          LbH2(title, align: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            LbBody(subtitle!, color: LbColors.muted, align: TextAlign.center),
          ],
          if (ctaLabel != null) ...[
            const SizedBox(height: 20),
            LbButton(label: ctaLabel!, onTap: onCta),
          ],
        ],
      ),
    );
  }
}

class LbStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? caption;
  final Color? valueColor;
  const LbStatCard({super.key, required this.label, required this.value, this.caption, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LbColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LbColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LbEyebrow(label),
          const SizedBox(height: 6),
          LbNumber(value, size: 20, color: valueColor),
          if (caption != null) ...[
            const SizedBox(height: 2),
            LbMeta(caption!),
          ],
        ],
      ),
    );
  }
}

class LbKeyValue extends StatelessWidget {
  final String label;
  final String value;
  final bool largeValue;
  final Color? valueColor;
  const LbKeyValue({super.key, required this.label, required this.value, this.largeValue = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: LbEyebrow(label),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: largeValue ? 16 : 14,
                color: valueColor ?? LbColors.fg,
                fontWeight: largeValue ? FontWeight.w600 : FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LbStackGap extends StatelessWidget {
  final double gap;
  final List<Widget> children;
  const LbStackGap({super.key, required this.gap, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

class LbDot extends StatelessWidget {
  final Color color;
  final double size;
  const LbDot({super.key, this.color = LbColors.accent, this.size = 6});
  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class LbBullet extends StatelessWidget {
  final List<String> items;
  final Color dotColor;
  final TextStyle? textStyle;
  const LbBullet({super.key, required this.items, this.dotColor = LbColors.accent, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7, right: 10),
                      child: LbDot(color: dotColor),
                    ),
                    Expanded(
                      child: Text(t, style: textStyle ?? const TextStyle(fontSize: 14, color: LbColors.fg, height: 1.45)),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class LbInfoBanner extends StatelessWidget {
  final String title;
  final String body;
  final Color background;
  final Color borderColor;
  final Color titleColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  const LbInfoBanner({
    super.key,
    required this.title,
    required this.body,
    this.background = LbColors.infoBg,
    this.borderColor = LbColors.cardWarnBorder,
    this.titleColor = LbColors.fg,
    this.icon = Icons.info_outline,
    this.iconBg = LbColors.surface,
    this.iconColor = LbColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty) ...[
                  Text(title, style: TextStyle(fontSize: 14, color: titleColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                ],
                Text(body, style: const TextStyle(fontSize: 13, color: LbColors.fg2, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LbProcessingRow extends StatelessWidget {
  final String text;
  final bool done;
  final bool spinner;
  const LbProcessingRow({super.key, required this.text, required this.done, required this.spinner});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (done) const Icon(Icons.check, color: LbColors.emerald, size: 18) else if (spinner) const LbSpinner(size: 18, color: LbColors.accent) else Container(width: 18, height: 18, decoration: BoxDecoration(color: LbColors.surface, shape: BoxShape.circle, border: Border.all(color: LbColors.border, width: 2))),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: done || spinner ? LbColors.fg : LbColors.muted))),
      ],
    );
  }
}

class LbCounter extends StatelessWidget {
  final int n;
  const LbCounter(this.n, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: LbColors.accentSoft, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '$n',
        style: const TextStyle(color: LbColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
