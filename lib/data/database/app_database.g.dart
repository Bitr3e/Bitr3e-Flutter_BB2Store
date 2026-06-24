// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyIncomeRecordsTable extends DailyIncomeRecords
    with TableInfo<$DailyIncomeRecordsTable, DailyIncomeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyIncomeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _p1Meta = const VerificationMeta('p1');
  @override
  late final GeneratedColumn<int> p1 = GeneratedColumn<int>(
    'p1',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p5Meta = const VerificationMeta('p5');
  @override
  late final GeneratedColumn<int> p5 = GeneratedColumn<int>(
    'p5',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p10Meta = const VerificationMeta('p10');
  @override
  late final GeneratedColumn<int> p10 = GeneratedColumn<int>(
    'p10',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p20Meta = const VerificationMeta('p20');
  @override
  late final GeneratedColumn<int> p20 = GeneratedColumn<int>(
    'p20',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p50Meta = const VerificationMeta('p50');
  @override
  late final GeneratedColumn<int> p50 = GeneratedColumn<int>(
    'p50',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p100Meta = const VerificationMeta('p100');
  @override
  late final GeneratedColumn<int> p100 = GeneratedColumn<int>(
    'p100',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p200Meta = const VerificationMeta('p200');
  @override
  late final GeneratedColumn<int> p200 = GeneratedColumn<int>(
    'p200',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p500Meta = const VerificationMeta('p500');
  @override
  late final GeneratedColumn<int> p500 = GeneratedColumn<int>(
    'p500',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _p1000Meta = const VerificationMeta('p1000');
  @override
  late final GeneratedColumn<int> p1000 = GeneratedColumn<int>(
    'p1000',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    p1,
    p5,
    p10,
    p20,
    p50,
    p100,
    p200,
    p500,
    p1000,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_income_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyIncomeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('p1')) {
      context.handle(_p1Meta, p1.isAcceptableOrUnknown(data['p1']!, _p1Meta));
    }
    if (data.containsKey('p5')) {
      context.handle(_p5Meta, p5.isAcceptableOrUnknown(data['p5']!, _p5Meta));
    }
    if (data.containsKey('p10')) {
      context.handle(
        _p10Meta,
        p10.isAcceptableOrUnknown(data['p10']!, _p10Meta),
      );
    }
    if (data.containsKey('p20')) {
      context.handle(
        _p20Meta,
        p20.isAcceptableOrUnknown(data['p20']!, _p20Meta),
      );
    }
    if (data.containsKey('p50')) {
      context.handle(
        _p50Meta,
        p50.isAcceptableOrUnknown(data['p50']!, _p50Meta),
      );
    }
    if (data.containsKey('p100')) {
      context.handle(
        _p100Meta,
        p100.isAcceptableOrUnknown(data['p100']!, _p100Meta),
      );
    }
    if (data.containsKey('p200')) {
      context.handle(
        _p200Meta,
        p200.isAcceptableOrUnknown(data['p200']!, _p200Meta),
      );
    }
    if (data.containsKey('p500')) {
      context.handle(
        _p500Meta,
        p500.isAcceptableOrUnknown(data['p500']!, _p500Meta),
      );
    }
    if (data.containsKey('p1000')) {
      context.handle(
        _p1000Meta,
        p1000.isAcceptableOrUnknown(data['p1000']!, _p1000Meta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyIncomeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyIncomeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      p1: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p1'],
      )!,
      p5: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p5'],
      )!,
      p10: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p10'],
      )!,
      p20: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p20'],
      )!,
      p50: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p50'],
      )!,
      p100: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p100'],
      )!,
      p200: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p200'],
      )!,
      p500: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p500'],
      )!,
      p1000: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p1000'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyIncomeRecordsTable createAlias(String alias) {
    return $DailyIncomeRecordsTable(attachedDatabase, alias);
  }
}

class DailyIncomeRecord extends DataClass
    implements Insertable<DailyIncomeRecord> {
  final int id;
  final DateTime date;
  final int p1;
  final int p5;
  final int p10;
  final int p20;
  final int p50;
  final int p100;
  final int p200;
  final int p500;
  final int p1000;
  final DateTime createdAt;
  const DailyIncomeRecord({
    required this.id,
    required this.date,
    required this.p1,
    required this.p5,
    required this.p10,
    required this.p20,
    required this.p50,
    required this.p100,
    required this.p200,
    required this.p500,
    required this.p1000,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['p1'] = Variable<int>(p1);
    map['p5'] = Variable<int>(p5);
    map['p10'] = Variable<int>(p10);
    map['p20'] = Variable<int>(p20);
    map['p50'] = Variable<int>(p50);
    map['p100'] = Variable<int>(p100);
    map['p200'] = Variable<int>(p200);
    map['p500'] = Variable<int>(p500);
    map['p1000'] = Variable<int>(p1000);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyIncomeRecordsCompanion toCompanion(bool nullToAbsent) {
    return DailyIncomeRecordsCompanion(
      id: Value(id),
      date: Value(date),
      p1: Value(p1),
      p5: Value(p5),
      p10: Value(p10),
      p20: Value(p20),
      p50: Value(p50),
      p100: Value(p100),
      p200: Value(p200),
      p500: Value(p500),
      p1000: Value(p1000),
      createdAt: Value(createdAt),
    );
  }

  factory DailyIncomeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyIncomeRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      p1: serializer.fromJson<int>(json['p1']),
      p5: serializer.fromJson<int>(json['p5']),
      p10: serializer.fromJson<int>(json['p10']),
      p20: serializer.fromJson<int>(json['p20']),
      p50: serializer.fromJson<int>(json['p50']),
      p100: serializer.fromJson<int>(json['p100']),
      p200: serializer.fromJson<int>(json['p200']),
      p500: serializer.fromJson<int>(json['p500']),
      p1000: serializer.fromJson<int>(json['p1000']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'p1': serializer.toJson<int>(p1),
      'p5': serializer.toJson<int>(p5),
      'p10': serializer.toJson<int>(p10),
      'p20': serializer.toJson<int>(p20),
      'p50': serializer.toJson<int>(p50),
      'p100': serializer.toJson<int>(p100),
      'p200': serializer.toJson<int>(p200),
      'p500': serializer.toJson<int>(p500),
      'p1000': serializer.toJson<int>(p1000),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyIncomeRecord copyWith({
    int? id,
    DateTime? date,
    int? p1,
    int? p5,
    int? p10,
    int? p20,
    int? p50,
    int? p100,
    int? p200,
    int? p500,
    int? p1000,
    DateTime? createdAt,
  }) => DailyIncomeRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    p1: p1 ?? this.p1,
    p5: p5 ?? this.p5,
    p10: p10 ?? this.p10,
    p20: p20 ?? this.p20,
    p50: p50 ?? this.p50,
    p100: p100 ?? this.p100,
    p200: p200 ?? this.p200,
    p500: p500 ?? this.p500,
    p1000: p1000 ?? this.p1000,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyIncomeRecord copyWithCompanion(DailyIncomeRecordsCompanion data) {
    return DailyIncomeRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      p1: data.p1.present ? data.p1.value : this.p1,
      p5: data.p5.present ? data.p5.value : this.p5,
      p10: data.p10.present ? data.p10.value : this.p10,
      p20: data.p20.present ? data.p20.value : this.p20,
      p50: data.p50.present ? data.p50.value : this.p50,
      p100: data.p100.present ? data.p100.value : this.p100,
      p200: data.p200.present ? data.p200.value : this.p200,
      p500: data.p500.present ? data.p500.value : this.p500,
      p1000: data.p1000.present ? data.p1000.value : this.p1000,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyIncomeRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('p1: $p1, ')
          ..write('p5: $p5, ')
          ..write('p10: $p10, ')
          ..write('p20: $p20, ')
          ..write('p50: $p50, ')
          ..write('p100: $p100, ')
          ..write('p200: $p200, ')
          ..write('p500: $p500, ')
          ..write('p1000: $p1000, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    p1,
    p5,
    p10,
    p20,
    p50,
    p100,
    p200,
    p500,
    p1000,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyIncomeRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.p1 == this.p1 &&
          other.p5 == this.p5 &&
          other.p10 == this.p10 &&
          other.p20 == this.p20 &&
          other.p50 == this.p50 &&
          other.p100 == this.p100 &&
          other.p200 == this.p200 &&
          other.p500 == this.p500 &&
          other.p1000 == this.p1000 &&
          other.createdAt == this.createdAt);
}

class DailyIncomeRecordsCompanion extends UpdateCompanion<DailyIncomeRecord> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> p1;
  final Value<int> p5;
  final Value<int> p10;
  final Value<int> p20;
  final Value<int> p50;
  final Value<int> p100;
  final Value<int> p200;
  final Value<int> p500;
  final Value<int> p1000;
  final Value<DateTime> createdAt;
  const DailyIncomeRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.p1 = const Value.absent(),
    this.p5 = const Value.absent(),
    this.p10 = const Value.absent(),
    this.p20 = const Value.absent(),
    this.p50 = const Value.absent(),
    this.p100 = const Value.absent(),
    this.p200 = const Value.absent(),
    this.p500 = const Value.absent(),
    this.p1000 = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyIncomeRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.p1 = const Value.absent(),
    this.p5 = const Value.absent(),
    this.p10 = const Value.absent(),
    this.p20 = const Value.absent(),
    this.p50 = const Value.absent(),
    this.p100 = const Value.absent(),
    this.p200 = const Value.absent(),
    this.p500 = const Value.absent(),
    this.p1000 = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyIncomeRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? p1,
    Expression<int>? p5,
    Expression<int>? p10,
    Expression<int>? p20,
    Expression<int>? p50,
    Expression<int>? p100,
    Expression<int>? p200,
    Expression<int>? p500,
    Expression<int>? p1000,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (p1 != null) 'p1': p1,
      if (p5 != null) 'p5': p5,
      if (p10 != null) 'p10': p10,
      if (p20 != null) 'p20': p20,
      if (p50 != null) 'p50': p50,
      if (p100 != null) 'p100': p100,
      if (p200 != null) 'p200': p200,
      if (p500 != null) 'p500': p500,
      if (p1000 != null) 'p1000': p1000,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyIncomeRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? p1,
    Value<int>? p5,
    Value<int>? p10,
    Value<int>? p20,
    Value<int>? p50,
    Value<int>? p100,
    Value<int>? p200,
    Value<int>? p500,
    Value<int>? p1000,
    Value<DateTime>? createdAt,
  }) {
    return DailyIncomeRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      p1: p1 ?? this.p1,
      p5: p5 ?? this.p5,
      p10: p10 ?? this.p10,
      p20: p20 ?? this.p20,
      p50: p50 ?? this.p50,
      p100: p100 ?? this.p100,
      p200: p200 ?? this.p200,
      p500: p500 ?? this.p500,
      p1000: p1000 ?? this.p1000,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (p1.present) {
      map['p1'] = Variable<int>(p1.value);
    }
    if (p5.present) {
      map['p5'] = Variable<int>(p5.value);
    }
    if (p10.present) {
      map['p10'] = Variable<int>(p10.value);
    }
    if (p20.present) {
      map['p20'] = Variable<int>(p20.value);
    }
    if (p50.present) {
      map['p50'] = Variable<int>(p50.value);
    }
    if (p100.present) {
      map['p100'] = Variable<int>(p100.value);
    }
    if (p200.present) {
      map['p200'] = Variable<int>(p200.value);
    }
    if (p500.present) {
      map['p500'] = Variable<int>(p500.value);
    }
    if (p1000.present) {
      map['p1000'] = Variable<int>(p1000.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyIncomeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('p1: $p1, ')
          ..write('p5: $p5, ')
          ..write('p10: $p10, ')
          ..write('p20: $p20, ')
          ..write('p50: $p50, ')
          ..write('p100: $p100, ')
          ..write('p200: $p200, ')
          ..write('p500: $p500, ')
          ..write('p1000: $p1000, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CashOutEntriesTable extends CashOutEntries
    with TableInfo<$CashOutEntriesTable, CashOutEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashOutEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    amount,
    category,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_out_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashOutEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashOutEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashOutEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CashOutEntriesTable createAlias(String alias) {
    return $CashOutEntriesTable(attachedDatabase, alias);
  }
}

class CashOutEntry extends DataClass implements Insertable<CashOutEntry> {
  final int id;
  final DateTime date;
  final int amount;
  final String category;
  final String? description;
  final DateTime createdAt;
  const CashOutEntry({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<int>(amount);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashOutEntriesCompanion toCompanion(bool nullToAbsent) {
    return CashOutEntriesCompanion(
      id: Value(id),
      date: Value(date),
      amount: Value(amount),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory CashOutEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashOutEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<int>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<int>(amount),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashOutEntry copyWith({
    int? id,
    DateTime? date,
    int? amount,
    String? category,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
  }) => CashOutEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  CashOutEntry copyWithCompanion(CashOutEntriesCompanion data) {
    return CashOutEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashOutEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, amount, category, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashOutEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class CashOutEntriesCompanion extends UpdateCompanion<CashOutEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> amount;
  final Value<String> category;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const CashOutEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CashOutEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int amount,
    required String category,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       amount = Value(amount),
       category = Value(category);
  static Insertable<CashOutEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? amount,
    Expression<String>? category,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CashOutEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? amount,
    Value<String>? category,
    Value<String?>? description,
    Value<DateTime>? createdAt,
  }) {
    return CashOutEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashOutEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyIncomeRecordsTable dailyIncomeRecords =
      $DailyIncomeRecordsTable(this);
  late final $CashOutEntriesTable cashOutEntries = $CashOutEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyIncomeRecords,
    cashOutEntries,
  ];
}

typedef $$DailyIncomeRecordsTableCreateCompanionBuilder =
    DailyIncomeRecordsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> p1,
      Value<int> p5,
      Value<int> p10,
      Value<int> p20,
      Value<int> p50,
      Value<int> p100,
      Value<int> p200,
      Value<int> p500,
      Value<int> p1000,
      Value<DateTime> createdAt,
    });
typedef $$DailyIncomeRecordsTableUpdateCompanionBuilder =
    DailyIncomeRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> p1,
      Value<int> p5,
      Value<int> p10,
      Value<int> p20,
      Value<int> p50,
      Value<int> p100,
      Value<int> p200,
      Value<int> p500,
      Value<int> p1000,
      Value<DateTime> createdAt,
    });

class $$DailyIncomeRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyIncomeRecordsTable> {
  $$DailyIncomeRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p1 => $composableBuilder(
    column: $table.p1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p5 => $composableBuilder(
    column: $table.p5,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p10 => $composableBuilder(
    column: $table.p10,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p20 => $composableBuilder(
    column: $table.p20,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p50 => $composableBuilder(
    column: $table.p50,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p100 => $composableBuilder(
    column: $table.p100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p200 => $composableBuilder(
    column: $table.p200,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p500 => $composableBuilder(
    column: $table.p500,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get p1000 => $composableBuilder(
    column: $table.p1000,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyIncomeRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyIncomeRecordsTable> {
  $$DailyIncomeRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p1 => $composableBuilder(
    column: $table.p1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p5 => $composableBuilder(
    column: $table.p5,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p10 => $composableBuilder(
    column: $table.p10,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p20 => $composableBuilder(
    column: $table.p20,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p50 => $composableBuilder(
    column: $table.p50,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p100 => $composableBuilder(
    column: $table.p100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p200 => $composableBuilder(
    column: $table.p200,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p500 => $composableBuilder(
    column: $table.p500,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get p1000 => $composableBuilder(
    column: $table.p1000,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyIncomeRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyIncomeRecordsTable> {
  $$DailyIncomeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get p1 =>
      $composableBuilder(column: $table.p1, builder: (column) => column);

  GeneratedColumn<int> get p5 =>
      $composableBuilder(column: $table.p5, builder: (column) => column);

  GeneratedColumn<int> get p10 =>
      $composableBuilder(column: $table.p10, builder: (column) => column);

  GeneratedColumn<int> get p20 =>
      $composableBuilder(column: $table.p20, builder: (column) => column);

  GeneratedColumn<int> get p50 =>
      $composableBuilder(column: $table.p50, builder: (column) => column);

  GeneratedColumn<int> get p100 =>
      $composableBuilder(column: $table.p100, builder: (column) => column);

  GeneratedColumn<int> get p200 =>
      $composableBuilder(column: $table.p200, builder: (column) => column);

  GeneratedColumn<int> get p500 =>
      $composableBuilder(column: $table.p500, builder: (column) => column);

  GeneratedColumn<int> get p1000 =>
      $composableBuilder(column: $table.p1000, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailyIncomeRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyIncomeRecordsTable,
          DailyIncomeRecord,
          $$DailyIncomeRecordsTableFilterComposer,
          $$DailyIncomeRecordsTableOrderingComposer,
          $$DailyIncomeRecordsTableAnnotationComposer,
          $$DailyIncomeRecordsTableCreateCompanionBuilder,
          $$DailyIncomeRecordsTableUpdateCompanionBuilder,
          (
            DailyIncomeRecord,
            BaseReferences<
              _$AppDatabase,
              $DailyIncomeRecordsTable,
              DailyIncomeRecord
            >,
          ),
          DailyIncomeRecord,
          PrefetchHooks Function()
        > {
  $$DailyIncomeRecordsTableTableManager(
    _$AppDatabase db,
    $DailyIncomeRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyIncomeRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyIncomeRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyIncomeRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> p1 = const Value.absent(),
                Value<int> p5 = const Value.absent(),
                Value<int> p10 = const Value.absent(),
                Value<int> p20 = const Value.absent(),
                Value<int> p50 = const Value.absent(),
                Value<int> p100 = const Value.absent(),
                Value<int> p200 = const Value.absent(),
                Value<int> p500 = const Value.absent(),
                Value<int> p1000 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyIncomeRecordsCompanion(
                id: id,
                date: date,
                p1: p1,
                p5: p5,
                p10: p10,
                p20: p20,
                p50: p50,
                p100: p100,
                p200: p200,
                p500: p500,
                p1000: p1000,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> p1 = const Value.absent(),
                Value<int> p5 = const Value.absent(),
                Value<int> p10 = const Value.absent(),
                Value<int> p20 = const Value.absent(),
                Value<int> p50 = const Value.absent(),
                Value<int> p100 = const Value.absent(),
                Value<int> p200 = const Value.absent(),
                Value<int> p500 = const Value.absent(),
                Value<int> p1000 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyIncomeRecordsCompanion.insert(
                id: id,
                date: date,
                p1: p1,
                p5: p5,
                p10: p10,
                p20: p20,
                p50: p50,
                p100: p100,
                p200: p200,
                p500: p500,
                p1000: p1000,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyIncomeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyIncomeRecordsTable,
      DailyIncomeRecord,
      $$DailyIncomeRecordsTableFilterComposer,
      $$DailyIncomeRecordsTableOrderingComposer,
      $$DailyIncomeRecordsTableAnnotationComposer,
      $$DailyIncomeRecordsTableCreateCompanionBuilder,
      $$DailyIncomeRecordsTableUpdateCompanionBuilder,
      (
        DailyIncomeRecord,
        BaseReferences<
          _$AppDatabase,
          $DailyIncomeRecordsTable,
          DailyIncomeRecord
        >,
      ),
      DailyIncomeRecord,
      PrefetchHooks Function()
    >;
typedef $$CashOutEntriesTableCreateCompanionBuilder =
    CashOutEntriesCompanion Function({
      Value<int> id,
      required DateTime date,
      required int amount,
      required String category,
      Value<String?> description,
      Value<DateTime> createdAt,
    });
typedef $$CashOutEntriesTableUpdateCompanionBuilder =
    CashOutEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> amount,
      Value<String> category,
      Value<String?> description,
      Value<DateTime> createdAt,
    });

class $$CashOutEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CashOutEntriesTable> {
  $$CashOutEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashOutEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CashOutEntriesTable> {
  $$CashOutEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashOutEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashOutEntriesTable> {
  $$CashOutEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CashOutEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashOutEntriesTable,
          CashOutEntry,
          $$CashOutEntriesTableFilterComposer,
          $$CashOutEntriesTableOrderingComposer,
          $$CashOutEntriesTableAnnotationComposer,
          $$CashOutEntriesTableCreateCompanionBuilder,
          $$CashOutEntriesTableUpdateCompanionBuilder,
          (
            CashOutEntry,
            BaseReferences<_$AppDatabase, $CashOutEntriesTable, CashOutEntry>,
          ),
          CashOutEntry,
          PrefetchHooks Function()
        > {
  $$CashOutEntriesTableTableManager(
    _$AppDatabase db,
    $CashOutEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashOutEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashOutEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashOutEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CashOutEntriesCompanion(
                id: id,
                date: date,
                amount: amount,
                category: category,
                description: description,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int amount,
                required String category,
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CashOutEntriesCompanion.insert(
                id: id,
                date: date,
                amount: amount,
                category: category,
                description: description,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashOutEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashOutEntriesTable,
      CashOutEntry,
      $$CashOutEntriesTableFilterComposer,
      $$CashOutEntriesTableOrderingComposer,
      $$CashOutEntriesTableAnnotationComposer,
      $$CashOutEntriesTableCreateCompanionBuilder,
      $$CashOutEntriesTableUpdateCompanionBuilder,
      (
        CashOutEntry,
        BaseReferences<_$AppDatabase, $CashOutEntriesTable, CashOutEntry>,
      ),
      CashOutEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyIncomeRecordsTableTableManager get dailyIncomeRecords =>
      $$DailyIncomeRecordsTableTableManager(_db, _db.dailyIncomeRecords);
  $$CashOutEntriesTableTableManager get cashOutEntries =>
      $$CashOutEntriesTableTableManager(_db, _db.cashOutEntries);
}
