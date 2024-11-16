import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des étudiants',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListScreen(),
    );
  }
}

// Modèle de données pour un étudiant
class Student {
  final String nom;
  final String prenom;
  final String email;
  final String universite;
  final String description;

  Student(this.nom, this.prenom, this.email, this.universite, this.description);
}

// Écran principal avec la liste des étudiants
class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];

  void _addStudent(String nom, String prenom, String email, String universite, String description) {
    setState(() {
      students.add(Student(nom, prenom, email, universite, description));
    });
  }

  void _showStudentDetails(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailsScreen(
          student: student,
          onDelete: () {
            setState(() {
              students.remove(student);
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des étudiants'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  color: Colors.blue[50],
                  child: ListTile(
                    title: Text('${student.nom} ${student.prenom}'),
                    subtitle: Text('${student.email}\nUniversité: ${student.universite}'),
                    trailing: TextButton(
                      onPressed: () => _showStudentDetails(student),
                      child: Text(
                        'Détails',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddStudentDialog(onAdd: _addStudent),
                );
              },
              child: Text('Ajouter un étudiant'),
            ),
          ),
        ],
      ),
    );
  }
}

// Écran pour afficher les détails d'un étudiant
class StudentDetailsScreen extends StatelessWidget {
  final Student student;
  final VoidCallback onDelete;

  StudentDetailsScreen({required this.student, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'étudiant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: ${student.nom}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Prénom: ${student.prenom}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${student.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Université: ${student.universite}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Description: ${student.description}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
              ),
              child: Text('Supprimer'),
            ),
          ],
        ),
      ),
    );
  }
}

// Boîte de dialogue pour ajouter un nouvel étudiant
class AddStudentDialog extends StatefulWidget {
  final Function(String, String, String, String, String) onAdd;

  AddStudentDialog({required this.onAdd});

  @override
  _AddStudentDialogState createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _universiteController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouvel étudiant'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _prenomController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _universiteController,
              decoration: InputDecoration(labelText: 'Université'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAdd(
              _nomController.text,
              _prenomController.text,
              _emailController.text,
              _universiteController.text,
              _descriptionController.text,
            );
            Navigator.of(context).pop();
          },
          child: Text('Ajouter'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _universiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}