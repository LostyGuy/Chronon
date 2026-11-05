import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uni_schedule/chronon_colors.dart';

class EntrolmentPage extends StatefulWidget {
  const EntrolmentPage({super.key});

  @override
  State<EntrolmentPage> createState() => _EntrolmentPageState();
}

class _EntrolmentPageState extends State<EntrolmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _universityController = TextEditingController();

  bool _marketingOptIn = false;
  bool _isSubmitting = false;
  bool _submitted = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'https://chronon-backend.vercel.app/api/v1/entrollment/form',
        ),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'university': _universityController.text.trim().isEmpty
              ? null
              : _universityController.text.trim(),
          'marketing_emails': _marketingOptIn,
        }),
      );

      final responseBody = _decodeResponse(response.body);
      if (response.statusCode == 201) {
        final message = responseBody?['message'];
        if (message is! String) {
          throw const FormatException('The server returned an invalid response.');
        }
        if (mounted) setState(() => _submitted = true);
      } else {
        final detail = responseBody?['detail'];
        if (mounted) {
          setState(() {
            _errorMessage = detail is String
                ? detail
                : 'Could not submit the form (HTTP ${response.statusCode}).';
          });
        }
      }
    } on http.ClientException catch (error) {
      if (mounted) setState(() => _errorMessage = 'Could not reach the server: $error');
    } on FormatException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Map<String, dynamic>? _decodeResponse(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChrononColors.abyss,
      appBar: AppBar(
        backgroundColor: ChrononColors.abyss,
        foregroundColor: ChrononColors.textMain,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded, color: ChrononColors.cyanAccent),
            SizedBox(width: 10),
            Text('Chronon', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.8),
            radius: 1.2,
            colors: [Color(0x33024F86), ChrononColors.abyss],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: _submitted ? _buildSuccessCard() : _buildFormCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: ChrononColors.cardBg,
        border: Border.all(color: ChrononColors.navyBorder),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x33048AC1), blurRadius: 32, offset: Offset(0, 12)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEyebrow(),
            const SizedBox(height: 18),
            const Text(
              'Join the tester program',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Help shape a clearer, more reliable way to keep up with your university schedule.',
              style: TextStyle(color: ChrononColors.textMuted, height: 1.6),
            ),
            const SizedBox(height: 28),
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              icon: Icons.person_outline_rounded,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your name.'
                  : null,
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _emailController,
              label: 'E-mail',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Enter your e-mail address.';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                  return 'Enter a valid e-mail address.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            _buildTextField(
              controller: _universityController,
              label: 'University (optional)',
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ChrononColors.navySurface.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ChrononColors.navyBorder),
              ),
              child: CheckboxListTile(
                value: _marketingOptIn,
                onChanged: _isSubmitting
                    ? null
                    : (value) => setState(() => _marketingOptIn = value ?? false),
                activeColor: ChrononColors.cyanAccent,
                checkColor: ChrononColors.abyss,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'I agree to receive occasional marketing e-mails.',
                  style: TextStyle(color: ChrononColors.textMain, fontSize: 14),
                ),
                subtitle: const Text(
                  'Optional. We send them rarely, and you can leave this unchecked.',
                  style: TextStyle(color: ChrononColors.textMuted, height: 1.4),
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 18),
              _buildErrorMessage(_errorMessage!),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChrononColors.cobalt,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: ChrononColors.cobalt.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit registration',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Your details are used to manage tester registrations.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ChrononColors.textDim, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEyebrow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0x33048AC1),
        border: Border.all(color: const Color(0x66048AC1)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.groups_2_rounded, size: 16, color: ChrononColors.cyanAccent),
          SizedBox(width: 8),
          Text(
            'CHRONON EARLY ACCESS',
            style: TextStyle(
              color: ChrononColors.cyanAccent,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLength: label == 'Name'
          ? 120
          : label == 'University (optional)'
              ? 160
              : 254,
      decoration: InputDecoration(
        counterText: '',
        labelText: label,
        labelStyle: const TextStyle(color: ChrononColors.textMuted),
        prefixIcon: Icon(icon, color: ChrononColors.cyanAccent, size: 20),
        filled: true,
        fillColor: ChrononColors.navySurface.withValues(alpha: 0.65),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ChrononColors.navyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ChrononColors.navyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ChrononColors.cyanAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ChrononColors.alert),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ChrononColors.alert, width: 1.5),
        ),
      ),
      style: const TextStyle(color: ChrononColors.textMain),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ChrononColors.alert.withValues(alpha: 0.12),
        border: Border.all(color: ChrononColors.alert.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(message, style: const TextStyle(color: Color(0xFFFFB4AB))),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: ChrononColors.cardBg,
        border: Border.all(color: ChrononColors.navyBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle_outline, color: ChrononColors.success, size: 58),
          SizedBox(height: 20),
          Text(
            'You’re on the list!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 12),
          Text(
            'Thanks for signing up to test Chronon. Your registration has been saved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ChrononColors.textMuted, height: 1.6),
          ),
        ],
      ),
    );
  }
}
