/// @desc Visual gamepad

if (global.debug > 1) {
	
	var _tileS = 8;
	var _tileX = 10*_tileS;
	var _tileY =  4*_tileS;
	
	draw_sprite_ext(sprGamepad,DEBUGPAD.PAD,_tileX,_tileY,1,1,0,c_white,0.75);
	
	if (lsHozHeld > 0) draw_sprite(sprGamepad,DEBUGPAD.AXISR  ,_tileX,_tileY);
	if (lsVerHeld < 0) draw_sprite(sprGamepad,DEBUGPAD.AXISU  ,_tileX,_tileY);
	if (lsHozHeld < 0) draw_sprite(sprGamepad,DEBUGPAD.AXISL  ,_tileX,_tileY);
	if (lsVerHeld > 0) draw_sprite(sprGamepad,DEBUGPAD.AXISD  ,_tileX,_tileY);
	if (    rightHeld) draw_sprite(sprGamepad,DEBUGPAD.DPADR  ,_tileX,_tileY);
	if (       upHeld) draw_sprite(sprGamepad,DEBUGPAD.DPADU  ,_tileX,_tileY);
	if (     leftHeld) draw_sprite(sprGamepad,DEBUGPAD.DPADL  ,_tileX,_tileY);
	if (     downHeld) draw_sprite(sprGamepad,DEBUGPAD.DPADD  ,_tileX,_tileY);
	if (   selectHeld) draw_sprite(sprGamepad,DEBUGPAD.SELECT ,_tileX,_tileY);
	if (    startHeld) draw_sprite(sprGamepad,DEBUGPAD.START  ,_tileX,_tileY);
	if (  button1held) draw_sprite(sprGamepad,DEBUGPAD.BUTTONX,_tileX,_tileY);
	if (  button2held) draw_sprite(sprGamepad,DEBUGPAD.BUTTONA,_tileX,_tileY);
	if (  button3held) draw_sprite(sprGamepad,DEBUGPAD.BUTTONY,_tileX,_tileY);
	if (  button4held) draw_sprite(sprGamepad,DEBUGPAD.BUTTONB,_tileX,_tileY);
	
}