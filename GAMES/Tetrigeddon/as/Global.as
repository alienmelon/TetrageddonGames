﻿/*** Include file contains all global variables*/var score:Number;var plyr_name:String = "";var NUM_BLOCKS_X:Number;var GRID_START_X:Number;var GRID_END_X:Number;var NUM_BLOCKS_Y:Number;var NUM_BLOCK_GRAPHICS:Number;var BLOCK_SIZE:Number;var BLOCK_SPACING:Number;var SCREEN_WIDTH:Number;var SCREEN_HEIGHT:Number;var ARR_ENEMIES:Array = new Array(); //all enemy sprites are stored here for removalvar ARR_DISPLAY:Array = new Array(); //any display elements (gibs, onomatopoeia) that are added during playvar ARR_INTERVALS:Array = new Array(); //intervals are stored here for removal later - this is one of the reasons all intervals should eventually be replaced with timers.var stopGame:Boolean = false;//Root refferencesvar mainAudioLoopStarted:Boolean;var spaceUp:Boolean;