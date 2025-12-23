import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterDropdownSection extends StatefulWidget {
  final Function(String) onGenreSelected; // <-- callback

  const FilterDropdownSection({Key? key, required this.onGenreSelected}) : super(key: key);

  @override
  State<FilterDropdownSection> createState() => _FilterDropdownSectionState();
}

class _FilterDropdownSectionState extends State<FilterDropdownSection> {
  // for more complex interactions between filters.


  @override
  Widget build(BuildContext context) {
    final Map<String, String> genres = {
      "Action": "1",
      "Nollywood & African Movies": "2",
      "Music Videos": "12",
      "Shows & Comedy": "14",
      "Talk Shows & Documentaries": "15",
    };
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column( // Using Column to stack two rows of filters
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStaticFilterButton("MOVIES"),
              _FilterDropdownButton(
                label: "LANGUAGES",
                items: const ["English"], // Consider making this dynamic
                onChanged: (String? newValue) {
                  // Handle language selection
                  print("Selected Language: $newValue");
                  // You can update state here if needed
                },
              ),
            ],
          ),
          SizedBox(height: 10.h), // Spacing between the two rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _FilterDropdownButton(
            label: "GENRES",
            items: genres.keys.toList(),   // শুধু নামগুলো দেখাবে
            onChanged: (String? newValue) {
              if (newValue != null) {
                final selectedId = genres[newValue]!; // নাম থেকে id বের করলাম
                widget.onGenreSelected(selectedId);   // MoviesScreen এ পাঠালাম শুধু ID
                print("Selected Genre: $newValue  -> ID: $selectedId");
              }
            },
          ),
              _FilterDropdownButton(
                label: "NEWEST",
                items: const ["OLDEST", "A to Z", "RANDOM"], // Consider making this dynamic
                onChanged: (String? newValue) {
                  print("Selected Sort By: $newValue");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
Widget _buildStaticFilterButton(String text) {
  return Expanded( // Use Expanded to make buttons take available space
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      // Add margin for spacing between buttons
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF3B3B54), // Dark purple-ish color from image
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ),
    ),
  );
}
class _FilterDropdownButton extends StatefulWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? initialValue; // Optional: to set an initial selected value

  const _FilterDropdownButton({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<_FilterDropdownButton> createState() => _FilterDropdownButtonState();
}

class _FilterDropdownButtonState extends State<_FilterDropdownButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Set initial value if provided and is part of the items list
    if (widget.initialValue != null &&
        widget.items.contains(widget.initialValue)) {
      _selectedValue = widget.initialValue;
    } else if (widget.items.isNotEmpty) {
      // Optionally, default to the first item if no initial value or invalid initial value
      // _selectedValue = widget.items.first;
      // Or leave it null to show the label as placeholder
      _selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the text to display on the button
    String buttonText = _selectedValue ?? widget.label;

    return Expanded( // Use Expanded to make buttons take available space
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        // Add margin for spacing
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        // Adjusted padding
        decoration: BoxDecoration(
          color: const Color(0xFFD52233), // Red color from image
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: DropdownButtonHideUnderline( // Hides the default underline of DropdownButton
          child: DropdownButton<String>(
            value: _selectedValue,
            isExpanded: true,
            // Makes the dropdown button take the full width of the container
            hint: Text( // Display label as hint if nothing is selected
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 24.sp,
            ),
            style: TextStyle( // Style for the selected item text in the button
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            dropdownColor: const Color(0xFF3B3B54),
            // Darker color for the dropdown menu itself
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue;
              });
              widget.onChanged(newValue);
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle( // Style for items in the dropdown list
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
            // Customize the displayed value when an item is selected
            // This ensures the button text remains consistent with the label or selected value
            selectedItemBuilder: (BuildContext context) {
              return widget.items.map<Widget>((String item) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _selectedValue ?? widget.label,
                    // Show selected value or label
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}