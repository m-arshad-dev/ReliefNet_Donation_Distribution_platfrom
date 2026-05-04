import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/features/campaigns/data/providers/campaign_providers.dart';

class CampaignCreateScreen extends ConsumerStatefulWidget {
  const CampaignCreateScreen({super.key});

  @override
  ConsumerState<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends ConsumerState<CampaignCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalAmountController = TextEditingController();
  String _donationType = 'money';

  bool _isSaving = false;
  String? _message;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _goalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Campaign')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value?.isEmpty == true ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: (value) => value?.isEmpty == true ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _goalAmountController,
                  decoration: const InputDecoration(labelText: 'Goal Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Please enter a goal amount';
                    final amount = num.tryParse(value!);
                    return amount == null || amount <= 0 ? 'Enter a valid amount' : null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _donationType,
                  items: const [
                    DropdownMenuItem(value: 'money', child: Text('Money')),
                    DropdownMenuItem(value: 'goods', child: Text('Goods')),
                    DropdownMenuItem(value: 'time', child: Text('Volunteer time')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _donationType = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Donation type'),
                ),
                const SizedBox(height: 20),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _message!.contains('success') ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving ? const CircularProgressIndicator() : const Text('Create Campaign'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _message = null;
    });

    final useCase = ref.read(createCampaignUseCaseProvider);

    try {
      await useCase(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        donationType: _donationType,
        goalAmount: num.parse(_goalAmountController.text.trim()),
      );

      if (!mounted) return;
      setState(() {
        _message = 'Campaign created successfully.';
      });
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _message = 'Failed to create campaign. ${error.toString()}';
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
}
