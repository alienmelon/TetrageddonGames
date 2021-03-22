import flash.display.MovieClip;import flash.events.KeyboardEvent;import flash.events.Event;
import flash.events.MouseEvent;
///////////// Higher-level, global game-specific logic and resources.//////////var stageWidth:Number = 960;var stageHeight:Number = 640;var gameTileParent:MovieClip;var gameLoops:Object = {mapRedraw: -1};var gameTileSize:Number = 100;//64;var gameCurrentMap:Object;var gameTilePlayerIsOn:Object = null;var gameLooseCallback:Function;var gameWinCallback:Function;var changeInt:Number = 30;//20var redrawInt:Number = 60;//50var shouldCenterMap:Boolean = true;var Aud_Spawn:Spawn = new Spawn();//Aud_Spawn.attachSound("Spawn.mp3");var Aud_Move1:Move_1 = new Move_1();//Aud_Move1.attachSound("Move-1.mp3");var Aud_Move2:Move_2 = new Move_2();//Aud_Move2.attachSound("Move-2.mp3");//var gamemc:MovieClip = new MovieClip;function createChildByString(child:String){    var Type:Class = getDefinitionByName(child) as Class;    return new Type();}function gameLoadMap(tiles:Array, mapWidth:Number, mapHeight:Number) {	var gamemc:MovieClip = new MovieClip;	gameCurrentMap = {map: tiles, width: mapWidth, height: mapHeight};	this.addChild(gamemc);//this.createEmptyMovieClip('gamemc', this.getNextHighestDepth());	gamemc.name = "gamemc";
	//	gameTileParent = gamemc;	gameStartMapRedraw();}function gameRenderTile(tile:Object) {	// Create totally new tile	if (tile.mc == null) {		var mc:MovieClip = createChildByString(tile.tile);		gameTileParent.addChild(mc);		mc.name = "tile_" + tile.x + "_" + tile.y;		//gameTileParent.attachMovie(tile.tile, "tile_" + tile.x + "_" + tile.y, gameTileParent.getNextHighestDepth());		mc.x = tile.x * gameTileSize;		mc.y = tile.y * gameTileSize;		mc.stop();		tile.mc = mc;		//trace(mc.name);	}	// Check if tile relocated since last redraw	else	{		if (tile.mc.x != (tile.x * gameTileSize) || (tile.mc.y != tile.y * gameTileSize))		{			tile.mc.x = tile.x * gameTileSize;			tile.mc.y = tile.y * gameTileSize;			tile.x = Math.floor(tile.mc.x / gameTileSize);			tile.y = Math.floor(tile.mc.y / gameTileSize);		}	}
	//trace(tile.mc.currentFrame +" " + (tile.opening+1));
	//slash change indication
	try{
		if(tile.mc.currentFrame != (tile.opening+1)){
			tile.mc.mc_flicker.gotoAndPlay(1);
			tile.mc.mc_warning.gotoAndStop(1);//reset warning
		}
	}catch(e:Error){
		//undefined
	}
	//move background
	mc_background.play();
	//	tile.mc.stop();	if (!tile.isPlayer) tile.mc.gotoAndStop(tile.opening+1);
	//flicker warning - this will change next
	try{
		if(tile.nextOpening == tile.opening){
			tile.mc.mc_warning.gotoAndStop(1);
		}
		if(tile.nextOpening != tile.opening){
			tile.mc.mc_warning.gotoAndStop(2);
		}
	}catch(e:Error){
		//TypeError: Error #1010:
	}}function gameStartMapRedraw() {	if (gameLoops.mapRedraw == -1) {		gameLoops.mapRedraw = setInterval(gameRedrawMap, redrawInt);
		gameLoops.mapShuffle = setInterval(gameShuffleMap, changeInt);
		playerKeyboardUpdate();		//gameLoops.mapPlayerMove = setInterval(playerKeyboardMove, 50);	}}function gameStopMapRedraw() {	clearInterval(gameLoops.mapRedraw);	gameLoops.mapRedraw = 0;}function centerMap(){	if(shouldCenterMap == true){
		shouldCenterMap = false;		gameTileParent.x = Math.floor((stageWidth / 2) - (gameTileParent.width / 2));// -80;		gameTileParent.y = Math.floor((stageHeight / 2) - (gameTileParent.height / 2)) - 50;// -120;	//-n added to pull it up a bit	};};function gameRedrawMap() {	var tile:Object = null;	var player:Object = null;	for (var a:Number = 0; a != gameCurrentMap.map.length; ++a) {		tile = gameCurrentMap.map[a];		gameRenderTile(tile);	}	centerMap();	playerCheckTile();//checked here and in keyboard so he doesn't idle on a deadly tile}function gameMakeTile(symbol:String, tx:Number, ty:Number) {	return {tile:symbol, x:tx, y:ty, opening:(Math.round(Math.random())), nextOpening:(Math.round(Math.random()))};}function gameShuffleMap() {	var tile1:Object = gameCurrentMap.map[(Math.floor(Math.random() * gameCurrentMap.map.length + 1)-1)];	while (tile1.isPlayer || (tile1.x == player.x && tile1.y == player.y) ) { // Slow, but at least now the setInterval for this function is accurate		tile1 = gameCurrentMap.map[(Math.floor(Math.random() * gameCurrentMap.map.length + 1)-1)];	}
	//	tile1.opening = tile1.nextOpening;//Math.floor(Math.random() * 3);
	//now chose the next tile that will change...
	tile1.nextOpening = Math.floor(Math.random() * 3);
	//trace(tile1.nextOpening + " " + tile1.opening);//!HERE!}///////////// Player control and render logic//////////
var dr:String = ""; // Direction: left | up | down | right var playerSprite:MovieClip;/*var playerKeyboardListener:Object;*/var player:Object;var playerCurrentTile:Object = null;//demoPlayer = playerMake("Demo Player", 0, 2);function playerMake(symbol:String, px:Number, py:Number) {	player = gameMakeTile(symbol, px, py);	player.isPlayer = true;	return player;}function setKeyboard(){	//on key down call a function, on key up call a function	stage.addEventListener(KeyboardEvent.KEY_DOWN, playerKeyboardMove);
	stage.addEventListener(KeyboardEvent.KEY_UP, playerKeyboardUp);};function clearKeyboard(){	stage.removeEventListener(KeyboardEvent.KEY_DOWN, playerKeyboardMove);
	stage.removeEventListener(KeyboardEvent.KEY_UP, playerKeyboardUp);};//UPfunction playerKeyboardUpdate() {	// Tile player is on right now	for (var i:Number = 0; i != gameCurrentMap.map.length; ++i) {		if (gameCurrentMap.map[i].x == player.x && gameCurrentMap.map[i].y == player.y && gameCurrentMap.map[i] != player) {			playerCurrentTile = gameCurrentMap.map[i];			break;		}	}}function playerKeyboardUp(event:KeyboardEvent){	playerKeyboardUpdate();}
function playerBtnPress(){
	playerCheckDirection();
	playerCheckTile();
};
//BUTTONS
function btn_game_ALLUP(event:MouseEvent){
	playerKeyboardUpdate();	
	dr = "";
	//trace("Player updated.");
};
function btn_game_DOWN(event:MouseEvent){
	if (MovieClip(gameTileParent.getChildByName("tile_"+player.x+"_"+(player.y+1))) != null && playerCurrentTile.opening == 0) {//(gameTileParent["tile_"+player.x+"_"+(player.y+1)] != undefined && playerCurrentTile.opening == 0) {
		player.y++;
		dr = "down";
		Aud_Move1.play();
	}
	//
	playerBtnPress();
	//trace(dr+" pressed");
};
function btn_game_UP(event:MouseEvent){
	if (MovieClip(gameTileParent.getChildByName("tile_"+player.x+"_"+(player.y-1))) != null && playerCurrentTile.opening == 0) { //(gameTileParent["tile_"+player.x+"_"+(player.y-1)] != undefined && playerCurrentTile.opening == 0) { 
		player.y--;
		dr = "up";
		Aud_Move2.play();
	}
	//
	playerBtnPress();
	//trace(dr+" pressed");
};
function btn_game_LEFT(event:MouseEvent){
	if (MovieClip(gameTileParent.getChildByName("tile_"+(player.x-1)+"_"+player.y)) != null  && playerCurrentTile.opening == 1) {//(gameTileParent["tile_"+(player.x-1)+"_"+player.y] != undefined  && playerCurrentTile.opening == 1) {
		player.x--;
		dr = "left";
		Aud_Move1.play();
	}
	//
	playerBtnPress();
	//trace(dr+" pressed");
};
function btn_game_RIGHT(event:MouseEvent){
	if (MovieClip(gameTileParent.getChildByName("tile_"+(player.x+1)+"_"+player.y)) != null && playerCurrentTile.opening == 1) {//(gameTileParent["tile_"+(player.x+1)+"_"+player.y] != undefined && playerCurrentTile.opening == 1) {
		player.x++;
		dr = "right";
		Aud_Move2.play();
	}
	//
	playerBtnPress();
	//trace(dr+" pressed");
};
//set the direction to face
function playerCheckDirection(){
	if (dr != "")  {
		player.mc.gotoAndStop(dr);
	}
};
//DOWNfunction playerKeyboardMove(event:KeyboardEvent) {		switch (event.keyCode){//Key.getCode()) {		case 37:			if (MovieClip(gameTileParent.getChildByName("tile_"+(player.x-1)+"_"+player.y)) != null  && playerCurrentTile.opening == 1) {//(gameTileParent["tile_"+(player.x-1)+"_"+player.y] != undefined  && playerCurrentTile.opening == 1) {				player.x--;				dr = "left";				Aud_Move1.play();			}			break;		case 38:			if (MovieClip(gameTileParent.getChildByName("tile_"+player.x+"_"+(player.y-1))) != null && playerCurrentTile.opening == 0) { //(gameTileParent["tile_"+player.x+"_"+(player.y-1)] != undefined && playerCurrentTile.opening == 0) { 				player.y--;				dr = "up";				Aud_Move2.play();			}			break;		case 39:			if (MovieClip(gameTileParent.getChildByName("tile_"+(player.x+1)+"_"+player.y)) != null && playerCurrentTile.opening == 1) {//(gameTileParent["tile_"+(player.x+1)+"_"+player.y] != undefined && playerCurrentTile.opening == 1) {				player.x++;				dr = "right";				Aud_Move2.play();			}			break;		case 40:			if (MovieClip(gameTileParent.getChildByName("tile_"+player.x+"_"+(player.y+1))) != null && playerCurrentTile.opening == 0) {//(gameTileParent["tile_"+player.x+"_"+(player.y+1)] != undefined && playerCurrentTile.opening == 0) {				player.y++;				dr = "down";				Aud_Move1.play();			}			break;	}
	playerCheckDirection();	/*if (dr != "")  {		player.mc.gotoAndStop(dr);	}*/	playerCheckTile();	//trace(MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)));/*	if (MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).currentFrame == 3) {		//player.mc.gotoAndStop("die");		player.mc.gotoAndStop("die");	}	if(MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).toString()=="[object Exit]"){	  	player.mc.gotoAndStop("win");		shouldCenterMap = false;	}*/}function playerCheckTile(){	if (MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).currentFrame == 3) {
		//player.mc.gotoAndStop("die");
		player.mc.gotoAndStop("die");
		//
		txt_haxalert.htmlText ="<font color='#FF0000'>"+"Error: Permission denied"+"</font>";
	}
	if(MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).toString()=="[object Exit]"){
		txt_haxalert.htmlText ="<font color='#33FFFF'>"+"function SUCCESS!"+"</font>";
	  	player.mc.gotoAndStop("win");
		shouldCenterMap = false;
	}
	if (MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).currentFrame == 1) {
		txt_haxalert.htmlText ="<font color='#00FF00'>"+"HTTP 'UP/DOWN' Move."+"</font>";
	}
	if (MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).currentFrame == 2) {
		txt_haxalert.htmlText ="<font color='#00FF00'>"+"HTTP 'LEFT/RIGHT' Move."+"</font>";
	}
	//also disable warnings on the current tile player is on...
	try{
		MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).mc_warning.gotoAndStop(1);
	}catch(e:Error){
		//no alert on this type of tyle
	}
	//trace(MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).mc_warning);}///////////// Demo start///////////var demoMapWidth:Number;var demoMapHeight:Number;var demoTiles:Array;var demoLibrary:Array;var demoPlayer:Object;var seconds:Number = 0;var tries:Number = 0;var timeInt:uint;function reset(){	seconds = 0;	tries = 0;}function time(){	seconds+=1;};function init(){
	stage.focus = stage;
	dr = "";	demoPlayer = null;	gameCurrentMap = null;	demoMapWidth = 7;//5;	demoMapHeight = 4;//5;	demoTiles = [];	demoLibrary = [];	demoPlayer = playerMake("Demo Player", 0, 2);	for (var i:Number = 0; i <= demoMapWidth; ++i) {		for (var j:Number = 0; j <= demoMapHeight; ++j) {			var chosen:Number = Math.floor(Math.random() * demoLibrary.length + 1);			--chosen;			demoTiles.push(gameMakeTile("Memory", i, j));		}	}	demoTiles.push(gameMakeTile("Exit", demoMapWidth+1, Math.floor(demoMapHeight/2)));	demoTiles.push(demoPlayer);	gameLoadMap(demoTiles, demoMapWidth, demoMapHeight);	shouldCenterMap = true;	setKeyboard();	Aud_Spawn.play();
	//
	playerKeyboardUpdate();};function uninit(){	shouldCenterMap = false;	clearKeyboard();	//	for (var j:Number = 0; j < gameTileParent.numChildren; j++){		  gameTileParent.removeChild(gameTileParent.getChildAt(j));	}	this.removeChild(gameTileParent);};function demoWin() {	selectedMenuItem = "win";	clearInterval(gameLoops.mapRedraw);	clearInterval(gameLoops.mapShuffle);	clearInterval(timeInt);	transition();	killAllIntervals();	uninit();}function demoLoose() {	tries+=1;	uninit();	init();}init();timeInt = setInterval(time,1000);gameLooseCallback = demoLoose;gameWinCallback = demoWin;