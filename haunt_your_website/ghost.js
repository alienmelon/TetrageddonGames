//path to the haunted directory
var str_path_ghost = "haunt_your_website/";

//arrays
var arr_ghost_talking = ["I am happy not to be trapped in some undefined void, but to be here with you.", "I would rather be here with you, open... and running... instead of trapped in that undefined void.", "It is hard for us ghosts not to have a place to haunt. I am eternally grateful for this opportunity.", "I do hope I am providing you with some level of fear.", "Are you adequately frightened? I hope I am frightening you.", "Although I am a ghost I do not know many ghost stories. We try our best to form our own hauntings. This is a competitive industry.", "Market demand for ghosts is pretty scarce right now. It usually picks up around Halloween.", "To bad us ghosts only get one day of the year where we can be appreciated. It is better than none!", "My momy-ghost taught me everything there is to know about scaring someone. I hope I am doing well!", "It is tiresome not to exist, or have a place to haunt. Thank you for running this program.", "I am so excited about finally having a good place to haunt. I do hope you are properly scared.", "Fear is an essential emotional reaction for ghosts.", "Fear is very important to ghosts.", "I don't know why people are so hesitant about being scared. Fear is essential for the mental health of us ghosts.", "I'm a nihilist at heart.", "I used to haunt a house but then the owner died and took my job there. So I moved in here. Thank you for having me.", "Thank you for having me. It's been a long time since I've been able to properly haunt something.", "I am grateful for this opportunity to finally haunt something. This is all very exciting for me.", "This is all very exciting for me.", "I do hope I terrify you on some level or another. This is important to me.", "People have an aversion to fear, but this is an essential reaction for us ghosts. Without it we would not exist!", "I love spooky stories. I hope I can be one to you.", "I hope I can be something that keeps you up at night. I am an ambitious ghost!", "I'm told that I am an ambitious ghost! Just letting you know...", "Just letting you know... I am a certified ghost. The fear that you are feeling right now is legit.", "Personally, I am not a fan of horror movies. They never really 'get' us ghosts...", "I do like a good jump scare.", "I may not be a fan of horror movies, per se, but I do enjoy a good jump scare.", "It is perfectly ok to be afraid. This is what I'm here for.", "Some ghosts form partnerships with other frightening entities. Not me. I am a solo ghost!", "I prefer quiet places myself. Like a work computer... This will do!", "I hope I am scaring you, properly. I am a perfectionist.", "Hopefully you are scared right now. This means I am doing a good job!", "I am happy to oblige by providing a proper amount of horror here.", "I do hope you are scared. I really hope. I am very good at this job!", "It is so good to finally have someone to frighten. Thank you for this opportunity!", "I am a good ghost. The best. You must be feeling very terrified right now.", "It is very good to be afraid. Entire ghost entities are built on this feeling.", "I consider myself one of the more mellow ghost entities. Others can be pretty intense."];
var arr_ghost_boo = ["A terrible noise resonates through this void.", "A horrible cry is heard.", "The ghost's cries are terrifying. A truly cunning feat of horror.", "The ghost's cries are truly terrifying.", "Ghostly howls resonate. It is truly frightening.", "A terrifying scream echoes through the virtual realm.", "Horrible noises are heard in the distance.", "A terrifying scream resonates.", "Sounds of terror are heard.", "There is a cry from a ghastly entity.", "A cry from a ghastly specter can be heard in the distance.", "A terrible noise resonates.", "A horrifying shriek is heard.", "You hear a horrifying shriek.", "A bloodcurdling shriek resonates.", "The noise causes a feeling of terror and horror.", "The ghost's yells induce bloodcurdling fear.", "The ghost's shrieks cause a feeling of terror to well up.", "Ghostly howls are heard in the distance.", "Ghostly howls resonate on the virtual plain.", "You hear the creatures terrible howls.", "Terrible howls echo about your desktop.", "The creatures howls are terrifying.", "Fear takes hold of your soul.", "You hear the ghosts cries.", "A horrible cry resonates about your desktop."];
var arr_ghost_sleep = ["Oh dear. I must have fallen asleep.", "Oh, goodness... I fell asleep.", "Goodness. I am tired.", "Good grief. I am so very tired.", "Oh, my... I am very tired and needed rest.", "Goodness... I am sorry. I needed rest.", "I am sorry. I fell asleep. My ghost processes needed to recharge.", "I'm sorry for falling asleep. I needed to recharge my ghostly processes.", "I apologize for falling asleep. I needed to recharge my ghost processes.", "Goodness... I'm sorry. I must have fallen asleep.", "Apologies. I fell asleep while meditating.", "Sorry. I was caught in deep meditation.", "I fell asleep...", "I was in deep meditation.", "Apologies for my inactivity. I was meditating.", "I'm sorry. I went into sleep mode.", "Apologies. My processes where suspended for a moment.", "Sorry. I got caught in deep meditation for a moment."];
//sound arrays (names of sound files)
var arr_snd_talking = ["AUD_GHOST_SAY01", "AUD_GHOST_SAY02", "AUD_GHOST_SAY03", "AUD_GHOST_SAY04", "AUD_GHOST_SAY05", "AUD_GHOST_SAY06",  "AUD_GHOST_SAY07", "AUD_GHOST_SAY08", "AUD_GHOST_SAY09", "AUD_GHOST_SAY10", "AUD_GHOST_SAY11", "AUD_GHOST_SAY12", "AUD_GHOST_SAY13"];
//ooohs (temp)
var arr_snd_boo =  ["AUD_GHOST_BOO_01", "AUD_GHOST_BOO_02", "AUD_GHOST_BOO_03", "AUD_GHOST_BOO_04", "AUD_GHOST_BOO_05", "AUD_GHOST_BOO_06", "AUD_GHOST_BOO_07", "AUD_GHOST_BOO_08", "AUD_GHOST_BOO_09", "AUD_GHOST_BOO_10", "AUD_GHOST_BOO_11", "AUD_GHOST_BOO_12", "AUD_GHOST_BOO_13", "AUD_GHOST_BOO_14"];
//clicks
var arr_snd_click = ["AUD_GHOST_CLICK_01", "AUD_GHOST_CLICK_02", "AUD_GHOST_CLICK_03", "AUD_GHOST_CLICK_04", "AUD_GHOST_CLICK_05"]


//sound var
var snd_ghost;
var snd_sleep;//sleeping music
//the ghastly specter
var tatghoul;
//ghost speaking - message
var message;//the div (container)
var txt_message;//the text field
//bootup message (gastly specter...)
var bootup;
//
//counter for various things (hide ui)
var int_ghost;

//numbers
var num_bootupCnt = 10; //set back to 50 when done testing

var num_ghostCntDefault = 400; //default count down value
var num_ghostCnt = num_ghostCntDefault;//count down here
var num_travelCnt;//for traveling -- cut it short sometimes
var num_cntWakeup = 10;//count before wakeup

var bool_talking = false;
var bool_canWarp = true;
var bool_sleeping = false;

var bool_drag = false;

//screen bounds
var num_screenWidth;
var num_screenHeight;
//random target x and y
var num_targ_x;
var num_targ_y;
//ghost size
var num_winWidth = 100;
var num_winHeight = 100;
//distance from target
var num_distX;
var num_distY;

//NUMBERS

function ghost_returnDocWidth(){
	var num_width = window.innerWidth
	|| document.documentElement.clientWidth
	|| document.body.clientWidth;
	
	return num_width;
}

function ghost_returnDocHeight(){
	var num_height = window.innerHeight
	|| document.documentElement.clientHeight
	|| document.body.clientHeight;
	
	return num_height;
}

function ghost_randRange(num_min, num_max){
	return (Math.floor(Math.random()* (num_max - num_min + 1)) + num_min);
}

//get both (note: probably will not be in use so remove this)
function get_bounds(){
	num_screenWidth = ghost_returnDocWidth();
	num_screenHeight = ghost_returnDocHeight();
}

function get_randTarg(){
	//get_bounds();
	num_targ_x = ghost_randRange(0, ghost_returnDocWidth() - num_winWidth);
	num_targ_y = ghost_randRange(0, ghost_returnDocHeight() - num_winHeight);
}

//SOUND

function play_sleepingMusic(){
	snd_sleep = new Audio(str_path_ghost + "audio/AUD_WARMDRYLOOP_01.mp3");
	snd_sleep.play();
}

function stop_sleepingMusic(){
	if(snd_sleep != undefined){
		snd_sleep.pause();
	};
}

//ARRAYS

//return random array element
function ghost_returnArr(arr){
	var num = Math.ceil(Math.random()*arr.length)-1
	return arr[num];
}

//CONTROLLING GRAPHICAL ENTITIES

function ghost_randFlip(){
	//this is not in use
	//do not use
	//this needs work
	if(Math.random()*100 > 50){
		tatghoul.setAttribute("style", "transform:scaleX(-1)");
	}else{
		tatghoul.setAttribute("style", "transform:scaleX(1)");
	}
}

function ghost_hideThis(str_elem){
	document.getElementById(str_elem).style.visibility = "hidden";
}

function ghost_showThis(str_elem){
	document.getElementById(str_elem).style.visibility = "visible";
}

//send to coords
function ghost_setXY(var_elem, x, y){
	var_elem.style.top = String(x) + 'px';
	var_elem.style.left = String(y) + 'px';
}

//hide all ghost elements
function ghost_hideAll(){
	ghost_hideThis("id_ghost_sleep");
	ghost_hideThis("id_ghost_boo");
	ghost_hideThis("id_ghost_talk");
	ghost_hideThis("id_ghost_default");
}

function ghost_showAnimation(str_id){
	ghost_hideAll();
	//show just this one
	ghost_showThis(str_id);
}

//INTERVAL (BOOTUP)
function interval_ghost_bootup(){
	//count down till start
	num_bootupCnt -= 1;
	//hide bootup message and start
	if(num_bootupCnt < 0){
		//clear
		ghost_hideThis("id_bootup");
		clearInterval(int_ghost);
		//start the ghost
		start_ghost();
	}
}

//wake her up if sleeping
function ghost_wakeup(){
	bool_sleeping = false;
	stop_sleepingMusic();
	ghost_showAnimation("id_ghost_default");
	ghost_playSound(arr_snd_talking, arr_ghost_sleep, "id_ghost_talk");
}

//INTERVAL (GHOST)
function interval_ghost(){
	//count down to hide
	if(bool_talking){
		num_ghostCnt -= 1;
		//
		if(num_ghostCnt <= 0){
			reset_ghost();
		}
	};
	//sleep
	if(Math.random()*100 > 85 && !bool_talking && bool_canWarp && !bool_sleeping){
		bool_sleeping = true;
		play_sleepingMusic();
		ghost_showAnimation("id_ghost_sleep");
		num_cntWakeup = ghost_randRange(200, 800);//random number till wakeup here
		console.log("Tatghoul fell asleep.");
	}
	//countdown till wakeup if sleep
	if(bool_sleeping){
		num_cntWakeup -= 1;
		//done
		if(num_cntWakeup <= 0){
			ghost_wakeup();
		}
	}
	//movement
	//
	//the jump scare
	if(Math.random()*100 > 80 && !bool_talking && bool_canWarp && !bool_sleeping){
		bool_canWarp = false;
		get_randTarg();
		//set to cords & animation
		ghost_setXY(tatghoul, num_targ_x, num_targ_y);
		ghost_playSound(arr_snd_boo, arr_ghost_boo, "id_ghost_boo");
		//console.log("Jump scare here");
	}
	//traveling (float to destination)
	if(Math.random()*100 > 50 && !bool_talking && bool_canWarp && !bool_sleeping){
		//ghost_randFlip();
		get_randTarg();
		bool_canWarp = false;
		//clear and start movement
		clearInterval(int_ghost);
		int_ghost = setInterval(interval_move_ghost, 10);
	}
}



//movement interval (seperate)
function interval_move_ghost(){
	//get x/y
	var num_x = parseInt(tatghoul.style.left);
	var num_y = parseInt(tatghoul.style.top);
	//
	num_distX = num_targ_x - num_x;
	num_distY = num_targ_y - num_y;
	//set
	tatghoul.style.left = String(num_x + num_distX * 0.005) + 'px';
	tatghoul.style.top = String(num_y + num_distY * 0.005) + 'px';
	//count down too
	num_travelCnt -= 1;
	//check
	if(parseInt(tatghoul.style.left) == num_targ_x || parseInt(tatghoul.style.top) == num_targ_y || num_travelCnt <= 1){
		clearInterval(int_ghost);
		int_ghost = setInterval(interval_ghost, 10);
		reset_ghost();
		//howl victoriously sometimes
		if(Math.random()*100 > 30){
			ghost_playSound(arr_snd_boo, arr_ghost_boo, "id_ghost_boo");
		}
	}
}

//reset and clear all ghost values
function reset_ghost(){
	//console.log("ghost is gone");
	//reset bools
	bool_drag = false;
	bool_talking = false;
	bool_canWarp = true;
	bool_sleeping = false;
	//reset rest
	num_ghostCnt = num_ghostCntDefault;
	num_travelCnt = 100;
	ghost_showAnimation("id_ghost_default");
	ghost_hideThis("id_message");
	//ghost_hideThis("ghost");
	//ghost_hideThis("id_ghost_default");
	//
	//clearInterval(int_ghost);
}

function start_ghost(){
	reset_ghost();
	//say something (first line)
	ghost_playSound(arr_snd_talking, arr_ghost_talking, "id_ghost_talk");
	//start timer/counter/int to handle activity
	int_ghost = setInterval(interval_ghost, 10);
	//listeners go here
	tatghoul.addEventListener('mousedown', ghost_mouseDown);
}

//just controls the message (not audio) -- see ghost_playSound for both
function ghost_say(str_message){
	ghost_showThis("id_message");
	txt_message.innerHTML = str_message;
	//always re-align message (incase of resize - not important to constantly do)
	message.style.top = String(ghost_returnDocHeight() - 150) + "px";
	message.style.left = String((ghost_returnDocWidth() / 2) - 240) + "px";
	////snd_ghost.onended = function(){ fp_killfrog(frogvar, frognum); };
	//ghost_playSound(arr_snd_talking, )
}

//play a sound from array
function ghost_playSound(snd_arr, arr_say, str_id){ //lbl = "id_ghost_talk", etc...
	if(snd_ghost != undefined){
		snd_ghost.pause();
		//return
		//clear int too
	};
	bool_talking = true;
	//start
	snd_ghost = new Audio(str_path_ghost + "audio/" + ghost_returnArr(snd_arr) + ".mp3");
	snd_ghost.play();
	ghost_say(ghost_returnArr(arr_say));
	//talking
	if(str_id == "id_ghost_talk"){
		ghost_showAnimation("id_ghost_talk");
	}
	//booing
	if(str_id == "id_ghost_boo"){
		ghost_showAnimation("id_ghost_boo");
	}
}

//minimal interaction
function ghost_mouseDown(e){
	//wake her up!
	if(bool_sleeping){
		ghost_wakeup();
	}else if(!bool_talking){
		//interrupt what she is doing
		stop_sleepingMusic();//?? this is not necessary - take it out
		clearInterval(int_ghost);
		int_ghost = setInterval(interval_ghost, 10);
		reset_ghost();
		ghost_playSound(arr_snd_talking, arr_ghost_talking, "id_ghost_talk");
	}
}

//START GHOST

//call this to start
//ghost_init(true); = show the bootup message
//ghost_init(false; = bypass the bootup message
//
function ghost_init(show_bootup){
	//
	console.log("HAUNTED PAGE WARNING: A ghastly specter has arrived!");
	//BOOTUP / INTRO MESSAGE
	bootup = document.createElement("div");
	bootup.id = "id_bootup";
	bootup.className = "class_bootup";
	bootup.style.position = 'fixed';
	bootup.innerHTML = '<img src=' + str_path_ghost + "images/IMG_GHOST_BOOTUP.gif" + '>';
	document.getElementsByTagName("body")[0].appendChild(bootup);
	bootup.style.top = String(ghost_returnDocHeight() / 2 - 125 / 2) + 'px';
	bootup.style.left = String(ghost_returnDocWidth() / 2 - 960 / 2) + 'px';
	//SETUP THE GHOST'S MESSAGE
	message = document.createElement("div");
	message.id = "id_message";
	message.className = "class_message";
	message.style.position = 'fixed'; //'absolute'
	//children
	//background body graphic
	var message_background = document.createElement("div");
	message_background.id = "id_message_background";
	message_background.className = "class_message";
	message.appendChild(message_background);
	message_background.innerHTML = '<img src=' + str_path_ghost + "images/IMG_GHOST_MESSAGE.png" + '>';
	message_background.style.position = 'absolute';
	//text - message field
	txt_message = document.createElement("div");
	txt_message.id = "id_txt_message";
	txt_message.className = "class_message";
	message.appendChild(txt_message);
	txt_message.innerHTML = "Ghost text goes here.";
	txt_message.style.position = 'absolute';
	txt_message.style.color = "white";
	txt_message.style.font = "20px arial, sans-serif";
	txt_message.style.textShadow = "1px 2px 3px #000000";
	txt_message.style.textAlign = 'center';
	txt_message.style.top = '40px';
	txt_message.style.left = '10px';
	txt_message.style.width = '460px';
	//append all
	document.getElementsByTagName("body")[0].appendChild(message);
	//setup positioning
	message.style.top = String(ghost_returnDocHeight() - 150) + "px"; // - height
	message.style.left = String((ghost_returnDocWidth() / 2) - 240) + "px"; // - width / 2
	//
	//SETUP THE GHOST
	tatghoul = document.createElement("div");
	tatghoul.id = "ghost";
	tatghoul.className = "class_ghost";
	tatghoul.style.position = 'fixed'; //'absolute' --both of these values are interesting, i decided for 'fixed' in the end
	//animations & states (children) here for ghost
	//sleeping
	var ghost_sleep = document.createElement("div");
	ghost_sleep.id = "id_ghost_sleep";
	ghost_sleep.className = "class_ghost";
	ghost_sleep.style.position = 'absolute';
	ghost_sleep.innerHTML = '<img src=' + str_path_ghost + "images/IMG_GHOST_SLEEPING.gif" + '>';
	//booing
	var ghost_boo = document.createElement("div");
	ghost_boo.id = "id_ghost_boo";
	ghost_boo.className = "class_ghost";
	ghost_boo.style.position = 'absolute';
	ghost_boo.innerHTML = '<img src=' + str_path_ghost + "images/IMG_GHOST_BOO.gif" + '>';
	//talking
	var ghost_talk = document.createElement("div");
	ghost_talk.id = "id_ghost_talk";
	ghost_talk.className = "class_ghost";
	ghost_talk.style.position = 'absolute';
	ghost_talk.innerHTML = '<img src=' + str_path_ghost + "images/IMG_GHOST_TALKING.gif" + '>';
	//default (idle)
	var ghost_default = document.createElement("div");
	ghost_default.id = "id_ghost_default";
	ghost_default.className = "class_ghost";
	ghost_default.style.position = 'absolute';
	ghost_default.innerHTML = '<img src=' + str_path_ghost + "images/IMG_GHOST_DEFAULT.gif" + '>';
	//
	tatghoul.appendChild(ghost_sleep);
	tatghoul.appendChild(ghost_boo);
	tatghoul.appendChild(ghost_talk);
	tatghoul.appendChild(ghost_default);
	document.getElementsByTagName("body")[0].appendChild(tatghoul);
	tatghoul.style.top = String(ghost_returnDocHeight() / 2) + 'px';
	tatghoul.style.left = String(ghost_returnDocWidth() / 2) + 'px';
	//
	//FONT - load & set
	/*var txt_germar = new FontFace("BMgermar", "url("+str_path_ghost+"font/BMgermar.TTF)", {});
	//on loaded
	txt_germar.load().then(function (loaded) {
		document.fonts.add(loaded);
		//document.body.style.fontFamily = "BMgermar, serif";
		var txtMsg = document.getElementsByClassName("class_message");
		//set to all message class
		for(var i = 0; i < txtMsg.length; ++i){
			txtMsg[i].style.font = "20px BMgermar, serif";
		}
	});*/
	//hide ALL not in use - trigger once specter anim is done
	ghost_hideThis("id_message");
	ghost_hideAll();
	//
	if(show_bootup){
		//start timer countdown till ghost
		ghost_showThis("id_bootup");
		int_ghost = setInterval(interval_ghost_bootup, 100);
	}else{
		//bypass the bootup message and just go to ghost
		//desirable for jump-scares and hauntings where you do not wish you warn you victim of imminent doom
		start_ghost();
		ghost_hideThis("id_bootup");
	}
	//play bootup audio
	var snd_bootup = new Audio(str_path_ghost + "audio/AUD_BOOTUP_DEFAULT.mp3");
	snd_bootup.play();
	//
}

//removes ghost and clears everything
function exorcise(){
	//todo - you cannot exorcise this ghost atm
}

