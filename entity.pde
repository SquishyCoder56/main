abstract class Entity{
    protected FVector position;
    protected String name;

    // Entity CONSTRUCTOR
    public Entity( String name, int x, int y ){
        this.name = name;
        this.position = new FVector();

        // Checks validity of column variable.
        if( x >= 0 ){
            if( x < gameSettings.playAreaResolution ){
                this.position.x = float(x);
            }
            else{
                IllegalArgumentSmaller( x );
            }
        }
        else{
            IllegalArgumentLarger( x );
        }

        // Checks validity of row variable.
        if( y >= 0 ){
            if( y < gameSettings.playAreaResolution ){
                this.position.y = float(y);
            }
            else{
                IllegalArgumentSmaller( y );
            }
        }
        else{
            IllegalArgumentLarger( y );
        }
    }

    // Abstract method for drawing the entity.
    abstract public void Draw( int frame );

    // Draws a sprite at the correct position, orientation.
    protected void DrawSprite( FVector position, float scale, float rotation, PImage sprite, boolean flip ){    // Draws a snake block.
        float sS = gameSettings.squareSize;

        pushMatrix();

        float x = gameSettings.IndexToPosition( position.x ) + sS/2f;
        float y = gameSettings.IndexToPosition( position.y ) + sS/2f;
        translate( x, y );

        // Drawing the sprite
        scale( scale, scale );
        if( flip ){ scale( -1, 1 ); }
        rotate( rotation );
        image( sprite, -sS/2f, -sS/2f, sS,sS );

        popMatrix();
    }

    // Properties
    public String   GetName()       { return this.name; }
    public FVector  GetPosition()   { return this.position.ReturnNewInstance(); }
    public float    GetX()          { return this.position.x; }
    public float    GetY()          { return this.position.y; }

    // Exceptions
    private void IllegalArgumentSmaller( int a ){
        throw new IllegalArgumentException( this.name + " must have a column (" + a + ") smaller than the play area." );
    }

    private void IllegalArgumentLarger( int a ){
        throw new IllegalArgumentException( this.name + " must have a row (" + a + ") at 0 or larger." );
    }

    abstract public String toString();
}