PImage start1, start2, bg1, bg2, fighter, enemy, hp, treasure, shoot, end1, end2;
PImage[] flame=new PImage[5];
int bg2_x;
int hpValue;
int treasureWidth=40, treasureHeight=40, treasureX, treasureY;
int fighterWidth=50, fighterHeight=50, fighterX, fighterY, fighterSpeed=5;
int enemyWidth=60, enemyHeight=60, enemyX_first=-350, enemyY_first, enemySpeed=3, enemyState;
int[] enemyX=new int[8], enemyY=new int[8]; 
boolean[] flameFire=new boolean[10];
int flameNum;
int[] flameX=new int[10], flameY=new int[10], flamePicture=new int[10], flameCounter=new int[10];
boolean shootAble, shootFire;
int shootWidth=31, shootHeight=27, shootX_first=-shootWidth, shootSpeed=5, shootNum;
int[] shootX=new int[5], shootY=new int[5];
boolean upPressed, downPressed, rightPressed, leftPressed;

// game state
final int GAME_START=0;
final int GAME_RUN=1;
final int GAME_END=2;
int gameState=GAME_START;


void setup () {
  size(640, 480);
  frameRate=60;
  start1=loadImage("img/start1.png");
  start2=loadImage("img/start2.png");
  bg1=loadImage("img/bg1.png");
  bg2=loadImage("img/bg2.png");
  fighter=loadImage("img/fighter.png");
  enemy=loadImage("img/enemy.png");
  hp=loadImage("img/hp.png");
  treasure=loadImage("img/treasure.png");
  for(int i=0;i<5;i++)
    flame[i]=loadImage("img/flame"+(i+1)+".png");  
  shoot=loadImage("img/shoot.png");
  end1=loadImage("img/end1.png");
  end2=loadImage("img/end2.png");
}


void draw() {  
  switch(gameState){
    case GAME_START:
      bg2_x=0;
      hpValue=40;
      treasureX=floor(random(640-treasureWidth));
      treasureY=floor(random(40,480-treasureHeight));
      fighterX=580;
      fighterY=240;
      enemyState=-1;
      for(int i=0;i<8;i++)
        enemyX[i]=641;
      flameNum=0;
      for(int i=0;i<10;i++){
        flameFire[i]=false;
        flamePicture[i]=0;
        flameCounter[i]=0;
      }
      shootAble=true;
      for(int i=0;i<5;i++){
        shootX[i]=-shootWidth;
        shootY[i]=0;
      }
      upPressed=false;
      downPressed=false;
      rightPressed=false;
      leftPressed=false;

      image(start2,0,0);
      if(mouseX>210 && mouseX<450 && mouseY>380 && mouseY<410){ // detect mouse location
        image(start1,0,0);
        if(mousePressed){
          gameState=GAME_RUN;
        }
      }
      break;
      
      
    case GAME_RUN:
      // background
      image(bg1,bg2_x-640,0);
      image(bg2,bg2_x,0);
      image(bg2,bg2_x-1280,0);
      bg2_x++;
      bg2_x%=1280;
      
      // hp
      colorMode(RGB);
      fill(255,0,0);
      rect(18,15,hpValue,15);
      image(hp,10,10);
      
      // treasure
      image(treasure,treasureX,treasureY);
      
      // fighter
      image(fighter,fighterX,fighterY);
      if(rightPressed)
        fighterX+=fighterSpeed;
      if(leftPressed)
        fighterX-=fighterSpeed;
      if(upPressed)
        fighterY-=fighterSpeed;
      if(downPressed)
        fighterY+=fighterSpeed;      
      // limit fighter location
      fighterX=constrain(fighterX,0,width-fighterWidth);
      fighterY=constrain(fighterY,0,height-fighterHeight);
      
      // enemyState
      if(enemyX[0]>640 && enemyX[1]>640 && enemyX[2]>640 && enemyX[3]>640 && enemyX[4]>640 && enemyX[5]>640 && enemyX[6]>640 && enemyX[7]>640){
        enemyState++;
        enemyState%=3;
        enemyY_first=floor(random(40,height-enemyHeight));
        switch(enemyState){
          case 0:
           for(int i=0;i<5;i++){
             enemyX[i]=enemyX_first+i*70;
             enemyY[i]=enemyY_first;
           }
           break;

          case 1:
           enemyY_first=constrain(enemyY_first,160,height-enemyHeight);
           for(int i=0;i<5;i++){
             enemyX[i]=enemyX_first+i*70;
             enemyY[i]=enemyY_first-i*40;
           }
           break;

          case 2:
           enemyY_first=constrain(enemyY_first,120,height-120-enemyHeight);
           for(int i=0;i<8;i++){
             if(i<5){
               enemyX[i]=enemyX_first+i*70;
               if(i<3)
                 enemyY[i]=enemyY_first-i*60;
               else
                 enemyY[i]=enemyY_first-120+(i-2)*60;
             }
             else{
               enemyX[i]=enemyX_first+280-(i-4)*70;
               if(i<7)
                 enemyY[i]=enemyY_first+(i-4)*60;
               else
                 enemyY[i]=enemyY_first+120-(i-6)*60;
             }
           }
           break;
        }
      }
      // enemy movement
      if(enemyState==2){
        for(int i=0;i<8;i++){
          image(enemy,enemyX[i],enemyY[i]);
          enemyX[i]+=enemySpeed;
        }   
      }
      else{
        for(int i=0;i<5;i++){
          image(enemy,enemyX[i],enemyY[i]);
          enemyX[i]+=enemySpeed;
        }        
      }
      
      // get treasure
      if(fighterX+fighterWidth>=treasureX && fighterX<=treasureX+treasureWidth && fighterY+fighterHeight>=treasureY && fighterY<=treasureY+treasureHeight){
        hpValue+=20;
        if(hpValue>200) // limit hpValue
          hpValue=200;
        treasureX=floor(random(640-treasureWidth));
        treasureY=floor(random(40,480-treasureHeight));
      }
            
      // shoot
      if(shootX[0]>0 && shootX[1]>0 && shootX[2]>0 && shootX[3]>0 && shootX[4]>0)
        shootAble=false;
      else
        shootAble=true;
      // bullet Counter
      shootNum=0;
      for(int i=0;i<5;i++){
        if(shootX[i]>0)
          shootNum++;
      }
      if(shootFire && shootAble){
        shootX[shootNum]=fighterX;
        shootY[shootNum]=fighterY;
      }
      for(int i=0;i<5;i++){
        image(shoot,shootX[i],shootY[i]);
        shootX[i]-=shootSpeed;
        if(shootX[i]<-shootWidth)
          shootX[i]=shootX_first;
      }
      shootFire=false;
      
      // hit enemy
      for(int i=0;i<8;i++){
        // fighter hit enemy
        if(fighterX+fighterWidth>=enemyX[i] && fighterX<=enemyX[i]+enemyWidth && fighterY+fighterHeight>=enemyY[i] && fighterY<=enemyY[i]+enemyHeight){
          hpValue-=40;
          flameX[flameNum]=enemyX[i];
          flameY[flameNum]=enemyY[i];
          flameFire[flameNum]=true;
          enemyX[i]+=640;
        }
        // bullet hit enemy
        for(int j=0;j<5;j++){
          if(shootX[j]>=0 && shootX[j]+shootWidth>=enemyX[i] && shootX[j]<=enemyX[i]+enemyWidth && shootY[j]+shootHeight>=enemyY[i] && shootY[j]<=enemyY[i]+enemyHeight){
            flameX[flameNum]=enemyX[i];
            flameY[flameNum]=enemyY[i];
            flameFire[flameNum]=true;
            enemyX[i]+=640;
            shootX[j]-=640;
          }
        }
      }
      
      // flame
      if(flameFire[flameNum]){
        // more than one flame
        for(int i=0;i<8;i++){
          if(fighterX+fighterWidth>=enemyX[i] && fighterX<=enemyX[i]+enemyWidth && fighterY+fighterHeight>=enemyY[i] && fighterY<=enemyY[i]+enemyHeight)
            flameNum++;
          for(int j=0;j<5;j++){
            if(shootX[j]>=0 && shootX[j]+shootWidth>=enemyX[i] && shootX[j]<=enemyX[i]+enemyWidth && shootY[j]+shootHeight>=enemyY[i] && shootY[j]<=enemyY[i]+enemyHeight)
              flameNum++;
          }
          flameNum%=10;
        }
        image(flame[flamePicture[flameNum]],flameX[flameNum],flameY[flameNum]);
        flameCounter[flameNum]++;
        if(flameCounter[flameNum]>6){
          flameCounter[flameNum]=0;
          flamePicture[flameNum]++;
        }
        if(flamePicture[flameNum]>4){
          flamePicture[flameNum]=0;
          flameFire[flameNum]=false;
        }
      }

      // game end
      if(hpValue<=0){
        gameState=GAME_END;
      }
      
      break;     
      
    case GAME_END:
      image(end2,0,0);
      if(mouseX>210 && mouseX<430 && mouseY>315 && mouseY<345){ // detect mouse location
        image(end1,0,0);
        if(mousePressed){
          gameState=GAME_START;
        }
      }
      break;
  }
}

void keyPressed(){
  // fighter movement
  if(key==CODED){
    switch(keyCode){
      case UP:
        upPressed=true;
        break;
      case DOWN:
        downPressed=true;
        break;
      case LEFT:
        leftPressed=true;
        break;
      case RIGHT:
        rightPressed=true;
        break;
    }
  }
    
  // shoot
  if(key==' ')
    shootFire=true;
}


void keyReleased(){
  if(key==CODED){
    switch(keyCode){
      case UP:
        upPressed=false;
        break;
      case DOWN:
        downPressed=false;
        break;
      case LEFT:
        leftPressed=false;
        break;
      case RIGHT:
        rightPressed=false;
        break;
    }
  }
}
