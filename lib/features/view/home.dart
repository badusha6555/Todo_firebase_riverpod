import 'dart:developer';

import 'package:firebase_basic/data/model/model.dart';
import 'package:firebase_basic/features/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoStream = ref.watch(todoStreamProvider);
    final fireStoreService = ref.read(fireStoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo With Firebase',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      return;
                    }
                    final String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    ref.read(fireStoreServiceProvider).addTodo(
                          Model(
                            id: id,
                            name: nameController.text,
                            description: descriptionController.text,
                          ),
                        );
                    log(
                      '${nameController.text} ${descriptionController.text}',
                    );
                    nameController.clear();
                    descriptionController.clear();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
              child: todoStream.when(
            data: (items) {
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].name),
                    subtitle: Text(items[index].description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            ref.read(fireStoreServiceProvider).deleteTodo(
                                  items[index].id,
                                );
                          },
                          icon: Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {
                            // Pre-fill the TextField with the existing data
                            nameController.text = items[index].name;
                            descriptionController.text =
                                items[index].description;

                            showAboutDialog(
                              context: context,
                              children: [
                                Text('Edit'),
                                Column(
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: descriptionController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Description',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (nameController.text.isEmpty ||
                                            descriptionController
                                                .text.isEmpty) {
                                          return;
                                        }

                                        ref
                                            .read(fireStoreServiceProvider)
                                            .updateTodo(
                                              Model(
                                                id: items[index].id,
                                                name: nameController.text,
                                                description:
                                                    descriptionController.text,
                                              ),
                                              items[index].id,
                                              todoId: items[index].id,
                                            );
                                        log(
                                          '${nameController.text} ${descriptionController.text}',
                                        );
                                        nameController.clear();
                                        descriptionController.clear();
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            error: (Object error, StackTrace stackTrace) {
              return Center(child: Text('Error: $error'));
            },
            loading: () {
              return Center(child: CircularProgressIndicator());
            },
          )),
        ],
      ),
    );
  }
}
