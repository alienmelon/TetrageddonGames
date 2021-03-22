/*

Licensed under the MIT License

Copyright (c) 2008 Corey O'Neil
www.coreyoneil.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package com.coreyoneil.collision
{	
	import flash.display.DisplayObject;

	public class CollisionGroup extends CDK
	{
		public function CollisionGroup(... objs):void 
		{
			for(var i:uint = 0; i < objs.length; i++)
			{
				addItem(objs[i]);
			}
		}
		
		public function checkCollisions():Array
		{
			clearArrays();
			
			var NUM_OBJS:uint = objectArray.length, item1:DisplayObject, item2:DisplayObject;
			for(var i:uint = 0; i < NUM_OBJS - 1; i++)
			{
				item1 = DisplayObject(objectArray[i]);
				
				for(var j:uint = i + 1; j < NUM_OBJS; j++)
				{
					item2 = DisplayObject(objectArray[j]);
					
					if(item1.hitTestObject(item2))
					{
						if((item2.width * item2.height) > (item1.width * item1.height))
						{
							objectCheckArray.push([item1,item2])
						}
						else
						{
							objectCheckArray.push([item2,item1]);
						}
					}
				}
			}
			
			NUM_OBJS = objectCheckArray.length;
			for(i = 0; i < NUM_OBJS; i++)
			{
				findCollisions(DisplayObject(objectCheckArray[i][0]), DisplayObject(objectCheckArray[i][1]));
			}
			
			return objectCollisionArray;
		}
	}
}