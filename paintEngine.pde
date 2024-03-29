class PaintEngine{
    private int currentFrame, lastFrame;
    private PFont mono;

    private int snakeClockRate = gameSettings.GameClockRate();
    private float snakeClockCycle;
    private int snakeFrame;

    private int     countDown       = 3;
    private float   countDownSize   = gameSettings.playAreaSize/4 + gameSettings.playAreaSize/3;
    private float   countDownAlpha  = 0;

    // GameOver variables
    private float   gameOverAlpha       = 0;
    private float   fadeOutAlpha        = 0;
    private float   scoreAlpha          = 0;
    private float   startOverAlpha      = 0;
    private float   scoreTextSize       = 120;
    private float   gameOverTextSize    = 190;
    private int     textSizeEnd         = int( gameSettings.playAreaSize / 10 );
    private int     gameOverWaitingTime = 3000;
    private boolean drawFadeOut         = true;
    private boolean drawGameScore       = false;
    private boolean drawRestart         = false;
    private boolean drawGameOverText    = false;

    private long    lastUpdate;
    private long    lastStartTextUpdate;
    private long    lastStartUpdate;
    private long    lastSnakeUpdate;
    private boolean replay = false;
    private boolean stop    = false;
    private int     frame;

    //  ----    ----    PaintEngine CONSTRUCTOR     ----    ----
    public PaintEngine(){
        mono            = createFont( "Cafe Matcha.ttf", 40 );
        lastFrame       = 1;
        lastUpdate      = millis();
        lastStartTextUpdate = millis();
        lastStartUpdate = millis();
        lastSnakeUpdate = millis();
        frame = 1;
    }

    // Draws the game in action.
    public void DrawGame(){
        if( gameSettings.LoopMovement() )       { DrawPlayAreaOutOfBounds(); }
        DrawPlayArea();
        DrawEntities();
        DrawGameScore();
        if( gameStatus == GameStatus.STARTUP )  { DrawCountDown(); }
        else if( gameStatus == GameStatus.GAMEOVER ) { DrawGameOver(); }
    }
    
    private void DrawPlayAreaOutOfBounds(){
        for( int i = 0; i < gameSettings.playAreaResolution; i++ ){
            for( int j = 0; j < 3; j++ ){
                if( i % 2 !=  j % 2 ){ continue; }

                fill( 210, 50 - 20*j );
                rect(
                    gameSettings.playAreaOffsetX - gameSettings.squareSize * (j + 1),
                    gameSettings.playAreaOffsetY + gameSettings.squareSize * i,
                    gameSettings.squareSize, gameSettings.squareSize
                );
                rect(
                    gameSettings.playAreaOffsetX + gameSettings.playAreaSize + gameSettings.squareSize * j,
                    gameSettings.playAreaOffsetY + gameSettings.squareSize * i,
                    gameSettings.squareSize, gameSettings.squareSize
                );

                rect(
                    gameSettings.playAreaOffsetX + gameSettings.squareSize * i,
                    gameSettings.playAreaOffsetY - gameSettings.squareSize * (j+1),
                    gameSettings.squareSize, gameSettings.squareSize
                );
                rect(
                    gameSettings.playAreaOffsetX + gameSettings.squareSize * i,
                    gameSettings.playAreaOffsetY + gameSettings.playAreaSize + gameSettings.squareSize * j,
                    gameSettings.squareSize, gameSettings.squareSize
                );
            }
        }
    }


    // Methods for drawing the play area.
    private void DrawPlayArea(){                                             // Draws the play area.
        float   size    = gameSettings.playAreaSize;
        float   sSize   = gameSettings.squareSize;
        int     res     = gameSettings.playAreaResolution;
        pushMatrix();

        rectMode( CORNER );
        translate( gameSettings.playAreaOffsetX, gameSettings.playAreaOffsetY );

        // Draws the back of the play area
        fill( gameSettings.PLAYAREACOLOR );
        noStroke();
        rect( 0, 0, size, size );

        pushMatrix();
        for( int i = 1; i <= res; i++ ){
            pushMatrix();
            for( int j = 1; j <= res; j++ ){
                if( i % 2 == 0 && j % 2 == 0 ){         // CHECKS IF THE COORDINATES ARE EVEN.
                    DrawPlayAreaSquare( sSize );
                }
                else if( i % 2 != 0 && j % 2 != 0 ){    // CHECKS IF THE COORDINATES ARE UNEVEN.
                    DrawPlayAreaSquare( sSize );
                }

                translate( sSize, 0 );
            }
            popMatrix();

            translate( 0, sSize );
        }
        popMatrix();

        popMatrix();
    }

    private void DrawPlayAreaSquare( float size ){                          // Draws one square in the play area.
        fill( gameSettings.PLAYSQUARECOLOR );
        noStroke();
        rect( 0, 0, size, size );
    }

    private void DrawEntities(){
        this.currentFrame   = ceil( gameSettings.frames * gE.phE.ReturnClockCycle() );         // Sets the current frame in sync with the gameClockCycle
        this.snakeFrame     = ceil( gameSettings.frames * gE.phE.ReturnSnakeClockCycle() );    // Sets the current frmae in sync with the snakeClockCycle, as to only speed up the snake frame rate.
        
        // Making sure no "illegal" frames are created.
        if( this.snakeFrame > 5 ){ this.snakeFrame = 5; }
        if( this.snakeFrame < 1 ){ this.snakeFrame = 1; }

        if( this.currentFrame > 5 ){ this.currentFrame = 5; }
        if( this.currentFrame < 1 ){ this.currentFrame = 1; }

        // Translating canvas and pushing matrix.
        pushMatrix();
        translate( gameSettings.playAreaOffsetX, gameSettings.playAreaOffsetY );

        // Drawing all sprites and fruits.
        for( Entity_Sprite e : gE.sprites ){
            e.Draw( this.currentFrame );
        }
        for( Entity e : gE.fruits ){
            e.Draw( this.currentFrame );
        }

        // Script for stopping snake at its current frame when game has paused.
        frame = currentFrame;
        if( gE.pause ){
            if( frame == 5 ){
                frame = this.lastFrame;
                stop = true;
            }
        }
        else if( this.lastFrame == this.currentFrame ){
            this.lastFrame = frame;
            stop = false;
        }

        // Drawing snake, and if paused draws it at the last frame.
        if( stop ){
            gE.snake.Draw( 5 );
        }
        else{
            gE.snake.Draw( snakeFrame );
        }

        // Draws a black border around the playarea.
        stroke( 255 );
        strokeWeight( 2 );
        noFill();
        rect( 0, 0, gameSettings.playAreaSize, gameSettings.playAreaSize );
    
        popMatrix();
        noTint();

        if( !gE.pause ){
            this.lastFrame = currentFrame;
            lastUpdate = millis();
        }
    }

    private void DrawGameScore(){
        float x = gameSettings.GameWindowWidth() / 2;
        float y = gameSettings.playAreaOffsetY / 2;
        int size = int( gameSettings.playAreaOffsetY / 2 ) + 10;
        DrawText( "SCORE: " + nf( gE.score, 3 ), x, y, size, color( 210, 255 - this.fadeOutAlpha ) );
    }

    // Creating a countdown for when the game starts.
    private void DrawCountDown(){
        if( millis() - this.lastStartUpdate > 30 ){
            this.countDownSize  = Lerp( this.countDownSize, gameSettings.playAreaSize/4, 0.5f );
            println( this.countDownSize );
            this.countDownAlpha = Lerp( this.countDownSize, 255, 0.5f );

            this.lastStartUpdate = millis();
        }
        if( millis() - this.lastStartTextUpdate > 1000 ){
            this.countDown -= 1;

            this.countDownSize = gameSettings.playAreaSize/4 + gameSettings.playAreaSize/3;
            this.countDownAlpha = 0;

            this.lastStartTextUpdate = millis();
        }

        if( this.countDown != 0 ){
            fill( 0, 210 );
            rect( gameSettings.playAreaOffsetX, gameSettings.playAreaOffsetY, gameSettings.playAreaSize, gameSettings.playAreaSize );
            DrawText( 
                str( this.countDown ),
                float( width / 2 ), float( height / 2 ),
                int( this.countDownSize ),
                color( 255, 120, 120, this.countDownAlpha ) );
        }
    }

    private void DrawGameOver(){
        if( millis() - this.lastUpdate >= this.gameOverWaitingTime ){
            if( this.fadeOutAlpha < 209.9f ){
                this.fadeOutAlpha = Lerp( this.fadeOutAlpha, 210, 0.2f );
            }
            else if( this.gameOverAlpha < 254.9 ){
                this.drawGameOverText   = true;
                this.gameOverAlpha      = Lerp( this.gameOverAlpha, 255, 0.5f );
                this.gameOverTextSize   = Lerp( this.gameOverTextSize, this.textSizeEnd + 60, 0.5f );
            }
            else if( this.scoreAlpha < 254.9f ){
                this.drawGameScore  = true;
                this.scoreAlpha     = Lerp( this.scoreAlpha, 255, 0.5f );
                this.scoreTextSize  = Lerp( this.scoreTextSize, this.textSizeEnd + 20, 0.5f );
            }
            else if( this.startOverAlpha < 254.9f ){
                this.drawRestart    = true;
                this.startOverAlpha = Lerp( this.startOverAlpha, 255, 0.8f );
            }
            else{
                this.gameOverWaitingTime    = 1000;
            }
            this.gameOverWaitingTime = 30;
            this.lastUpdate = millis();
        }
        fill( 0, this.fadeOutAlpha );
        rect( gameSettings.playAreaOffsetX, gameSettings.playAreaOffsetY, gameSettings.playAreaSize, gameSettings.playAreaSize );
        if( this.drawGameOverText ){
            float x = gameSettings.GameWindowWidth() / 2;
            float y = gameSettings.GameWindowSize() / 2;
            
            DrawText( "GAME OVER.", x, 3f*y/4f, int(this.gameOverTextSize), color( 255, 70, 70, this.gameOverAlpha ) );

            if( this.drawGameScore ){
                DrawText( "FINAL SCORE: " + nf( gE.score, 3 ), x, y, int(this.scoreTextSize), color( 255, this.scoreAlpha) );

                if( this.drawRestart ){
                    DrawText( "Press 'r' to restart with current settingss, or 'm' to return to the menu", x, height - 0.1f*y, int(this.scoreTextSize/3), color( 255, this.startOverAlpha ) );
                }
            }
        }
    }

    private void DrawText( String text, float x, float y, int size, color fillColor ){
        fill( 200 );
        noStroke();
        textAlign( CENTER, CENTER );
        fill( fillColor );
        textFont( this.mono, size );
        text( text, x, y );
    }

    // Return methods
    public int ReturnCurrentFrame(){
        return currentFrame;
    }
}