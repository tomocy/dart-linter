// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// test w/ `pub run test -N use_named_pararmeters_in_widget_constructors`
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class A extends StatelessWidget {
  A({Key key, this.title}) : super(key: key); // OK

  final String title;
}

class B extends StatelessWidget {
  B(Key key, this.title) : super(key: key); // LINT

  B.withTitle(this.title); // LINT

  final String title;
}

class C {
  C(this.title); // OK Widgetではないから

  final String title;
}
