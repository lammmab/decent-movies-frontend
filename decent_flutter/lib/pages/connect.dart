import 'package:flutter/material.dart';
import 'package:decent_flutter/utils/http.dart';
import 'package:decent_flutter/utils/save.dart';

class ConnectPage extends StatefulWidget {
  final VoidCallback onConnected;

  const ConnectPage({super.key, required this.onConnected});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final FocusNode firstFocusNode = FocusNode();
  final FocusNode secondFocusNode = FocusNode();
  final FocusNode buttonFocusNode = FocusNode();
  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    firstFocusNode.dispose();
    secondFocusNode.dispose();
    buttonFocusNode.dispose();

    super.dispose();
  }

  void _connect() async {
    final instance = firstController.text;
    final password = secondController.text;
    final httpClient = Http();

    try {
      final postResponse = await httpClient.post(
        instance,
        body: {'password': password},
      );

      final data = SaveData(
        token: postResponse['token'] ?? '',
        backendUrl: instance,
      );

      saveData(data);

      if (!mounted) return;
      widget.onConnected();

    } on HttpException catch (e) {
      print('Server error: ${e.message}'); 
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  focusNode: firstFocusNode,
                  controller: firstController,
                  decoration: const InputDecoration(
                    labelText: 'Instance Link',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  focusNode: secondFocusNode,
                  controller: secondController,
                  decoration: const InputDecoration(
                    labelText: 'Password (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  focusNode: buttonFocusNode,
                  onPressed: _connect,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    child: Text('Connect'),
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