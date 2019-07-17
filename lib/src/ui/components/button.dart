import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener, BlocBuilder;

import '../../blocs/component/component_bloc.dart' show ComponentBloc;
import '../../blocs/component/component_event.dart'
    show ComponentEvent, SendingComponentValueRequested;
import '../../blocs/component/component_state.dart'
    show ComponentState, ComponentIsFetching, ComponentFetchingError;
import '../../blocs/screen/screen_bloc.dart' show ScreenBloc;
import '../../models/screen/components/button_model.dart' show ButtonModel;
import '../../resources/auth_repository.dart' show AuthRepository;
import '../../resources/component_repository.dart' show ComponentRepository;
import '../../utils/show_alert.dart' show showError;

import '../components/styled/styled_button.dart' show StyledButton;

class Button extends StatefulWidget {
  const Button(this.button, this.path, this.screenBloc);

  final ButtonModel button;
  final String path;
  final ScreenBloc screenBloc;

  @override
  State<StatefulWidget> createState() {
    return _ButtonState();
  }
}

class _ButtonState extends State<Button> {
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

  @override
  Widget build(BuildContext context) {
    final ButtonModel button = widget.button;
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
          return StyledButton(
            color: button.color,
            text: button.key,
            onPressed: button.isAble
                ? () async {
              componentBloc.dispatch(SendingComponentValueRequested(
                route: '${widget.path}/${button.id}',
                value: button.typeQuery == 'PUT' ? button.value : null,
                typeQuery: button.typeQuery,
              ));
            }
                : null,
            loading: state is ComponentIsFetching,
          );
        },
      ),
    );
  }
}
