import 'package:flutter/material.dart';
import 'package:hulee_user_shifts_app/config/consts.dart';

class Toast extends StatefulWidget {
  const Toast({
    super.key,
    required this.message,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 3),
  });

  final String message;
  final ToastType type;
  final Duration duration;

  @override
  ToastState createState() => ToastState();
}

class ToastState extends State<Toast> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  Color getColor() {
    switch (widget.type) {
      case ToastType.info:
        return Colors.lightBlue;
      case ToastType.success:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.vertical,
            onDismissed: (direction) {
              setState(() {
                _isVisible = false;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: getColor(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
