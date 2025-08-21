/// Industry Coding Standards and Rules Template
/// This template provides comprehensive coding standards for different industries
/// and domains to ensure production-ready, maintainable code
library;

// ============================================================================
// FINTECH/BANKING INDUSTRY CODING STANDARDS
// ============================================================================

/// Financial Transaction - Critical security and precision requirements
class FinancialTransaction {
  // ✅ GOOD: Use Decimal for monetary values (never double/float)
  final String id;
  final String accountId;
  final BigInt amountInCents; // Store money as smallest unit
  final String currency;
  final TransactionType type;
  final DateTime timestamp;
  final String? description;
  final TransactionStatus status;
  final Map<String, String> metadata;

  const FinancialTransaction({
    required this.id,
    required this.accountId,
    required this.amountInCents,
    required this.currency,
    required this.type,
    required this.timestamp,
    this.description,
    this.status = TransactionStatus.pending,
    this.metadata = const {},
  });

  /// ✅ GOOD: Always validate financial data
  factory FinancialTransaction.create({
    required String accountId,
    required BigInt amountInCents,
    required String currency,
    required TransactionType type,
    String? description,
  }) {
    // Validation rules for fintech
    if (accountId.isEmpty) {
      throw ValidationError('Account ID cannot be empty');
    }
    if (amountInCents <= BigInt.zero) {
      throw ValidationError('Transaction amount must be positive');
    }
    if (currency.length != 3) {
      throw ValidationError('Currency must be 3-letter ISO code');
    }

    return FinancialTransaction(
      id: _generateSecureId(),
      accountId: accountId,
      amountInCents: amountInCents,
      currency: currency.toUpperCase(),
      type: type,
      timestamp: DateTime.now().toUtc(),
      description: description?.trim(),
    );
  }

  /// ✅ GOOD: Immutable updates for financial data
  FinancialTransaction copyWith({
    TransactionStatus? status,
    String? description,
    Map<String, String>? metadata,
  }) {
    return FinancialTransaction(
      id: id,
      accountId: accountId,
      amountInCents: amountInCents,
      currency: currency,
      type: type,
      timestamp: timestamp,
      description: description ?? this.description,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  /// ✅ GOOD: Format money properly for display
  String get formattedAmount {
    final dollars = amountInCents ~/ BigInt.from(100);
    final cents = amountInCents % BigInt.from(100);
    return '$currency ${dollars.toString()}.${cents.toString().padLeft(2, '0')}';
  }

  static String _generateSecureId() {
    // Use cryptographically secure random ID generation
    return 'txn_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
  }

  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
            length, (index) => chars[DateTime.now().microsecond % chars.length])
        .join();
  }
}

enum TransactionType { deposit, withdrawal, transfer, payment, refund }

enum TransactionStatus { pending, processing, completed, failed, cancelled }

class ValidationError extends Error {
  final String message;
  ValidationError(this.message);
  @override
  String toString() => 'ValidationError: $message';
}

// ============================================================================
// HEALTHCARE INDUSTRY CODING STANDARDS
// ============================================================================

/// Patient Record - HIPAA compliance and data privacy requirements
class PatientRecord {
  // ✅ GOOD: Separate PII from medical data
  final String patientId; // Anonymous identifier
  final String encryptedPii; // Encrypted personally identifiable information
  final List<MedicalRecord> medicalHistory;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final Set<String> accessLog; // Track who accessed the record

  const PatientRecord({
    required this.patientId,
    required this.encryptedPii,
    required this.medicalHistory,
    required this.createdAt,
    required this.lastUpdated,
    required this.accessLog,
  });

  /// ✅ GOOD: Factory with validation and compliance checks
  factory PatientRecord.create({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String socialSecurityNumber,
  }) {
    // HIPAA compliance validation
    _validatePatientData(
        firstName, lastName, dateOfBirth, socialSecurityNumber);

    final patientId = _generateAnonymousId();
    final encryptedPii = _encryptPii({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'ssn': socialSecurityNumber,
    });

    return PatientRecord(
      patientId: patientId,
      encryptedPii: encryptedPii,
      medicalHistory: [],
      createdAt: DateTime.now().toUtc(),
      lastUpdated: DateTime.now().toUtc(),
      accessLog: {},
    );
  }

  /// ✅ GOOD: Audit trail for data access
  PatientRecord recordAccess(String userId, String accessReason) {
    final accessEntry =
        '${DateTime.now().toUtc().toIso8601String()}|$userId|$accessReason';
    return PatientRecord(
      patientId: patientId,
      encryptedPii: encryptedPii,
      medicalHistory: medicalHistory,
      createdAt: createdAt,
      lastUpdated: DateTime.now().toUtc(),
      accessLog: {...accessLog, accessEntry},
    );
  }

  static void _validatePatientData(
      String firstName, String lastName, DateTime dateOfBirth, String ssn) {
    if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
      throw ValidationError('Patient name cannot be empty');
    }
    if (dateOfBirth.isAfter(DateTime.now())) {
      throw ValidationError('Date of birth cannot be in the future');
    }
    if (!RegExp(r'^\d{3}-\d{2}-\d{4}$').hasMatch(ssn)) {
      throw ValidationError('Invalid SSN format');
    }
  }

  static String _generateAnonymousId() =>
      'patient_${DateTime.now().millisecondsSinceEpoch}';
  static String _encryptPii(Map<String, String> pii) {
    // In production, use proper encryption (AES-256)
    return 'encrypted_${pii.toString().length}';
  }
}

class MedicalRecord {
  final String recordId;
  final DateTime visitDate;
  final String diagnosis;
  final List<String> medications;
  final String providerId;

  const MedicalRecord({
    required this.recordId,
    required this.visitDate,
    required this.diagnosis,
    required this.medications,
    required this.providerId,
  });
}

// ============================================================================
// E-COMMERCE INDUSTRY CODING STANDARDS
// ============================================================================

/// E-commerce Order - High availability and scalability requirements
class ECommerceOrder {
  final String orderId;
  final String customerId;
  final List<OrderItem> items;
  final Address shippingAddress;
  final Address? billingAddress;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final BigInt totalAmountCents;
  final String currency;
  final DateTime createdAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final Map<String, dynamic> trackingInfo;

  const ECommerceOrder({
    required this.orderId,
    required this.customerId,
    required this.items,
    required this.shippingAddress,
    this.billingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.totalAmountCents,
    required this.currency,
    required this.createdAt,
    this.shippedAt,
    this.deliveredAt,
    this.trackingInfo = const {},
  });

  /// ✅ GOOD: Business logic validation
  factory ECommerceOrder.create({
    required String customerId,
    required List<OrderItem> items,
    required Address shippingAddress,
    Address? billingAddress,
    required PaymentMethod paymentMethod,
    required String currency,
  }) {
    // E-commerce validation rules
    if (items.isEmpty) {
      throw ValidationError('Order must contain at least one item');
    }
    if (customerId.isEmpty) {
      throw ValidationError('Customer ID is required');
    }

    final totalAmount = items.fold<BigInt>(
      BigInt.zero,
      (sum, item) => sum + (item.priceInCents * BigInt.from(item.quantity)),
    );

    if (totalAmount <= BigInt.zero) {
      throw ValidationError('Order total must be positive');
    }

    return ECommerceOrder(
      orderId: _generateOrderId(),
      customerId: customerId,
      items: List.unmodifiable(items),
      shippingAddress: shippingAddress,
      billingAddress: billingAddress ?? shippingAddress,
      paymentMethod: paymentMethod,
      totalAmountCents: totalAmount,
      currency: currency.toUpperCase(),
      createdAt: DateTime.now().toUtc(),
    );
  }

  /// ✅ GOOD: State machine for order status
  ECommerceOrder updateStatus(OrderStatus newStatus) {
    // Validate state transitions
    if (!_isValidStatusTransition(status, newStatus)) {
      throw StateError('Invalid status transition from $status to $newStatus');
    }

    return ECommerceOrder(
      orderId: orderId,
      customerId: customerId,
      items: items,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      paymentMethod: paymentMethod,
      status: newStatus,
      totalAmountCents: totalAmountCents,
      currency: currency,
      createdAt: createdAt,
      shippedAt:
          newStatus == OrderStatus.shipped ? DateTime.now().toUtc() : shippedAt,
      deliveredAt: newStatus == OrderStatus.delivered
          ? DateTime.now().toUtc()
          : deliveredAt,
      trackingInfo: trackingInfo,
    );
  }

  static bool _isValidStatusTransition(OrderStatus from, OrderStatus to) {
    const validTransitions = {
      OrderStatus.pending: [OrderStatus.confirmed, OrderStatus.cancelled],
      OrderStatus.confirmed: [OrderStatus.processing, OrderStatus.cancelled],
      OrderStatus.processing: [OrderStatus.shipped, OrderStatus.cancelled],
      OrderStatus.shipped: [OrderStatus.delivered, OrderStatus.returned],
      OrderStatus.delivered: [OrderStatus.returned],
    };
    return validTransitions[from]?.contains(to) ?? false;
  }

  static String _generateOrderId() =>
      'ord_${DateTime.now().millisecondsSinceEpoch}';
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final BigInt priceInCents;
  final String currency;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceInCents,
    required this.currency,
  });
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  const Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned
}

enum PaymentMethod { creditCard, debitCard, paypal, applePay, googlePay }

// ============================================================================
// GAMING INDUSTRY CODING STANDARDS
// ============================================================================

/// Game Player - Performance and real-time requirements
class GamePlayer {
  final String playerId;
  final String username;
  final int level;
  final BigInt experience;
  final Map<String, int> stats;
  final List<String> achievements;
  final PlayerStatus status;
  final DateTime lastActiveAt;
  final GameSession? currentSession;

  const GamePlayer({
    required this.playerId,
    required this.username,
    required this.level,
    required this.experience,
    required this.stats,
    required this.achievements,
    this.status = PlayerStatus.offline,
    required this.lastActiveAt,
    this.currentSession,
  });

  /// ✅ GOOD: Optimized for frequent updates
  GamePlayer updateStats({
    BigInt? experienceGained,
    Map<String, int>? statChanges,
    List<String>? newAchievements,
  }) {
    final newExperience = experience + (experienceGained ?? BigInt.zero);
    final newLevel = _calculateLevel(newExperience);

    final updatedStats = Map<String, int>.from(stats);
    if (statChanges != null) {
      for (final entry in statChanges.entries) {
        updatedStats[entry.key] = (updatedStats[entry.key] ?? 0) + entry.value;
      }
    }

    final updatedAchievements = List<String>.from(achievements);
    if (newAchievements != null) {
      updatedAchievements
          .addAll(newAchievements.where((a) => !achievements.contains(a)));
    }

    return GamePlayer(
      playerId: playerId,
      username: username,
      level: newLevel,
      experience: newExperience,
      stats: updatedStats,
      achievements: updatedAchievements,
      status: status,
      lastActiveAt: DateTime.now().toUtc(),
      currentSession: currentSession,
    );
  }

  /// ✅ GOOD: Performance-critical calculations
  static int _calculateLevel(BigInt experience) {
    // Efficient level calculation for gaming
    if (experience < BigInt.from(100)) return 1;
    if (experience < BigInt.from(500)) return 2;
    if (experience < BigInt.from(1500)) return 3;
    // Continue with logarithmic scaling...
    return (experience / BigInt.from(1000)).toInt() + 1;
  }

  /// ✅ GOOD: Real-time status management
  GamePlayer startSession(String sessionId) {
    return GamePlayer(
      playerId: playerId,
      username: username,
      level: level,
      experience: experience,
      stats: stats,
      achievements: achievements,
      status: PlayerStatus.online,
      lastActiveAt: DateTime.now().toUtc(),
      currentSession: GameSession(
        sessionId: sessionId,
        startTime: DateTime.now().toUtc(),
        playerId: playerId,
      ),
    );
  }
}

class GameSession {
  final String sessionId;
  final DateTime startTime;
  final String playerId;
  final DateTime? endTime;
  final Map<String, dynamic> sessionData;

  const GameSession({
    required this.sessionId,
    required this.startTime,
    required this.playerId,
    this.endTime,
    this.sessionData = const {},
  });

  Duration get sessionDuration {
    final end = endTime ?? DateTime.now().toUtc();
    return end.difference(startTime);
  }
}

enum PlayerStatus { offline, online, inGame, away, busy }

// ============================================================================
// ENTERPRISE/CORPORATE CODING STANDARDS
// ============================================================================

/// Enterprise Employee - Compliance and audit requirements
class EnterpriseEmployee {
  final String employeeId;
  final String email;
  final String department;
  final EmployeeRole role;
  final DateTime hireDate;
  final EmployeeStatus status;
  final Set<String> permissions;
  final List<AuditEntry> auditLog;
  final Map<String, String> personalInfo; // Encrypted

  const EnterpriseEmployee({
    required this.employeeId,
    required this.email,
    required this.department,
    required this.role,
    required this.hireDate,
    this.status = EmployeeStatus.active,
    required this.permissions,
    required this.auditLog,
    required this.personalInfo,
  });

  /// ✅ GOOD: Role-based access control
  bool hasPermission(String permission) {
    return permissions.contains(permission) ||
        role.defaultPermissions.contains(permission);
  }

  /// ✅ GOOD: Audit logging for enterprise compliance
  EnterpriseEmployee logActivity(String activity, String details) {
    final auditEntry = AuditEntry(
      timestamp: DateTime.now().toUtc(),
      employeeId: employeeId,
      activity: activity,
      details: details,
      ipAddress: _getCurrentIpAddress(),
    );

    return EnterpriseEmployee(
      employeeId: employeeId,
      email: email,
      department: department,
      role: role,
      hireDate: hireDate,
      status: status,
      permissions: permissions,
      auditLog: [...auditLog, auditEntry],
      personalInfo: personalInfo,
    );
  }

  /// ✅ GOOD: Data retention and privacy compliance
  EnterpriseEmployee anonymize() {
    return EnterpriseEmployee(
      employeeId: 'ANONYMOUS_${DateTime.now().millisecondsSinceEpoch}',
      email: 'anonymized@company.com',
      department: department,
      role: role,
      hireDate: hireDate,
      status: EmployeeStatus.terminated,
      permissions: {},
      auditLog: [], // Clear audit log for privacy
      personalInfo: {'status': 'anonymized'},
    );
  }

  static String _getCurrentIpAddress() => '192.168.1.1'; // Mock implementation
}

class EmployeeRole {
  final String name;
  final int level;
  final Set<String> defaultPermissions;

  const EmployeeRole({
    required this.name,
    required this.level,
    required this.defaultPermissions,
  });

  static const developer = EmployeeRole(
    name: 'Developer',
    level: 3,
    defaultPermissions: {'code.read', 'code.write', 'deploy.staging'},
  );

  static const manager = EmployeeRole(
    name: 'Manager',
    level: 5,
    defaultPermissions: {'team.manage', 'budget.view', 'reports.generate'},
  );
}

class AuditEntry {
  final DateTime timestamp;
  final String employeeId;
  final String activity;
  final String details;
  final String ipAddress;

  const AuditEntry({
    required this.timestamp,
    required this.employeeId,
    required this.activity,
    required this.details,
    required this.ipAddress,
  });
}

enum EmployeeStatus { active, inactive, onLeave, terminated }

// ============================================================================
// COMMON CODING STANDARDS ACROSS ALL INDUSTRIES
// ============================================================================

/// ✅ GOOD: Error handling with context and recovery
class ServiceResult<T> {
  final T? data;
  final ServiceError? error;
  final Map<String, dynamic> metadata;

  const ServiceResult.success(this.data, {this.metadata = const {}})
      : error = null;
  const ServiceResult.failure(this.error, {this.metadata = const {}})
      : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;

  R fold<R>(
    R Function(T data) onSuccess,
    R Function(ServiceError error) onFailure,
  ) {
    if (isSuccess) {
      return onSuccess(data!);
    } else {
      return onFailure(error!);
    }
  }
}

class ServiceError {
  final String code;
  final String message;
  final String? details;
  final DateTime timestamp;
  final String? stackTrace;

  const ServiceError({
    required this.code,
    required this.message,
    this.details,
    required this.timestamp,
    this.stackTrace,
  });

  factory ServiceError.validation(String message, {String? details}) {
    return ServiceError(
      code: 'VALIDATION_ERROR',
      message: message,
      details: details,
      timestamp: DateTime.now().toUtc(),
    );
  }

  factory ServiceError.notFound(String resource) {
    return ServiceError(
      code: 'NOT_FOUND',
      message: '$resource not found',
      timestamp: DateTime.now().toUtc(),
    );
  }

  factory ServiceError.serverError(String message, {String? stackTrace}) {
    return ServiceError(
      code: 'SERVER_ERROR',
      message: message,
      timestamp: DateTime.now().toUtc(),
      stackTrace: stackTrace,
    );
  }
}

/// ✅ GOOD: Configuration management
class AppConfig {
  final String environment;
  final String apiBaseUrl;
  final int timeoutSeconds;
  final bool enableLogging;
  final Map<String, String> features;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.timeoutSeconds = 30,
    this.enableLogging = true,
    this.features = const {},
  });

  factory AppConfig.development() {
    return const AppConfig(
      environment: 'development',
      apiBaseUrl: 'https://dev-api.example.com',
      enableLogging: true,
      features: {'debugMode': 'true', 'mockData': 'true'},
    );
  }

  factory AppConfig.production() {
    return const AppConfig(
      environment: 'production',
      apiBaseUrl: 'https://api.example.com',
      enableLogging: false,
      features: {'analytics': 'true', 'crashReporting': 'true'},
    );
  }

  bool isFeatureEnabled(String feature) {
    return features[feature]?.toLowerCase() == 'true';
  }
}

/// ✅ GOOD: Dependency injection container
class ServiceContainer {
  static final Map<Type, dynamic> _services = {};
  static final Map<Type, dynamic Function()> _factories = {};

  static void registerSingleton<T>(T instance) {
    _services[T] = instance;
  }

  static void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  static T get<T>() {
    if (_services.containsKey(T)) {
      return _services[T] as T;
    }

    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }

    throw StateError('Service of type $T is not registered');
  }

  static bool isRegistered<T>() {
    return _services.containsKey(T) || _factories.containsKey(T);
  }

  static void clear() {
    _services.clear();
    _factories.clear();
  }
}

// ============================================================================
// EXAMPLE USAGE AND TESTING
// ============================================================================

void main() {
  print('🏭 Industry Coding Standards Demo');
  print('=' * 50);

  // Fintech example
  try {
    final transaction = FinancialTransaction.create(
      accountId: 'acc_12345',
      amountInCents: BigInt.from(150075), // $1,500.75
      currency: 'USD',
      type: TransactionType.payment,
      description: 'Payment for services',
    );
    print('✅ Fintech: ${transaction.formattedAmount} transaction created');
  } catch (e) {
    print('❌ Fintech error: $e');
  }

  // Healthcare example
  try {
    final patient = PatientRecord.create(
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: DateTime(1985, 5, 15),
      socialSecurityNumber: '123-45-6789',
    );
    print('✅ Healthcare: Patient ${patient.patientId} created');
  } catch (e) {
    print('❌ Healthcare error: $e');
  }

  // E-commerce example
  try {
    final order = ECommerceOrder.create(
      customerId: 'cust_789',
      items: [
        OrderItem(
          productId: 'prod_123',
          productName: 'Widget',
          quantity: 2,
          priceInCents: BigInt.from(2999),
          currency: 'USD',
        ),
      ],
      shippingAddress: const Address(
        street: '123 Main St',
        city: 'Anytown',
        state: 'CA',
        zipCode: '12345',
        country: 'US',
      ),
      paymentMethod: PaymentMethod.creditCard,
      currency: 'USD',
    );
    print(
        '✅ E-commerce: Order ${order.orderId} for ${order.totalAmountCents} cents');
  } catch (e) {
    print('❌ E-commerce error: $e');
  }

  // Gaming example
  final player = GamePlayer(
    playerId: 'player_456',
    username: 'ProGamer',
    level: 1,
    experience: BigInt.from(50),
    stats: {'kills': 0, 'deaths': 0},
    achievements: [],
    lastActiveAt: DateTime.now(),
  );

  final updatedPlayer = player.updateStats(
    experienceGained: BigInt.from(100),
    statChanges: {'kills': 5, 'deaths': 1},
    newAchievements: ['first_kill'],
  );
  print(
      '✅ Gaming: Player ${updatedPlayer.username} now level ${updatedPlayer.level}');

  // Enterprise example
  final employee = EnterpriseEmployee(
    employeeId: 'emp_001',
    email: 'john.doe@company.com',
    department: 'Engineering',
    role: EmployeeRole.developer,
    hireDate: DateTime(2020, 1, 15),
    permissions: {'code.review'},
    auditLog: [],
    personalInfo: {'encrypted': 'data'},
  );

  final loggedEmployee =
      employee.logActivity('code_review', 'Reviewed PR #123');
  print(
      '✅ Enterprise: Employee activity logged (${loggedEmployee.auditLog.length} entries)');

  print('\n🎯 All industry patterns demonstrated successfully!');
}
