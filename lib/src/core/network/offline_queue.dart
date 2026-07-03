import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

/// A single grade request that couldn't be sent (e.g. offline) and is awaiting
/// retry. [payload] holds the metadata needed to rebuild the request; the paper
/// image path is kept as a local file reference.
class QueuedGradeRequest {
  QueuedGradeRequest({
    required this.id,
    required this.paperImagePath,
    required this.payload,
    DateTime? queuedAt,
  }) : queuedAt = queuedAt ?? DateTime.now();

  final String id;
  final String paperImagePath;
  final Map<String, dynamic> payload;
  final DateTime queuedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'paperImagePath': paperImagePath,
        'payload': payload,
        'queuedAt': queuedAt.toIso8601String(),
      };

  factory QueuedGradeRequest.fromJson(Map<String, dynamic> json) => QueuedGradeRequest(
        id: json['id'] as String,
        paperImagePath: json['paperImagePath'] as String,
        payload: (json['payload'] as Map).cast<String, dynamic>(),
        queuedAt: DateTime.parse(json['queuedAt'] as String),
      );
}

/// Persists pending grade uploads to disk and flushes them when connectivity
/// returns. The actual send is delegated back to a caller-supplied [sender] so
/// this stays independent of the grading service.
class OfflineGradingQueue {
  OfflineGradingQueue({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<File> get _file async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/pending_grades.json');
  }

  Future<List<QueuedGradeRequest>> _read() async {
    final file = await _file;
    if (!file.existsSync()) return [];
    final raw = jsonDecode(await file.readAsString()) as List<dynamic>;
    return raw
        .cast<Map<String, dynamic>>()
        .map(QueuedGradeRequest.fromJson)
        .toList();
  }

  Future<void> _write(List<QueuedGradeRequest> items) async {
    final file = await _file;
    await file.writeAsString(jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<void> enqueue(QueuedGradeRequest request) async {
    final items = await _read()..add(request);
    await _write(items);
  }

  Future<List<QueuedGradeRequest>> pending() => _read();

  Future<void> _remove(String id) async {
    final items = (await _read())..removeWhere((r) => r.id == id);
    await _write(items);
  }

  /// Attempts to send every queued request. [sender] returns true on success.
  Future<void> flush(Future<bool> Function(QueuedGradeRequest) sender) async {
    for (final req in await pending()) {
      final ok = await sender(req);
      if (ok) await _remove(req.id);
    }
  }

  /// Auto-flush whenever the device comes back online.
  void startAutoFlush(Future<bool> Function(QueuedGradeRequest) sender) {
    _sub = _connectivity.onConnectivityChanged.listen((results) async {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) await flush(sender);
    });
  }

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  void dispose() => _sub?.cancel();
}
