
import 'package:flutter/material.dart';

import '../../models/attendance.dart';

class DownloadAttendanceSheetCard extends StatefulWidget {
	const DownloadAttendanceSheetCard({
		super.key,
		required this.options,
		required this.onDownload,
		this.initialSelection,
	});

	final List<AttendanceSubject> options;
	final AttendanceSubject? initialSelection;
	final Future<void> Function({
		required AttendanceSubject subject,
		required int month,
		required int year,
	}) onDownload;

	@override
	State<DownloadAttendanceSheetCard> createState() =>
			_DownloadAttendanceSheetCardState();
}

class _DownloadAttendanceSheetCardState extends State<DownloadAttendanceSheetCard> {
	late final List<AttendanceSubject> _options;
	AttendanceSubject? _selected;
	late int _month;
	late int _year;
	bool _isDownloading = false;

	@override
	void initState() {
		super.initState();
		_options = _dedupe(widget.options);
		_selected = _normalizeSelection(
			options: _options,
			initial: widget.initialSelection,
		);
		final now = DateTime.now();
		_month = now.month;
		_year = now.year;
	}

	static List<AttendanceSubject> _dedupe(List<AttendanceSubject> input) {
		final map = <String, AttendanceSubject>{
			for (final o in input) '${o.type.name}:${o.id}': o,
		};
		final out = map.values.toList();
		out.sort((l, r) => l.name.toLowerCase().compareTo(r.name.toLowerCase()));
		return out;
	}

	static AttendanceSubject? _normalizeSelection({
		required List<AttendanceSubject> options,
		required AttendanceSubject? initial,
	}) {
		if (options.isEmpty) return null;
		if (initial == null) return options.first;
		for (final o in options) {
			if (o == initial) return o;
		}
		return options.first;
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		final months = <int, String>{
			1: 'January',
			2: 'February',
			3: 'March',
			4: 'April',
			5: 'May',
			6: 'June',
			7: 'July',
			8: 'August',
			9: 'September',
			10: 'October',
			11: 'November',
			12: 'December',
		};
		final years = <int>[for (int y = DateTime.now().year; y >= DateTime.now().year - 6; y--) y];

		return SafeArea(
			child: Padding(
				padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
				child: Card(
					color: theme.colorScheme.surface,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(24),
						side: BorderSide(color: outline),
					),
					child: Padding(
						padding: const EdgeInsets.all(16),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								Row(
									children: [
										Icon(Icons.download_rounded, color: theme.colorScheme.primary),
										const SizedBox(width: 10),
										Expanded(
											child: Text(
												'Download Attendance Sheet',
												style: theme.textTheme.titleMedium?.copyWith(
													fontWeight: FontWeight.w900,
													letterSpacing: -0.2,
												),
											),
										),
									],
								),
								const SizedBox(height: 14),
								DropdownButtonFormField<AttendanceSubject>(
									initialValue: _selected,
									items: [
										for (final o in _options)
											DropdownMenuItem(
												value: o,
												child: Text('${o.label} • ${o.name}'),
											),
									],
									onChanged: (v) => setState(() => _selected = v),
									decoration: const InputDecoration(labelText: 'MR / ASM'),
								),
								const SizedBox(height: 12),
								Row(
									children: [
										Expanded(
											child: DropdownButtonFormField<int>(
												initialValue: _month,
												items: [
													for (final e in months.entries)
														DropdownMenuItem(
															value: e.key,
															child: Text(e.value),
														),
												],
												onChanged: (v) => setState(() => _month = v ?? _month),
												decoration: const InputDecoration(labelText: 'Month'),
											),
										),
										const SizedBox(width: 12),
										Expanded(
											child: DropdownButtonFormField<int>(
												initialValue: _year,
												items: [
													for (final y in years)
														DropdownMenuItem(
															value: y,
															child: Text(y.toString()),
														),
												],
												onChanged: (v) => setState(() => _year = v ?? _year),
												decoration: const InputDecoration(labelText: 'Year'),
											),
										),
									],
								),
								const SizedBox(height: 16),
								FilledButton.icon(
									onPressed: (_isDownloading || _selected == null)
											? null
											: () async {
												setState(() => _isDownloading = true);
												try {
													await widget.onDownload(
														subject: _selected!,
														month: _month,
														year: _year,
													);
													if (!mounted) return;
													Navigator.of(context).pop();
												} finally {
													if (mounted) setState(() => _isDownloading = false);
												}
											},
									icon: _isDownloading
											? const SizedBox(
													width: 18,
													height: 18,
													child: CircularProgressIndicator(strokeWidth: 2),
												)
											: const Icon(Icons.download_rounded),
									label: const Text('Download'),
								),
							],
						),
					),
				),
			),
		);
	}
}

