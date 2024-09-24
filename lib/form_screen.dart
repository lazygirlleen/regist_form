import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Untuk mendeteksi platform (kIsWeb)
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phonenumbers/phonenumbers.dart';
import 'package:email_validator/email_validator.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}



class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final phoneNumberController = PhoneNumberEditingController();
  static const _locale = 'id';
  
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  
  // Controller untuk menyimpan waktu
  final TextEditingController timeinput = TextEditingController(); 

  // Controller untuk menyimpan tanggal
  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController etaInputController = TextEditingController();
  final TextEditingController etdInputController = TextEditingController();

  String? _dropdownValue;
  String? _selectedCountry;

  @override
  void initState() {
    timeinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  void dispose() {
    _arrivalDateController.dispose();
    _departureDateController.dispose();
    _birthDateController.dispose();
    phoneNumberController.dispose(); 
    super.dispose();
  }

   TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectArrivalTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectDepartureTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    if (kIsWeb) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Pick a date"),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'yyyy-MM-dd',
                    ),
                    keyboardType: TextInputType.datetime,
                    onFieldSubmitted: (value) {
                      setState(() {
                        controller.text = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        setState(() {
          controller.text = DateFormat('dd-MM-yyyy').format(picked);
        });
      }
    }
  }
  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500, // Optional. Country list modal height
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (country) {
        setState(() {
          _selectedCountry = country.displayName;
        });
      },
    );
  }

  bool paymentCash = false;
  bool paymentVisa = false;
  bool paymentMaster = false;
  bool paymentAmerican = false;
  bool paymentBCA = false;
  bool paymentJCB = false;
  bool paymentTraveller = false;
  bool paymentVoucher = false;
  bool paymentCompany = false;
  bool paymentOther = false;

  bool agree = false;

  bool isETA = true;
  bool isETD = false;

  void _paymentCash(bool? newValue) {
    setState(() {
      paymentCash = newValue ?? false;
    });
  }

  void _paymentVisa(bool? newValue) {
    setState(() {
      paymentVisa = newValue ?? false;
    });
  }

  void _paymentMaster(bool? newValue) {
    setState(() {
      paymentMaster = newValue ?? false;
    });
  }

    void _paymentAmerican(bool? newValue) {
    setState(() {
      paymentAmerican = newValue ?? false;
    });
  }

    void _paymentBCA(bool? newValue) {
    setState(() {
      paymentBCA = newValue ?? false;
    });
  }

   void _paymentJCB(bool? newValue) {
    setState(() {
      paymentJCB = newValue ?? false;
    });
  }

   void _paymentTraveller(bool? newValue) {
    setState(() {
      paymentTraveller = newValue ?? false;
    });
  }

   void _paymentVoucher(bool? newValue) {
    setState(() {
      paymentVoucher = newValue ?? false;
    });
  }

   void _paymentCompany(bool? newValue) {
    setState(() {
      paymentCompany = newValue ?? false;
    });
  }

   void _paymentOther(bool? newValue) {
    setState(() {
      paymentOther = newValue ?? false;
    });
  }

   void _agreeCheck(bool? newValue) {
    setState(() {
      agree = newValue ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horison Pasuruan',
        ),
        backgroundColor: const Color.fromARGB(255, 178, 220, 255),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            const Text('Registration Form',
            textAlign: TextAlign.center,
            style: TextStyle (
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
            ),
            const SizedBox(height: 18),
            const Text('Reservation Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            ),
            const SizedBox(height: 16),
            // Arrival Date 
            TextFormField(
              controller: _arrivalDateController,
              decoration: const InputDecoration(
                labelText: 'Arrival Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _arrivalDateController), 
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an arrival date!';
                }
                return null;
              },
            ),
         const SizedBox(height: 16),
            // Flight/ETA
            TextField(
              controller: etaInputController,
              decoration: const InputDecoration(
                icon: Icon(Icons.timer),
                labelText: "Flight/ETA",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                if (pickedTime != null) {
                  final now = DateTime.now();
                  final parsedTime = DateTime(
                      now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);

                  String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                  setState(() {
                    etaInputController.text = formattedTime;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Time is not selected")),
                  );
                }
              },
            ),

            const SizedBox(height: 16),
            // Departure Date
            TextFormField(
              controller: _departureDateController,
              decoration: const InputDecoration(
                labelText: 'Departure Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _departureDateController), // Buka date picker saat di-tap
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a departure date!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Flight/ETD
            TextField(
              controller: etdInputController,
              decoration: const InputDecoration(
                icon: Icon(Icons.timer_off),
                labelText: "Flight/ETD",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                if (pickedTime != null) {
                  final now = DateTime.now();
                  final parsedTime = DateTime(
                      now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);

                  String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                  setState(() {
                    etdInputController.text = formattedTime;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Time is not selected")),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // No. of Guest
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Guest',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your number of guest!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Room Type
            DropdownButtonFormField<String>(
              value: _dropdownValue,
              decoration: const InputDecoration(
                labelText: 'Select Room Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _dropdownValue = newValue;
                });
              },
               items: const [
                DropdownMenuItem(
                  value: 'Deluxe Twin',
                  child: Text('Deluxe Twin'),
                ),
                DropdownMenuItem(
                  value: 'Deluxe Double',
                  child: Text('Deluxe Double'),
                ),
                DropdownMenuItem(
                  value: 'Executive Double',
                  child: Text('Deluxe Double'),
                ),
                DropdownMenuItem(
                  value: 'Executive Suite',
                  child: Text('Executive Suite'),
                ),
                DropdownMenuItem(
                  value: 'Junior Suite',
                  child: Text('Junior Suite'),
                ),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Please select a room type!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Room Rate
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                prefixText: _currency,
                labelText: 'Room Rate',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (string) {
                string = _formatNumber(string.replaceAll(',', ''));
                _controller.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length),
                );
              },
            ),
              const SizedBox(height: 16),
            // Room No.
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Room Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your room number!';
                }
                return null;
              },
            ),
              const SizedBox(height: 16),
            // Confirmation No.
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Confirmation Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your confirmation number!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
             const Text('Personal Information',
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
             ),
            const SizedBox(height: 16),
            // First Name 
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first name!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Name 
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Folio Number 
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Folio Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your folio number!';
                }
                return null;
              },
            ),
             const SizedBox(height: 16),
            // Passport Number 
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Passport Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your passport number!';
                }
                return null;
              },
            ),
              const SizedBox(height: 16),
            // Nationality.
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nationality',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your nationality!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Number Membership Card
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'No Membership Card',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your number membership card!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Date of Birth
            TextFormField(
              controller: _birthDateController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _birthDateController), // Buka date picker saat di-tap
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an birth date!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Company.
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Company',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your company!';
                }
                return null;
              },
            ),
             const SizedBox(height: 16),
            // Occupation or Position.
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Occupation or Position',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your occupation or position!';
                }
                return null;
              },
            ),
              const SizedBox(height: 16),
            // Address 
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your address!';
                }
                return null;
              },
            ),
             const SizedBox(height: 16),
            // Residential 
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1, // <-- SEE HERE
              maxLines: 5, // <-- SEE HERE
              decoration: const InputDecoration(
                labelText: 'Residential',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your residential!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // City 
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your city!';
                }
                return null;
              },
            ),
             const SizedBox(height: 16),
            // State or Province
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'State of Province',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your state or province!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Country Picker
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Country',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.flag),
                  onPressed: () => _showCountryPicker(context),
                ),
              ),
              controller: TextEditingController(text: _selectedCountry),
              onTap: () => _showCountryPicker(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your country!';
                }
                return null;
              },
            ),
             const SizedBox(height: 16),
            // postal code
              TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your postal code!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // telephone
              TextFormField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telephone',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your telephone number!';
                }
                return null;
              },
            ),
              const SizedBox(height: 16),
            // mobile
              TextFormField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile',
                border: OutlineInputBorder(),
              ),

              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your mobile number!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
        // Email
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction, // Memvalidasi saat pengguna mengetik
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email!';
            } else if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email!';
            }
            return null;
          },
          ),
           // method payment
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 16),
            const Text('Method of Payment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: paymentCash,
                  onChanged: _paymentCash,
                ),
                const Text('Cash'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: paymentVisa,
                  onChanged: _paymentVisa,
                ),
                const Text('Visa Card'),
              ],
            ),
             Row(
              children: [
                Checkbox(
                  value: paymentMaster,
                  onChanged: _paymentMaster,
                ),
                const Text('Master Card'),
              ],
            ),
             Row(
              children: [
                Checkbox(
                  value: paymentAmerican,
                  onChanged: _paymentAmerican,
                ),
                const Text('American Express'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: paymentBCA,
                  onChanged: _paymentBCA,
                ),
                const Text('BCA Card'),
              ],
            ),
             Row(
              children: [
                Checkbox(
                  value: paymentJCB,
                  onChanged: _paymentJCB,
                ),
                const Text('JCB Card'),
              ],
            ),
             Row(
              children: [
                Checkbox(
                  value: paymentTraveller,
                  onChanged: _paymentTraveller,
                ),
                const Text('Traveller Cheque'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: paymentVoucher,
                  onChanged: _paymentVoucher,
                ),
                const Text('Voucher'),
              ],
            ),
             Row(
              children: [
                Checkbox(
                  value: paymentCompany,
                  onChanged: _paymentCompany,
                ),
                const Text('Company Acct'),
              ],
            ),
             Row(
              children: [
                Checkbox(
                  value: paymentOther,
                  onChanged: _paymentOther,
                ),
                const Text('Others'),
              ],
            ),
             TextFormField(
              // decoration: const InputDecoration(
              //   labelText: 'Others',
                // border: OutlineInputBorder(),
              ),
      ],
    ),
      const SizedBox(height: 16),
      const Text('Dear Guest, Please note the following terms and condition:',
       style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      ),
      const SizedBox(height: 16),
      const Text('- Check-In time starts at 2pm and Check-Out time is 12 noon'),
      const Text('- Hotel assumes no responsibilities of Guest(s) forgotten lost and/or stolen money, jewels, or any other valuables, unless placed in Hotel safe deposit box: certain restriction apply'),
      const Text('- Room rate are subject to 21% service charge and prevailiking government tax'),
      const Text('- Hotel does not store items left behind by Guests: but under rare ciscumstances we hold-on to certain items to Lost & Found. After 3 (three) months items will be donated and/or discarded if not claimed'),
      const Text('- You agree to forfeit your deposit if smoking in non-smoking room, damages, missing room items and/or attempting to collect deposit at a later time after Check-Out'),
      const Text('- Hotel is not responsible for accidents/injury to any Guest(s)/visitors including personal items'),
      const Text('- Noise-tree rooms NOT guaranteed. All offers, promotions, coupons, and discount cannot be combined'),
      const Text('- Cash Guest Deposit can only be collected at check-out and can only be requested by registered Guest(s): NO exceptions'),
      const Text('- I agree to receive e-mails from Metropolitan Golden Management (MGM) regarding my stay experience and exclusive benefits'),
      const Text('- My signatures is an authorization for the hotel to use credit card imprint for the payment of my account'),
      const SizedBox(height: 16),
      Row(
              children: [
                Checkbox(
                  value: agree,
                  onChanged: (bool? newValue){
                    setState(() {
                      agree = newValue ?? false;
                    });
                  }
                ),
                const Text('I Agree Rp. 1.000.000 for smoking penalty'),
              ],
            ),
             const SizedBox(height: 16),
            // Regist Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Successfully Registered!'),
                    ),
                  );
                }
              },
              child: const Text('Registration'),
            ),
          ]
      )
      )

    );
  }
}