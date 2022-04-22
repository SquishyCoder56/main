class Sprite{
    private PImage[]    images;
    private int         frames;
    private String      spriteName;

    // Sprite CONSTRUCTOR
    public Sprite( String spriteDirectory, String spriteName ){
        this.spriteName = spriteName;
        this.frames     = gameSettings.frames;
        this.images     = new PImage[ frames ];

        for( int i = 0; i < this.frames; i++ ){
            this.images[i] = loadImage( "data/sprites/" + spriteDirectory + "/" + this.spriteName + nf( i + 1, 2 ) + ".png" );
        }
    }

    /**
     Draws a sprite on the canvas.
     @args frame    the frame to draw the sprite at
     @args position the position to draw the sprite at
     @args rotation the rotation of the sprite
     @args flip     if true, flips the sprite image
     */
    public void DrawSprite( int frame, FVector position, float scale, float rotation, boolean flip ){    // Draws a snake block.
        float sS = gameSettings.squareSize;

        pushMatrix();

        float x = gameSettings.IndexToPosition( position.x ) + sS/2f;
        float y = gameSettings.IndexToPosition( position.y ) + sS/2f;
        translate( x, y );

        // Drawing the sprite
        scale( scale, scale );
        if( flip ){ scale( -1, 1 ); }
        rotate( rotation );
        image( this.images[ frame - 1 ], -sS/2f, -sS/2f, sS,sS );

        popMatrix();
    }

    // Returns the name
    public String SpriteName(){
        return this.spriteName;
    }
}