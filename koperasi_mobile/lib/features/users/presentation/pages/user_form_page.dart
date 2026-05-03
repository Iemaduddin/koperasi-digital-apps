import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';

class UserFormPage extends StatefulWidget {
  final UserModel? user; // Null if creating, non-null if editing

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'USER';
  bool _isLoading = false;

  final List<String> _roles = ['USER', 'ADMIN', 'SUPER_ADMIN', 'MASTER_ADMIN'];

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'role': _selectedRole,
    };

    if (widget.user == null || _passwordController.text.isNotEmpty) {
      userData['password'] = _passwordController.text;
    }

    try {
      if (widget.user == null) {
        await UserService.createUser(userData);
      } else {
        await UserService.updateUser(widget.user!.id, userData);
      }
      if (mounted) {
        Navigator.pop(context, true); // Return true to signal refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan pengguna')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Pengguna' : 'Tambah Pengguna'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: 'Nama Lengkap',
                controller: _nameController,
                validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Email wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: isEditing ? 'Kata Sandi Baru (Kosongkan jika tidak diubah)' : 'Kata Sandi',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (!isEditing && value!.isEmpty) {
                    return 'Kata sandi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: _isLoading ? 'Menyimpan...' : 'Simpan',
                onPressed: _isLoading ? () {} : _saveUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
