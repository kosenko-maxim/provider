import 'package:meta/meta.dart' show required;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocListener, BlocBuilder;
import 'package:flutter_masked_text/flutter_masked_text.dart'
    show MoneyMaskedTextController;

import '../../blocs/component/component_bloc.dart' show ComponentBloc;
import '../../blocs/component/component_event.dart' show ComponentEvent;
import '../../blocs/component/component_state.dart'
    show
        ComponentState,
        ComponentIsFetching,
        ComponentFetchingSuccess,
        ComponentFetchingError;
import '../../models/screen/components/item_model.dart';
import '../../models/screen/components/item_model.dart' show ItemModel;
import '../../utils/show_alert.dart' show showError;

import '../components/page_template.dart' show PageTemplate;
import '../components/pickers/money_picker.dart' show MoneyPicker;
import '../components/styled/styled_button.dart' show StyledButton;

import '../helpers/money_controller.dart' show createMoneyController;

class DataEntry extends StatefulWidget {
  const DataEntry(
      {@required this.item,
      @required this.onChanged,
      @required this.componentBloc});

  final ItemModel item;
  final Function onChanged;
  final ComponentBloc componentBloc;

  @override
  State<StatefulWidget> createState() {
    return _DataEntryState();
  }
}

class _DataEntryState extends State<DataEntry> {
  MoneyMaskedTextController _moneyController;

  @override
  void initState() {
    switch (widget.item.typeValue) {
      case 'money':
        _moneyController = createMoneyController(widget.item.value);
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComponentEvent, ComponentState>(
      bloc: widget.componentBloc,
      listener: (BuildContext context, ComponentState state) {
        if (state is ComponentFetchingSuccess) {
          Navigator.of(context).pop();
        }

        if (state is ComponentFetchingError) {
          showError(context, state);
        }
      },
      child: BlocBuilder<ComponentEvent, ComponentState>(
        bloc: widget.componentBloc,
        builder: (BuildContext context, ComponentState state) {
          return PageTemplate(
            title: widget.item.key,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: buildDataEntryWidget(),
                  ),
                ),
                StyledButton(
                  text: 'save',
                  onPressed: _handleSubmit(context),
                  loading: state is ComponentIsFetching,
                ),
              ],
            ),
            padding: true,
          );
        },
      ),
    );
  }

  MoneyPicker buildDataEntryWidget() {
    switch (widget.item.typeValue) {
      case 'money':
        return MoneyPicker(_moneyController);

      default:
        return null;
    }
  }

  Function _handleSubmit(BuildContext context) => () async {
        dynamic value;
        switch (widget.item.typeValue) {
          case 'money':
            value = _moneyController.numberValue * 100;
            break;
        }

        widget.onChanged(value);
      };
}
