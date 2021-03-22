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
	
	public class CollisionList extends CDK
	{
		public function CollisionList(target, ... objs):void 
		{
			addItem(target);
			
			for(var i:uint = 0; i < objs.length; i++)
			{
				addItem(objs[i]);
			}
		}
		
		public function checkCollisions():Array
		{
			clearArrays();
			
			var NUM_OBJS:uint = objectArray.length;
			var item1 = DisplayObject(objectArray[0]), item2:DisplayObject;
			for(var i:uint = 1; i < NUM_OBJS; i++)
			{
				item2 = DisplayObject(objectArray[i]);
					
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
			
			NUM_OBJS = objectCheckArray.length;
			for(i = 0; i < NUM_OBJS; i++)
			{
				findCollisions(DisplayObject(objectCheckArray[i][0]), DisplayObject(objectCheckArray[i][1]));
			}
			
			return objectCollisionArray;
		}
		
		public function swapTarget(target):void
		{
			if(target is DisplayObject)
			{
				objectArray[0] = target;
			}
			else
			{
				throw new Error("Cannot swap target: " + target + " - item must be a Display Object.");
			}
		}
		
		public override function removeItem(obj):void 
		{
			var loc:int = objectArray.indexOf(obj);
			if(loc > 0)
			{
				objectArray.splice(loc, 1);
			}
			else if(loc == 0)
			{
				throw new Error("You cannot remove the target from CollisionList.  Use swapTarget to change the target.");
			}
			else
			{
				throw new Error(obj + " could not be removed - object not found in item list.");
			}
		}
	}
}