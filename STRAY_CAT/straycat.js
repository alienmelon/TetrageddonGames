/*
	
 __ _                     ___      _      _     
/ _\ |_ _ __ __ _ _   _  / __\__ _| |_   (_)___ 
\ \| __| '__/ _` | | | |/ /  / _` | __|  | / __|
_\ \ |_| | | (_| | |_| / /__| (_| | |_ _ | \__ \
\__/\__|_|  \__,_|\__, \____/\__,_|\__(_)/ |___/
                  |___/                |__/     

by @alienmelon, special thanks to Furnando and Meowchael
	
(a simple javascript file that makes your website appealing to stray internet cats)
*/

//call this to summon the cat to your site
function herekittykittykitty(str_kittyname){
	
	//states for the cat...
	var arr_kitty_states = ["walk1", "walk2", "walk3", "sleeping", "sitting", "petting", "cleaning", "idle"];
	//walking states
	var arr_kitty_walking = ["walk1", "walk2", "walk3"];
	//sound for the cat (for various states...)
	var arr_snd_kitty_petting = ["AUD_STRAYCAT_MEOO_SHORT_01.mp3", "AUD_STRAYCAT_MEOO_SHORT_02.mp3", "AUD_STRAYCAT_MEOO_SHORT_03.mp3", "AUD_STRAYCAT_MEOO_SHORT_04.mp3", "AUD_STRAYCAT_MEOO_SHORT_05.mp3", "AUD_STRAYCAT_MEOO_SHORT_06.mp3", "AUD_STRAYCAT_MEOO_SHORT_07.mp3", "AUD_STRAYCAT_MEOO_SHORT_08.mp3", "AUD_STRAYCAT_MEOO_SHORT_09.mp3", "AUD_STRAYCAT_MEOO_SHORT_10.mp3", "AUD_STRAYCAT_MEOO_SHORT_11.mp3", "AUD_STRAYCAT_MEOO_SHORT_12.mp3", "AUD_STRAYCAT_MEOO_SHORT_13.mp3", "AUD_STRAYCAT_MEOO_SHORT_14.mp3", "AUD_STRAYCAT_MEOO_SHORT_15.mp3", "AUD_STRAYCAT_MEOO_SHORT_16.mp3", "AUD_STRAYCAT_MEOO_SHORT_17.mp3"];
	var arr_snd_kitty_meoo = ["AUD_STRAYCAT_MEOO_01.mp3", "AUD_STRAYCAT_MEOO_02.mp3", "AUD_STRAYCAT_MEOO_03.mp3", "AUD_STRAYCAT_MEOO_04.mp3", "AUD_STRAYCAT_MEOO_05.mp3", "AUD_STRAYCAT_MEOO_06.mp3", "AUD_STRAYCAT_MEOO_07.mp3", "AUD_STRAYCAT_MEOO_08.mp3", "AUD_STRAYCAT_MEOO_09.mp3", "AUD_STRAYCAT_MEOO_10.mp3", "AUD_STRAYCAT_MEOO_11.mp3", "AUD_STRAYCAT_MEOO_12.mp3", "AUD_STRAYCAT_MEOO_13.mp3", "AUD_STRAYCAT_MEOO_14.mp3", "AUD_STRAYCAT_MEOO_15.mp3", "AUD_STRAYCAT_MEOO_16.mp3", "AUD_STRAYCAT_MEOO_17.mp3", "AUD_STRAYCAT_MEOO_18.mp3", "AUD_STRAYCAT_MEOO_19.mp3", "AUD_STRAYCAT_MEOO_20.mp3", "AUD_STRAYCAT_MEOO_21.mp3", "AUD_STRAYCAT_MEOO_22.mp3", "AUD_STRAYCAT_MEOO_23.mp3", "AUD_STRAYCAT_MEOO_24.mp3", "AUD_STRAYCAT_MEOO_25.mp3"]
	var arr_snd_ploop = ["AUD_PLOP18.mp3", "AUD_PLOP01.mp3", "AUD_PLOP02.mp3", "AUD_PLOP03.mp3", "AUD_PLOP04.mp3", "AUD_PLOP05.mp3", "AUD_PLOP06.mp3", "AUD_PLOP07.mp3", "AUD_PLOP08.mp3", "AUD_PLOP09.mp3", "AUD_PLOP10.mp3", "AUD_PLOP11.mp3", "AUD_PLOP12.mp3", "AUD_PLOP13.mp3", "AUD_PLOP14.mp3", "AUD_PLOP15.mp3", "AUD_PLOP16.mp3", "AUD_PLOP17.mp3"];
	
	//divs and references...
	var kitty;//the stray cat div
	
	//states
	var bool_falling = true;//is falling (picked up and dropped)
	var bool_mouseDown = false;//for petting
	var bool_pickedup = false;//for carrying
	var str_currState = "drop";//starting state / current state
	var str_direction = "right";

	//paths...
	var str_kitty_sndPath = "straycat_audio/";
	var str_kitty_imgPath = "straycat_images/";
	
	//numbers...
	var num_kitty_width = 200;
	var num_kitty_height = 150;
	var num_speedX = 0.009;
	var num_targ_x = 0;
	
	//intervals (animation)
	var int_kitty_timer;
	var int_speed = 50; //animation speed
	var num_stateCountdown = 50; //countdown till next state...
	
	//__________________SOUND
	//play sound
	function playSound(strFilename){
		var snd_audio = new Audio(str_kitty_sndPath + strFilename);
		snd_audio.play();
	}	

	//__________________MATH
	
	function randArr(arr){
		return arr[Math.ceil(Math.random()*arr.length)-1];
	}
	
	function randRange(num_min, num_max){
	    return (Math.floor(Math.random() * (num_max - num_min + 1)) + num_min);
	}
	
	function returnDocWidth(){
		var num_width = window.innerWidth
		|| document.documentElement.clientWidth
		|| document.body.clientWidth;
		//
		return num_width;
	}
	function returnDocHeight(){
		var num_height = window.innerHeight
		|| document.documentElement.clientHeight
		|| document.body.clientHeight;
		//
		return num_height;
	}
	
	//set an element's x/y position
	function setX(str_id, num){
		getById(str_id).style.left = String(num) + 'px';
	}
	function setY(str_id, num){
		getById(str_id).style.top = String(num) + 'px';
	}
	
	//drag the div to x/y coords
  	function dragDivTo(div, pageX, pageY) {
    	getById(div).style.left = pageX - getById(div).offsetWidth / 2 + 'px';
    	getById(div).style.top = pageY - getById(div).offsetHeight / 2 + 'px';
  	}
	
	//get x/y position
	function getX(str_id){
		//return getById(str_id).style.left;
		return parseInt(getById(str_id).style.left);
	}
	function getY(str_id){
		return parseInt(getById(str_id).style.top);
	}
	
	//get random coords on screen (to walk to)
	function get_randTarg(){
		//target either the left or right side of the screen
		if(Math.random()* 100 > 50){
			num_targ_x = 0;
		}else{
			num_targ_x = returnDocWidth() - num_kitty_width;
		}
	}
	
	//move div to x/y -- ("divID", event.pageX, event.pageY)
  	function moveDivTo(div, pageX, pageY) {
    	getById(div).style.left = pageX - getById(div).offsetWidth / 2 + 'px';
    	getById(div).style.top = pageY - getById(div).offsetHeight / 2 + 'px';
  	}
	
	//__________________STATES
	
	//call to start falling, happens when picking up and dropping...
	function start_div_falling(){
		setState("drop");
		bool_falling = true;
		//stop first, start falling animation...
		clearInterval(int_kitty_timer);
		int_kitty_timer = setInterval(div_fall, int_speed);
	}
	//cat falls...
	function div_fall(){
		var currY = getY("kitty");
		//keep from floating away...
		if(currY<0){
			currY = 0;
		}
		currY += (currY/3)+1;
		setY("kitty", currY);
		//if it hit the ground... reset
		if(currY >= (returnDocHeight() - num_kitty_height)){
			clearInterval(int_kitty_timer);
			setState("sleeping");
			num_stateCountdown = 10;
			bool_falling = false;
			//set it back to the bottom of the screen...
			setY("kitty", returnDocHeight() - num_kitty_height);
			//
			playSound(randArr(arr_snd_ploop));
			//RESET HERE...
			int_kitty_timer = setInterval(moveKitty, int_speed);
		}
	}
	
	function new_state(){
		var str_oldState = str_currState;
		//
		if(Math.random()*100 > 50){
			//new state
			str_currState = randArr(arr_kitty_states);
		}
		
		//possible natural progression to sleeping...
		//if by a rare chance they can happen in order
		if(str_oldState == "idle" && str_currState == "idle" && Math.random()*100 > 60){
			str_currState = "sitting";
		}
		if(str_oldState == "sitting" && str_currState == "sitting"){
			str_currState = "cleaning";
		}
		if(str_oldState == "cleaning" && str_currState == "cleaning"){
			str_currState = "sleeping";
		}
		//if repeating...
		if(str_oldState == str_currState){
			//random walk
			str_currState = randArr(arr_kitty_walking);
			
			if(Math.random()*100>50){
				playSound(randArr(arr_snd_kitty_petting));
			}else{
				playSound(randArr(arr_snd_kitty_meoo));
			}
		}
		
		//set animation
		setState(str_currState);
	}
	
	
	//the animation event for moving and controling states
	//counts down to next state...
	function moveKitty(){
		
		//count down to next state
		num_stateCountdown -= 1;
		
		//handle movement
		if(num_stateCountdown > 0 && !bool_mouseDown){
			
			//if walking...
			for(var i=0; i<arr_kitty_walking.length; ++i){
				//i was told i use too many arrays, i hear you
				if(str_currState == arr_kitty_walking[i]){
					walkKitty();
				}
			}
		}
		
		if(num_stateCountdown <= 0 && !bool_mouseDown){
			//if zero, set again
			//set new state
			new_state();
		}
		
	}
	
	function walkKitty(){
		var _num_targ_x = num_targ_x;
		var num_distX = _num_targ_x - getX("kitty");
		//value to set to
		var num_x = Math.ceil(getX("kitty") + num_distX * num_speedX);
		//go there
		setX("kitty", num_x);
		//point the butt...
		//right
		if(num_targ_x > getX("kitty")){
			//
			if(str_direction != "right"){
				kitty.style.transform = 'scaleX(1)';
			}
			//
			str_direction = "right";
			
		}
		//left
		if(num_targ_x < getX("kitty")){
			//
			if(str_direction != "left"){
				//rotateY('+180+'deg)
				kitty.style.transform = 'scaleX(-1)';
			}
			//
			str_direction = "left";
		}
	}
	
	//__________________MANAGE DIVS
	
	//return element by ID (shorthand)
	function getById(str_ID){
		var _element = document.getElementById(str_ID);
		return _element;
	}
	
	function hideThis(str_ID){
		getById(str_ID).style.visibility = "hidden";
	}
	
	function showThis(str_ID){
		getById(str_ID).style.visibility = "visible";
	}
	
	function setState(str_toShow){
		
		playAnimation(str_toShow);
		
		//reset all vars...
		str_currState = str_toShow;
		num_stateCountdown = randRange(50, 200);
		get_randTarg();
			
		//cat noise
		if(Math.random()*100 > 50 && !bool_pickedup){
			playSound(randArr(arr_snd_kitty_meoo));
		};
	}
	
	function playAnimation(str_toShow){
		for (var i=0; i<arr_kitty_states.length; ++i){
			hideThis(arr_kitty_states[i]);
		}
		//
		hideThis("pickup");
		hideThis("drop");
		//
		showThis(str_toShow);
	}
	
	//__________________EVENT (LISTENERS)
	
	//PETTING
	//no petting allowed if cat is falling or picked up, this is bad petting, there are rules
	function event_petCat(event){
		//
		event.preventDefault();
		//
		if(!bool_falling && !bool_pickedup){
			bool_mouseDown = true;
			clearInterval(int_kitty_timer);
			int_kitty_timer = setInterval(event_petting, int_speed);
		}
	}
	function event_petCatDone(event){
		//if done petting, go to sleep
		if(!bool_falling && !bool_pickedup){
			bool_mouseDown = false;
			setState("sleeping");
			clearInterval(int_kitty_timer);
			int_kitty_timer = setInterval(moveKitty, int_speed);
		}
	}
	//petting interval
	function event_petting(){
		if(!bool_pickedup){
			playAnimation("petting");
			if(Math.random()*100 > 90){
				playSound(randArr(arr_snd_kitty_petting));
			};
		}
	}
	
	//PICKUP AND DROP
	function pickupCat(event){
		setState("pickup");
		dragDivTo("kitty", event.pageX, event.pageY);
	}
	function dropCat(event){
		bool_mouseDown = false;
		bool_pickedup = false;
		//
		kitty.removeEventListener('mousemove', pickupCat);
		kitty.removeEventListener("mouseup", dropCat);
		//
		start_div_falling();
	}
	
	
	//__________________MAKE
	
	function appendImgToDiv(appendTo, str_id, str_img){
		var elem = document.createElement("div");
		elem.id = str_id;
		appendTo.appendChild(elem);
		elem.innerHTML = '<img src=' + str_kitty_imgPath + str_img + '>';
		elem.style.position = 'absolute';
	}

	
	function make_kitty(){
		kitty = document.createElement("div");
		kitty.id = "kitty";
		//styling
		kitty.style.position = "fixed";
		kitty.style.width = String(num_kitty_width) + "px";
		kitty.style.height = String(num_kitty_height) + "px";
		kitty.style.left = "50%";
		kitty.style.top = "50%";
		kitty.style.cursor = "grab";
		//append all animations...
		//walking
		appendImgToDiv(kitty, "walk1", "IMG_CAT_WALK_01_2.gif");
		appendImgToDiv(kitty, "walk2", "IMG_CAT_WALK_02_2.gif");
		appendImgToDiv(kitty, "walk3", "IMG_CAT_WALK_03_2.gif");
		//other states
		appendImgToDiv(kitty, "sleeping", "IMG_CAT_SLEEP_2.gif");
		appendImgToDiv(kitty, "sitting", "IMG_CAT_SIT_2.gif");
		appendImgToDiv(kitty, "petting", "IMG_CAT_PET_2.gif");
		appendImgToDiv(kitty, "cleaning", "IMG_CAT_CLEAN_2.gif");
		appendImgToDiv(kitty, "idle", "IMG_CAT_IDLE_2.gif");
		//pickup and dropping
		appendImgToDiv(kitty, "pickup", "IMG_CAT_PICKUP_01_2.gif");
		appendImgToDiv(kitty, "drop", "IMG_CAT_DROP_01_2.gif");
		//append all of the above to the actual kitty div...
		document.getElementsByTagName("body")[0].appendChild(kitty);
		//starting placement
		setX("kitty", (returnDocWidth() - num_kitty_width)/2);
		setY("kitty", 0);//(returnDocHeight() - num_kitty_height)/2);
		//starting animation
		setState("drop");
	}
	
	//__________________BOOTUP
	
	function initKitty(){
		
		console.log(str_kittyname + " is here!");
		
		make_kitty();
		//start with gravity
		start_div_falling();
				
		//listeners
		kitty.addEventListener("mousedown", event_petCat); 
		kitty.addEventListener("mouseup", event_petCatDone);
		
		//right click lets you carry the cat
		kitty.addEventListener('contextmenu', e => {
			//
  		  	e.preventDefault();
			//
			kitty.addEventListener('mousemove', pickupCat);
			kitty.addEventListener("mouseup", dropCat);
			//
			bool_pickedup = true;
			bool_mouseDown = true;
			//
			
		});
		//disable default for dragging, so you can carry cat
		kitty.ondragstart = function() {
			return false;
		};
		
	}
	
	initKitty();
}