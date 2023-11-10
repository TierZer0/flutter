class IGoogleGeocodingModel {
  final List<AddressComponents> addressComponents;
  final String formattedAddress;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  IGoogleGeocodingModel({
    required this.addressComponents,
    required this.formattedAddress,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory IGoogleGeocodingModel.fromMap(Map<String, dynamic> map) {
    return IGoogleGeocodingModel(
      addressComponents: List<AddressComponents>.from(
        map['results'][0]['address_components'].map(
          (x) => AddressComponents(
            longName: x['long_name'],
            shortName: x['short_name'],
            types: List<String>.from(x['types'].map((x) => x)),
          ),
        ),
      ),
      formattedAddress: map['results'][0]['formatted_address'],
      street: map['results'][0]['address_components'][0]['long_name'],
      city: map['results'][0]['address_components'][2]['long_name'],
      state: map['results'][0]['address_components'][4]['long_name'],
      country: map['results'][0]['address_components'][5]['long_name'],
      postalCode: map['results'][0]['address_components'][6]['long_name'],
    );
  }
}

class AddressComponents {
  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponents({
    required this.longName,
    required this.shortName,
    required this.types,
  });
}
