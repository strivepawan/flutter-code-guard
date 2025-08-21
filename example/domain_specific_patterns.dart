/// Domain-Specific Coding Patterns for Different Industries
/// This demonstrates coding patterns and practices specific to various business domains
library;

// ============================================================================
// FINTECH DOMAIN PATTERNS
// ============================================================================

/// Financial Transaction Processing Patterns
class FinTechPatterns {
  /// ✅ PATTERN: Money Object Pattern - Always use dedicated money types
  static void demonstrateMoneyPattern() {
    // ❌ BAD: Using double for money
    // double price = 19.99;  // Subject to floating point errors

    // ✅ GOOD: Using Money object
    final productPrice = Money.fromDollars(19, 99);
    final tax = productPrice.multiply(0.08875); // 8.875% tax
    final total = productPrice.add(tax);

    print('Product: ${productPrice.display()}');
    print('Tax: ${tax.display()}');
    print('Total: ${total.display()}');
  }

  /// ✅ PATTERN: Financial Transaction State Machine
  static void demonstrateTransactionStateMachine() {
    var transaction = PaymentTransaction.create(
      amount: Money.fromDollars(500, 0),
      fromAccount: 'acc_123',
      toAccount: 'acc_456',
    );

    // Valid state transitions only
    transaction = transaction.authorize();
    transaction = transaction.capture();
    transaction = transaction.settle();

    print('Final transaction status: ${transaction.status}');
  }

  /// ✅ PATTERN: Audit Trail Pattern
  static void demonstrateAuditTrail() {
    final auditLogger = FinancialAuditLogger();

    auditLogger.logEvent(
      eventType: 'PAYMENT_INITIATED',
      userId: 'user_123',
      details: {'amount': '500.00', 'currency': 'USD'},
      sensitiveData: false,
    );

    auditLogger.logEvent(
      eventType: 'ACCOUNT_ACCESS',
      userId: 'user_123',
      details: {'account_id': 'acc_123'},
      sensitiveData: true, // Will be encrypted
    );
  }
}

/// Money class for precise financial calculations
class Money {
  final int _cents;
  final String currency;

  const Money._(this._cents, this.currency);

  factory Money.fromDollars(int dollars, int cents) {
    return Money._(dollars * 100 + cents, 'USD');
  }

  factory Money.fromCents(int cents, String currency) {
    return Money._(cents, currency);
  }

  Money add(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money._(_cents + other._cents, currency);
  }

  Money multiply(double factor) {
    return Money._((_cents * factor).round(), currency);
  }

  String display() {
    final dollars = _cents ~/ 100;
    final cents = _cents % 100;
    return '$currency \$${dollars}.${cents.toString().padLeft(2, '0')}';
  }
}

/// Payment Transaction with state machine
class PaymentTransaction {
  final String id;
  final Money amount;
  final String fromAccount;
  final String toAccount;
  final PaymentStatus status;
  final DateTime createdAt;
  final List<String> auditTrail;

  const PaymentTransaction._({
    required this.id,
    required this.amount,
    required this.fromAccount,
    required this.toAccount,
    required this.status,
    required this.createdAt,
    required this.auditTrail,
  });

  factory PaymentTransaction.create({
    required Money amount,
    required String fromAccount,
    required String toAccount,
  }) {
    return PaymentTransaction._(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      fromAccount: fromAccount,
      toAccount: toAccount,
      status: PaymentStatus.pending,
      createdAt: DateTime.now(),
      auditTrail: ['Created'],
    );
  }

  PaymentTransaction authorize() {
    if (status != PaymentStatus.pending) {
      throw StateError('Can only authorize pending transactions');
    }
    return PaymentTransaction._(
      id: id,
      amount: amount,
      fromAccount: fromAccount,
      toAccount: toAccount,
      status: PaymentStatus.authorized,
      createdAt: createdAt,
      auditTrail: [...auditTrail, 'Authorized at ${DateTime.now()}'],
    );
  }

  PaymentTransaction capture() {
    if (status != PaymentStatus.authorized) {
      throw StateError('Can only capture authorized transactions');
    }
    return PaymentTransaction._(
      id: id,
      amount: amount,
      fromAccount: fromAccount,
      toAccount: toAccount,
      status: PaymentStatus.captured,
      createdAt: createdAt,
      auditTrail: [...auditTrail, 'Captured at ${DateTime.now()}'],
    );
  }

  PaymentTransaction settle() {
    if (status != PaymentStatus.captured) {
      throw StateError('Can only settle captured transactions');
    }
    return PaymentTransaction._(
      id: id,
      amount: amount,
      fromAccount: fromAccount,
      toAccount: toAccount,
      status: PaymentStatus.settled,
      createdAt: createdAt,
      auditTrail: [...auditTrail, 'Settled at ${DateTime.now()}'],
    );
  }
}

enum PaymentStatus { pending, authorized, captured, settled, failed, cancelled }

/// Audit logger for financial compliance
class FinancialAuditLogger {
  final List<AuditEvent> _events = [];

  void logEvent({
    required String eventType,
    required String userId,
    required Map<String, String> details,
    bool sensitiveData = false,
  }) {
    final event = AuditEvent(
      id: 'audit_${DateTime.now().millisecondsSinceEpoch}',
      eventType: eventType,
      userId: userId,
      timestamp: DateTime.now(),
      details: sensitiveData ? _encryptDetails(details) : details,
      encrypted: sensitiveData,
    );
    _events.add(event);
    _persistToSecureStorage(event);
  }

  Map<String, String> _encryptDetails(Map<String, String> details) {
    // In production, use proper encryption
    return details.map((key, value) => MapEntry(key, 'encrypted_$value'));
  }

  void _persistToSecureStorage(AuditEvent event) {
    // In production, store in tamper-proof audit log
    print('🔒 Audit event logged: ${event.eventType}');
  }
}

class AuditEvent {
  final String id;
  final String eventType;
  final String userId;
  final DateTime timestamp;
  final Map<String, String> details;
  final bool encrypted;

  const AuditEvent({
    required this.id,
    required this.eventType,
    required this.userId,
    required this.timestamp,
    required this.details,
    required this.encrypted,
  });
}

// ============================================================================
// HEALTHCARE DOMAIN PATTERNS
// ============================================================================

/// Healthcare Domain Patterns
class HealthcarePatterns {
  /// ✅ PATTERN: Patient Data Segregation
  static void demonstratePatientDataSegregation() {
    // Separate PII from medical data
    final patientIdentity = PatientIdentity.create(
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: DateTime(1985, 5, 15),
      ssn: '123-45-6789',
    );

    final medicalRecord = MedicalRecord.create(
      patientId: patientIdentity.anonymousId,
      diagnosis: 'Hypertension',
      medications: ['Lisinopril 10mg'],
      providerId: 'dr_smith_123',
    );

    print('Patient ID: ${patientIdentity.anonymousId}');
    print('Medical Record: ${medicalRecord.id}');
  }

  /// ✅ PATTERN: HIPAA Compliant Access Control
  static void demonstrateHIPAAAccess() {
    final accessController = HIPAAAccessController();

    // Request access with business justification
    final accessToken = accessController.requestAccess(
      userId: 'nurse_jane_456',
      patientId: 'patient_789',
      purpose: 'Treatment planning',
      department: 'Cardiology',
    );

    if (accessToken != null) {
      print('✅ Access granted: ${accessToken.id}');
      // Use access token for operations
      accessController.logAccess(accessToken, 'Viewed patient chart');
    } else {
      print('❌ Access denied');
    }
  }

  /// ✅ PATTERN: Medical Data Validation
  static void demonstrateMedicalValidation() {
    final validator = MedicalDataValidator();

    // Validate vital signs
    final vitals = VitalSigns(
      bloodPressureSystolic: 120,
      bloodPressureDiastolic: 80,
      heartRate: 72,
      temperature: 98.6,
      respiratoryRate: 16,
    );

    final validation = validator.validateVitalSigns(vitals);
    if (validation.isValid) {
      print('✅ Vital signs are within normal ranges');
    } else {
      print('⚠️ Abnormal vital signs detected: ${validation.warnings}');
    }
  }
}

/// Patient Identity with PII encryption
class PatientIdentity {
  final String anonymousId;
  final String _encryptedPII; // Encrypted personally identifiable information
  final DateTime createdAt;

  const PatientIdentity._(this.anonymousId, this._encryptedPII, this.createdAt);

  factory PatientIdentity.create({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String ssn,
  }) {
    final anonymousId = 'patient_${DateTime.now().millisecondsSinceEpoch}';
    final piiData = {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'ssn': ssn,
    };
    final encryptedPII = _encryptPII(piiData);

    return PatientIdentity._(anonymousId, encryptedPII, DateTime.now());
  }

  static String _encryptPII(Map<String, String> pii) {
    // In production, use AES-256 encryption
    return 'encrypted_${pii.toString().hashCode}';
  }
}

/// Medical record without PII
class MedicalRecord {
  final String id;
  final String patientId; // Anonymous ID only
  final String diagnosis;
  final List<String> medications;
  final String providerId;
  final DateTime createdAt;

  const MedicalRecord._({
    required this.id,
    required this.patientId,
    required this.diagnosis,
    required this.medications,
    required this.providerId,
    required this.createdAt,
  });

  factory MedicalRecord.create({
    required String patientId,
    required String diagnosis,
    required List<String> medications,
    required String providerId,
  }) {
    return MedicalRecord._(
      id: 'medical_${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      diagnosis: diagnosis,
      medications: List.unmodifiable(medications),
      providerId: providerId,
      createdAt: DateTime.now(),
    );
  }
}

/// HIPAA compliant access control
class HIPAAAccessController {
  final Map<String, AccessToken> _activeTokens = {};

  AccessToken? requestAccess({
    required String userId,
    required String patientId,
    required String purpose,
    required String department,
  }) {
    // Check if user has valid role and department
    if (_validateUserAccess(userId, department, purpose)) {
      final token = AccessToken(
        id: 'access_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        patientId: patientId,
        purpose: purpose,
        expiresAt: DateTime.now().add(const Duration(hours: 8)),
      );
      _activeTokens[token.id] = token;
      return token;
    }
    return null;
  }

  void logAccess(AccessToken token, String action) {
    final logEntry = AccessLog(
      tokenId: token.id,
      userId: token.userId,
      patientId: token.patientId,
      action: action,
      timestamp: DateTime.now(),
    );
    _persistAccessLog(logEntry);
  }

  bool _validateUserAccess(String userId, String department, String purpose) {
    // In production, check against role-based access control
    return true; // Simplified for demo
  }

  void _persistAccessLog(AccessLog log) {
    // Store in tamper-proof audit log
    print('🏥 Access logged: ${log.action} by ${log.userId}');
  }
}

class AccessToken {
  final String id;
  final String userId;
  final String patientId;
  final String purpose;
  final DateTime expiresAt;

  const AccessToken({
    required this.id,
    required this.userId,
    required this.patientId,
    required this.purpose,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class AccessLog {
  final String tokenId;
  final String userId;
  final String patientId;
  final String action;
  final DateTime timestamp;

  const AccessLog({
    required this.tokenId,
    required this.userId,
    required this.patientId,
    required this.action,
    required this.timestamp,
  });
}

/// Medical data validation
class MedicalDataValidator {
  ValidationResult validateVitalSigns(VitalSigns vitals) {
    final warnings = <String>[];

    // Blood pressure validation
    if (vitals.bloodPressureSystolic > 140 ||
        vitals.bloodPressureDiastolic > 90) {
      warnings.add('High blood pressure detected');
    }
    if (vitals.bloodPressureSystolic < 90 ||
        vitals.bloodPressureDiastolic < 60) {
      warnings.add('Low blood pressure detected');
    }

    // Heart rate validation
    if (vitals.heartRate > 100) {
      warnings.add('Tachycardia (high heart rate) detected');
    }
    if (vitals.heartRate < 60) {
      warnings.add('Bradycardia (low heart rate) detected');
    }

    // Temperature validation
    if (vitals.temperature > 100.4) {
      warnings.add('Fever detected');
    }
    if (vitals.temperature < 96.0) {
      warnings.add('Hypothermia detected');
    }

    return ValidationResult(
      isValid: warnings.isEmpty,
      warnings: warnings,
    );
  }
}

class VitalSigns {
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final int heartRate;
  final double temperature;
  final int respiratoryRate;

  const VitalSigns({
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.heartRate,
    required this.temperature,
    required this.respiratoryRate,
  });
}

class ValidationResult {
  final bool isValid;
  final List<String> warnings;

  const ValidationResult({
    required this.isValid,
    required this.warnings,
  });
}

// ============================================================================
// E-COMMERCE DOMAIN PATTERNS
// ============================================================================

/// E-commerce Domain Patterns
class ECommercePatterns {
  /// ✅ PATTERN: Shopping Cart State Management
  static void demonstrateCartManagement() {
    var cart = ShoppingCart.empty('user_123');

    cart = cart.addItem(CartItem(
      productId: 'prod_456',
      name: 'Premium Widget',
      priceInCents: 2999,
      quantity: 2,
    ));

    cart = cart.addItem(CartItem(
      productId: 'prod_789',
      name: 'Basic Widget',
      priceInCents: 1499,
      quantity: 1,
    ));

    print('Cart total: ${cart.totalAmountInCents / 100} USD');
    print('Item count: ${cart.itemCount}');
  }

  /// ✅ PATTERN: Order Processing Pipeline
  static void demonstrateOrderPipeline() {
    final pipeline = OrderProcessingPipeline();

    final orderRequest = OrderRequest(
      customerId: 'cust_123',
      items: [
        const CartItem(
          productId: 'prod_456',
          name: 'Widget',
          priceInCents: 2999,
          quantity: 1,
        ),
      ],
      shippingAddress: 'Test Address',
    );

    pipeline.processOrder(orderRequest);
  }

  /// ✅ PATTERN: Inventory Management with Concurrency
  static void demonstrateInventoryManagement() {
    final inventory = InventoryManager();

    // Reserve inventory for order
    final reservation = inventory.reserveStock('prod_456', 2);

    if (reservation.success) {
      print('✅ Stock reserved: ${reservation.reservationId}');
      // Later, confirm or release the reservation
      inventory.confirmReservation(reservation.reservationId!);
    } else {
      print('❌ Insufficient stock');
    }
  }
}

/// Shopping cart with immutable state
class ShoppingCart {
  final String customerId;
  final Map<String, CartItem> _items;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const ShoppingCart._({
    required this.customerId,
    required Map<String, CartItem> items,
    required this.createdAt,
    required this.lastUpdated,
  }) : _items = items;

  factory ShoppingCart.empty(String customerId) {
    return ShoppingCart._(
      customerId: customerId,
      items: const {},
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  ShoppingCart addItem(CartItem item) {
    final updatedItems = Map<String, CartItem>.from(_items);

    if (updatedItems.containsKey(item.productId)) {
      final existing = updatedItems[item.productId]!;
      updatedItems[item.productId] =
          existing.updateQuantity(existing.quantity + item.quantity);
    } else {
      updatedItems[item.productId] = item;
    }

    return ShoppingCart._(
      customerId: customerId,
      items: updatedItems,
      createdAt: createdAt,
      lastUpdated: DateTime.now(),
    );
  }

  ShoppingCart removeItem(String productId) {
    final updatedItems = Map<String, CartItem>.from(_items);
    updatedItems.remove(productId);

    return ShoppingCart._(
      customerId: customerId,
      items: updatedItems,
      createdAt: createdAt,
      lastUpdated: DateTime.now(),
    );
  }

  List<CartItem> get items => _items.values.toList();
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  int get totalAmountInCents => _items.values
      .fold(0, (sum, item) => sum + (item.priceInCents * item.quantity));
}

class CartItem {
  final String productId;
  final String name;
  final int priceInCents;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.name,
    required this.priceInCents,
    required this.quantity,
  });

  CartItem updateQuantity(int newQuantity) {
    return CartItem(
      productId: productId,
      name: name,
      priceInCents: priceInCents,
      quantity: newQuantity,
    );
  }
}

/// Order processing pipeline
class OrderProcessingPipeline {
  void processOrder(OrderRequest request) {
    print('🛒 Processing order for ${request.customerId}');

    // Step 1: Validate order
    final validation = _validateOrder(request);
    if (!validation.isValid) {
      print('❌ Order validation failed: ${validation.error}');
      return;
    }

    // Step 2: Reserve inventory
    final inventory = _reserveInventory(request.items);
    if (!inventory.success) {
      print('❌ Inventory reservation failed');
      return;
    }

    // Step 3: Calculate pricing
    final pricing = _calculatePricing(request.items);
    print('💰 Order total: \$${pricing.totalInCents / 100}');

    // Step 4: Create order
    final order = _createOrder(request, pricing);
    print('✅ Order created: ${order.id}');
  }

  OrderValidation _validateOrder(OrderRequest request) {
    if (request.items.isEmpty) {
      return const OrderValidation(false, 'Order must contain items');
    }
    if (request.shippingAddress.isEmpty) {
      return const OrderValidation(false, 'Shipping address required');
    }
    return const OrderValidation(true, null);
  }

  InventoryReservation _reserveInventory(List<CartItem> items) {
    // Simulate inventory check
    return const InventoryReservation(true, 'res_123');
  }

  OrderPricing _calculatePricing(List<CartItem> items) {
    final subtotal =
        items.fold(0, (sum, item) => sum + (item.priceInCents * item.quantity));
    final tax = (subtotal * 0.08875).round(); // 8.875% tax
    final shipping = 599; // $5.99 shipping

    return OrderPricing(
      subtotalInCents: subtotal,
      taxInCents: tax,
      shippingInCents: shipping,
      totalInCents: subtotal + tax + shipping,
    );
  }

  Order _createOrder(OrderRequest request, OrderPricing pricing) {
    return Order(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      customerId: request.customerId,
      items: request.items,
      totalInCents: pricing.totalInCents,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
    );
  }
}

class OrderRequest {
  final String customerId;
  final List<CartItem> items;
  final String shippingAddress;

  const OrderRequest({
    required this.customerId,
    required this.items,
    required this.shippingAddress,
  });
}

class OrderValidation {
  final bool isValid;
  final String? error;

  const OrderValidation(this.isValid, this.error);
}

class InventoryReservation {
  final bool success;
  final String? reservationId;

  const InventoryReservation(this.success, this.reservationId);
}

class OrderPricing {
  final int subtotalInCents;
  final int taxInCents;
  final int shippingInCents;
  final int totalInCents;

  const OrderPricing({
    required this.subtotalInCents,
    required this.taxInCents,
    required this.shippingInCents,
    required this.totalInCents,
  });
}

class Order {
  final String id;
  final String customerId;
  final List<CartItem> items;
  final int totalInCents;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalInCents,
    required this.status,
    required this.createdAt,
  });
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled
}

/// Inventory management with concurrency control
class InventoryManager {
  final Map<String, int> _stock = {
    'prod_456': 100,
    'prod_789': 50,
  };

  final Map<String, StockReservation> _reservations = {};

  StockReservationResult reserveStock(String productId, int quantity) {
    final available = _stock[productId] ?? 0;
    final reserved = _reservations.values
        .where((r) => r.productId == productId && !r.isExpired)
        .fold(0, (sum, r) => sum + r.quantity);

    if (available - reserved >= quantity) {
      final reservation = StockReservation(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        quantity: quantity,
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      );
      _reservations[reservation.id] = reservation;

      return StockReservationResult(true, reservation.id);
    }

    return const StockReservationResult(false, null);
  }

  void confirmReservation(String reservationId) {
    final reservation = _reservations[reservationId];
    if (reservation != null && !reservation.isExpired) {
      _stock[reservation.productId] =
          (_stock[reservation.productId] ?? 0) - reservation.quantity;
      _reservations.remove(reservationId);
      print('✅ Reservation confirmed: $reservationId');
    }
  }

  void releaseReservation(String reservationId) {
    _reservations.remove(reservationId);
    print('🔄 Reservation released: $reservationId');
  }
}

class StockReservation {
  final String id;
  final String productId;
  final int quantity;
  final DateTime expiresAt;

  const StockReservation({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class StockReservationResult {
  final bool success;
  final String? reservationId;

  const StockReservationResult(this.success, this.reservationId);
}

// ============================================================================
// MAIN DEMO
// ============================================================================

void main() {
  print('🏭 Domain-Specific Coding Patterns Demo');
  print('=' * 60);

  // Fintech patterns
  print('\n💰 FINTECH PATTERNS:');
  print('-' * 30);
  FinTechPatterns.demonstrateMoneyPattern();
  print('');
  FinTechPatterns.demonstrateTransactionStateMachine();
  print('');
  FinTechPatterns.demonstrateAuditTrail();

  // Healthcare patterns
  print('\n🏥 HEALTHCARE PATTERNS:');
  print('-' * 30);
  HealthcarePatterns.demonstratePatientDataSegregation();
  print('');
  HealthcarePatterns.demonstrateHIPAAAccess();
  print('');
  HealthcarePatterns.demonstrateMedicalValidation();

  // E-commerce patterns
  print('\n🛒 E-COMMERCE PATTERNS:');
  print('-' * 30);
  ECommercePatterns.demonstrateCartManagement();
  print('');
  ECommercePatterns.demonstrateOrderPipeline();
  print('');
  ECommercePatterns.demonstrateInventoryManagement();

  print('\n🎯 All domain patterns demonstrated successfully!');
}
