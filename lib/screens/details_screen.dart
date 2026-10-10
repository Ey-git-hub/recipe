import 'package:flutter/material.dart';
import 'package:recipe/model/recipe.dart';
import 'package:recipe/notification/notification_service.dart';

class RecipesDetailsScreen extends StatelessWidget {
  const RecipesDetailsScreen({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.heart_broken_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe.image-${recipe.image}',
              child: Image.network(
                recipe.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 13,
                bottom: 45,
                left: 13,
                right: 13,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ingridents:",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.ingredients.map((ing) => '=> $ing').join('\n'),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    recipe.instructions
                        .asMap()
                        .entries
                        .map((entry) {
                          int idx = entry.key + 1;
                          return '$idx. ${entry.value}';
                        })
                        .join('\n\n'),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // ማሻሻያ 1፦ የ context መጥፋትን ለመከላከል ScaffoldMessengerን እዚህ አናት ላይ እንይዘዋለን
                        final messenger = ScaffoldMessenger.of(context);

                        try {
                          // 1. የኖቲፊኬሽን ጥሪውን እንሞክራለን
                          await NotificationService.instance
                              .scheduleNotification(
                                id: recipe.id,
                                title: 'የማብሰያ ማሳሰቢያ! 🍳',
                                body: 'ዛሬ ማታ "${recipe.name}" ማብሰል እንዳትረሳ!',
                                secondsLater: 5,
                              );

                          // 2. የ async ሥራው ካለቀ በኋላ ገጹ አለመዘጋቱን እናረጋግጣለን
                          if (!context.mounted) return;

                          // 3. አናት ላይ የያዝነውን 'messenger' ተለዋዋጭ ተጠቅመን SnackBarውን እናሳያለን
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'ለ "${recipe.name}" የማብሰያ ማሳሰቢያ ከ 5 ሰከንድ በኋላ ይታያል!',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } catch (e) {
                          // 4. *** ዋነኛው መመርመሪያ እዚህ ጋ ነው ***
                          // ኖቲፊኬሽኑ እምቢ ካለ ስህተቱን በ SnackBar በኩል በስክሪኑ ላይ ያሳየናል
                          if (!context.mounted) return;
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      },

                      icon: Icon(Icons.alarm),
                      label: Text("Cook this recipe tonight!"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
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
