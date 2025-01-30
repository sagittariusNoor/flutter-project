import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/note_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'add_edit_note_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authViewModel.logout(),
          ),
        ],
      ),
      body: FutureBuilder(
        future: noteViewModel.fetchNotes(authViewModel.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: noteViewModel.notes.length,
            itemBuilder: (context, index) {
              final note = noteViewModel.notes[index];

              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditNoteScreen(note: note)));
                    }),
                    IconButton(icon: Icon(Icons.delete), onPressed: () {
                      noteViewModel.deleteNote(note.id);
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditNoteScreen()));
        },
      ),
    );
  }
}
