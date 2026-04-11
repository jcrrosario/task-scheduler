// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cnpjMeta = const VerificationMeta('cnpj');
  @override
  late final GeneratedColumn<String> cnpj = GeneratedColumn<String>(
    'cnpj',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
    'hourly_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    cnpj,
    phone,
    contact,
    email,
    hourlyRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cnpj')) {
      context.handle(
        _cnpjMeta,
        cnpj.isAcceptableOrUnknown(data['cnpj']!, _cnpjMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      cnpj: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cnpj'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hourly_rate'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String name;
  final String? cnpj;
  final String? phone;
  final String? contact;
  final String? email;
  final double hourlyRate;
  const Client({
    required this.id,
    required this.name,
    this.cnpj,
    this.phone,
    this.contact,
    this.email,
    required this.hourlyRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || cnpj != null) {
      map['cnpj'] = Variable<String>(cnpj);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['hourly_rate'] = Variable<double>(hourlyRate);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      cnpj: cnpj == null && nullToAbsent ? const Value.absent() : Value(cnpj),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      hourlyRate: Value(hourlyRate),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      cnpj: serializer.fromJson<String?>(json['cnpj']),
      phone: serializer.fromJson<String?>(json['phone']),
      contact: serializer.fromJson<String?>(json['contact']),
      email: serializer.fromJson<String?>(json['email']),
      hourlyRate: serializer.fromJson<double>(json['hourlyRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'cnpj': serializer.toJson<String?>(cnpj),
      'phone': serializer.toJson<String?>(phone),
      'contact': serializer.toJson<String?>(contact),
      'email': serializer.toJson<String?>(email),
      'hourlyRate': serializer.toJson<double>(hourlyRate),
    };
  }

  Client copyWith({
    int? id,
    String? name,
    Value<String?> cnpj = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> contact = const Value.absent(),
    Value<String?> email = const Value.absent(),
    double? hourlyRate,
  }) => Client(
    id: id ?? this.id,
    name: name ?? this.name,
    cnpj: cnpj.present ? cnpj.value : this.cnpj,
    phone: phone.present ? phone.value : this.phone,
    contact: contact.present ? contact.value : this.contact,
    email: email.present ? email.value : this.email,
    hourlyRate: hourlyRate ?? this.hourlyRate,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      cnpj: data.cnpj.present ? data.cnpj.value : this.cnpj,
      phone: data.phone.present ? data.phone.value : this.phone,
      contact: data.contact.present ? data.contact.value : this.contact,
      email: data.email.present ? data.email.value : this.email,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cnpj: $cnpj, ')
          ..write('phone: $phone, ')
          ..write('contact: $contact, ')
          ..write('email: $email, ')
          ..write('hourlyRate: $hourlyRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, cnpj, phone, contact, email, hourlyRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.name == this.name &&
          other.cnpj == this.cnpj &&
          other.phone == this.phone &&
          other.contact == this.contact &&
          other.email == this.email &&
          other.hourlyRate == this.hourlyRate);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> cnpj;
  final Value<String?> phone;
  final Value<String?> contact;
  final Value<String?> email;
  final Value<double> hourlyRate;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.cnpj = const Value.absent(),
    this.phone = const Value.absent(),
    this.contact = const Value.absent(),
    this.email = const Value.absent(),
    this.hourlyRate = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.cnpj = const Value.absent(),
    this.phone = const Value.absent(),
    this.contact = const Value.absent(),
    this.email = const Value.absent(),
    this.hourlyRate = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? cnpj,
    Expression<String>? phone,
    Expression<String>? contact,
    Expression<String>? email,
    Expression<double>? hourlyRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (cnpj != null) 'cnpj': cnpj,
      if (phone != null) 'phone': phone,
      if (contact != null) 'contact': contact,
      if (email != null) 'email': email,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? cnpj,
    Value<String?>? phone,
    Value<String?>? contact,
    Value<String?>? email,
    Value<double>? hourlyRate,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      cnpj: cnpj ?? this.cnpj,
      phone: phone ?? this.phone,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      hourlyRate: hourlyRate ?? this.hourlyRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cnpj.present) {
      map['cnpj'] = Variable<String>(cnpj.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cnpj: $cnpj, ')
          ..write('phone: $phone, ')
          ..write('contact: $contact, ')
          ..write('email: $email, ')
          ..write('hourlyRate: $hourlyRate')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requesterMeta = const VerificationMeta(
    'requester',
  );
  @override
  late final GeneratedColumn<String> requester = GeneratedColumn<String>(
    'requester',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _doneDescriptionMeta = const VerificationMeta(
    'doneDescription',
  );
  @override
  late final GeneratedColumn<String> doneDescription = GeneratedColumn<String>(
    'done_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
    'hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pendente'),
  );
  static const VerificationMeta _clientHourlyRateSnapshotMeta =
      const VerificationMeta('clientHourlyRateSnapshot');
  @override
  late final GeneratedColumn<double> clientHourlyRateSnapshot =
      GeneratedColumn<double>(
        'client_hourly_rate_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    title,
    requester,
    description,
    doneDescription,
    date,
    time,
    hours,
    status,
    clientHourlyRateSnapshot,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('requester')) {
      context.handle(
        _requesterMeta,
        requester.isAcceptableOrUnknown(data['requester']!, _requesterMeta),
      );
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
    if (data.containsKey('done_description')) {
      context.handle(
        _doneDescriptionMeta,
        doneDescription.isAcceptableOrUnknown(
          data['done_description']!,
          _doneDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('client_hourly_rate_snapshot')) {
      context.handle(
        _clientHourlyRateSnapshotMeta,
        clientHourlyRateSnapshot.isAcceptableOrUnknown(
          data['client_hourly_rate_snapshot']!,
          _clientHourlyRateSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      requester: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      doneDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}done_description'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      clientHourlyRateSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}client_hourly_rate_snapshot'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final int clientId;
  final String title;
  final String? requester;
  final String? description;
  final String? doneDescription;
  final DateTime date;
  final String time;
  final double hours;
  final String status;
  final double clientHourlyRateSnapshot;
  final DateTime? completedAt;
  const Task({
    required this.id,
    required this.clientId,
    required this.title,
    this.requester,
    this.description,
    this.doneDescription,
    required this.date,
    required this.time,
    required this.hours,
    required this.status,
    required this.clientHourlyRateSnapshot,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || requester != null) {
      map['requester'] = Variable<String>(requester);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || doneDescription != null) {
      map['done_description'] = Variable<String>(doneDescription);
    }
    map['date'] = Variable<DateTime>(date);
    map['time'] = Variable<String>(time);
    map['hours'] = Variable<double>(hours);
    map['status'] = Variable<String>(status);
    map['client_hourly_rate_snapshot'] = Variable<double>(
      clientHourlyRateSnapshot,
    );
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      clientId: Value(clientId),
      title: Value(title),
      requester: requester == null && nullToAbsent
          ? const Value.absent()
          : Value(requester),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      doneDescription: doneDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(doneDescription),
      date: Value(date),
      time: Value(time),
      hours: Value(hours),
      status: Value(status),
      clientHourlyRateSnapshot: Value(clientHourlyRateSnapshot),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      title: serializer.fromJson<String>(json['title']),
      requester: serializer.fromJson<String?>(json['requester']),
      description: serializer.fromJson<String?>(json['description']),
      doneDescription: serializer.fromJson<String?>(json['doneDescription']),
      date: serializer.fromJson<DateTime>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      hours: serializer.fromJson<double>(json['hours']),
      status: serializer.fromJson<String>(json['status']),
      clientHourlyRateSnapshot: serializer.fromJson<double>(
        json['clientHourlyRateSnapshot'],
      ),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'title': serializer.toJson<String>(title),
      'requester': serializer.toJson<String?>(requester),
      'description': serializer.toJson<String?>(description),
      'doneDescription': serializer.toJson<String?>(doneDescription),
      'date': serializer.toJson<DateTime>(date),
      'time': serializer.toJson<String>(time),
      'hours': serializer.toJson<double>(hours),
      'status': serializer.toJson<String>(status),
      'clientHourlyRateSnapshot': serializer.toJson<double>(
        clientHourlyRateSnapshot,
      ),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  Task copyWith({
    int? id,
    int? clientId,
    String? title,
    Value<String?> requester = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> doneDescription = const Value.absent(),
    DateTime? date,
    String? time,
    double? hours,
    String? status,
    double? clientHourlyRateSnapshot,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    title: title ?? this.title,
    requester: requester.present ? requester.value : this.requester,
    description: description.present ? description.value : this.description,
    doneDescription: doneDescription.present
        ? doneDescription.value
        : this.doneDescription,
    date: date ?? this.date,
    time: time ?? this.time,
    hours: hours ?? this.hours,
    status: status ?? this.status,
    clientHourlyRateSnapshot:
        clientHourlyRateSnapshot ?? this.clientHourlyRateSnapshot,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      title: data.title.present ? data.title.value : this.title,
      requester: data.requester.present ? data.requester.value : this.requester,
      description: data.description.present
          ? data.description.value
          : this.description,
      doneDescription: data.doneDescription.present
          ? data.doneDescription.value
          : this.doneDescription,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      hours: data.hours.present ? data.hours.value : this.hours,
      status: data.status.present ? data.status.value : this.status,
      clientHourlyRateSnapshot: data.clientHourlyRateSnapshot.present
          ? data.clientHourlyRateSnapshot.value
          : this.clientHourlyRateSnapshot,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('requester: $requester, ')
          ..write('description: $description, ')
          ..write('doneDescription: $doneDescription, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('hours: $hours, ')
          ..write('status: $status, ')
          ..write('clientHourlyRateSnapshot: $clientHourlyRateSnapshot, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    title,
    requester,
    description,
    doneDescription,
    date,
    time,
    hours,
    status,
    clientHourlyRateSnapshot,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.title == this.title &&
          other.requester == this.requester &&
          other.description == this.description &&
          other.doneDescription == this.doneDescription &&
          other.date == this.date &&
          other.time == this.time &&
          other.hours == this.hours &&
          other.status == this.status &&
          other.clientHourlyRateSnapshot == this.clientHourlyRateSnapshot &&
          other.completedAt == this.completedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<String> title;
  final Value<String?> requester;
  final Value<String?> description;
  final Value<String?> doneDescription;
  final Value<DateTime> date;
  final Value<String> time;
  final Value<double> hours;
  final Value<String> status;
  final Value<double> clientHourlyRateSnapshot;
  final Value<DateTime?> completedAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.title = const Value.absent(),
    this.requester = const Value.absent(),
    this.description = const Value.absent(),
    this.doneDescription = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.hours = const Value.absent(),
    this.status = const Value.absent(),
    this.clientHourlyRateSnapshot = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required String title,
    this.requester = const Value.absent(),
    this.description = const Value.absent(),
    this.doneDescription = const Value.absent(),
    required DateTime date,
    required String time,
    this.hours = const Value.absent(),
    this.status = const Value.absent(),
    this.clientHourlyRateSnapshot = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : clientId = Value(clientId),
       title = Value(title),
       date = Value(date),
       time = Value(time);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<String>? title,
    Expression<String>? requester,
    Expression<String>? description,
    Expression<String>? doneDescription,
    Expression<DateTime>? date,
    Expression<String>? time,
    Expression<double>? hours,
    Expression<String>? status,
    Expression<double>? clientHourlyRateSnapshot,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (title != null) 'title': title,
      if (requester != null) 'requester': requester,
      if (description != null) 'description': description,
      if (doneDescription != null) 'done_description': doneDescription,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (hours != null) 'hours': hours,
      if (status != null) 'status': status,
      if (clientHourlyRateSnapshot != null)
        'client_hourly_rate_snapshot': clientHourlyRateSnapshot,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<int>? clientId,
    Value<String>? title,
    Value<String?>? requester,
    Value<String?>? description,
    Value<String?>? doneDescription,
    Value<DateTime>? date,
    Value<String>? time,
    Value<double>? hours,
    Value<String>? status,
    Value<double>? clientHourlyRateSnapshot,
    Value<DateTime?>? completedAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      requester: requester ?? this.requester,
      description: description ?? this.description,
      doneDescription: doneDescription ?? this.doneDescription,
      date: date ?? this.date,
      time: time ?? this.time,
      hours: hours ?? this.hours,
      status: status ?? this.status,
      clientHourlyRateSnapshot:
          clientHourlyRateSnapshot ?? this.clientHourlyRateSnapshot,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (requester.present) {
      map['requester'] = Variable<String>(requester.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (doneDescription.present) {
      map['done_description'] = Variable<String>(doneDescription.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (clientHourlyRateSnapshot.present) {
      map['client_hourly_rate_snapshot'] = Variable<double>(
        clientHourlyRateSnapshot.value,
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('requester: $requester, ')
          ..write('description: $description, ')
          ..write('doneDescription: $doneDescription, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('hours: $hours, ')
          ..write('status: $status, ')
          ..write('clientHourlyRateSnapshot: $clientHourlyRateSnapshot, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $ConsultanciesTable extends Consultancies
    with TableInfo<$ConsultanciesTable, Consultancy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsultanciesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cnpjMeta = const VerificationMeta('cnpj');
  @override
  late final GeneratedColumn<String> cnpj = GeneratedColumn<String>(
    'cnpj',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateRegistrationMeta = const VerificationMeta(
    'stateRegistration',
  );
  @override
  late final GeneratedColumn<String> stateRegistration =
      GeneratedColumn<String>(
        'state_registration',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
    'hourly_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accessPasswordMeta = const VerificationMeta(
    'accessPassword',
  );
  @override
  late final GeneratedColumn<String> accessPassword = GeneratedColumn<String>(
    'access_password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    phone,
    cnpj,
    stateRegistration,
    address,
    hourlyRate,
    accessPassword,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consultancies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Consultancy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('cnpj')) {
      context.handle(
        _cnpjMeta,
        cnpj.isAcceptableOrUnknown(data['cnpj']!, _cnpjMeta),
      );
    }
    if (data.containsKey('state_registration')) {
      context.handle(
        _stateRegistrationMeta,
        stateRegistration.isAcceptableOrUnknown(
          data['state_registration']!,
          _stateRegistrationMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('access_password')) {
      context.handle(
        _accessPasswordMeta,
        accessPassword.isAcceptableOrUnknown(
          data['access_password']!,
          _accessPasswordMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Consultancy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Consultancy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      cnpj: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cnpj'],
      ),
      stateRegistration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_registration'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hourly_rate'],
      )!,
      accessPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_password'],
      ),
    );
  }

  @override
  $ConsultanciesTable createAlias(String alias) {
    return $ConsultanciesTable(attachedDatabase, alias);
  }
}

class Consultancy extends DataClass implements Insertable<Consultancy> {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final String? cnpj;
  final String? stateRegistration;
  final String? address;
  final double hourlyRate;
  final String? accessPassword;
  const Consultancy({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.cnpj,
    this.stateRegistration,
    this.address,
    required this.hourlyRate,
    this.accessPassword,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || cnpj != null) {
      map['cnpj'] = Variable<String>(cnpj);
    }
    if (!nullToAbsent || stateRegistration != null) {
      map['state_registration'] = Variable<String>(stateRegistration);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['hourly_rate'] = Variable<double>(hourlyRate);
    if (!nullToAbsent || accessPassword != null) {
      map['access_password'] = Variable<String>(accessPassword);
    }
    return map;
  }

  ConsultanciesCompanion toCompanion(bool nullToAbsent) {
    return ConsultanciesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      cnpj: cnpj == null && nullToAbsent ? const Value.absent() : Value(cnpj),
      stateRegistration: stateRegistration == null && nullToAbsent
          ? const Value.absent()
          : Value(stateRegistration),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      hourlyRate: Value(hourlyRate),
      accessPassword: accessPassword == null && nullToAbsent
          ? const Value.absent()
          : Value(accessPassword),
    );
  }

  factory Consultancy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Consultancy(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      cnpj: serializer.fromJson<String?>(json['cnpj']),
      stateRegistration: serializer.fromJson<String?>(
        json['stateRegistration'],
      ),
      address: serializer.fromJson<String?>(json['address']),
      hourlyRate: serializer.fromJson<double>(json['hourlyRate']),
      accessPassword: serializer.fromJson<String?>(json['accessPassword']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'cnpj': serializer.toJson<String?>(cnpj),
      'stateRegistration': serializer.toJson<String?>(stateRegistration),
      'address': serializer.toJson<String?>(address),
      'hourlyRate': serializer.toJson<double>(hourlyRate),
      'accessPassword': serializer.toJson<String?>(accessPassword),
    };
  }

  Consultancy copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> cnpj = const Value.absent(),
    Value<String?> stateRegistration = const Value.absent(),
    Value<String?> address = const Value.absent(),
    double? hourlyRate,
    Value<String?> accessPassword = const Value.absent(),
  }) => Consultancy(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    cnpj: cnpj.present ? cnpj.value : this.cnpj,
    stateRegistration: stateRegistration.present
        ? stateRegistration.value
        : this.stateRegistration,
    address: address.present ? address.value : this.address,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    accessPassword: accessPassword.present
        ? accessPassword.value
        : this.accessPassword,
  );
  Consultancy copyWithCompanion(ConsultanciesCompanion data) {
    return Consultancy(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      cnpj: data.cnpj.present ? data.cnpj.value : this.cnpj,
      stateRegistration: data.stateRegistration.present
          ? data.stateRegistration.value
          : this.stateRegistration,
      address: data.address.present ? data.address.value : this.address,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      accessPassword: data.accessPassword.present
          ? data.accessPassword.value
          : this.accessPassword,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Consultancy(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('cnpj: $cnpj, ')
          ..write('stateRegistration: $stateRegistration, ')
          ..write('address: $address, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('accessPassword: $accessPassword')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    phone,
    cnpj,
    stateRegistration,
    address,
    hourlyRate,
    accessPassword,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Consultancy &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.cnpj == this.cnpj &&
          other.stateRegistration == this.stateRegistration &&
          other.address == this.address &&
          other.hourlyRate == this.hourlyRate &&
          other.accessPassword == this.accessPassword);
}

class ConsultanciesCompanion extends UpdateCompanion<Consultancy> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> cnpj;
  final Value<String?> stateRegistration;
  final Value<String?> address;
  final Value<double> hourlyRate;
  final Value<String?> accessPassword;
  const ConsultanciesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.cnpj = const Value.absent(),
    this.stateRegistration = const Value.absent(),
    this.address = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.accessPassword = const Value.absent(),
  });
  ConsultanciesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.cnpj = const Value.absent(),
    this.stateRegistration = const Value.absent(),
    this.address = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.accessPassword = const Value.absent(),
  });
  static Insertable<Consultancy> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? cnpj,
    Expression<String>? stateRegistration,
    Expression<String>? address,
    Expression<double>? hourlyRate,
    Expression<String>? accessPassword,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (cnpj != null) 'cnpj': cnpj,
      if (stateRegistration != null) 'state_registration': stateRegistration,
      if (address != null) 'address': address,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (accessPassword != null) 'access_password': accessPassword,
    });
  }

  ConsultanciesCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? cnpj,
    Value<String?>? stateRegistration,
    Value<String?>? address,
    Value<double>? hourlyRate,
    Value<String?>? accessPassword,
  }) {
    return ConsultanciesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cnpj: cnpj ?? this.cnpj,
      stateRegistration: stateRegistration ?? this.stateRegistration,
      address: address ?? this.address,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      accessPassword: accessPassword ?? this.accessPassword,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (cnpj.present) {
      map['cnpj'] = Variable<String>(cnpj.value);
    }
    if (stateRegistration.present) {
      map['state_registration'] = Variable<String>(stateRegistration.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    if (accessPassword.present) {
      map['access_password'] = Variable<String>(accessPassword.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsultanciesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('cnpj: $cnpj, ')
          ..write('stateRegistration: $stateRegistration, ')
          ..write('address: $address, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('accessPassword: $accessPassword')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ConsultanciesTable consultancies = $ConsultanciesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clients,
    tasks,
    consultancies,
  ];
}

typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> cnpj,
      Value<String?> phone,
      Value<String?> contact,
      Value<String?> email,
      Value<double> hourlyRate,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> cnpj,
      Value<String?> phone,
      Value<String?> contact,
      Value<String?> email,
      Value<double> hourlyRate,
    });

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cnpj => $composableBuilder(
    column: $table.cnpj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cnpj => $composableBuilder(
    column: $table.cnpj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get cnpj =>
      $composableBuilder(column: $table.cnpj, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
          Client,
          PrefetchHooks Function()
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> cnpj = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                name: name,
                cnpj: cnpj,
                phone: phone,
                contact: contact,
                email: email,
                hourlyRate: hourlyRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> cnpj = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                name: name,
                cnpj: cnpj,
                phone: phone,
                contact: contact,
                email: email,
                hourlyRate: hourlyRate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
      Client,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required int clientId,
      required String title,
      Value<String?> requester,
      Value<String?> description,
      Value<String?> doneDescription,
      required DateTime date,
      required String time,
      Value<double> hours,
      Value<String> status,
      Value<double> clientHourlyRateSnapshot,
      Value<DateTime?> completedAt,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<int> clientId,
      Value<String> title,
      Value<String?> requester,
      Value<String?> description,
      Value<String?> doneDescription,
      Value<DateTime> date,
      Value<String> time,
      Value<double> hours,
      Value<String> status,
      Value<double> clientHourlyRateSnapshot,
      Value<DateTime?> completedAt,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<int> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requester => $composableBuilder(
    column: $table.requester,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doneDescription => $composableBuilder(
    column: $table.doneDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get clientHourlyRateSnapshot => $composableBuilder(
    column: $table.clientHourlyRateSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<int> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requester => $composableBuilder(
    column: $table.requester,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doneDescription => $composableBuilder(
    column: $table.doneDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get clientHourlyRateSnapshot => $composableBuilder(
    column: $table.clientHourlyRateSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get requester =>
      $composableBuilder(column: $table.requester, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doneDescription => $composableBuilder(
    column: $table.doneDescription,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get clientHourlyRateSnapshot => $composableBuilder(
    column: $table.clientHourlyRateSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> requester = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> doneDescription = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<double> hours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> clientHourlyRateSnapshot = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                clientId: clientId,
                title: title,
                requester: requester,
                description: description,
                doneDescription: doneDescription,
                date: date,
                time: time,
                hours: hours,
                status: status,
                clientHourlyRateSnapshot: clientHourlyRateSnapshot,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clientId,
                required String title,
                Value<String?> requester = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> doneDescription = const Value.absent(),
                required DateTime date,
                required String time,
                Value<double> hours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> clientHourlyRateSnapshot = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                clientId: clientId,
                title: title,
                requester: requester,
                description: description,
                doneDescription: doneDescription,
                date: date,
                time: time,
                hours: hours,
                status: status,
                clientHourlyRateSnapshot: clientHourlyRateSnapshot,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$ConsultanciesTableCreateCompanionBuilder =
    ConsultanciesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> cnpj,
      Value<String?> stateRegistration,
      Value<String?> address,
      Value<double> hourlyRate,
      Value<String?> accessPassword,
    });
typedef $$ConsultanciesTableUpdateCompanionBuilder =
    ConsultanciesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> cnpj,
      Value<String?> stateRegistration,
      Value<String?> address,
      Value<double> hourlyRate,
      Value<String?> accessPassword,
    });

class $$ConsultanciesTableFilterComposer
    extends Composer<_$AppDatabase, $ConsultanciesTable> {
  $$ConsultanciesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cnpj => $composableBuilder(
    column: $table.cnpj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateRegistration => $composableBuilder(
    column: $table.stateRegistration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessPassword => $composableBuilder(
    column: $table.accessPassword,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConsultanciesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsultanciesTable> {
  $$ConsultanciesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cnpj => $composableBuilder(
    column: $table.cnpj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateRegistration => $composableBuilder(
    column: $table.stateRegistration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessPassword => $composableBuilder(
    column: $table.accessPassword,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConsultanciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsultanciesTable> {
  $$ConsultanciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get cnpj =>
      $composableBuilder(column: $table.cnpj, builder: (column) => column);

  GeneratedColumn<String> get stateRegistration => $composableBuilder(
    column: $table.stateRegistration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accessPassword => $composableBuilder(
    column: $table.accessPassword,
    builder: (column) => column,
  );
}

class $$ConsultanciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsultanciesTable,
          Consultancy,
          $$ConsultanciesTableFilterComposer,
          $$ConsultanciesTableOrderingComposer,
          $$ConsultanciesTableAnnotationComposer,
          $$ConsultanciesTableCreateCompanionBuilder,
          $$ConsultanciesTableUpdateCompanionBuilder,
          (
            Consultancy,
            BaseReferences<_$AppDatabase, $ConsultanciesTable, Consultancy>,
          ),
          Consultancy,
          PrefetchHooks Function()
        > {
  $$ConsultanciesTableTableManager(_$AppDatabase db, $ConsultanciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsultanciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsultanciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsultanciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> cnpj = const Value.absent(),
                Value<String?> stateRegistration = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
                Value<String?> accessPassword = const Value.absent(),
              }) => ConsultanciesCompanion(
                id: id,
                name: name,
                email: email,
                phone: phone,
                cnpj: cnpj,
                stateRegistration: stateRegistration,
                address: address,
                hourlyRate: hourlyRate,
                accessPassword: accessPassword,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> cnpj = const Value.absent(),
                Value<String?> stateRegistration = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
                Value<String?> accessPassword = const Value.absent(),
              }) => ConsultanciesCompanion.insert(
                id: id,
                name: name,
                email: email,
                phone: phone,
                cnpj: cnpj,
                stateRegistration: stateRegistration,
                address: address,
                hourlyRate: hourlyRate,
                accessPassword: accessPassword,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConsultanciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsultanciesTable,
      Consultancy,
      $$ConsultanciesTableFilterComposer,
      $$ConsultanciesTableOrderingComposer,
      $$ConsultanciesTableAnnotationComposer,
      $$ConsultanciesTableCreateCompanionBuilder,
      $$ConsultanciesTableUpdateCompanionBuilder,
      (
        Consultancy,
        BaseReferences<_$AppDatabase, $ConsultanciesTable, Consultancy>,
      ),
      Consultancy,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ConsultanciesTableTableManager get consultancies =>
      $$ConsultanciesTableTableManager(_db, _db.consultancies);
}
