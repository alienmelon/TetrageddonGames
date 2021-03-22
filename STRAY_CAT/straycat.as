import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

/*
small round cat
pet it and it purrs
runs arround
falls asleep
pick up
looks at you curiously

right mouse = pet
left mouse = carry
*/


stage.align = StageAlign.TOP_LEFT;
stage.scaleMode = StageScaleMode.NO_SCALE;

var window = stage.nativeWindow;
window.alwaysInFront = true;

////////////////////////////////////

var arr_states:Array = new Array("walk", "walk", "walk", "idle", "sit", "sleep", "cleaning");
//event based states:
//"pickup", "drop"
//pet

var arr_window_land:Array = new Array(new AUD_PLOP01(), new AUD_PLOP02(), new AUD_PLOP03(), new AUD_PLOP04(), new AUD_PLOP05(), new AUD_PLOP06(), new AUD_PLOP07(), new AUD_PLOP08(), new AUD_PLOP09(), new AUD_PLOP10(), new AUD_PLOP11(), new AUD_PLOP12(), new AUD_PLOP13(), new AUD_PLOP14(), new AUD_PLOP15(), new AUD_PLOP16(), new AUD_PLOP17(), new AUD_PLOP18());

var arr_meoo_long:Array = new Array(new AUD_STRAYCAT_MEOO_SHORT_17(), new AUD_STRAYCAT_MEOO_01(), new AUD_STRAYCAT_MEOO_02(), new AUD_STRAYCAT_MEOO_03(), new AUD_STRAYCAT_MEOO_04(), new AUD_STRAYCAT_MEOO_05(), new AUD_STRAYCAT_MEOO_06(), new AUD_STRAYCAT_MEOO_07(), new AUD_STRAYCAT_MEOO_08(), new AUD_STRAYCAT_MEOO_09(), new AUD_STRAYCAT_MEOO_10(), new AUD_STRAYCAT_MEOO_11(), new AUD_STRAYCAT_MEOO_12(), new AUD_STRAYCAT_MEOO_13(), new AUD_STRAYCAT_MEOO_14(), new AUD_STRAYCAT_MEOO_15(), new AUD_STRAYCAT_MEOO_16(), new AUD_STRAYCAT_MEOO_17(), new AUD_STRAYCAT_MEOO_18(), new AUD_STRAYCAT_MEOO_19(), new AUD_STRAYCAT_MEOO_20(), new AUD_STRAYCAT_MEOO_21(), new AUD_STRAYCAT_MEOO_22(), new AUD_STRAYCAT_MEOO_23(), new AUD_STRAYCAT_MEOO_24(), new AUD_STRAYCAT_MEOO_25());
var arr_meoo_short:Array = new Array(new AUD_STRAYCAT_MEOO_SHORT_01(), new AUD_STRAYCAT_MEOO_SHORT_02(), new AUD_STRAYCAT_MEOO_SHORT_03(), new AUD_STRAYCAT_MEOO_SHORT_04(), new AUD_STRAYCAT_MEOO_SHORT_05(), new AUD_STRAYCAT_MEOO_SHORT_06(), new AUD_STRAYCAT_MEOO_SHORT_07(), new AUD_STRAYCAT_MEOO_SHORT_08(), new AUD_STRAYCAT_MEOO_SHORT_09(), new AUD_STRAYCAT_MEOO_SHORT_10(), new AUD_STRAYCAT_MEOO_SHORT_11(), new AUD_STRAYCAT_MEOO_SHORT_12(), new AUD_STRAYCAT_MEOO_SHORT_13(), new AUD_STRAYCAT_MEOO_SHORT_14(), new AUD_STRAYCAT_MEOO_SHORT_15(), new AUD_STRAYCAT_MEOO_SHORT_16());

var chan_sndfx:SoundChannel = new SoundChannel();
var trans_sndfx:SoundTransform = new SoundTransform(.3, 0);

var chan_cat:SoundChannel = new SoundChannel();

//the stage's window w/h
var num_windowWidth:Number = window.width;
var num_windowHeight:Number = window.height;
//the actual monitor/screen width / height
var num_resolutionWidth:Number = Screen.mainScreen.bounds.width;
var num_resolutionHeight:Number = Screen.mainScreen.bounds.height;

//target numbers (for moving)
var num_targ_x:Number = num_resolutionWidth/2;
var num_speedX:Number = 0.005;

var num_stateCountdown:Number = 50;

//window is being dragged
var bool_mouseDown:Boolean = false;

var str_currState = "drop";
var str_direction = "right";

//GRAVITY
//set up unique variables for gravity...
var num_grav_xPos:Number;
var num_grav_yPos:Number;
var num_grav_xVel:Number;
var num_grav_yVel:Number;
var num_grav:Number;
var num_grav_prevY:Number;
//countdown till reset
var num_grav_cnt:Number;
var bool_grav_hitG:Boolean;

////////////////////////////////////
//SETUP

function init_window(){
	window.x = Math.ceil(Screen.mainScreen.bounds.width - num_windowWidth)/2;
	window.y = num_windowHeight;//num_windowHeight;//Math.ceil(Screen.mainScreen.bounds.height - num_windowHeight)/2;
}

function randRange(num_min:Number, num_max:Number){
	return Math.ceil(num_min + (num_max - num_min) * Math.random());
}

function randArr(arr:Array){
	return arr[Math.ceil(Math.random()*arr.length)-1];
}

function get_randTarg(){
	//default or extreme value...
	if(Math.random()* 100 > 50){
		num_targ_x = randRange(0, Screen.mainScreen.bounds.width);
	}else{
		//force to extreme...
		if(Math.random()* 100 > 50){
			num_targ_x = 0;
		}else{
			num_targ_x = Screen.mainScreen.bounds.width;
		}
	}
}

//PLAYHEAD
function playAnimation(str_label:String){
	if(mc_clip.currentLabel != str_label){
		mc_clip.gotoAndStop(str_label);
	}
}

////////////////////////////////////
//STATES

function new_state(){
	
	var str_oldState:String = str_currState;
	
	if(Math.random()*100 > 50){
		//new state
		str_currState = randArr(arr_states);
	}
	
	//possible natural progression to sleeping...
	if(str_oldState == "idle" && str_currState == "idle" && Math.random()*100 > 60){
		str_currState = "sit";
	}
	if(str_oldState == "sit" && str_currState == "sit"){
		str_currState = "cleaning";
	}
	if(str_oldState == "cleaning" && str_currState == "cleaning"){
		str_currState = "sleep";
	}
	//if repeating...
	if(str_oldState == str_currState){
		//walk
		str_currState = "walk";
		snd_purr();
	}
	
	//set playhead
	set_state(str_currState);
}

function set_state(strState:String){
	str_currState = strState;
	num_stateCountdown = randRange(50, 200);
	get_randTarg();
	playAnimation(strState);
	
	//cat noise
	if(Math.random()*100 > 50){
		snd_meoo();
	};
}

function speed_walk(){
	num_speedX = 0.002;
	snd_footstep();
}

function speed_stop(){
	num_speedX = 0;
	snd_footstep();
}

////////////////////////////////////
//SOUND



function snd_footstep(){
	chan_sndfx.stop();
	chan_sndfx = randArr(arr_window_land).play();
	chan_sndfx.soundTransform = trans_sndfx;
}

function snd_purr(){
	chan_cat.stop();
	chan_cat = randArr(arr_meoo_short).play();
	//chan_cat.soundTransform = trans_sndfx;
}

function snd_meoo(){
	chan_cat.stop();
	chan_cat = randArr(arr_meoo_long).play();
}

//random long or short
function snd_randMeoo(){
	chan_cat.stop();
	if(Math.random()*100 > 50){
		chan_cat = randArr(arr_meoo_long).play();
	}else{
		chan_cat = randArr(arr_meoo_short).play();
	}
}

////////////////////////////////////
//ANIMATION

function move(event:Event){
	
	//count down till next
	num_stateCountdown -= 1;
	
	//handle state
	if(num_stateCountdown > 0 && !bool_mouseDown){
		
		if(str_currState == "walk"){
			//movement, etc...
			event_move();
		};
		
	}
	
	if(num_stateCountdown <= 0 && !bool_mouseDown){
		//if zero, set again
		//set new state
		new_state();
	}
	
	//reset petting - in case not canceled...
	if(num_stateCountdown <= 0 && bool_mouseDown){
		this.removeEventListener(Event.ENTER_FRAME, event_petting);
		bool_mouseDown = false;
		new_state();
	}
}



function event_move(){
	//
	var num_targ_x:Number = num_targ_x;
	//
	var num_distX:Number = num_targ_x - window.x;
	//
	window.x = Math.ceil(window.x + num_distX * num_speedX);
	//face direction
	if(num_targ_x > window.x){
		//
		if(str_direction != "right"){
			mc_clip.scaleX *= -1;
		}
		//
		str_direction = "right";
	}
	if(num_targ_x < window.x){
		//
		if(str_direction != "left"){
			mc_clip.scaleX *= -1;
		}
		//
		str_direction = "left";
	}
}

////////////////////////////////////
//GRAVITY

function reset_window_fall(){
	//
	num_grav_xPos = window.x;
	num_grav_yPos = window.y;
	num_grav_xVel = Math.ceil(Math.random() * 10) - 5;
	num_grav_yVel = Math.ceil(Math.random() * -10) - 10;
	num_grav = Math.ceil(Math.random() * 2);
	num_grav_prevY = window.y;
	//countdown till reset
	num_grav_cnt = Math.ceil(Math.random()*10)+20;
	bool_grav_hitG = false;
}

//call to start falling, this happens when picking up and dropping...
function start_falling(curr_win){
	reset_window_fall();
	//
	playAnimation("drop");
	//
	snd_randMeoo();
	//
	this.removeEventListener(Event.ENTER_FRAME, window_fall);
	this.removeEventListener(Event.ENTER_FRAME, event_petting);
	this.addEventListener(Event.ENTER_FRAME, window_fall);
}


function window_fall(event:Event):void
{
	//
	num_grav_yVel +=  num_grav;
	num_grav_xPos +=  num_grav_xVel;
	num_grav_yPos +=  num_grav_yVel;
	//
	if (num_grav_yPos > Screen.mainScreen.bounds.height - window.height)
	{
		num_grav_yVel *=  -.10;
		num_grav_xVel *=  .7;
	}
	//update position with above...
	window.x = num_grav_xPos;
	window.y = num_grav_yPos;
	//if it hit the bottom
	if(num_grav_yPos >= Screen.mainScreen.bounds.height - window.height){
		//countdown till reset
		num_grav_cnt -= 1;
		//hid the ground - play sound & reset
		if(!bool_grav_hitG){
			//
			snd_footstep();
			this.removeEventListener(Event.ENTER_FRAME, window_fall);
			this.removeEventListener(Event.ENTER_FRAME, event_petting);
			this.addEventListener(Event.ENTER_FRAME, move);
			set_state("idle");
			num_stateCountdown = 10;
			//INIT STATE HERE
			//
		};
		//
		bool_grav_hitG = true;
		//
	}
	//keep at bottom, don't go further
	if(bool_grav_hitG){
		window.y = Screen.mainScreen.bounds.height - window.height;
	}
	//set the previous y position before updating - eventually the above condition returns true...
	num_grav_prevY = window.y;
}

////////////////////////////////////

//picked up
function event_window_MOVING(event:Event){
	//
	this.removeEventListener(Event.ENTER_FRAME, window_fall);
	this.removeEventListener(Event.ENTER_FRAME, move);
	this.removeEventListener(Event.ENTER_FRAME, event_petting);
	playAnimation("pickup");
	//
}

function event_window_DROP(event:MouseEvent){
	start_falling(window);
}

function event_window_PICKUP(e:MouseEvent)
{
	snd_randMeoo();
    stage.nativeWindow.startMove();
}

////////////////////////////////////
//PETTING

function event_petCat(event:MouseEvent){
	if(bool_grav_hitG){
		bool_mouseDown = true;
		this.addEventListener(Event.ENTER_FRAME, event_petting);
	}
}
function event_petCatDone(event:MouseEvent){
	//if done petting, go to sleep state
	if(bool_grav_hitG){
		bool_mouseDown = false;
		this.removeEventListener(Event.ENTER_FRAME, event_petting);
		set_state("sleep");
	}
}

function event_petting(event:Event){
	playAnimation("pet");
	//play sound
	if(Math.random()*100 > 90){
		snd_randMeoo();
	}
	//countdown to release in above main listener, force set to false
}

////////////////////////////////////
//INIT

mc_clip.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, event_petCat);
mc_clip.addEventListener(MouseEvent.RIGHT_MOUSE_UP, event_petCatDone);

mc_clip.addEventListener(MouseEvent.MOUSE_DOWN, event_window_PICKUP);
mc_clip.addEventListener(MouseEvent.MOUSE_UP, event_window_DROP);

init_window();
start_falling(window);

window.addEventListener(NativeWindowBoundsEvent.MOVING, event_window_MOVING);
