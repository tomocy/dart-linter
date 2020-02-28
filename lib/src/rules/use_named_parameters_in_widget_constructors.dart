// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../analyzer.dart';
import '../util/flutter_utils.dart';

const _desc = r'Widgetのコンストラクターの引数は名前付き引数にする.';

const _details = r'''

**DO** Widgetのコンストラクターの引数を名前付き引数にする

**BAD:**
```
class Bad extends StatelessWidget {
  Bad(Key key, this.title) : super(key: key);

  final String title;
}
```

**GOOD:**
class Good extends StatelessWidget {
  Bad({Key key, this.title}) : super(key: key);
  
  final String title;
}
```

```

''';

class UseNamedParametersInWidgetConstructors extends LintRule
    implements NodeLintRule {
  UseNamedParametersInWidgetConstructors()
      : super(
            name: 'use_named_parameters_in_widget_constructors',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  void registerNodeProcessors(NodeLintRegistry registry,
      [LinterContext context]) {
    final visitor = _Visitor(this);
    registry.addClassDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor {
  final LintRule rule;

  _Visitor(this.rule);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declared = node.declaredElement;
    if (!isWidgetType(declared.thisType)) {
      return;
    }

    declared.constructors.forEach((element) {
      if (element.parameters.every((parameter) => parameter.isNamed)) {
        return;
      }

      final name = element.name != '' ? element.name : null;
      rule.reportLint(node.getConstructor(name));
    });
  }
}
