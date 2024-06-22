import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserProfile extends StatelessWidget {
  final String documentId;

  const GetUserProfile({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(documentId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Icon(Icons.person);
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        String? imageUrl = data['photoURL'];

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl == null || imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
            const SizedBox(width: 10),
          ],
        );
      },
    );
  }
}
