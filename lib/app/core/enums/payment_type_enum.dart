enum PaymentType { cash, creditCard, debitCard, pix }

const Map<PaymentType, String> paymentTypeLabels = {
  PaymentType.cash: 'Dinheiro',
  PaymentType.creditCard: 'Cartão Crédito',
  PaymentType.debitCard: 'Cartão Débito',
  PaymentType.pix: 'Pix',
};
