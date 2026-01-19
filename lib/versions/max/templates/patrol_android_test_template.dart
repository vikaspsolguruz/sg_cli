part of '../max.dart';

String _patrolAndroidTestTemplate(String packageName) {
  // Convert package name to path (e.g., com.example.app -> com/example/app)
  final packagePath = packageName.replaceAll('.', '/');
  
  return '''
package $packageName;

import androidx.test.platform.app.InstrumentationRegistry;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import pl.leancode.patrol.PatrolJUnitRunner;

@RunWith(Parameterized.class)
public class MainActivityTest {
    @Parameters(name = "{0}")
    public static Object[] testCases() {
        PatrolJUnitRunner instrumentation = (PatrolJUnitRunner) InstrumentationRegistry.getInstrumentation();
        // Use MainActivity.class for standard setup
        // Replace with io.flutter.embedding.android.FlutterActivity.class
        // if your AndroidManifest uses android:name="io.flutter.embedding.android.FlutterActivity"
        instrumentation.setUp(MainActivity.class);
        instrumentation.waitForPatrolAppService();
        return instrumentation.listDartTests();
    }

    public MainActivityTest(String dartTestName) {
        this.dartTestName = dartTestName;
    }

    private final String dartTestName;

    @Test
    public void runDartTest() {
        PatrolJUnitRunner instrumentation = (PatrolJUnitRunner) InstrumentationRegistry.getInstrumentation();
        instrumentation.runDartTest(dartTestName);
    }
}
''';
}
