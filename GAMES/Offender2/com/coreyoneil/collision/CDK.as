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
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.errors.EOFError;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;	
	
	public class CDK
	{
		protected var objectArray			:Array;
		protected var objectCheckArray		:Array;
		protected var objectCollisionArray	:Array;
		private var colorExclusionArray		:Array;
		
		private var bmd1					:BitmapData;
		private var bmd2					:BitmapData;
		private var bmdResample				:BitmapData;
		
		private var pixels1					:ByteArray;
		private var pixels2					:ByteArray;
		
		private var rect1					:Rectangle;
		private var rect2					:Rectangle;
		
		private var transMatrix1			:Matrix;
		private var transMatrix2			:Matrix;
		
		private var colorTransform1			:ColorTransform;
		private var colorTransform2			:ColorTransform;
		
		private var item1Registration		:Point;
		private var item2Registration		:Point;
		
		private var _alphaThreshold			:Number;
		private var _returnAngle			:Boolean;
		private var _returnAngleType		:String;
		
		private var _numChildren			:uint;

		public function CDK():void 
		{	
			if(getQualifiedClassName(this) == "com.coreyoneil.collision::CDK")
			{
            	throw new Error('CDK is an abstract class and is not meant for instantiation - use CollisionGroup or CollisionList');
			}
			
			init();
		}
		
		private function init():void
		{			
			objectCheckArray = [];
			objectCollisionArray = [];
			objectArray = [];
			colorExclusionArray = [];
			
			_alphaThreshold = 0;
			_returnAngle = true;
			_returnAngleType = "RADIANS";
		}
		
		public function addItem(obj):void 
		{
			if(obj is DisplayObject)
			{
				objectArray.push(obj);
			}
			else
			{
				throw new Error("Cannot add item: " + obj + " - item must be a Display Object.");
			}
		}
		
		public function removeItem(obj):void 
		{
			var loc:int = objectArray.indexOf(obj);
			if(loc > -1) 
			{
				objectArray.splice(loc, 1);
			}
			else
			{
				throw new Error(obj + " could not be removed - object not found in item list.");
			}
		}
		
		public function excludeColor(theColor:uint, alphaRange:uint = 255, redRange:uint = 20, greenRange:uint = 20, blueRange:uint = 20):void
		{
			var numColors:int = colorExclusionArray.length;
			for(var i:uint = 0; i < numColors; i++)
			{
				if(colorExclusionArray[i].color == theColor)
				{
					throw new Error("Color could not be added - color already in the exclusion list [" + theColor + "]");
					break;
				}
			}
			
			var aPlus:uint, aMinus:uint, rPlus:uint, rMinus:uint, gPlus:uint, gMinus:uint, bPlus:uint, bMinus:uint;
			
			aPlus = (theColor >> 24 & 0xFF) + alphaRange;
			aMinus = aPlus - (alphaRange << 1);
			rPlus = (theColor >> 16 & 0xFF) + redRange;
			rMinus = rPlus - (redRange << 1);
			gPlus = (theColor >> 8 & 0xFF) + greenRange;
			gMinus = gPlus - (greenRange << 1);
			bPlus = (theColor & 0xFF) + blueRange;
			bMinus = bPlus - (blueRange << 1);
			
			var colorExclusion:Object = {color:theColor, aPlus:aPlus, aMinus:aMinus, rPlus:rPlus, rMinus:rMinus, gPlus:gPlus, gMinus:gMinus, bPlus:bPlus, bMinus:bMinus};
			colorExclusionArray.push(colorExclusion);
		}
		
		public function removeExcludeColor(theColor:uint):void
		{
			var found:Boolean = false, numColors:int = colorExclusionArray.length;
			for(var i:uint = 0; i < numColors; i++)
			{
				if(colorExclusionArray[i].color == theColor)
				{
					colorExclusionArray.splice(i, 1);
					found = true;
					break;
				}
			}
			
			if(!found)
			{
				throw new Error("Color could not be removed - color not found in exclusion list [" + theColor + "]");
			}
		}
		
		protected function clearArrays():void
		{
			objectCheckArray = [];
			objectCollisionArray = [];
		}
		
		protected function findCollisions(item1, item2):void
		{
			var item1_isText:Boolean = false, item2_isText:Boolean = false;
			var item1xDiff:Number, item1yDiff:Number;

			if(item1 is TextField)
			{
				item1_isText = (item1.antiAliasType == "advanced") ? true : false;
				item1.antiAliasType = (item1.antiAliasType == "advanced") ? "normal" : item1.antiAliasType;
			}

			if(item2 is TextField)
			{
				item2_isText = (item2.antiAliasType == "advanced") ? true : false;
				item2.antiAliasType = (item2.antiAliasType == "advanced") ? "normal" : item2.antiAliasType;
			}
			
			colorTransform1 = item1.transform.colorTransform;
			colorTransform2 = item2.transform.colorTransform;
			
			item1Registration = new Point();
			item2Registration = new Point();

			item1Registration = item1.localToGlobal(item1Registration);
			item2Registration = item2.localToGlobal(item2Registration);
			
			bmd1 = new BitmapData(item1.width, item1.height, true, 0x00FFFFFF);  
			bmd2 = new BitmapData(item1.width, item1.height, true, 0x00FFFFFF);
			
			transMatrix1 = item1.transform.matrix;
			
			var currentObj = item1;
			while(currentObj.parent != null)
			{
				transMatrix1.concat(currentObj.parent.transform.matrix);
				currentObj = currentObj.parent;
			}
			
			rect1 = item1.getBounds(currentObj);
			if(item1 != currentObj)
			{
				rect1.x += currentObj.x;
				rect1.y += currentObj.y;
			}
			
			transMatrix1.tx = item1xDiff = (item1Registration.x - rect1.left);
			transMatrix1.ty = item1yDiff = (item1Registration.y - rect1.top);
			
			transMatrix2 = item2.transform.matrix;
			
			currentObj = item2;
			while(currentObj.parent != null)
			{
				transMatrix2.concat(currentObj.parent.transform.matrix);
				currentObj = currentObj.parent;
			}
			
			transMatrix2.tx = (item2Registration.x - rect1.left);
			transMatrix2.ty = (item2Registration.y - rect1.top);
			
			bmd1.draw(item1, transMatrix1, colorTransform1, null, null, true);
			bmd2.draw(item2, transMatrix2, colorTransform2, null, null, true);
			
			pixels1 = bmd1.getPixels(new Rectangle(0, 0, bmd1.width, bmd1.height));
			pixels2 = bmd2.getPixels(new Rectangle(0, 0, bmd1.width, bmd1.height));	
			
			var k:uint = 0, value1:uint = 0, value2:uint = 0, collisionPoint:Number = -1, overlap:Boolean = false, overlapping:Array = [];
			var locY:Number, locX:Number, locStage:Point, hasColors:int = colorExclusionArray.length;
			
			pixels1.position = 0;
			pixels2.position = 0;
			
			var pixelLength:int = pixels1.length;
			while(k < pixelLength)
			{
				k = pixels1.position;
				
				try
				{
					value1 = pixels1.readUnsignedInt();
					value2 = pixels2.readUnsignedInt();
				}
				catch(e:EOFError)
				{
					break;
				}
				
				var alpha1:uint = value1 >> 24 & 0xFF, alpha2:uint = value2 >> 24 & 0xFF;
				
				if(alpha1 > _alphaThreshold && alpha2 > _alphaThreshold)
				{	
					var colorFlag:Boolean = false;
					if(hasColors)
					{
						var red1:uint = value1 >> 16 & 0xFF, red2:uint = value2 >> 16 & 0xFF, green1:uint = value1 >> 8 & 0xFF, green2:uint = value2 >> 8 & 0xFF, blue1:uint = value1 & 0xFF, blue2:uint = value2 & 0xFF;
						
						var colorObj:Object, aPlus:uint, aMinus:uint, rPlus:uint, rMinus:uint, gPlus:uint, gMinus:uint, bPlus:uint, bMinus:uint, item1Flags:uint, item2Flags:uint;
						
						for(var n:uint = 0; n < hasColors; n++)
						{
							colorObj = Object(colorExclusionArray[n]);
							
							item1Flags = 0;
							item2Flags = 0;
							if((blue1 >= colorObj.bMinus) && (blue1 <= colorObj.bPlus))
							{
								item1Flags++;
							}
							if((blue2 >= colorObj.bMinus) && (blue2 <= colorObj.bPlus))
							{
								item2Flags++;
							}
							if((green1 >= colorObj.gMinus) && (green1 <= colorObj.gPlus))
							{
								item1Flags++;
							}
							if((green2 >= colorObj.gMinus) && (green2 <= colorObj.gPlus))
							{
								item2Flags++;
							}
							if((red1 >= colorObj.rMinus) && (red1 <= colorObj.rPlus))
							{
								item1Flags++;
							}
							if((red2 >= colorObj.rMinus) && (red2 <= colorObj.rPlus))
							{
								item2Flags++;
							}
							if((alpha1 >= colorObj.aMinus) && (alpha1 <= colorObj.aPlus))
							{
								item1Flags++;
							}
							if((alpha2 >= colorObj.aMinus) && (alpha2 <= colorObj.aPlus))
							{
								item2Flags++;
							}
							
							if((item1Flags == 4) || (item2Flags == 4)) colorFlag = true;
						}
					}
					
					if(!colorFlag)
					{
						overlap = true;

						collisionPoint = k >> 2;
						
						locY = collisionPoint / bmd1.width, locX = collisionPoint % bmd1.width;
			
						locY -= item1yDiff;
						locX -= item1xDiff;
						
						locStage = item1.localToGlobal(new Point(locX, locY));
						overlapping.push(locStage);
					}
				}
			}
			
			if(overlap)
			{
				var angle:Number = _returnAngle ? findAngle(item1, item2) : 0;
				var recordedCollision:Object = {object1:item1, object2:item2, angle:angle, overlapping:overlapping}
				objectCollisionArray.push(recordedCollision);
			}
			
			if(item1_isText) item1.antiAliasType = "advanced";

			if(item2_isText) item2.antiAliasType = "advanced";
			
			item1_isText = item2_isText = false;
		}
		
		private function findAngle(item1:DisplayObject, item2:DisplayObject):Number
		{
			var center:Point = new Point((item1.width >> 1), (item1.height >> 1));
			var pixels:ByteArray = pixels2;
			transMatrix2.tx += center.x;
			transMatrix2.ty += center.y;
			bmdResample = new BitmapData(item1.width << 1, item1.height << 1, true, 0x00FFFFFF);
			bmdResample.draw(item2, transMatrix2, colorTransform2, null, null, true);
			pixels = bmdResample.getPixels(new Rectangle(0, 0, bmdResample.width, bmdResample.height));

			center.x = bmdResample.width >> 1;
			center.y = bmdResample.height >> 1;
			
			var columnHeight:uint = Math.round(bmdResample.height);
			var rowWidth:uint = Math.round(bmdResample.width);
			
			var pixel:uint, thisAlpha:uint, lastAlpha:int, edgeArray:Array = [], hasColors:int = colorExclusionArray.length;

			for(var j:uint = 0; j < columnHeight; j++)
			{
				var k:uint = (j * rowWidth) << 2;
				pixels.position = k;
				lastAlpha = -1;
				var upperLimit:int = ((j + 1) * rowWidth) << 2;
				while(k < upperLimit)
				{
					k = pixels.position;
					
					try
					{
						pixel = pixels.readUnsignedInt();
					}
					catch(e:EOFError)
					{
						break;
					}
					
					
					thisAlpha = pixel >> 24 & 0xFF;
					
					if(lastAlpha == -1)
					{
						lastAlpha = thisAlpha;
					}
					else
					{
						if(thisAlpha > _alphaThreshold)
						{
							var colorFlag:Boolean = false;
							if(hasColors)
							{
								var red1:uint = pixel >> 16 & 0xFF, green1:uint = pixel >> 8 & 0xFF, blue1:uint = pixel & 0xFF;
								
								var colorObj:Object, a:uint, r:uint, g:uint, b:uint, item1Flags:uint;
								
								for(var n:uint = 0; n < hasColors; n++)
								{
									colorObj = Object(colorExclusionArray[n]);
									
									item1Flags = 0;
									if((blue1 >= colorObj.bMinus) && (blue1 <= colorObj.bPlus))
									{
										item1Flags++;
									}
									if((green1 >= colorObj.gMinus) && (green1 <= colorObj.gPlus))
									{
										item1Flags++;
									}
									if((red1 >= colorObj.rMinus) && (red1 <= colorObj.rPlus))
									{
										item1Flags++;
									}
									if((thisAlpha >= colorObj.aMinus) && (thisAlpha <= colorObj.aPlus))
									{
										item1Flags++;
									}									
									if(item1Flags == 4)
									{
										colorFlag = true;
									}
								}
							}
							
							if(!colorFlag) edgeArray.push(k >> 2);
						}
					}
				}
			}
			
			var edgePoint:int, numEdges:int = edgeArray.length;
			var slopeYAvg:Number = 0, slopeXAvg:Number = 0
			for(j = 0; j < numEdges; j++)
			{
				edgePoint = int(edgeArray[j]);
				
				slopeYAvg += center.y - (edgePoint / rowWidth);
				slopeXAvg += (edgePoint % rowWidth) - center.x;
			}
			
			var average:Number = -Math.atan2(slopeYAvg, slopeXAvg);

			average = _returnAngleType == "RADIANS" ? average : average * 57.2957795;
			
			return average;
		}
		
		public function dispose():void
		{
			objectArray = [];
		}
		
		public function set alphaThreshold(theAlpha:Number):void
		{
			if((theAlpha <= 1) && (theAlpha >= 0))
			{
				_alphaThreshold = theAlpha * 255;
			}
			else
			{
				throw new Error("alphaThreshold expects a value from 0 to 1");
			}
		}
		
		public function get alphaThreshold():Number
		{
			return _alphaThreshold;
		}
		
		public function get returnAngle():Boolean
		{
			return _returnAngle;
		}
		
		public function set returnAngle(value:Boolean):void
		{
			_returnAngle = value;
		}
		
		public function set returnAngleType(returnType:String):void
		{
			returnType = returnType.toUpperCase();
			
			switch (returnType)
			{
				case "DEGREES" :
				case "DEGREE" :
				case "DEG" :
				case "DEGS" :
					_returnAngleType = "DEGREES";
					break;
				case "RADIANS" :
				case "RADIAN" :
				case "RAD" :
				case "RADS" :
					_returnAngleType = "RADIANS";
					break;
				default :
					throw new Error("returnAngleType expects 'DEGREES' or 'RADIANS'");
					break;
			}
		}
		
		public function get returnAngleType():String
		{
			return _returnAngleType;
		}
		
		public function get numChildren():uint
		{
			return objectArray.length;
		}
	}
}