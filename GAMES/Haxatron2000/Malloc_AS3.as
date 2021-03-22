﻿import flash.display.MovieClip;
import flash.events.MouseEvent;

	//
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
	//
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
	}
		gameLoops.mapShuffle = setInterval(gameShuffleMap, changeInt);
		playerKeyboardUpdate();
		shouldCenterMap = false;
	//
	//now chose the next tile that will change...
	tile1.nextOpening = Math.floor(Math.random() * 3);
	//trace(tile1.nextOpening + " " + tile1.opening);//!HERE!
var dr:String = ""; // Direction: left | up | down | right 
	stage.addEventListener(KeyboardEvent.KEY_UP, playerKeyboardUp);
	stage.removeEventListener(KeyboardEvent.KEY_UP, playerKeyboardUp);
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

	playerCheckDirection();
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
	//trace(MovieClip(gameTileParent.getChildByName("tile_" + player.x + "_" + player.y)).mc_warning);
	stage.focus = stage;
	dr = "";
	//
	playerKeyboardUpdate();