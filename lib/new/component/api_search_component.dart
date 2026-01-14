import 'dart:async';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/material.dart';


class ApiSearchDropdown<T> extends StatefulWidget {
  final String? hint;
  final String? labelText;
  final Widget? icon;
  final bool? isFetchFirst;

  /// Selected item (nilai yang dipilih)
  final T? value;

  /// Kalau user pilih item
  final ValueChanged<T?> onChanged;

  /// Untuk menampilkan teks di UI (misal: item.name)
  final String Function(T item) itemLabel;

  /// API fetcher: input query -> return list item
  final Future<List<T>> Function(String query) fetchItems;

  /// Validator (opsional) untuk Form
  final String? Function(T?)? validator;

  /// Placeholder search
  final String searchHint;

  /// Debounce search agar gak nembak API tiap karakter
  final Duration debounce;

  /// Optional: minimum karakter sebelum hit API
  final int minQueryLength;

  const ApiSearchDropdown({
    this.isFetchFirst = false,
    super.key,
    this.hint,
    this.labelText,
    this.icon,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    required this.fetchItems,
    this.validator,
    this.searchHint = "Cari...",
    this.debounce = const Duration(milliseconds: 350),
    this.minQueryLength = 1,
  });

  @override
  State<ApiSearchDropdown<T>> createState() => _ApiSearchDropdownState<T>();
}

class _ApiSearchDropdownState<T> extends State<ApiSearchDropdown<T>> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncDisplay();
  }

  @override
  void didUpdateWidget(covariant ApiSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _syncDisplay();
  }

  void _syncDisplay() {
    _displayController.text = widget.value == null
        ? ""
        : widget.itemLabel(widget.value as T);
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(color: ColorHelper.hint),
      prefixIcon: widget.icon,
      suffixIcon: const Icon(Icons.keyboard_arrow_down),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ColorHelper.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ColorHelper.border, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Future<void> _openSearchModal() async {
    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _SearchSheet<T>(
        isFetchFirst: widget.isFetchFirst,
        initialValue: widget.value,
        itemLabel: widget.itemLabel,
        fetchItems: widget.fetchItems,
        searchHint: widget.searchHint,
        debounce: widget.debounce,
        minQueryLength: widget.minQueryLength,
      ),
    );

    // kalau user pilih item
    if (!mounted) return;
    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: (_) => widget.validator?.call(widget.value),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null && widget.labelText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.labelText!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            GestureDetector(
              onTap: _openSearchModal,
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _displayController,
                  readOnly: true,
                  decoration: _buildInputDecoration().copyWith(
                    errorText: state.errorText,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SearchSheet<T> extends StatefulWidget {
  final bool? isFetchFirst;
  final T? initialValue;
  final String Function(T item) itemLabel;
  final Future<List<T>> Function(String query) fetchItems;
  final String searchHint;
  final Duration debounce;
  final int minQueryLength;

  const _SearchSheet({
    this.isFetchFirst,
    required this.initialValue,
    required this.itemLabel,
    required this.fetchItems,
    required this.searchHint,
    required this.debounce,
    required this.minQueryLength,
  });

  @override
  State<_SearchSheet<T>> createState() => _SearchSheetState<T>();
}

class _SearchSheetState<T> extends State<_SearchSheet<T>> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounceTimer;
  bool _loading = false;
  String? _error;
  List<T> _items = const [];

  @override
  void initState() {
    super.initState();
    // optional: load awal (misal query kosong) kalau kamu mau
    if (widget.isFetchFirst ?? false) {
      _runSearch("");
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce, () {
      _runSearch(q.trim());
    });
  }

  Future<void> _runSearch(String q) async {
    if (q.length < widget.minQueryLength) {
      setState(() {
        _items = const [];
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await widget.fetchItems(q);
      if (!mounted) return;
      setState(() {
        _items = res;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),

              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ColorHelper.border,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ColorHelper.border,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Gagal memuat data.\n$_error",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Data tidak ditemukan."),
        ),
      );
    }

    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final item = _items[i];
        return ListTile(
          title: Text(widget.itemLabel(item)),
          onTap: () => Navigator.pop(context, item),
        );
      },
    );
  }
}