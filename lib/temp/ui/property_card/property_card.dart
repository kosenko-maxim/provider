import 'package:flutter/material.dart';
import '../../../src/models/screen/components/property_model.dart';
import 'property_card_footer.dart';
import 'property_card_image.dart';


class PropertyCard extends StatelessWidget {
  factory PropertyCard(PropertyModel property, {Function makeTransition}) {
    return PropertyCard._(property,
        makeTransition: makeTransition, key: GlobalKey());
  }

  PropertyCard._(this.property, {this.makeTransition, GlobalKey key})
      : id = property.id,
        _key = key,
        super(key: key);

  final PropertyModel property;
  final Function makeTransition;
  final String id;
  final GlobalKey _key;

  @override
  GlobalKey get key => _key;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(
                width: 0.1,
                style: BorderStyle.solid,
                color: Colors.black.withOpacity(0.3)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 0.5,
                  offset: const Offset(0.0, 2.0))
            ]),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: property.isTransition
                  ? () {
                      if (makeTransition is Function) {
                        makeTransition(context, property.id);
                      }
                    }
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PropertyImage(
                      id: property.id,
                      picture: property.picture,
                      statusColor: property.statusColor,
                      statusValue: property.statusValue),
                  PropertyFooter(
                    isInput: property.isInput,
                    currency: property.currency,
                    costSale: property.costSale,
                    costRent: property.costRent,
                    paymentPeriod: property.paymentPeriod,
                    mainInfo: property.mainInfo,
                    address: property.address,
                  ),
                  Container(height: 4.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
