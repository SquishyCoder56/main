class Entity_Fruit extends Entity{
    private final String[] spriteNames = { "appleIdle", "bananaIdle", "strawberryIdle" };
    private PImage[] sprites;
    private Sprite sprite;

    // Entity_Snake CONSTRUCTOR
    public Entity_Fruit( String name, int x, int y ){
        super( name, x, y );                            // Sending arguments to inherited class.

        int a = int( random( this.spriteNames.length ) );    // Choosing a random sprite.
        this.sprite = new Sprite( "fruits", this.spriteNames[a] );
    }
    
    public void Draw( int frame ){
        this.sprite.DrawSprite( frame, this.position, 0.95f, 0f, false );
    }


    // Returns a string to explain the object.
    public String toString(){
        return this.name + " (Entity_Fruit), " + "pos : ( " + this.position.x + ", " + this.position.y + " ), ";
    }
}