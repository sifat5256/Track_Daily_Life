import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/data/models/transaction_model.dart';
import '../controllers/add_transaction_controller.dart';

class AddTransactionScreen extends StatelessWidget {
  final Function(TransactionModel) onAddTransaction;

  AddTransactionScreen({required this.onAddTransaction});

  @override
  Widget build(BuildContext context) {
    final AddTransactionController controller = Get.put(AddTransactionController());
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Curved header with balance field
            Stack(
              children: [
                // Custom curved background
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 300,
                    color: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Balance',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (amountController.text != controller.amount.value) {
                            amountController.text = controller.amount.value;
                          }
                          return TextField(
                            controller: amountController,
                            style: const TextStyle(color: Colors.white, fontSize: 32),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              controller.setAmount(value);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '\$0',
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                // Back and delete buttons at the top
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    onPressed: () {
                      // Add delete functionality here
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Dropdown
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: DropdownButton<String>(
                        value: controller.type.value,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.setType(newValue);
                          }
                        },
                        isExpanded: true,
                        underline: SizedBox(),
                        items: <String>['Income', 'Expense'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    );
                  }),

                  const SizedBox(height: 16.0),

                  // Description TextField
                  Obx(() {
                    if (descriptionController.text != controller.description.value) {
                      descriptionController.text = controller.description.value;
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          controller.setDescription(value);
                        },
                        controller: descriptionController,
                      ),
                    );
                  }),

                  const SizedBox(height: 16.0),

                  // Date Picker
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date: ${controller.selectedDate.value.toLocal()}'),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: controller.selectedDate.value,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null && pickedDate != controller.selectedDate.value) {
                                controller.setDate(pickedDate);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16.0),

                  // Time Picker
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Time: ${controller.selectedTime.value.format(context)}'),
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: controller.selectedTime.value,
                              );
                              if (pickedTime != null && pickedTime != controller.selectedTime.value) {
                                controller.setTime(pickedTime);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24.0),

                  // Add Transaction Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addTransaction((transaction) {
                          onAddTransaction(transaction);
                          Get.back(); // Close the screen after adding the transaction
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Add Transaction',style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the curved header
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 100); // Start at bottom left
    path.quadraticBezierTo(
      size.width / 2, size.height, // Control point
      size.width, size.height - 100, // End point
    );
    path.lineTo(size.width, 0); // Top right corner
    path.close(); // Complete the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
