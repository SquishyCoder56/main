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
boolean startup = true;


// Creating some enumerations to control the status of the game
boolean runGame = true;
enum GameStatus {
    STARTUP, GAME, GAMEOVER;
}
enum ProgramStatus {
    RESTART, GAME;
}

ProgramStatus   pStatus     = ProgramStatus.GAME;
GameStatus      gameStatus  = GameStatus.STARTUP;

void settings(){
    size( 500, 500 );
    //fullScreen();
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

    if( pStatus == ProgramStatus.RESTART ){
        gE          = new GameEngine();
        pStatus     = ProgramStatus.GAME;
        gameStatus  = GameStatus.STARTUP;
    }


    // // Sets start up to false, ie changes game status to game.
    // if( millis() - lastMillis >= 3000 && startup ){
    //     startup = false;
    // }

    // // Detects if the gamestatus is restart, and changes it to startup.
    // if( millis() - lastMillis >= 800 && restart ){
    //         gE = new GameEngine();
    //         restart = false;
    //         startup = true;
    // }

    // plays the game.
    if( runGame ){
        gE.UpdateGame();
    }
}

float Lerp( float a, float b, float t ){
    return a + t *( b - a );
}

void keyPressed(){
    if( gameStatus == GameStatus.GAME ){
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
    }

    if( key == 'r' ){
      pStatus = ProgramStatus.RESTART;
      println( "Snake: RESTART!" );
    }
}
