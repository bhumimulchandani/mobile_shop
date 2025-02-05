import 'dart:async';
import 'dart:ui' as ui;
import 'package:fluent_ui/fluent_ui.dart' hide Colors, IconButton;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

typedef SearchableDropdownSorter<T> = List<SearchableDropdownItem<T>> Function(
  String text,
  List<SearchableDropdownItem<T>> items,
);

typedef OnChangeSearchableDropdown<T> = void Function(
  String text,
  TextChangedReason reason,
);

enum TextChangedReason {
  /// Whether the text in an [SearchableDropdown] was changed by user input
  userInput,

  /// Whether the text in an [SearchableDropdown] was changed because the user
  /// chose the suggestion
  suggestionChosen,

  /// Whether the text in an [SearchableDropdown] was cleared by the user
  cleared,
}

/// The default max height the auto suggest box popup can have
const kSearchableDropdownPopupMaxHeight = 380.0;

/// An item used in [SearchableDropdown]
class SearchableDropdownItem<T> {
  /// The value attached to this item
  final T? value;

  /// The label that identifies this item
  ///
  /// The data is filtered based on this label
  final Widget? subtitle;
  final String? label;

  /// The widget to be shown.
  ///
  /// If null, [label] is displayed
  ///
  /// Usually a [Text]
  final Widget? child;

  /// Called when this item's focus is changed.
  final ValueChanged<bool>? onFocusChange;

  /// Called when this item is selected
  final VoidCallback? onSelected;

  /// Creates an auto suggest box item
  SearchableDropdownItem({
    this.value,
    this.label,
    this.child,
    this.subtitle,
    this.onFocusChange,
    this.onSelected,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchableDropdownItem && other.value == value;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }
}

// ignore: must_be_immutable
/// An SearchableDropdown provides a list of suggestions for a user to select from
/// as they type.
///
/// ![SearchableDropdown Preview](https://docs.microsoft.com/en-us/windows/apps/design/controls/images/controls-autosuggest-expanded-01.png)
///
/// See also:
///
///  * [TextBox], which is used by this widget to enter user text input
///  * [TextFormBox], which is used by this widget by Form
///  * [Overlay], which is used to show the suggestion popup
///  * <https://docs.microsoft.com/en-us/windows/apps/design/controls/auto-suggest-box>
class SearchableDropdown<T> extends StatefulWidget {
  /// Creates a fluent-styled auto suggest form box.
  SearchableDropdown({
    Key? key,
    this.items,
    this.canAdd = false,
    // this.isFluent=false,
    this.onAddPressed,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onSelected,
    this.noResultsFoundBuilder,
    this.sorter,
    this.isFluent = false,
    this.leadingIcon,
    this.trailingIcon,
    // this.onTap,
    this.clearButtonEnabled = true,
    this.placeholder,
    this.textCapitalization,
    this.placeholderStyle,
    this.header,
    this.headerStyle,
    this.style,
    this.decoration,
    this.foregroundDecoration,
    this.highlightColor,
    this.unfocusedColor,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius,
    this.maxWidth,
    this.cursorWidth = 1.5,
    this.showCursor,
    this.isSubtitle = false,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.enableKeyboardControls = true,
    this.enabled = true,
    this.inputFormatters,
    this.maxPopupHeight = kSearchableDropdownPopupMaxHeight,
  }) : super(key: key);

  /// The list of items to display to the user to pick
  final List<SearchableDropdownItem<T>>? items;

  /// The controller used to have control over what to show on the [TextBox].
  final TextEditingController? controller;
  final bool canAdd;
  final bool isSubtitle;
  final double? maxWidth;
  // final bool isFluent;

  /// Called when the text is updated
  final OnChangeSearchableDropdown? onChanged;

  /// Called when the user selected a value.
  final ValueChanged<SearchableDropdownItem<T>>? onSelected;
  final void Function()? onAddPressed;
  // final void Function()? onTap;

  /// Widget to be displayed when none of the items fit the [sorter]
  final WidgetBuilder? noResultsFoundBuilder;

  /// Sort the [items] based on the current query text
  ///
  /// See also:
  ///
  ///  * [SearchableDropdown.defaultItemSorter], the default item sorter
  final SearchableDropdownSorter<T>? sorter;

  /// A widget displayed at the start of the text box
  ///
  final Widget? leadingIcon;

  /// A widget displayed at the end of the text box
  ///
  final Widget? trailingIcon;

  /// Whether the close button is enabled
  ///
  /// Defauls to true
  final bool? clearButtonEnabled;

  /// The text shown when the text box is empty
  ///
  /// See also:
  ///
  ///  * [TextBox.placeholder]
  final String? placeholder;

  /// The style of [placeholder]
  ///
  /// See also:
  ///
  ///  * [TextBox.placeholderStyle]
  final TextStyle? placeholderStyle;

  ///  * [TextBox.placeholder]
  final String? header;

  /// The style of [header]
  ///
  /// See also:
  ///
  ///  * [TextBox.headerStyle]
  final TextStyle? headerStyle;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// Controls the [BoxDecoration] of the box behind the text input.
  final InputDecoration? decoration;
  final TextCapitalization? textCapitalization;

  /// Controls the [BoxDecoration] of the box in front of the text input.
  ///
  /// If [highlightColor] is provided, this must not be provided
  final BoxDecoration? foregroundDecoration;

  /// The highlight color of the text box.
  ///
  /// If [foregroundDecoration] is provided, this must not be provided.
  ///
  /// See also:
  ///  * [unfocusedColor], displayed when the field is not focused
  final Color? highlightColor;

  /// The unfocused color of the highlight border.
  ///
  /// See also:
  ///   * [highlightColor], displayed when the field is focused
  final Color? unfocusedColor;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double? cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  final Color? cursorColor;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle? selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle? selectionWidthStyle;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [fluentThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets? scrollPadding;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<String>? validator;

  /// Used to enable/disable this form field auto validation and update its
  /// error text.
  final AutovalidateMode? autovalidateMode;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// An object that can be used by a stateful widget to obtain the keyboard focus
  /// and to handle keyboard events.
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool? autofocus;
  final TextInputType? keyboardType;

  /// Whether the items can be selected using the keyboard
  ///
  /// Arrow Up - focus the item above
  /// Arrow Down - focus the item below
  /// Enter - select the current focused item
  /// Escape - close the suggestions overlay
  ///
  /// Defaults to `true`
  final bool? enableKeyboardControls;

  /// Whether the text box is enabled
  ///
  /// See also:
  ///  * [TextBox.enabled]
  final bool? enabled;
  final bool isFluent;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// The max height the popup can assume.
  ///
  /// The suggestion popup can assume the space available below the text box but,
  /// by default, it's limited to a 380px height. If the value provided is greater
  /// than the available space, the box is limited to the available space.s
  final double maxPopupHeight;

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<SearchableDropdownItem<T>>('items', items))
      ..add(ObjectFlagProperty<ValueChanged<SearchableDropdownItem<T>>>(
        'onSelected',
        onSelected,
        ifNull: 'disabled',
      ))
      ..add(FlagProperty(
        'clearButtonEnabled',
        value: clearButtonEnabled,
        defaultValue: true,
        ifFalse: 'clear button disabled',
      ));
  }

  List<SearchableDropdownItem<T>> defaultItemSorter(
    String text,
    List<SearchableDropdownItem<T>> items,
  ) {
    // text = text.trim();
    if (text.isEmpty) return items;

    // starting sort
    return items.where((element) {
      return text.contains(' ')
          ? element.label!.toLowerCase().contains(text.trim().toLowerCase())
          : element.label!.toLowerCase().startsWith(text.trim().toLowerCase());
    }).toList();

    // contain sort
    // return items.where((element) {
    //   return element.label!.contains(' ')
    //       ? element.label!.toLowerCase().contains(text.toLowerCase())
    //       : element.label!.split(' ').any(
    //           (element) => element.toLowerCase().contains(text.toLowerCase()));
    // }).toList();
  }
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  FocusNode? focusNode;
  OverlayEntry? _entry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textBoxKey = GlobalKey(
    debugLabel: "SearchableDropdown's TextBox Key",
  );
  int selectedIndex = 0;

  TextEditingController? controller;
  final FocusScopeNode overlayNode = FocusScopeNode();
  final _focusStreamController = StreamController<int>.broadcast();
  final _dynamicItemsController = StreamController<List<SearchableDropdownItem<T>>>.broadcast();

  SearchableDropdownSorter<T> get sorter => widget.sorter ?? widget.defaultItemSorter;
  Size _boxSize = Size.zero;
  List<SearchableDropdownItem<T>>? _localItems;

  void updateLocalItems() {
    if (!mounted) return;
    setState(() => _localItems = sorter(controller!.text, widget.items!));
  }

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    controller = widget.controller ?? TextEditingController();

    controller!.addListener(_handleTextChanged);
    focusNode!.addListener(_handleFocusChanged);

    _localItems = sorter(controller!.text, widget.items!);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final box = _textBoxKey.currentContext!.findRenderObject() as RenderBox;
      if (_boxSize != box.size) {
        _dismissOverlay();
        _boxSize = box.size;
      }
    });
  }

  @override
  void dispose() {
    focusNode!.removeListener(_handleFocusChanged);
    controller!.removeListener(_handleTextChanged);
    _focusStreamController.close();
    _dynamicItemsController.close();
    _unselectAll();

    {
      if (widget.controller == null) controller!.dispose();
      if (widget.focusNode == null) focusNode!.dispose();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown<T> oldWidget) {
    {
      if (widget.focusNode != oldWidget.focusNode) {
        if (oldWidget.focusNode == null) focusNode!.dispose();
        focusNode = widget.focusNode ?? FocusNode();
      }

      if (widget.controller != oldWidget.controller) {
        if (oldWidget.controller == null) controller!.dispose();
        controller = widget.controller ?? TextEditingController();
        controller!.addListener(_handleTextChanged);
      }
    }

    if (widget.items != oldWidget.items) {
      _dynamicItemsController.add(widget.items!);
      _localItems = sorter(controller!.text, widget.items!);
    }

    super.didUpdateWidget(oldWidget);
  }

  void _handleFocusChanged() {
    final hasFocus = focusNode!.hasFocus;
    if (!hasFocus) {
      _dismissOverlay();
    } else {
      // print('inside start');
      // if (widget.onTap != null) {
      //   widget.onTap!.call();
      // }
      // print('inside end');

      ////..
      setState(() {});
      _showOverlay();
    }
    setState(() {});
  }

  void _handleTextChanged() {
    if (!mounted) return;
    if (controller!.text.length < 2) setState(() {});

    updateLocalItems();

    // Update the overlay when the text box size has changed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      updateLocalItems();
    });
  }

  void _insertOverlay() {
    // selectedIndex = 0;
    _entry = OverlayEntry(builder: (context) {
      assert(debugCheckHasMediaQuery(context));
      final boxContext = _textBoxKey.currentContext;
      if (boxContext == null) return const SizedBox.shrink();
      final box = boxContext.findRenderObject() as RenderBox;
      final globalOffset = box.localToGlobal(Offset.zero);

      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height - mediaQuery.viewPadding.bottom;
      final overlayY = globalOffset.dy + box.size.height;
      final maxHeight = (screenHeight - overlayY).clamp(
        0.0,
        widget.maxPopupHeight,
      );

      Widget child = PositionedDirectional(
        width: widget.maxWidth ?? box.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, box.size.height + (widget.header != null ? 26 : 0.8)),
          child: SizedBox(
            width: box.size.width,
            child: FluentTheme(
              data: fluentThemeData!,
              child: _SearchableDropdownOverlay<T>(
                isSubtitie: widget.isSubtitle,
                canAdd: widget.canAdd,
                onAddPressed: widget.onAddPressed,
                maxHeight: maxHeight,
                node: overlayNode,
                controller: controller!,
                items: widget.items!,
                focusStream: _focusStreamController.stream,
                itemsStream: _dynamicItemsController.stream,
                sorter: sorter,
                onSelected: (SearchableDropdownItem<T> item) {
                  item.onSelected?.call();
                  widget.onSelected?.call(item);
                  controller!
                    ..text = item.label!
                    ..selection = TextSelection.collapsed(
                      offset: item.label!.length,
                    );
                  widget.onChanged?.call(
                    item.label!,
                    TextChangedReason.suggestionChosen,
                  );
                  _dismissOverlay();
                  focusNode!.nextFocus();
                },
                noResultsFoundBuilder: widget.noResultsFoundBuilder,
              ),
            ),
          ),
        ),
      );

      return child;
    });

    if (_textBoxKey.currentContext != null) {
      Overlay.of(context).insert(_entry!);
      if (mounted) setState(() {});
    }
  }

  void _dismissOverlay() {
    _entry?.remove();
    _entry = null;
    _unselectAll();
  }

  void _showOverlay() {
    if (_entry == null && !(_entry?.mounted ?? false)) {
      if (_localItems!.isNotEmpty) {
        select(0);
      }
      _insertOverlay();
    }
  }

  void _unselectAll() {
    for (final item in _localItems!) {
      item.onFocusChange?.call(false);
    }
  }

  void _onChanged(String text) {
    widget.onChanged?.call(text, TextChangedReason.userInput);
    _showOverlay();
  }

  void _onSubmitted() {
    int currentlySelectedIndex = selectedIndex < _localItems!.length ? selectedIndex : -1;
    if (currentlySelectedIndex.isNegative) {
      if (_localItems!.isNotEmpty) {
        currentlySelectedIndex = 0;
      } else {
        return;
      }
    }

    final item = _localItems![currentlySelectedIndex];
    widget.onSelected?.call(item);
    item.onSelected?.call();

    controller!.text = item.label!;
    widget.onChanged?.call(controller!.text, TextChangedReason.suggestionChosen);
  }

  /// Whether a [TextFormBox] is used instead of a [TextBox]
  bool get useForm => widget.validator != null;

  void select(int index) {
    // _unselectAll();
    selectedIndex = index;
    // controller.text = _localItems[index].label.toString();
    // final item = (_localItems[index]).._selected = true;
    // _localItems[index].onFocusChange?.call(true);
    // item.onFocusChange?.call(true);
    _focusStreamController.add(index);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    assert(debugCheckHasFluentLocalizations(context));

    return CompositedTransformTarget(
        link: _layerLink,
        child: Focus(
            onFocusChange: (value) {
              if (value) {
                focusNode!.requestFocus();
              }
            },
            onKeyEvent: (node, event) {
              if (!(event is KeyDownEvent || event is KeyRepeatEvent) || !widget.enableKeyboardControls!) {
                return KeyEventResult.ignored;
              }

              if (event.logicalKey == LogicalKeyboardKey.escape) {
                _dismissOverlay();
                return KeyEventResult.handled;
              }

              if (_localItems!.isEmpty) return KeyEventResult.ignored;

              final currentlySelectedIndex = selectedIndex < _localItems!.length ? selectedIndex : -1;

              // _localItems.indexWhere(
              //   (item) => item._selected,
              // );

              final lastIndex = _localItems!.length - 1;
              if (event.logicalKey == LogicalKeyboardKey.f2 && widget.canAdd) {
                widget.onAddPressed!();
              }
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                // if nothing is selected, select the first
                if (currentlySelectedIndex == -1 || currentlySelectedIndex == lastIndex) {
                  select(0);
                } else if (currentlySelectedIndex >= 0) {
                  select(currentlySelectedIndex + 1);
                }
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                // if nothing is selected, select the last
                if (currentlySelectedIndex == -1 || currentlySelectedIndex == 0) {
                  select(_localItems!.length - 1);
                } else {
                  select(currentlySelectedIndex - 1);
                }
                return KeyEventResult.handled;
              } else {
                return KeyEventResult.ignored;
              }
            },
            child: widget.isFluent
                ? InfoLabel(
                    isHeader: widget.header != null,
                    label: widget.header ?? '',
                    labelStyle: widget.headerStyle,
                    child: TextFormBox(
                      key: _textBoxKey,
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: _onChanged,
                      onFieldSubmitted: (text) => _onSubmitted(),
                      style: widget.style,
                      cursorColor: widget.cursorColor,
                      cursorHeight: widget.cursorHeight,
                      showCursor: widget.showCursor,
                      validator: widget.validator,
                      textInputAction: TextInputAction.next,
                      keyboardAppearance: widget.keyboardAppearance,
                      enabled: widget.enabled!,
                      inputFormatters: widget.inputFormatters,
                    ),
                  )
                : InfoLabel(
                    isHeader: widget.header != null,
                    label: widget.header ?? '',
                    labelStyle: widget.headerStyle,
                    child: TextFormField(
                      key: _textBoxKey,
                      decoration: (widget.decoration ??
                          InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          )),
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: _onChanged,
                      onFieldSubmitted: (text) => _onSubmitted(),
                      style: widget.style,
                      cursorColor: widget.cursorColor,
                      cursorHeight: widget.cursorHeight,
                      showCursor: widget.showCursor,
                      validator: widget.validator ??
                          (val) {
                            return widget.items!.indexWhere((element) => element.value == val) == -1 ? '* invalid' : null;
                          },
                      textInputAction: widget.textInputAction?? TextInputAction.next,
                      keyboardAppearance: widget.keyboardAppearance,
                      enabled: widget.enabled,
                      inputFormatters: widget.inputFormatters,
                    ),
                  )
            // child: TextFormField(
            //   key: _textBoxKey,
            //   keyboardType: widget.keyboardType,
            //   controller: controller,
            //   focusNode: focusNodke,
            //   autofocus: widget.autofocus!,
            //   onChanged: _onChanged,
            //   onFieldSubmitted: (text) => _onSubmitted(),
            //   style: widget.style,
            // decoration: widget.decoration!.copyWith(
            //   cursorColor: widget.cursorColor,
            //   cursorHeight: widget.cursorHeight,
            //   cursorRadius: widget.cursorRadius ?? const Radius.circular(2.0),
            //   cursorWidth: widget.cursorWidth!,
            //   showCursor: widget.showCursor,
            //   scrollPadding: widget.scrollPadding!,
            //   validator: widget.validator,
            //   autovalidateMode: widget.autovalidateMode,
            //   textInputAction: widget.textInputAction,
            //   keyboardAppearance: widget.keyboardAppearance,
            //   enabled: widget.enabled,
            //   inputFormatters: widget.inputFormatters,
            // )
            ));
  }
}

class _SearchableDropdownOverlay<T> extends StatefulWidget {
  const _SearchableDropdownOverlay({
    Key? key,
    this.items,
    this.controller,
    this.isSubtitie = false,
    this.onSelected,
    this.onAddPressed,
    this.node,
    this.canAdd,
    this.focusStream,
    this.itemsStream,
    this.sorter,
    this.maxHeight,
    this.noResultsFoundBuilder,
  }) : super(key: key);
  final bool isSubtitie;
  final List<SearchableDropdownItem<T>>? items;
  final TextEditingController? controller;
  final ValueChanged<SearchableDropdownItem<T>>? onSelected;
  final void Function()? onAddPressed;
  final FocusScopeNode? node;
  final bool? canAdd;
  final Stream<int>? focusStream;
  final Stream<List<SearchableDropdownItem<T>>>? itemsStream;
  final SearchableDropdownSorter<T>? sorter;
  final double? maxHeight;
  final WidgetBuilder? noResultsFoundBuilder;

  @override
  State<_SearchableDropdownOverlay<T>> createState() => _SearchableDropdownOverlayState<T>();
}

class _SearchableDropdownOverlayState<T> extends State<_SearchableDropdownOverlay<T>> {
  StreamSubscription? focusSubscription;
  StreamSubscription? itemsSubscription;
  final ScrollController scrollController = ScrollController();
  static const tileHeight = kOneLineTileHeight + 2.0;
  List<SearchableDropdownItem<T>>? items;
  int selectedIndex = 0;
  double theight = 0;
  int totalListNo = 0;
  List sortedItems = [];

  @override
  void initState() {
    super.initState();
    items = widget.items;
    if (widget.isSubtitie) {
      theight = tileHeight + 16;
      totalListNo = (widget.maxHeight! - (widget.canAdd! ? 35 : 0)) ~/ (theight + 16);
    } else {
      theight = tileHeight;
      totalListNo = (widget.maxHeight! - (widget.canAdd! ? 35 : 0)) ~/ theight;
    }
    focusSubscription = widget.focusStream!.listen((index) {
      if (!mounted) return;
      // if (widget.localItems!.length > totalListNo) {
      final currentSelectedOffset = (theight * index);
      if (sortedItems.length > totalListNo) {
        if ((items!.length - 1 - totalListNo) > index) {
          scrollController.animateTo(
            currentSelectedOffset,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        } else if (scrollController.offset == 0 && (items!.length - 1) == index) {
          scrollController.animateTo(
            theight * ((items!.length) - totalListNo),
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        }
      }
      // }
      setState(() {
        selectedIndex = index;
      });
    });
    itemsSubscription = widget.itemsStream!.listen((items) {
      this.items = items;
    });
  }

  @override
  void dispose() {
    focusSubscription!.cancel();
    itemsSubscription!.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    assert(debugCheckHasFluentLocalizations(context));

    // final theme = fluentThemeData;
    final localizations = FluentLocalizations.of(context);

    return FocusScope(
      node: widget.node,
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.maxHeight!),
        decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(4.0),
            ),
          ),
          color: Colors.grey.shade200,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(-1, 1),
              blurRadius: 2.0,
              spreadRadius: 3.0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(1, 1),
              blurRadius: 2.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller!,
          builder: (context, value, _) {
            sortedItems = widget.sorter!(value.text, items!);
            Widget result;
            if (sortedItems.isEmpty && !widget.canAdd!) {
              result = widget.noResultsFoundBuilder?.call(context) ??
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 4.0),
                    child: _SearchableDropdownOverlayTile(
                      text: Text(localizations.noResultsFoundLabel),
                    ),
                  );
            } else {
              result = TextFieldTapRegion(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (sortedItems.isEmpty && widget.canAdd!)
                      Material(
                        color: Colors.grey.shade200,
                        child: InkWell(
                            onTap: widget.onAddPressed,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.green.shade700, size: 20),
                                const SizedBox(
                                  width: 5,
                                  height: 35,
                                ),
                                Text('Add New', style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: Colors.green.shade800, fontSize: 14)),
                              ],
                            )),
                      ),
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemExtent: (widget.items!.isNotEmpty && widget.items![0].subtitle == null) ? tileHeight : tileHeight + 16,
                        controller: scrollController,
                        key: ValueKey<int>(sortedItems.length),
                        shrinkWrap: true,
                        itemCount: sortedItems.length,
                        itemBuilder: (context, index) {
                          final item = sortedItems[index];
                          return _SearchableDropdownOverlayTile(
                            subtitle: item.subtitle,
                            text: item.child ??
                                Text(
                                  item.label!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            selected: index == selectedIndex,
                            onSelected: () => widget.onSelected!(item),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return result;
          },
        ),
      ),
    );
  }
}

class _SearchableDropdownOverlayTile extends StatefulWidget {
  const _SearchableDropdownOverlayTile({
    Key? key,
    this.text,
    this.subtitle,
    this.selected = false,
    this.onSelected,
  }) : super(key: key);

  final Widget? text;
  final Widget? subtitle;
  final VoidCallback? onSelected;
  final bool selected;

  @override
  State<_SearchableDropdownOverlayTile> createState() => __SearchableDropdownOverlayTileState();
}

class __SearchableDropdownOverlayTileState extends State<_SearchableDropdownOverlayTile> with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );
    controller!.forward();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = fluentThemeData;
    return ListTile.selectable(
      tileColor: ButtonState.all(Colors.white70),
      selectedColor: Colors.blue.withOpacity(0.3),
      subtitle: widget.subtitle,
      title: EntrancePageTransition(
        animation: Tween<double>(
          begin: 0.75,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: controller!,
          curve: Curves.easeOut,
        )),
        child: DefaultTextStyle(
          maxLines: 1,
          style: GoogleFonts.manrope(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ),
          child: widget.text!,
        ),
      ),
      selected: widget.selected,
      onPressed: widget.onSelected,
    );
  }
}
