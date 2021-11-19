import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hybrid_gift/app/home/job_entries/job_entries_page.dart';
import 'package:hybrid_gift/app/home/jobs/edit_job_page.dart';
import 'package:hybrid_gift/app/home/jobs/job_list_tile.dart';
import 'package:hybrid_gift/app/home/jobs/list_items_builder.dart';
import 'package:hybrid_gift/app/home/models/job.dart';
import 'package:hybrid_gift/app/top_level_providers.dart';
import 'package:hybrid_gift/constants/strings.dart';
import 'package:hybrid_gift/services/firestore_database.dart';

final jobsStreamProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final database = ref.watch(databaseProvider)!;
  return database.jobsStream();
});

// watch database
class JobsPage extends ConsumerWidget {
  const JobsPage({Key? key}) : super(key: key);

  Future<void> _delete(BuildContext context, WidgetRef ref, Job job) async {
    try {
      final database = ref.read<FirestoreDatabase?>(databaseProvider)!;
      await database.deleteJob(job);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.jobs),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EditJobPage.show(context),
          ),
        ],
      ),
      body: _buildContents(context, ref),
    );
  }

  Widget _buildContents(BuildContext context, WidgetRef ref) {
    final jobsAsyncValue = ref.watch(jobsStreamProvider);
    return ListItemsBuilder<Job>(
      data: jobsAsyncValue,
      itemBuilder: (context, job) => Dismissible(
        key: Key('job-${job.id}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _delete(context, ref, job),
        child: JobListTile(
          job: job,
          onTap: () => JobEntriesPage.show(context, job),
        ),
      ),
    );
  }
}