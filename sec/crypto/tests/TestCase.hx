/**
 * TestCase
 * 
 * Embryonic unit test support class.
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.tests;

class TestCase 
{
  public var harness:ITestHarness;
  
  public function new(h:ITestHarness, title:String) {
    harness = h;
    harness.beginTestCase(title);
  }
  
  
  public function assert(msg:String, value:Bool):Void {
    if (value) {
//				TestHarness.print("+ ",msg);
      return;
    }
    throw new flash.Error("Test Failure:"+msg);
  }
  
  public function runTest(f:Void->Void, title:String):Void {
    harness.beginTest(title);
    try {
      f();
    } catch (e:flash.Error) {
      trace("EXCEPTION THROWN: "+e);
      trace(e.getStackTrace());
      harness.failTest(e.message);
      return;
    }
    harness.passTest();
  }
}
