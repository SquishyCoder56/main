GameEngine gE;
GameSettings gameSettings;

public final FVector MOVELEFT   = new FVector( -1f,  0f );
public final FVector MOVERIGHT  = new FVector(  1f,  0f );
public final FVector MOVEUP     = new FVector(  0f, -1f );
public final FVector MOVEDOWN   = new FVector(  0f,  1f );
public final FVector MOVENONE   = new FVector(  0f,  0f );

int countDown = 0;
long lastMillis;
boolean restart = false;

void settings(){
    //size( 600, 600 );
    fullScreen();
    noSmooth();
}

void setup(){
    frameRate( 80 );

    gameSettings = new GameSettings();

    gE = new GameEngine();

    lastMillis = millis();
}

void draw(){
    background( gameSettings.BACKCOLOR );

    if( millis() - lastMillis >= 800 && restart ){
            gE = new GameEngine();
            restart = false;
    }

    if( !gE.Quit() ){
        gE.UpdateGame();
    }
}

float Lerp( float a, float b, float t ){
    return a + t *( b - a );
}

void keyPressed(){
    if( key == 'k'  ){
        gE.AddSnakeBody();
    }
    if( key == 'p' ){
        gE.TogglePause();
    }
    if( key == CODED ){
        if( keyCode == LEFT ){
            gE.TurnSnakeLeft();
        }
        if( keyCode == RIGHT ){
            gE.TurnSnakeRight();
        }
    }
    if( key == 'r' ){
      restart = true;
      lastMillis = millis();
    }
}
