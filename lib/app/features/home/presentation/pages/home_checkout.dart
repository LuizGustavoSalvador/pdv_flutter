import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdv_flutter/app/core/enums/payment_type_enum.dart';
import 'package:pdv_flutter/app/core/l10n/app_localizations.dart';

class PaymentForm {
  PaymentType type;
  double value;
  PaymentForm(this.type, this.value);
}

class HomeCheckout extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotal;
  final VoidCallback onCancel;
  final VoidCallback onCheckout;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final void Function(int index) onRemoveCartItem;

  const HomeCheckout({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.onCancel,
    required this.onCheckout,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onRemoveCartItem,
  });

  @override
  State<HomeCheckout> createState() => _HomeCheckoutState();
}

class _HomeCheckoutState extends State<HomeCheckout> {
  List<PaymentForm> payments = [PaymentForm(PaymentType.cash, 0)];
  final _formKey = GlobalKey<FormState>();
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  final ScrollController _cartScrollController = ScrollController();

  final List<TextEditingController> _controllers = [];
  final List<String?> _errors = [];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void dispose() {
    _cartScrollController.dispose();
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeCheckout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems.isEmpty && payments.length != 1) {
      setState(() {
        payments = [PaymentForm(PaymentType.cash, 0)];
        _syncControllers();
      });
    }
    if (_controllers.length != payments.length) {
      _syncControllers();
    }
  }

  void _syncControllers() {
    while (_controllers.length < payments.length) {
      _controllers.add(TextEditingController());
      _errors.add(null);
    }
    while (_controllers.length > payments.length) {
      _controllers.removeLast().dispose();
      _errors.removeLast();
    }
    for (int i = 0; i < payments.length; i++) {
      final val = payments[i].value;
      if (_controllers[i].text !=
          (val > 0 ? val.toStringAsFixed(2).replaceAll('.', ',') : '')) {
        _controllers[i].text = val > 0
            ? val.toStringAsFixed(2).replaceAll('.', ',')
            : '';
      }
    }
  }

  double get subtotal => widget.subtotal;

  double get totalPaid => payments.asMap().entries.fold(0.0, (sum, entry) {
    if (_errors.length > entry.key && _errors[entry.key] == null) {
      return sum + entry.value.value;
    }
    return sum;
  });

  double get totalPaidWithoutCash => payments
      .asMap()
      .entries
      .where(
        (e) =>
            e.value.type != PaymentType.cash &&
            (_errors.length > e.key && _errors[e.key] == null),
      )
      .fold(0.0, (s, e) => s + e.value.value);

  double get totalCashPaid => payments
      .asMap()
      .entries
      .where(
        (e) =>
            e.value.type == PaymentType.cash &&
            (_errors.length > e.key && _errors[e.key] == null),
      )
      .fold(0.0, (s, e) => s + e.value.value);

  double get remaining => (subtotal - totalPaid).clamp(0, double.infinity);

  bool get canAddPayment => remaining > 0.01;

  double get change {
    if (totalCashPaid > 0) {
      final restante = subtotal - totalPaidWithoutCash;
      final troco = totalCashPaid - restante;
      return troco > 0 ? troco : 0.0;
    }
    return 0.0;
  }

  void _addPayment() {
    if (!canAddPayment) return;
    setState(() {
      payments.add(PaymentForm(PaymentType.creditCard, remaining));
      _syncControllers();
    });
  }

  void _removePayment(int idx) {
    setState(() {
      if (payments.length > 1) {
        payments.removeAt(idx);
        _syncControllers();
      } else {
        payments[0].value = 0;
        _syncControllers();
      }
    });
  }

  void _updatePaymentType(int idx, PaymentType type, AppLocalizations l10n) {
    setState(() {
      payments[idx].type = type;
      final valueLeft = subtotal - _otherPaymentsSum(idx);
      if (type != PaymentType.cash && payments[idx].value > valueLeft) {
        payments[idx].value = valueLeft < 0 ? 0 : valueLeft;
        _controllers[idx].text = payments[idx].value == 0
            ? ''
            : payments[idx].value.toStringAsFixed(2).replaceAll('.', ',');
      }
      _validatePayment(idx, l10n);
    });
  }

  double _otherPaymentsSum(int idx) {
    return payments
        .asMap()
        .entries
        .where((e) => e.key != idx)
        .fold(0.0, (s, e) => s + e.value.value);
  }

  void _onChangedValue(int idx, String v, AppLocalizations l10n) {
    setState(() {
      String sanitized = v
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .replaceAll('R\$', '')
          .trim();
      double value = double.tryParse(sanitized) ?? 0.0;
      payments[idx].value = value;
      for (int i = 0; i < payments.length; i++) {
        _validatePayment(i, l10n);
      }
    });
  }

  void _validatePayment(int idx, AppLocalizations l10n) {
    final type = payments[idx].type;
    final value = payments[idx].value;

    double maxAllowed = type == PaymentType.cash
        ? double.infinity
        : subtotal - _otherPaymentsSum(idx);

    if (value == 0) {
      _errors[idx] = l10n.insertValue;
    } else if (type != PaymentType.cash && value > maxAllowed) {
      _errors[idx] = 'Valor informado excede o valor total do pedido';
    } else if (value < 0) {
      _errors[idx] = l10n.insertValue;
    } else {
      _errors[idx] = null;
    }
  }

  void _resetCheckout() {
    setState(() {
      payments = [PaymentForm(PaymentType.cash, 0)];
      for (final c in _controllers) {
        c.clear();
      }
      _syncControllers();
    });
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    final bool cartIsEmpty = widget.cartItems.isEmpty;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 400,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Switch de tema
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          widget.themeMode == ThemeMode.dark
                              ? Icons.wb_sunny_outlined
                              : widget.themeMode == ThemeMode.light
                              ? Icons.nights_stay_outlined
                              : Icons.brightness_6,
                        ),
                        tooltip: widget.themeMode == ThemeMode.dark
                            ? l10n.lightMode
                            : widget.themeMode == ThemeMode.light
                            ? l10n.darkMode
                            : l10n.systemMode,
                        onPressed: () {
                          ThemeMode nextMode;
                          if (widget.themeMode == ThemeMode.system) {
                            nextMode = ThemeMode.light;
                          } else if (widget.themeMode == ThemeMode.light) {
                            nextMode = ThemeMode.dark;
                          } else {
                            nextMode = ThemeMode.system;
                          }
                          widget.onThemeModeChanged(nextMode);
                        },
                      ),
                    ),
                    Text(
                      l10n.checkoutTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    // Carrinho
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface
                              .withAlpha((255 * 0.08).round()),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(maxHeight: 160),
                      child: cartIsEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  l10n.emptyCart,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha((255 * 0.5).round()),
                                  ),
                                ),
                              ),
                            )
                          : Scrollbar(
                              controller: _cartScrollController,
                              radius: const Radius.circular(12),
                              thumbVisibility: true,
                              child: ListView.separated(
                                controller: _cartScrollController,
                                padding: const EdgeInsets.all(0),
                                itemCount: widget.cartItems.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                shrinkWrap: true,
                                itemBuilder: (_, i) {
                                  final item = widget.cartItems[i];
                                  return ListTile(
                                    dense: true,
                                    title: Text(item['name']),
                                    trailing: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            currencyFormat.format(
                                              item['price'],
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () =>
                                                widget.onRemoveCartItem(i),
                                            child: const Icon(
                                              Icons.close,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${l10n.subtotal}: ${currencyFormat.format(subtotal)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Divider(),
                    Text(
                      l10n.paymentMethod,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    // Formas de pagamento
                    ...List.generate(payments.length, (idx) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 128,
                              child: DropdownButtonFormField<PaymentType>(
                                value: payments[idx].type,
                                isExpanded: true,
                                items: PaymentType.values
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(paymentTypeLabels[type]!),
                                      ),
                                    )
                                    .toList(),
                                onChanged: cartIsEmpty
                                    ? null
                                    : (val) {
                                        if (val != null) {
                                          _updatePaymentType(idx, val, l10n);
                                        }
                                      },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _controllers[idx],
                                    enabled: !cartIsEmpty,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: l10n.value,
                                      prefixText: 'R\$ ',
                                      errorText: _errors[idx],
                                      errorMaxLines: 2,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    onChanged: (v) =>
                                        _onChangedValue(idx, v, l10n),
                                  ),
                                  if (_errors[idx] == null)
                                    const SizedBox(height: 32),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: !cartIsEmpty && payments.length > 1
                                  ? () => _removePayment(idx)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed:
                          cartIsEmpty ||
                              !canAddPayment ||
                              _errors.any((e) => e != null)
                          ? null
                          : _addPayment,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addPaymentMethod),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.totalPaid}: ${currencyFormat.format(totalPaid)}',
                        ),
                        if (change > 0)
                          Text(
                            '${l10n.change}: ${currencyFormat.format(change)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        if (remaining > 0)
                          Text(
                            '${l10n.totalFault}: ${currencyFormat.format(remaining)}',
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[100],
                                foregroundColor: Colors.red[800],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: cartIsEmpty ? null : _resetCheckout,
                              child: Text(l10n.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed:
                                  (!cartIsEmpty &&
                                      totalPaid >= subtotal &&
                                      payments.every(
                                        (p) =>
                                            p.value > 0 &&
                                            (_errors.length >
                                                    payments.indexOf(p)
                                                ? _errors[payments.indexOf(
                                                        p,
                                                      )] ==
                                                      null
                                                : true),
                                      ))
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        widget.onCheckout();
                                        setState(() {
                                          payments = [
                                            PaymentForm(PaymentType.cash, 0),
                                          ];
                                          _syncControllers();
                                        });
                                      }
                                    }
                                  : null,
                              child: Text(l10n.finalizeSale),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
