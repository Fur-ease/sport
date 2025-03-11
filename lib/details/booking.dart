import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String selectedDuration = '1 hour';
  final List<String> durations = ['1 hour', '2 hours', 'Full day'];

  bool validateInputs() {
  if (dateController.text.isEmpty || 
      timeController.text.isEmpty || 
      selectedDuration.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all booking details'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return false;
  }
  return true;
}

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController){
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.9),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    index == 0 
                                      ? 'https://drive.google.com/uc?export=view&id=1NX27ft0qmWAsBXw6ZRw4F2WhtHRhRyt8'
                                      : 'https://drive.google.com/uc?export=view&id=YOUR_SECOND_IMAGE_ID',
                                  ),
                                    fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SmoothPageIndicator(
                      controller: PageController(),
                      count: 2,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.blue,
                        dotColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Select Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)), 
                        firstDate: DateTime.now(), 
                        lastDate: DateTime.now().add(const Duration(days: 30)), 
                        selectableDayPredicate: (DateTime date) {
                          return date.isAfter(DateTime.now());
                        },
                      );
                      if (pickedDate != null) {
                        String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                ],
               ),
             ),
             const SizedBox(height: 15),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(
                controller: timeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: 'Select Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: 'Select Duration',
                  suffixIcon: Icon(Icons.timer),
                ),
                value: selectedDuration,
                items: durations.map((String duration) {
                  return DropdownMenuItem(
                    value: duration,
                    child: Text(duration),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDuration = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
               Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    if (validateInputs()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ground Booked successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    //color: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Book Ground',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}