class PaintEngine{
    private int currentFrame, lastFrame;
    private PFont mono;

    private int snakeClockRate = gameSettings.GameClockRate();
    private float snakeClockCycle;
    private int snakeFrame;

    private int acceleration = 0;

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
    private long    lastSnakeUpdate;
    private boolean replay = false;
    private boolean stop    = false;
    private int     frame;

    //  ----    ----    PaintEngine CONSTRUCTOR     ----    ----
    public PaintEngine(){
        mono            = createFont( "Cafe Matcha.ttf", 40 );
        lastFrame       = 1;
        lastUpdate      = millis();
        lastSnakeUpdate = millis();
        frame = 1;
    }

    // Creating a countdown for when the game starts.
    // public void CountDown(){
    //     if( millis() - lastUpdate )
    // }

    //  ----    ----    Drawing Methods     ----    ----
    public void DrawEntities( Entity_Snake snake, ArrayList<Entity> fruits, ArrayList<Entity_Sprite> sprites, float clockCycle, float snakeClockCycle, boolean pause ){      
        this.currentFrame   = ceil( gameSettings.frames * clockCycle );         // Sets the current frame in sync with the gameClockCycle
        this.snakeFrame     = ceil( gameSettings.frames * snakeClockCycle );    // Sets the current frmae in sync with the snakeClockCycle, as to only speed up the snake frame rate.
        
        // Making sure no "illegal" frames are created.
        if( this.snakeFrame > 5 ){ this.snakeFrame = 5; }
        if( this.snakeFrame < 1 ){ this.snakeFrame = 1; }

        if( this.currentFrame > 5 ){ this.currentFrame = 5; }
        if( this.currentFrame < 1 ){ this.currentFrame = 1; }

        // Translating canvas and pushing matrix.
        pushMatrix();
        translate( gameSettings.playAreaOffsetX, gameSettings.playAreaOffsetY );

        // Drawing all sprites and fruits.
        for( Entity_Sprite e : sprites ){
            e.Draw( this.currentFrame );
        }
        for( Entity e : fruits ){
            e.Draw( this.currentFrame );
        }

        // Script for stopping snake at its current frame when game has paused.
        frame = currentFrame;
        if( pause ){
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
            snake.Draw( 5 );
        }
        else{
            snake.Draw( snakeFrame );
        }

        // Draws a black border around the playarea.
        stroke( 255 );
        strokeWeight( 2 );
        noFill();
        rect( 0, 0, gameSettings.playAreaSize, gameSettings.playAreaSize );
    
        popMatrix();
        noTint();

        if( !pause ){
            this.lastFrame = currentFrame;
            lastUpdate = millis();
        }
    }

    // Methods for drawing the play area.
    public void DrawPlayArea(){                                             // Draws the play area.
        pushMatrix();

        rectMode( CORNER );
        translate( gameSettings.playAreaOffsetX, gameSettings.playAreaOffsetY );

        // Draws checker-pattern playearea.
        DrawPlayAreaBack( gameSettings.playAreaSize );
        DrawPlayAreaSquares( gameSettings.squareSize, gameSettings.playAreaResolution );

        popMatrix();
    }

    // Draws the backdrop of the play area. 
    private void DrawPlayAreaBack( float size ){                            
        pushMatrix();
        fill( gameSettings.PLAYAREACOLOR );
        noStroke();
        rect( 0, 0, size, size );
        popMatrix();
    }

    private void DrawPlayAreaSquares( float size, float res ){              // Draws the checkboard pattern of squares on the play area.
        
        pushMatrix();

        for( int i = 1; i <= res; i++ ){
            pushMatrix();
            for( int j = 1; j <= res; j++ ){
                if( i % 2 == 0 && j % 2 == 0 ){         // CHECKS IF THE COORDINATES ARE EVEN.
                    DrawPlayAreaSquare( size );
                }
                else if( i % 2 != 0 && j % 2 != 0 ){    // CHECKS IF THE COORDINATES ARE UNEVEN.
                    DrawPlayAreaSquare( size );
                }

                translate( size, 0 );
            }
            popMatrix();

            translate( 0, size );
        }

        popMatrix();
    }

    private void DrawPlayAreaOutOfBounds(){
        pushMatrix();
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
        popMatrix();
    }

    private void DrawPlayAreaSquare( float size ){                          // Draws one square in the play area.
        pushMatrix();
        fill( gameSettings.PLAYSQUARECOLOR );
        noStroke();
        rect( 0, 0, size, size );
        popMatrix();
    }

    public void DrawGameScore(){
        float x = gameSettings.GameWindowWidth() / 2;
        float y = gameSettings.playAreaOffsetY / 2 + 10;
        textSize( 40 );
        DrawText( "SCORE: " + nf( gE.score, 3 ), x, y, 40, color( 210, 255 - this.fadeOutAlpha ) );
    }

    private void DrawText( String text, float x, float y, int size, color fillColor ){
        fill( 200 );
        noStroke();
        textAlign( CENTER );
        fill( fillColor );
        textFont( this.mono, size );
        text( text, x, y );
    }

    public void DrawGameOver( float clockCycle ){
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
                    DrawText( "Press 'r' to restart with current settingss, or 'm' to return to the menu", x, y + 0.5f*y, 20, color( 255, this.startOverAlpha ) );
                }
            }
        }
    }

    private void SpeedUpSnake( int b ){
        this.acceleration += b;
    }

    // Return methods
    public int ReturnCurrentFrame(){
        return currentFrame;
    }
}