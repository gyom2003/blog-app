
import 'package:blog_flutter_prototype/Home.dart';
import 'package:blog_flutter_prototype/ScriptReferences/parametrePage.dart';
typedef T Constructor<T>();


final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<DrawerPage>(() => DrawerPage());
    register<Parameterpage>(() => Parameterpage());
    
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}