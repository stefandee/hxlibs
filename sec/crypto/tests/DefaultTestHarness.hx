package sec.crypto.tests;

class DefaultTestHarness implements ITestHarness
{
			private var testCount  : Int;
			private var testFailed : Int;
			//private var testIndex  : Int;

			public function new()
      {
        testCount  = 0;
        testFailed = 0;
      }
      
      // ITestHarness
			public function beginTestCase(name:String):Void {
//				writeln("BEGIN: "+name);
			}
			public function endTestCase():Void {
//				writeln("END.");
			}
			public function beginTest(name:String):Void {
				trace("  - "+name+"... ");
			}
			public function passTest():Void {
				trace("TEST OK");
				testCount++;
			}
			public function failTest(msg:String):Void {
				trace("TEST FAIL! (reason: " + msg + ")");
				testCount++;
				testFailed++;
			}
}
