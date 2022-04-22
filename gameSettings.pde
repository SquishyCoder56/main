class GameSettings{
    // Settings
    private int         gameWindowSize, gameWindowWidth;
    public final int    playAreaResolution  = 10;
    public final int    frames              = 5;

    // Game Settings
    private int     fruitsPerPlayArea   = 1;
    private boolean loopMovement        = true;
    public  int     gameClockRate       = 380;  // Default 380

    // the snake goes back a frame, some kind of bug

    // Color settings
    public final color  BACKCOLOR        = #1D1B1C;
    public final color  PLAYAREACOLOR    = #DCE2BD;
    public final color  PLAYSQUARECOLOR  = #D4CDAB;

    // Automated settings
    public float playAreaSize, playAreaOffsetX, playAreaOffsetY, squareSize;
    public int     snakeClockRate      = gameClockRate; 

    public GameSettings(){
        this.gameWindowSize     = height;
        this.gameWindowWidth    = width;

        this.squareSize     = floor( ( float(this.gameWindowSize) * 0.8f ) / ( float(this.playAreaResolution) * 10f ) ) * 10f;
        this.playAreaSize   = this.squareSize * this.playAreaResolution;


        this.playAreaOffsetX = ( this.gameWindowWidth - playAreaSize ) / 2f;
        this.playAreaOffsetY = ( this.gameWindowSize - playAreaSize ) / 2f;
    }

    // Methods
    public boolean OutOfBounds( FVector min, FVector max, FVector vector ){
        if( vector.x >= min.x && vector.x <= max.x && vector.y >= min.y && vector.y <= max.y ){
            return true;
        }
        return false;
    }

    public float IndexToPosition( float i ){
        return i * squareSize;
    }

    // Scales a vector by the square size.
    public void ScaleFVector( FVector vector ){
        vector.Multiply( squareSize );
    }

    public int CorrectInt( int i ){
        int res = playAreaResolution;
        if( i < 0 ){ i += res; }
        if( i >= res ){ i -= res; }
        return i;
    }

    // Corrects a vector so that its length doesn't go past 1 unit.
    public FVector CorrectFVector( FVector vector ){
        int res = playAreaResolution;
        FVector newVector = vector.ReturnNewInstance();
        if( newVector.GetMagnitude() > 1f ){
            if( vector.x < -1f ){ vector.x += res; }
            else if( vector.x >  1f ){ vector.x -= res; }
            if( vector.y < -1f ){ vector.y += res; }
            else if( vector.y >  1f ){ vector.y -= res; }
        }

        return vector;
    }


    // PROPERTIES
    public int  GameWindowSize(){ return this.gameWindowSize; }
    public void GameWindowSize( int gameWindowSize ){ this.gameWindowSize = gameWindowSize; }
    
    public int  GameWindowWidth(){ return this.gameWindowWidth; }
    public void GameWindowWidth( int gameWindowWidth ){ this.gameWindowWidth = gameWindowWidth; }

    public int  GameClockRate(){ return this.gameClockRate; }
    public void GameClockRate( int gameClockRate ){ this.gameClockRate = gameClockRate; }
    
    public boolean  LoopMovement(){ return this.loopMovement; }
    public void     LoopMovement( boolean loopMovement ){ this.loopMovement = loopMovement; }
    
    public int  FruitsPerPlayArea(){ return this.fruitsPerPlayArea; }
    public void FruitsPerPlayArea( int fruitsPerPlayArea ){ this.fruitsPerPlayArea = fruitsPerPlayArea; }
}
