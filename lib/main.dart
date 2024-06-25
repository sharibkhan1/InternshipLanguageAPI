import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transaltionappp/provider/TranslationProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TranslationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TranslationPage(),
      ),
    );
  }
}

class TranslationPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<String?> _translatedText = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TranslationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.translatedTexts['appTitle'] ?? 'Loading...'),
        actions: [
          DropdownButton<String>(
            value: provider.selectedLanguage,
            items: provider.languages.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.value,
                child: Text(entry.key),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                provider.translateTexts(newValue);
              }
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              provider.translatedTexts['helloEveryone'] ?? 'Loading...',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text(provider.translatedTexts['addToCart'] ?? 'Loading...'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter text to translate',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final translated = await provider.translateInputText(
                  _textController.text,
                  provider.selectedLanguage,
                );
                _translatedText.value = translated;
              },
              child: Text('Translate Input Text'),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<String?>(
              valueListenable: _translatedText,
              builder: (context, translated, child) {
                return Text(
                  translated ?? '',
                  style: TextStyle(fontSize: 24),
                );
              },
            ),
            // Add other UI elements here
          ],
        ),
      ),
    );
  }
}
