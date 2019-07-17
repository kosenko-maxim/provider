import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocListener, BlocProvider, BlocBuilder;

import '../../../blocs/component/component_bloc.dart' show ComponentBloc;
import '../../../blocs/component/component_event.dart'
    show
        ComponentEvent,
        SendingComponentValueRequested,
        FileUploadingStart,
        FileUploadingCanceled;
import '../../../blocs/component/component_state.dart'
    show ComponentState, ComponentIsFetching, ComponentFetchingError;
import '../../../blocs/screen/screen_bloc.dart' show ScreenBloc;
import '../../../constants/layout.dart' show heightSwitch;
import '../../../models/screen/components/item_model.dart';
import '../../../resources/auth_repository.dart' show AuthRepository;
import '../../../resources/component_repository.dart' show ComponentRepository;

import '../../../utils/show_alert.dart' show showError;
import '../../../utils/type_check.dart' show isNotNull;

import '../../components/styled/styled_circular_progress.dart'
    show StyledCircularProgress;
import '../../helpers/money_controller.dart' show formatCost;
import '../../pages/data_entry.dart' show DataEntry;
import '../pickers/date_picker/date_picker_modal.dart' show openDatePicker;
import '../pickers/list_picker/list_picker_modal.dart' show openListPicker;
import '../pickers/photo_uploader.dart' show openPhotoUploader;
import './item_layout.dart' show ItemLayout;

class Item extends StatefulWidget {
  Item(this.item, this.path, this.makeTransition, this.screenBloc)
      : id = item.id;

  final ItemModel item;
  final String path;
  final Function makeTransition;
  final ScreenBloc screenBloc;
  final String id;

  @override
  State<StatefulWidget> createState() {
    return _ItemState();
  }
}

class _ItemState extends State<Item> {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  ComponentBloc componentBloc;

  @override
  void initState() {
    componentBloc = ComponentBloc(
        screenBloc: widget.screenBloc,
        authRepository: AuthRepository(),
        componentRepository: ComponentRepository());
    super.initState();
  }

  @override
  void dispose() {
    componentBloc.dispose();
    super.dispose();
  }

  bool get isTapable => widget.item.isTransition || widget.item.isInput;

  Future<void> onChanged(dynamic value, {dynamic body}) async {
    componentBloc.dispatch(SendingComponentValueRequested(
      route: '${widget.path}/${widget.item.id}',
      value: value,
      body: body,
    ));
  }

  Function onTap(BuildContext context) => () {
        final ItemModel item = widget.item;
        if (item.isTransition) {
          widget.makeTransition(context, item.id);
        } else if (item.isInput) {
          if (isNotNull(item.list)) {
            openListPicker(context,
                initialItem: item.value, onOk: onChanged, listItems: item.list);
            return;
          }
          switch (item.typeValue) {
            case 'date':
              openDatePicker(
                context,
                minimumDate: item.min,
                initialDateTime: item.value,
                maximumDate: item.max,
                onOk: onChanged,
              );
              break;
            case 'money':
              openDataEntry(context);
              break;
            case 'photo':
              openPhotoUploader(context, onChoose: () {
                componentBloc.dispatch(FileUploadingStart());
              }, onLoad: (Future<File> cb) async {
                final File photo = await cb;
                if (photo != null) {
                  onChanged(item.value, body: photo);
                } else {
                  componentBloc.dispatch(FileUploadingCanceled());
                }
              });
              break;
            case 'switch':
              onChanged(!item.value);
              break;
            default:
              return;
          }
        }
      };

  void openDataEntry(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => DataEntry(
          item: widget.item,
          onChanged: onChanged,
          componentBloc: componentBloc,
        ),
      ),
    );
  }

  Object buildSuffix(BuildContext context, ComponentState state) {
    if (state is ComponentIsFetching) {
      return Container(
        height: heightSwitch,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(right: 12),
                child: const StyledCircularProgress(size: 'sm')),
          ],
        ),
      );
    }

    final ItemModel item = widget.item;
    switch (item.typeValue) {
      case 'date':
        return isNotNull(item.value)
            ? formatter.format(DateTime.fromMillisecondsSinceEpoch(item.value))
            : null;
      case 'switch':
        return renderSwitch(context);
      case 'money':
        return formatCost(item.value);
      default:
        return item.value?.toString();
    }
  }

  Widget renderSwitch(BuildContext context) {
    final ItemModel item = widget.item;
    return Container(
      height: heightSwitch,
      child: Switch(
        activeColor: Theme.of(context).primaryColor,
        value: item.value,
        onChanged: item.isInput ? onChanged : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ItemModel item = widget.item;
    return BlocListener<ComponentEvent, ComponentState>(
      bloc: componentBloc,
      listener: (BuildContext context, ComponentState state) {
        if (state is ComponentFetchingError) {
          showError(context, state);
        }
      },
      child: BlocBuilder<ComponentEvent, ComponentState>(
        bloc: componentBloc,
        builder: (BuildContext context, ComponentState state) {
          return ItemLayout(
            picture: item.picture,
            body: item.key,
            suffix: buildSuffix(context, state),
            link: item.isTransition,
            disabled: !item.isInput,
            onTap: isTapable ? onTap(context) : null,
          );
        },
      ),
    );
  }
}
