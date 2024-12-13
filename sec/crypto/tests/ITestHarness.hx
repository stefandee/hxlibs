/**
 * ITestHarness
 * 
 * An interface to specify what's available for test cases to use.
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.tests;

interface ITestHarness
{
  function beginTestCase(name:String):Void;
  function endTestCase():Void;
  
  function beginTest(name:String):Void;
  function passTest():Void;
  function failTest(msg:String):Void;
}
