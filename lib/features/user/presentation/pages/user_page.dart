import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _idController = TextEditingController(text: '1');

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _fetchUser() {
    final idText = _idController.text.trim();
    final userId = int.tryParse(idText);
    if (userId != null) {
      context.read<UserBloc>().add(FetchUserEvent(userId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid numeric User ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenAPI Generator POC'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Architecture Info Banner
            _buildArchitectureCard(context),
            const SizedBox(height: 20),

            // User ID Input Controls
            _buildInputSection(context),
            const SizedBox(height: 24),

            // BLoC Result Display
            _buildBlocView(),
          ],
        ),
      ),
    );
  }

  Widget _buildArchitectureCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.architecture,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Clean Architecture Flow',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'UI → BLoC → Use Case → Repository → Remote Data Source → OpenAPI Generated UserApi (Dio)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Request Parameters',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'User ID (Path Parameter: /users/{id})',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_search),
                hintText: 'e.g. 1, 2, 42',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Quick Test: '),
                Wrap(
                  spacing: 8,
                  children: [1, 2, 42].map((id) {
                    return ActionChip(
                      label: Text('ID $id'),
                      onPressed: () {
                        _idController.text = '$id';
                        _fetchUser();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchUser,
              icon: const Icon(Icons.send),
              label: const Text('Execute OpenAPI GET /users/{id}'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlocView() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitialState) {
          return Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(
                  Icons.api_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter a User ID and tap execute to test the generated Dio API client.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        } else if (state is UserLoadingState) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Calling OpenAPI endpoint via Dio...'),
              ],
            ),
          );
        } else if (state is UserLoadedState) {
          final user = state.user;
          return Card(
            color: Colors.green.shade50,
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.green.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Chip(
                        avatar: Icon(Icons.check_circle, color: Colors.green),
                        label: Text('HTTP 200 OK'),
                        backgroundColor: Colors.white,
                      ),
                      Text(
                        'OpenAPI User DTO',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade700,
                      child: Text(
                        '${user.id}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('User ID: ${user.id}'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is UserErrorState) {
          return Card(
            color: Colors.red.shade50,
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Request Failed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _fetchUser,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Request'),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
