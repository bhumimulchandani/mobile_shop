import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime parseToDateTime(String dateFormat) {
    if (length > dateFormat.length) return DateTime.now();
    try {
      return DateFormat(dateFormat).parse(this);
    } on FormatException catch (_) {
      return DateTime.now();
    }
  }
}

extension DateTimeExtension on DateTime? {
  String parseToString(String dateFormat) {
    if (this == null) return '';
    return DateFormat(dateFormat).format(this!);
  }
}

class WebDatePicker extends StatefulWidget {
  const WebDatePicker({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.controller,
    this.lastDate,
    this.decoration,
    required this.onChange,
    this.style,
    this.header,
    this.viewUp = false,
    this.headerStyle,
    this.width = 200,
    this.height = 45,
    this.isFluent = false,
    this.prefix,
    this.dateformat = 'yyyy/MM/dd',
    this.overlayVerticalPosition = 5.0,
    this.overlayHorizontalPosiition = 0.0,
  }) : super(key: key);

  final bool isFluent;
  final bool viewUp;
  final DateTime? initialDate;
  final TextEditingController? controller;

  final DateTime? firstDate;
  final InputDecoration? decoration;

  final DateTime? lastDate;
  final String? header;

  final ValueChanged<DateTime?> onChange;

  final TextStyle? style;
  final TextStyle? headerStyle;

  final double width;
  final double height;

  final double overlayVerticalPosition;
  final double overlayHorizontalPosiition;

  //The decoration of text form field

  final Widget? prefix;

  final String dateformat;

  //icon calendar

  @override
  _WebDatePickerState createState() => _WebDatePickerState();
}

class _WebDatePickerState extends State<WebDatePicker> {
  final FocusNode _focusNode = FocusNode();

  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  late TextEditingController _controller;

  late DateTime? _selectedDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  // bool _isEnterDateField = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _selectedDate = widget.initialDate;
    _firstDate = widget.firstDate ?? DateTime(2000);
    _lastDate = widget.lastDate ?? DateTime(2100);

    if (_selectedDate != null) {
      _controller.text = _selectedDate?.parseToString(widget.dateformat) ?? '';
    }
    if (!true) {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          _overlayEntry = _createOverlayEntry();
          Overlay.of(context).insert(_overlayEntry);
        } else {
          _controller.text = _selectedDate.parseToString(widget.dateformat);
          widget.onChange.call(_selectedDate);
          _overlayEntry.remove();
        }
      });
    }
  }

  void onChange(DateTime? selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
      _controller.text = _selectedDate.parseToString(widget.dateformat);
      _focusNode.nextFocus();
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              widget.overlayHorizontalPosiition,
              widget.viewUp
                  ? -(widget.overlayVerticalPosition + widget.height + 310)
                  // widget.overlayVerticalPosition - widget.height - 10:
                  : widget.overlayVerticalPosition + widget.height + 5),
          child: Material(
            elevation: 5,
            color: Colors.grey.shade200,
            child: SizedBox(
                child: TextFieldTapRegion(
                    child: CalendarDatePicker(
              firstDate: _firstDate,
              lastDate: _lastDate,
              initialDate: _selectedDate ?? DateTime.now(),
              onDateChanged: onChange,
            ))),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant WebDatePicker oldWidget) {
    {
      if (widget.controller != oldWidget.controller) {
        if (oldWidget.controller == null) _controller.dispose();
        _controller = widget.controller ?? TextEditingController();
        _selectedDate = widget.initialDate;
      } else if (widget.controller != null &&
          widget.controller!.text.parseToDateTime(widget.dateformat) !=
              _selectedDate) {
        _selectedDate = widget.initialDate;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          if (!true) {
            setState(() {
              // _isEnterDateField = true;
            });
          }
        },
        onExit: (_) {
          if (!true) {
            setState(() {
              // _isEnterDateField = false;
            });
          }
        },
        child: widget.isFluent
            ? fl.TextFormBox(
                readOnly: true,
                onTap: () {
                  if (true) {
                    showDatePicker(
                            context: context,
                            initialDate: _selectedDate!,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100)
                            )
                        .then((value) {
                      if (value != null) {
                        widget.onChange(value);
                        onChange(value);
                      }
                    });
                  }
                },
                textInputAction: TextInputAction.next,
                style: widget.style,
                focusNode: _focusNode,
                controller: _controller,
                onChanged: (dateString) {
                  final date = dateString.parseToDateTime(widget.dateformat);
                  if (date.isBefore(_firstDate)) {
                    _selectedDate = _firstDate;
                  } else if (date.isAfter(_lastDate)) {
                    _selectedDate = _lastDate;
                  } else {
                    _selectedDate = date;
                  }
                },
              )
            : TextFormField(
                readOnly: true,
                onTap: () {
                  if (true) {
                    showDatePicker(
                            context: context,
                            initialDate: _selectedDate!,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(DateTime.now().year + 1))
                        .then((value) {
                      if (value != null) {
                        widget.onChange(value);
                        onChange(value);
                      }
                    });
                  }
                },
                decoration: widget.decoration,
                textInputAction: TextInputAction.next,
                style: widget.style,
                focusNode: _focusNode,
                controller: _controller,
                onChanged: (dateString) {
                  final date = dateString.parseToDateTime(widget.dateformat);
                  if (date.isBefore(_firstDate)) {
                    _selectedDate = _firstDate;
                  } else if (date.isAfter(_lastDate)) {
                    _selectedDate = _lastDate;
                  } else {
                    _selectedDate = date;
                  }
                },
              ),
      ),
    );
  }
}
