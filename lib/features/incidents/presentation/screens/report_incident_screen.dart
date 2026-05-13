import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/incident_provider.dart';

class ReportIncidentScreen extends ConsumerStatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  ConsumerState<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends ConsumerState<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _selectedType;
  File? _imageFile;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024, imageQuality: 80);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an incident type'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    final notifier = ref.read(incidentNotifierProvider.notifier);
    final report = await notifier.submitReport(
      incidentType: _selectedType!,
      description: _descriptionController.text.trim(),
      imageFile: _imageFile,
    );

    if (mounted) {
      if (report != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Incident reported successfully'), backgroundColor: AppTheme.successColor),
        );
        context.go('/home');
      } else {
        final msg = ref.read(incidentNotifierProvider).errorMessage ?? 'Submission failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
        );
      }
      notifier.resetState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final incidentState = ref.watch(incidentNotifierProvider);
    final isSubmitting = incidentState.status == IncidentStatus.submitting;

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Report Incident'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Incident type
                Text('Incident Type', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: AppConstants.incidentTypes.map((type) {
                    final selected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: selected,
                      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: selected ? AppTheme.primaryColor : Colors.grey.shade700,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      onSelected: (val) => setState(() => _selectedType = val ? type : null),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Description
                Text('Description', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe the incident in detail...',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please describe the incident';
                    if (value.trim().length < 10) return 'Please provide more detail (min 10 characters)';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Image upload (optional)
                Text('Photo Evidence (Optional)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(_imageFile!, fit: BoxFit.cover),
                                Positioned(
                                  top: 8, right: 8,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _imageFile = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_a_photo_rounded, size: 36, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text('Tap to add photo', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Auto-location note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    const Icon(Icons.location_on_rounded, size: 18, color: AppTheme.secondaryColor),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Location will be auto-captured on submit', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.secondaryColor, fontWeight: FontWeight.w500))),
                  ]),
                ),
                const SizedBox(height: 24),

                // Submit
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitReport,
                    child: isSubmitting
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text('Submit Report'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
