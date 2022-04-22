class Entity_Sprite extends Entity{
    private Sprite  sprite;
    private float   rotation; 
    private long    lastUpdate;
    
    // Pre-set variables
    private boolean expired     = false;
    private int     clock       = gameSettings.GameClockRate();
    private int     frame       = 1;
    

    // Entity_Sprite CONSTRUCTOR
    public Entity_Sprite( String name, int x, int y, String spriteDirectory, String spriteName, float rotation ){
        super( name, gameSettings.CorrectInt( x ), gameSettings.CorrectInt( y ) );

        this.sprite     = new Sprite( spriteDirectory, spriteName );
        this.rotation   = rotation;

        this.lastUpdate = millis();
    }

    // Entity_Sprite CONSTRUCTOR with a clock
    public Entity_Sprite( String name, int x, int y, String spriteDirectory, String spriteName, float rotation, int clock ){
        super( name, gameSettings.CorrectInt( x ), gameSettings.CorrectInt( y ) );

        this.sprite     = new Sprite( spriteDirectory, spriteName );
        this.rotation   = rotation;
        this.clock      = clock;

        this.lastUpdate = millis();
    }

    /**
     Draws the sprites entity with its own frame count.
    */
    public void Draw( int frame ){
        long dLastUpdate    = millis() - this.lastUpdate;
        if( dLastUpdate >= clock ){                             // Expires the sprite if an amount of time has gone
            this.expired = true;
            return;
        }

        float clockCycle = dLastUpdate / float(gameSettings.GameClockRate());

        this.frame = ceil( gameSettings.frames * clockCycle ); 
        if( this.frame <= 0 || this.frame > 5){ this.frame = 1; }
        
        sprite.DrawSprite( this.frame, this.position, 0.9f, this.rotation, false );
    }

    /**
     Returns the current status of this sprite. If expired, this sprite will be destroyed.
    */
    public boolean IsExpired(){
        return this.expired;
    }

    public String toString(){
        return name + "(Entity_Sprite), pos : " + position + ".";
    }
}