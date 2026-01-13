import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/demo_provider.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final demoProvider = context.watch<DemoProvider>();
    // final demoProvider = context.read<DemoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Demo Screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center(
          //   child: Text(
          //     'Counter Value: ${context.select((DemoProvider provider) => provider.counter)}',
          //     style: TextStyle(fontSize: 24),
          //   ),
          // ),
          // Center(
          //   child: Selector<DemoProvider, int>(
          //     builder: (_, counter, __) {
          //       return Text(
          //         'Counter Value: $counter',
          //         style: const TextStyle(fontSize: 24),
          //       );
          //     },
          //     selector: (_, provider) => provider.counter,
          //   ),
          // ),
          Consumer<DemoProvider>(
            builder: (_, demoProvider, __) {
              return Text(
                'Counter Value: ${demoProvider.counter}',
                style: const TextStyle(fontSize: 24),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<DemoProvider>().incrementCounter();
                },
                child: const Text('Increment Counter'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<DemoProvider>().decrementCounter();
                },
                child: const Text('Decrement Counter'),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // Center(
          //   child: Text(
          //     'Age Value: ${context.select((DemoProvider provider) => provider.age)}',
          //     style: TextStyle(fontSize: 24),
          //   ),
          // ),
          // Center(
          //   child: Selector<DemoProvider, int>(
          //     builder: (_, age, __) {
          //       return Text(
          //         'Age Value: $age',
          //         style: const TextStyle(fontSize: 24),
          //       );
          //     },
          //     selector: (_, provider) => provider.age,
          //   ),
          // ),
          Consumer<DemoProvider>(
            builder: (_, demoProvider, __) {
              return Text(
                'Age Value: ${demoProvider.age}',
                style: const TextStyle(fontSize: 24),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<DemoProvider>().incrementAge();
                },
                child: const Text('Increment Age'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<DemoProvider>().decrementAge();
                },
                child: const Text('Decrement Age'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
