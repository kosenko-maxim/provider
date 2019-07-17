import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

import '../../src/ui/components/page_template.dart' show PageTemplate;
import '../../src/ui/components/styled/styled_button.dart' show StyledButton;
import '../../src/ui/components/styled/styled_circular_progress.dart'
    show StyledCircularProgress;
import '../../src/utils/route_transition.dart' show SlideRoute;
import 'components/description.dart' show Description;
import 'components/main_points.dart' show MainPoint;
import 'components/sub_points.dart' show SubPoint;

class HomePage extends StatelessWidget {
  final bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? PageTemplate(
            title: 'My property',
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.only(top: 21),
                                  height: 130,
                                  child:
                                      SvgPicture.asset('lib/assets/dog.svg')),
                              const Padding(
                                  padding: EdgeInsets.only(top: 17),
                                  child: Description()),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 22.0),
                        child: Column(
                          children: const <Widget>[
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: MainPoint(
                                    'Fill in some property information and send it to us',
                                    1)),
                            Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: MainPoint(
                                    'Choose a meeting time on the property and then we will do everything ourselves',
                                    2)),
                            Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: SubPoint(
                                    'Prepare and sign a contract with you')),
                            Padding(
                                padding: EdgeInsets.only(right: 43),
                                child:
                                    SubPoint('Create a virtual property tour')),
                            Padding(
                                padding: EdgeInsets.only(right: 28),
                                child: SubPoint(
                                    'Prepare a property specification')),
                            Padding(
                                padding: EdgeInsets.only(right: 13),
                                child: SubPoint(
                                    'Prepare information for publication')),
                            Padding(
                                padding: EdgeInsets.only(top: 13),
                                child: MainPoint(
                                    'Agree on information for publication', 3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 9, left: 15.0, right: 15.0, bottom: 16),
                  child: StyledButton(text: 'Add property', onPressed: () {}),
                )
              ],
            ))
        : const StyledCircularProgress();
  }
}
