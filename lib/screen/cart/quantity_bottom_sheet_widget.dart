import 'package:flutter/material.dart';
import 'package:doan/widget/subtitle_text.dart';

class QuantityBottomSheetWidget extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onUpdate;

  const QuantityBottomSheetWidget({
    super.key,
    required this.initialQuantity,
    required this.onUpdate,
  });

  @override
  _QuantityBottomSheetWidgetState createState() =>
      _QuantityBottomSheetWidgetState();
}

class _QuantityBottomSheetWidgetState extends State<QuantityBottomSheetWidget> {
  late ValueNotifier<int> _currentQuantityNotifier;

  @override
  void initState() {
    super.initState();
    _currentQuantityNotifier = ValueNotifier<int>(widget.initialQuantity);
  }

  @override
  void dispose() {
    _currentQuantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _currentQuantityNotifier,
            builder: (context, currentQuantity, _) {
              return ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  final quantity = index + 1;
                  return ListTile(
                    title: SubtitleTextWidget(label: "$quantity"),
                    onTap: () {
                      _currentQuantityNotifier.value = quantity; // Update value
                      widget.onUpdate(
                          quantity); // Notify the parent about the updated quantity
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    tileColor: quantity == currentQuantity
                        ? Colors.blue.withOpacity(0.2)
                        : null,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
