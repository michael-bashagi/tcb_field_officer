// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FarmsTableTable extends FarmsTable
    with TableInfo<$FarmsTableTable, FarmsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _acreageMeta =
      const VerificationMeta('acreage');
  @override
  late final GeneratedColumn<double> acreage = GeneratedColumn<double>(
      'acreage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _polygonCoordinatesJsonMeta =
      const VerificationMeta('polygonCoordinatesJson');
  @override
  late final GeneratedColumn<String> polygonCoordinatesJson =
      GeneratedColumn<String>('polygon_coordinates_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, location, acreage, polygonCoordinatesJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farms_table';
  @override
  VerificationContext validateIntegrity(Insertable<FarmsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('acreage')) {
      context.handle(_acreageMeta,
          acreage.isAcceptableOrUnknown(data['acreage']!, _acreageMeta));
    } else if (isInserting) {
      context.missing(_acreageMeta);
    }
    if (data.containsKey('polygon_coordinates_json')) {
      context.handle(
          _polygonCoordinatesJsonMeta,
          polygonCoordinatesJson.isAcceptableOrUnknown(
              data['polygon_coordinates_json']!, _polygonCoordinatesJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      acreage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}acreage'])!,
      polygonCoordinatesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}polygon_coordinates_json']),
    );
  }

  @override
  $FarmsTableTable createAlias(String alias) {
    return $FarmsTableTable(attachedDatabase, alias);
  }
}

class FarmsTableData extends DataClass implements Insertable<FarmsTableData> {
  final String id;
  final String location;
  final double acreage;
  final String? polygonCoordinatesJson;
  const FarmsTableData(
      {required this.id,
      required this.location,
      required this.acreage,
      this.polygonCoordinatesJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location'] = Variable<String>(location);
    map['acreage'] = Variable<double>(acreage);
    if (!nullToAbsent || polygonCoordinatesJson != null) {
      map['polygon_coordinates_json'] =
          Variable<String>(polygonCoordinatesJson);
    }
    return map;
  }

  FarmsTableCompanion toCompanion(bool nullToAbsent) {
    return FarmsTableCompanion(
      id: Value(id),
      location: Value(location),
      acreage: Value(acreage),
      polygonCoordinatesJson: polygonCoordinatesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(polygonCoordinatesJson),
    );
  }

  factory FarmsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmsTableData(
      id: serializer.fromJson<String>(json['id']),
      location: serializer.fromJson<String>(json['location']),
      acreage: serializer.fromJson<double>(json['acreage']),
      polygonCoordinatesJson:
          serializer.fromJson<String?>(json['polygonCoordinatesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'location': serializer.toJson<String>(location),
      'acreage': serializer.toJson<double>(acreage),
      'polygonCoordinatesJson':
          serializer.toJson<String?>(polygonCoordinatesJson),
    };
  }

  FarmsTableData copyWith(
          {String? id,
          String? location,
          double? acreage,
          Value<String?> polygonCoordinatesJson = const Value.absent()}) =>
      FarmsTableData(
        id: id ?? this.id,
        location: location ?? this.location,
        acreage: acreage ?? this.acreage,
        polygonCoordinatesJson: polygonCoordinatesJson.present
            ? polygonCoordinatesJson.value
            : this.polygonCoordinatesJson,
      );
  FarmsTableData copyWithCompanion(FarmsTableCompanion data) {
    return FarmsTableData(
      id: data.id.present ? data.id.value : this.id,
      location: data.location.present ? data.location.value : this.location,
      acreage: data.acreage.present ? data.acreage.value : this.acreage,
      polygonCoordinatesJson: data.polygonCoordinatesJson.present
          ? data.polygonCoordinatesJson.value
          : this.polygonCoordinatesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmsTableData(')
          ..write('id: $id, ')
          ..write('location: $location, ')
          ..write('acreage: $acreage, ')
          ..write('polygonCoordinatesJson: $polygonCoordinatesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, location, acreage, polygonCoordinatesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmsTableData &&
          other.id == this.id &&
          other.location == this.location &&
          other.acreage == this.acreage &&
          other.polygonCoordinatesJson == this.polygonCoordinatesJson);
}

class FarmsTableCompanion extends UpdateCompanion<FarmsTableData> {
  final Value<String> id;
  final Value<String> location;
  final Value<double> acreage;
  final Value<String?> polygonCoordinatesJson;
  final Value<int> rowid;
  const FarmsTableCompanion({
    this.id = const Value.absent(),
    this.location = const Value.absent(),
    this.acreage = const Value.absent(),
    this.polygonCoordinatesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmsTableCompanion.insert({
    required String id,
    required String location,
    required double acreage,
    this.polygonCoordinatesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        location = Value(location),
        acreage = Value(acreage);
  static Insertable<FarmsTableData> custom({
    Expression<String>? id,
    Expression<String>? location,
    Expression<double>? acreage,
    Expression<String>? polygonCoordinatesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (location != null) 'location': location,
      if (acreage != null) 'acreage': acreage,
      if (polygonCoordinatesJson != null)
        'polygon_coordinates_json': polygonCoordinatesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? location,
      Value<double>? acreage,
      Value<String?>? polygonCoordinatesJson,
      Value<int>? rowid}) {
    return FarmsTableCompanion(
      id: id ?? this.id,
      location: location ?? this.location,
      acreage: acreage ?? this.acreage,
      polygonCoordinatesJson:
          polygonCoordinatesJson ?? this.polygonCoordinatesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (acreage.present) {
      map['acreage'] = Variable<double>(acreage.value);
    }
    if (polygonCoordinatesJson.present) {
      map['polygon_coordinates_json'] =
          Variable<String>(polygonCoordinatesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmsTableCompanion(')
          ..write('id: $id, ')
          ..write('location: $location, ')
          ..write('acreage: $acreage, ')
          ..write('polygonCoordinatesJson: $polygonCoordinatesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FarmersTableTable extends FarmersTable
    with TableInfo<$FarmersTableTable, FarmersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _middleNameMeta =
      const VerificationMeta('middleName');
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
      'middle_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _registeredByOfficerMeta =
      const VerificationMeta('registeredByOfficer');
  @override
  late final GeneratedColumn<String> registeredByOfficer =
      GeneratedColumn<String>('registered_by_officer', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentStatusMeta =
      const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
      'payment_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _controlNumberMeta =
      const VerificationMeta('controlNumber');
  @override
  late final GeneratedColumn<String> controlNumber = GeneratedColumn<String>(
      'control_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES farms_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        middleName,
        lastName,
        phoneNumber,
        registeredByOfficer,
        paymentStatus,
        controlNumber,
        farmId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farmers_table';
  @override
  VerificationContext validateIntegrity(Insertable<FarmersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('middle_name')) {
      context.handle(
          _middleNameMeta,
          middleName.isAcceptableOrUnknown(
              data['middle_name']!, _middleNameMeta));
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('registered_by_officer')) {
      context.handle(
          _registeredByOfficerMeta,
          registeredByOfficer.isAcceptableOrUnknown(
              data['registered_by_officer']!, _registeredByOfficerMeta));
    } else if (isInserting) {
      context.missing(_registeredByOfficerMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(
          _paymentStatusMeta,
          paymentStatus.isAcceptableOrUnknown(
              data['payment_status']!, _paymentStatusMeta));
    }
    if (data.containsKey('control_number')) {
      context.handle(
          _controlNumberMeta,
          controlNumber.isAcceptableOrUnknown(
              data['control_number']!, _controlNumberMeta));
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      middleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}middle_name']),
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number'])!,
      registeredByOfficer: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}registered_by_officer'])!,
      paymentStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_status'])!,
      controlNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}control_number']),
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
    );
  }

  @override
  $FarmersTableTable createAlias(String alias) {
    return $FarmersTableTable(attachedDatabase, alias);
  }
}

class FarmersTableData extends DataClass
    implements Insertable<FarmersTableData> {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String phoneNumber;
  final String registeredByOfficer;
  final String paymentStatus;
  final String? controlNumber;
  final String farmId;
  const FarmersTableData(
      {required this.id,
      required this.firstName,
      this.middleName,
      required this.lastName,
      required this.phoneNumber,
      required this.registeredByOfficer,
      required this.paymentStatus,
      this.controlNumber,
      required this.farmId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || middleName != null) {
      map['middle_name'] = Variable<String>(middleName);
    }
    map['last_name'] = Variable<String>(lastName);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['registered_by_officer'] = Variable<String>(registeredByOfficer);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || controlNumber != null) {
      map['control_number'] = Variable<String>(controlNumber);
    }
    map['farm_id'] = Variable<String>(farmId);
    return map;
  }

  FarmersTableCompanion toCompanion(bool nullToAbsent) {
    return FarmersTableCompanion(
      id: Value(id),
      firstName: Value(firstName),
      middleName: middleName == null && nullToAbsent
          ? const Value.absent()
          : Value(middleName),
      lastName: Value(lastName),
      phoneNumber: Value(phoneNumber),
      registeredByOfficer: Value(registeredByOfficer),
      paymentStatus: Value(paymentStatus),
      controlNumber: controlNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(controlNumber),
      farmId: Value(farmId),
    );
  }

  factory FarmersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmersTableData(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      registeredByOfficer:
          serializer.fromJson<String>(json['registeredByOfficer']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      controlNumber: serializer.fromJson<String?>(json['controlNumber']),
      farmId: serializer.fromJson<String>(json['farmId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'middleName': serializer.toJson<String?>(middleName),
      'lastName': serializer.toJson<String>(lastName),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'registeredByOfficer': serializer.toJson<String>(registeredByOfficer),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'controlNumber': serializer.toJson<String?>(controlNumber),
      'farmId': serializer.toJson<String>(farmId),
    };
  }

  FarmersTableData copyWith(
          {String? id,
          String? firstName,
          Value<String?> middleName = const Value.absent(),
          String? lastName,
          String? phoneNumber,
          String? registeredByOfficer,
          String? paymentStatus,
          Value<String?> controlNumber = const Value.absent(),
          String? farmId}) =>
      FarmersTableData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        middleName: middleName.present ? middleName.value : this.middleName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        registeredByOfficer: registeredByOfficer ?? this.registeredByOfficer,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        controlNumber:
            controlNumber.present ? controlNumber.value : this.controlNumber,
        farmId: farmId ?? this.farmId,
      );
  FarmersTableData copyWithCompanion(FarmersTableCompanion data) {
    return FarmersTableData(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      middleName:
          data.middleName.present ? data.middleName.value : this.middleName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      registeredByOfficer: data.registeredByOfficer.present
          ? data.registeredByOfficer.value
          : this.registeredByOfficer,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      controlNumber: data.controlNumber.present
          ? data.controlNumber.value
          : this.controlNumber,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmersTableData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('registeredByOfficer: $registeredByOfficer, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('farmId: $farmId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, firstName, middleName, lastName,
      phoneNumber, registeredByOfficer, paymentStatus, controlNumber, farmId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmersTableData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.middleName == this.middleName &&
          other.lastName == this.lastName &&
          other.phoneNumber == this.phoneNumber &&
          other.registeredByOfficer == this.registeredByOfficer &&
          other.paymentStatus == this.paymentStatus &&
          other.controlNumber == this.controlNumber &&
          other.farmId == this.farmId);
}

class FarmersTableCompanion extends UpdateCompanion<FarmersTableData> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String?> middleName;
  final Value<String> lastName;
  final Value<String> phoneNumber;
  final Value<String> registeredByOfficer;
  final Value<String> paymentStatus;
  final Value<String?> controlNumber;
  final Value<String> farmId;
  final Value<int> rowid;
  const FarmersTableCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.registeredByOfficer = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.farmId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmersTableCompanion.insert({
    required String id,
    required String firstName,
    this.middleName = const Value.absent(),
    required String lastName,
    required String phoneNumber,
    required String registeredByOfficer,
    this.paymentStatus = const Value.absent(),
    this.controlNumber = const Value.absent(),
    required String farmId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName),
        phoneNumber = Value(phoneNumber),
        registeredByOfficer = Value(registeredByOfficer),
        farmId = Value(farmId);
  static Insertable<FarmersTableData> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? middleName,
    Expression<String>? lastName,
    Expression<String>? phoneNumber,
    Expression<String>? registeredByOfficer,
    Expression<String>? paymentStatus,
    Expression<String>? controlNumber,
    Expression<String>? farmId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (registeredByOfficer != null)
        'registered_by_officer': registeredByOfficer,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (controlNumber != null) 'control_number': controlNumber,
      if (farmId != null) 'farm_id': farmId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String?>? middleName,
      Value<String>? lastName,
      Value<String>? phoneNumber,
      Value<String>? registeredByOfficer,
      Value<String>? paymentStatus,
      Value<String?>? controlNumber,
      Value<String>? farmId,
      Value<int>? rowid}) {
    return FarmersTableCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      registeredByOfficer: registeredByOfficer ?? this.registeredByOfficer,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      controlNumber: controlNumber ?? this.controlNumber,
      farmId: farmId ?? this.farmId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (registeredByOfficer.present) {
      map['registered_by_officer'] =
          Variable<String>(registeredByOfficer.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (controlNumber.present) {
      map['control_number'] = Variable<String>(controlNumber.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmersTableCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('registeredByOfficer: $registeredByOfficer, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('farmId: $farmId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillCacheTableTable extends BillCacheTable
    with TableInfo<$BillCacheTableTable, BillCacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _farmerUidMeta =
      const VerificationMeta('farmerUid');
  @override
  late final GeneratedColumn<String> farmerUid = GeneratedColumn<String>(
      'farmer_uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _controlNumberMeta =
      const VerificationMeta('controlNumber');
  @override
  late final GeneratedColumn<String> controlNumber = GeneratedColumn<String>(
      'control_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentStatusMeta =
      const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
      'payment_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [farmerUid, controlNumber, paymentStatus, amount, generatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_cache_table';
  @override
  VerificationContext validateIntegrity(Insertable<BillCacheTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('farmer_uid')) {
      context.handle(_farmerUidMeta,
          farmerUid.isAcceptableOrUnknown(data['farmer_uid']!, _farmerUidMeta));
    } else if (isInserting) {
      context.missing(_farmerUidMeta);
    }
    if (data.containsKey('control_number')) {
      context.handle(
          _controlNumberMeta,
          controlNumber.isAcceptableOrUnknown(
              data['control_number']!, _controlNumberMeta));
    } else if (isInserting) {
      context.missing(_controlNumberMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(
          _paymentStatusMeta,
          paymentStatus.isAcceptableOrUnknown(
              data['payment_status']!, _paymentStatusMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {farmerUid};
  @override
  BillCacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillCacheTableData(
      farmerUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farmer_uid'])!,
      controlNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}control_number'])!,
      paymentStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_status'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
    );
  }

  @override
  $BillCacheTableTable createAlias(String alias) {
    return $BillCacheTableTable(attachedDatabase, alias);
  }
}

class BillCacheTableData extends DataClass
    implements Insertable<BillCacheTableData> {
  final String farmerUid;
  final String controlNumber;
  final String paymentStatus;
  final double amount;
  final DateTime generatedAt;
  const BillCacheTableData(
      {required this.farmerUid,
      required this.controlNumber,
      required this.paymentStatus,
      required this.amount,
      required this.generatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['farmer_uid'] = Variable<String>(farmerUid);
    map['control_number'] = Variable<String>(controlNumber);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['amount'] = Variable<double>(amount);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    return map;
  }

  BillCacheTableCompanion toCompanion(bool nullToAbsent) {
    return BillCacheTableCompanion(
      farmerUid: Value(farmerUid),
      controlNumber: Value(controlNumber),
      paymentStatus: Value(paymentStatus),
      amount: Value(amount),
      generatedAt: Value(generatedAt),
    );
  }

  factory BillCacheTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillCacheTableData(
      farmerUid: serializer.fromJson<String>(json['farmerUid']),
      controlNumber: serializer.fromJson<String>(json['controlNumber']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      amount: serializer.fromJson<double>(json['amount']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'farmerUid': serializer.toJson<String>(farmerUid),
      'controlNumber': serializer.toJson<String>(controlNumber),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'amount': serializer.toJson<double>(amount),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
    };
  }

  BillCacheTableData copyWith(
          {String? farmerUid,
          String? controlNumber,
          String? paymentStatus,
          double? amount,
          DateTime? generatedAt}) =>
      BillCacheTableData(
        farmerUid: farmerUid ?? this.farmerUid,
        controlNumber: controlNumber ?? this.controlNumber,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        amount: amount ?? this.amount,
        generatedAt: generatedAt ?? this.generatedAt,
      );
  BillCacheTableData copyWithCompanion(BillCacheTableCompanion data) {
    return BillCacheTableData(
      farmerUid: data.farmerUid.present ? data.farmerUid.value : this.farmerUid,
      controlNumber: data.controlNumber.present
          ? data.controlNumber.value
          : this.controlNumber,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      amount: data.amount.present ? data.amount.value : this.amount,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillCacheTableData(')
          ..write('farmerUid: $farmerUid, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('amount: $amount, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(farmerUid, controlNumber, paymentStatus, amount, generatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillCacheTableData &&
          other.farmerUid == this.farmerUid &&
          other.controlNumber == this.controlNumber &&
          other.paymentStatus == this.paymentStatus &&
          other.amount == this.amount &&
          other.generatedAt == this.generatedAt);
}

class BillCacheTableCompanion extends UpdateCompanion<BillCacheTableData> {
  final Value<String> farmerUid;
  final Value<String> controlNumber;
  final Value<String> paymentStatus;
  final Value<double> amount;
  final Value<DateTime> generatedAt;
  final Value<int> rowid;
  const BillCacheTableCompanion({
    this.farmerUid = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.amount = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillCacheTableCompanion.insert({
    required String farmerUid,
    required String controlNumber,
    this.paymentStatus = const Value.absent(),
    required double amount,
    required DateTime generatedAt,
    this.rowid = const Value.absent(),
  })  : farmerUid = Value(farmerUid),
        controlNumber = Value(controlNumber),
        amount = Value(amount),
        generatedAt = Value(generatedAt);
  static Insertable<BillCacheTableData> custom({
    Expression<String>? farmerUid,
    Expression<String>? controlNumber,
    Expression<String>? paymentStatus,
    Expression<double>? amount,
    Expression<DateTime>? generatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (farmerUid != null) 'farmer_uid': farmerUid,
      if (controlNumber != null) 'control_number': controlNumber,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (amount != null) 'amount': amount,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillCacheTableCompanion copyWith(
      {Value<String>? farmerUid,
      Value<String>? controlNumber,
      Value<String>? paymentStatus,
      Value<double>? amount,
      Value<DateTime>? generatedAt,
      Value<int>? rowid}) {
    return BillCacheTableCompanion(
      farmerUid: farmerUid ?? this.farmerUid,
      controlNumber: controlNumber ?? this.controlNumber,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      amount: amount ?? this.amount,
      generatedAt: generatedAt ?? this.generatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (farmerUid.present) {
      map['farmer_uid'] = Variable<String>(farmerUid.value);
    }
    if (controlNumber.present) {
      map['control_number'] = Variable<String>(controlNumber.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillCacheTableCompanion(')
          ..write('farmerUid: $farmerUid, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('amount: $amount, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FarmsTableTable farmsTable = $FarmsTableTable(this);
  late final $FarmersTableTable farmersTable = $FarmersTableTable(this);
  late final $BillCacheTableTable billCacheTable = $BillCacheTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [farmsTable, farmersTable, billCacheTable];
}

typedef $$FarmsTableTableCreateCompanionBuilder = FarmsTableCompanion Function({
  required String id,
  required String location,
  required double acreage,
  Value<String?> polygonCoordinatesJson,
  Value<int> rowid,
});
typedef $$FarmsTableTableUpdateCompanionBuilder = FarmsTableCompanion Function({
  Value<String> id,
  Value<String> location,
  Value<double> acreage,
  Value<String?> polygonCoordinatesJson,
  Value<int> rowid,
});

final class $$FarmsTableTableReferences
    extends BaseReferences<_$AppDatabase, $FarmsTableTable, FarmsTableData> {
  $$FarmsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FarmersTableTable, List<FarmersTableData>>
      _farmersTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.farmersTable,
              aliasName: 'farms_table__id__farmers_table__farm_id');

  $$FarmersTableTableProcessedTableManager get farmersTableRefs {
    final manager = $$FarmersTableTableTableManager($_db, $_db.farmersTable)
        .filter((f) => f.farmId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_farmersTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FarmsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FarmsTableTable> {
  $$FarmsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get acreage => $composableBuilder(
      column: $table.acreage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get polygonCoordinatesJson => $composableBuilder(
      column: $table.polygonCoordinatesJson,
      builder: (column) => ColumnFilters(column));

  Expression<bool> farmersTableRefs(
      Expression<bool> Function($$FarmersTableTableFilterComposer f) f) {
    final $$FarmersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.farmersTable,
        getReferencedColumn: (t) => t.farmId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FarmersTableTableFilterComposer(
              $db: $db,
              $table: $db.farmersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FarmsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmsTableTable> {
  $$FarmsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get acreage => $composableBuilder(
      column: $table.acreage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get polygonCoordinatesJson => $composableBuilder(
      column: $table.polygonCoordinatesJson,
      builder: (column) => ColumnOrderings(column));
}

class $$FarmsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmsTableTable> {
  $$FarmsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<double> get acreage =>
      $composableBuilder(column: $table.acreage, builder: (column) => column);

  GeneratedColumn<String> get polygonCoordinatesJson => $composableBuilder(
      column: $table.polygonCoordinatesJson, builder: (column) => column);

  Expression<T> farmersTableRefs<T extends Object>(
      Expression<T> Function($$FarmersTableTableAnnotationComposer a) f) {
    final $$FarmersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.farmersTable,
        getReferencedColumn: (t) => t.farmId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FarmersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.farmersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FarmsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FarmsTableTable,
    FarmsTableData,
    $$FarmsTableTableFilterComposer,
    $$FarmsTableTableOrderingComposer,
    $$FarmsTableTableAnnotationComposer,
    $$FarmsTableTableCreateCompanionBuilder,
    $$FarmsTableTableUpdateCompanionBuilder,
    (FarmsTableData, $$FarmsTableTableReferences),
    FarmsTableData,
    PrefetchHooks Function({bool farmersTableRefs})> {
  $$FarmsTableTableTableManager(_$AppDatabase db, $FarmsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<double> acreage = const Value.absent(),
            Value<String?> polygonCoordinatesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmsTableCompanion(
            id: id,
            location: location,
            acreage: acreage,
            polygonCoordinatesJson: polygonCoordinatesJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String location,
            required double acreage,
            Value<String?> polygonCoordinatesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmsTableCompanion.insert(
            id: id,
            location: location,
            acreage: acreage,
            polygonCoordinatesJson: polygonCoordinatesJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FarmsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({farmersTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (farmersTableRefs) db.farmersTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (farmersTableRefs)
                    await $_getPrefetchedData<FarmsTableData, $FarmsTableTable,
                            FarmersTableData>(
                        currentTable: table,
                        referencedTable: $$FarmsTableTableReferences
                            ._farmersTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FarmsTableTableReferences(db, table, p0)
                                .farmersTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.farmId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FarmsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FarmsTableTable,
    FarmsTableData,
    $$FarmsTableTableFilterComposer,
    $$FarmsTableTableOrderingComposer,
    $$FarmsTableTableAnnotationComposer,
    $$FarmsTableTableCreateCompanionBuilder,
    $$FarmsTableTableUpdateCompanionBuilder,
    (FarmsTableData, $$FarmsTableTableReferences),
    FarmsTableData,
    PrefetchHooks Function({bool farmersTableRefs})>;
typedef $$FarmersTableTableCreateCompanionBuilder = FarmersTableCompanion
    Function({
  required String id,
  required String firstName,
  Value<String?> middleName,
  required String lastName,
  required String phoneNumber,
  required String registeredByOfficer,
  Value<String> paymentStatus,
  Value<String?> controlNumber,
  required String farmId,
  Value<int> rowid,
});
typedef $$FarmersTableTableUpdateCompanionBuilder = FarmersTableCompanion
    Function({
  Value<String> id,
  Value<String> firstName,
  Value<String?> middleName,
  Value<String> lastName,
  Value<String> phoneNumber,
  Value<String> registeredByOfficer,
  Value<String> paymentStatus,
  Value<String?> controlNumber,
  Value<String> farmId,
  Value<int> rowid,
});

final class $$FarmersTableTableReferences extends BaseReferences<_$AppDatabase,
    $FarmersTableTable, FarmersTableData> {
  $$FarmersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FarmsTableTable _farmIdTable(_$AppDatabase db) =>
      db.farmsTable.createAlias('farmers_table__farm_id__farms_table__id');

  $$FarmsTableTableProcessedTableManager get farmId {
    final $_column = $_itemColumn<String>('farm_id')!;

    final manager = $$FarmsTableTableTableManager($_db, $_db.farmsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_farmIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FarmersTableTableFilterComposer
    extends Composer<_$AppDatabase, $FarmersTableTable> {
  $$FarmersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get middleName => $composableBuilder(
      column: $table.middleName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get registeredByOfficer => $composableBuilder(
      column: $table.registeredByOfficer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => ColumnFilters(column));

  $$FarmsTableTableFilterComposer get farmId {
    final $$FarmsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.farmId,
        referencedTable: $db.farmsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FarmsTableTableFilterComposer(
              $db: $db,
              $table: $db.farmsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FarmersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmersTableTable> {
  $$FarmersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get middleName => $composableBuilder(
      column: $table.middleName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get registeredByOfficer => $composableBuilder(
      column: $table.registeredByOfficer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber,
      builder: (column) => ColumnOrderings(column));

  $$FarmsTableTableOrderingComposer get farmId {
    final $$FarmsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.farmId,
        referencedTable: $db.farmsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FarmsTableTableOrderingComposer(
              $db: $db,
              $table: $db.farmsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FarmersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmersTableTable> {
  $$FarmersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
      column: $table.middleName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get registeredByOfficer => $composableBuilder(
      column: $table.registeredByOfficer, builder: (column) => column);

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => column);

  GeneratedColumn<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => column);

  $$FarmsTableTableAnnotationComposer get farmId {
    final $$FarmsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.farmId,
        referencedTable: $db.farmsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FarmsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.farmsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FarmersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FarmersTableTable,
    FarmersTableData,
    $$FarmersTableTableFilterComposer,
    $$FarmersTableTableOrderingComposer,
    $$FarmersTableTableAnnotationComposer,
    $$FarmersTableTableCreateCompanionBuilder,
    $$FarmersTableTableUpdateCompanionBuilder,
    (FarmersTableData, $$FarmersTableTableReferences),
    FarmersTableData,
    PrefetchHooks Function({bool farmId})> {
  $$FarmersTableTableTableManager(_$AppDatabase db, $FarmersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String?> middleName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String> phoneNumber = const Value.absent(),
            Value<String> registeredByOfficer = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<String?> controlNumber = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmersTableCompanion(
            id: id,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            registeredByOfficer: registeredByOfficer,
            paymentStatus: paymentStatus,
            controlNumber: controlNumber,
            farmId: farmId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String firstName,
            Value<String?> middleName = const Value.absent(),
            required String lastName,
            required String phoneNumber,
            required String registeredByOfficer,
            Value<String> paymentStatus = const Value.absent(),
            Value<String?> controlNumber = const Value.absent(),
            required String farmId,
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmersTableCompanion.insert(
            id: id,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            registeredByOfficer: registeredByOfficer,
            paymentStatus: paymentStatus,
            controlNumber: controlNumber,
            farmId: farmId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FarmersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({farmId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (farmId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.farmId,
                    referencedTable:
                        $$FarmersTableTableReferences._farmIdTable(db),
                    referencedColumn:
                        $$FarmersTableTableReferences._farmIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FarmersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FarmersTableTable,
    FarmersTableData,
    $$FarmersTableTableFilterComposer,
    $$FarmersTableTableOrderingComposer,
    $$FarmersTableTableAnnotationComposer,
    $$FarmersTableTableCreateCompanionBuilder,
    $$FarmersTableTableUpdateCompanionBuilder,
    (FarmersTableData, $$FarmersTableTableReferences),
    FarmersTableData,
    PrefetchHooks Function({bool farmId})>;
typedef $$BillCacheTableTableCreateCompanionBuilder = BillCacheTableCompanion
    Function({
  required String farmerUid,
  required String controlNumber,
  Value<String> paymentStatus,
  required double amount,
  required DateTime generatedAt,
  Value<int> rowid,
});
typedef $$BillCacheTableTableUpdateCompanionBuilder = BillCacheTableCompanion
    Function({
  Value<String> farmerUid,
  Value<String> controlNumber,
  Value<String> paymentStatus,
  Value<double> amount,
  Value<DateTime> generatedAt,
  Value<int> rowid,
});

class $$BillCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $BillCacheTableTable> {
  $$BillCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get farmerUid => $composableBuilder(
      column: $table.farmerUid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));
}

class $$BillCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BillCacheTableTable> {
  $$BillCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get farmerUid => $composableBuilder(
      column: $table.farmerUid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BillCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillCacheTableTable> {
  $$BillCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get farmerUid =>
      $composableBuilder(column: $table.farmerUid, builder: (column) => column);

  GeneratedColumn<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => column);

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);
}

class $$BillCacheTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillCacheTableTable,
    BillCacheTableData,
    $$BillCacheTableTableFilterComposer,
    $$BillCacheTableTableOrderingComposer,
    $$BillCacheTableTableAnnotationComposer,
    $$BillCacheTableTableCreateCompanionBuilder,
    $$BillCacheTableTableUpdateCompanionBuilder,
    (
      BillCacheTableData,
      BaseReferences<_$AppDatabase, $BillCacheTableTable, BillCacheTableData>
    ),
    BillCacheTableData,
    PrefetchHooks Function()> {
  $$BillCacheTableTableTableManager(
      _$AppDatabase db, $BillCacheTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillCacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillCacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> farmerUid = const Value.absent(),
            Value<String> controlNumber = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillCacheTableCompanion(
            farmerUid: farmerUid,
            controlNumber: controlNumber,
            paymentStatus: paymentStatus,
            amount: amount,
            generatedAt: generatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String farmerUid,
            required String controlNumber,
            Value<String> paymentStatus = const Value.absent(),
            required double amount,
            required DateTime generatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BillCacheTableCompanion.insert(
            farmerUid: farmerUid,
            controlNumber: controlNumber,
            paymentStatus: paymentStatus,
            amount: amount,
            generatedAt: generatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BillCacheTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillCacheTableTable,
    BillCacheTableData,
    $$BillCacheTableTableFilterComposer,
    $$BillCacheTableTableOrderingComposer,
    $$BillCacheTableTableAnnotationComposer,
    $$BillCacheTableTableCreateCompanionBuilder,
    $$BillCacheTableTableUpdateCompanionBuilder,
    (
      BillCacheTableData,
      BaseReferences<_$AppDatabase, $BillCacheTableTable, BillCacheTableData>
    ),
    BillCacheTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FarmsTableTableTableManager get farmsTable =>
      $$FarmsTableTableTableManager(_db, _db.farmsTable);
  $$FarmersTableTableTableManager get farmersTable =>
      $$FarmersTableTableTableManager(_db, _db.farmersTable);
  $$BillCacheTableTableTableManager get billCacheTable =>
      $$BillCacheTableTableTableManager(_db, _db.billCacheTable);
}
