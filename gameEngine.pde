class GameEngine{
    // Engines
    private PhysicsEngine   phE;
    private PaintEngine     pE;

    // Entities
    private ArrayList<Entity>           fruits;
    private ArrayList<Entity_Sprite>    sprites;
    private Entity_Snake                snake;

    // INFO about play area
    private boolean[][] inhabitedCells;

    // gameSettings pointers
    private int res;

    // Start-up settings
    private int score;

    // FLAGS
    private boolean pause               = false;
    private boolean gameOver            = false;
    private boolean quit                = false;

    // GameEngine CONSTRUCTOR
    public GameEngine(){
        this.phE = new PhysicsEngine();              // Initializing engines.
        this.pE  = new PaintEngine();

        this.fruits  = new ArrayList<Entity>();       // Initializing entity arrays.
        this.sprites = new ArrayList<Entity_Sprite>();

        this.res = gameSettings.playAreaResolution;  // Retrieving variables from gameSettings.

        this.score = 0;                              // Start-up settings.
        
        this.inhabitedCells = new boolean[ this.res ][ this.res ];                 // Makes all cells uninhabited for the beginning.
        for( int y = 0; y < this.res; y++ ){
            for( int x = 0; x < this.res; x++ ){
                this.inhabitedCells[ x ][ y ] = false;
            }
        }

        this.snake =  new Entity_Snake( "Snake", 3, 6, MOVELEFT );       // Creating our player (a Entity_Snake object).

        for( int i = 0; i < gameSettings.FruitsPerPlayArea(); i++ ){  // Filling play area with the fruits.
            this.fruits.add( MakeFruit() );
        }
    }

    public void CountDown(){
        // pE.CountDown();
    }

    /** 
     Main method for GameEngine. Updates the games engines (physics engine and painengine),
     checks for collisions and refills play area with fruits.
    */
    public void UpdateGame(){
        phE.UpdateEntityPhysics( this.snake, this.fruits, this.pause );
        pE.DrawPlayArea();
        if( gameSettings.LoopMovement() ){ pE.DrawPlayAreaOutOfBounds(); }
        pE.DrawEntities( this.snake, this.fruits, this.sprites, this.phE.ReturnClockCycle(), this.phE.ReturnSnakeClockCycle(), this.pause );
        pE.DrawGameScore();

        if( this.gameOver ){
            pE.DrawGameOver( this.phE.ReturnClockCycle() );
        }

        if( CheckSnakeCollision() ){
            this.gameOver   = true;
            this.pause      = true;
        }

        if( phE.CheckFruitCollision( snake, fruits ) ){
            this.score += 10;
            if( this.score % 50 == 0 ){
                println("SNAKE: SPEEDING UP!");
                gameSettings.snakeClockRate -= 2;
            }
            this.snake.AddToSnakeBody();
        }

        if( fruits.size() < gameSettings.FruitsPerPlayArea() ){
            this.fruits.add( MakeFruit() );
        }
    }

    /**
     Adds a fruit to any unhabited cells in the play area.
    */
    private Entity_Fruit MakeFruit(){
        CheckIC();                                  // Rechecks play area for inhabited cells.

        int x =  int( random( res ) );              // Creates a random set of coordinates in
        int y =  int( random( res ) );              // the play area.

        while( true ){                              // Loops and makes new random coordinates
            if( this.inhabitedCells[ x ][ y ] ){         // until they dont match any occupied
                x = int ( random( res ) );          // cells.
                y = int ( random( res ) );
            }
            else{ break; }
        }

        this.inhabitedCells[ x ][ y ] = true;            // Sets the coordinates cell to 'occupied'

        return new Entity_Fruit( "Apple", x, y );
    }

    private boolean CheckSnakeCollision(){
        if( this.snake.HeadCollision() ){
            return true;
        }
        return false;
    }

    private void CheckSprites(){
        for( int i = 0; i < this.sprites.size(); i++ ){
            if( sprites.get( i ).IsExpired() ){
                sprites.remove( i );
            }
        }
    }



    /**
     Checks the play area for all occupied cells and updates
     the 'inhabitedCells' arrayList.
    */
    private void CheckIC(){
        ICClear();
        ICCheckSnake();
        ICCheckFruits();
    }

    /**
     Clears the 'inhabitedCells' arrayList by setting all
     indexes to false.
    */
    private void ICClear(){
        for( int y = 0; y < this.res; y++ ){
            for( int x = 0; x < this.res; x++ ){
                this.inhabitedCells[x][y] = false;
            }
        }
    }
    
    /**
     Adds the cells that the snake occupies to the arrayList.
    */
    private void ICCheckSnake(){
        for( int y = 0; y < this.res; y++ ){
            for( int x = 0; x < this.res; x++ ){
                if( this.snake.DoesCollideSnake( new FVector( x, y ) ) ){
                    this.inhabitedCells[x][y] = true;
                }
            }
        }
    }

    /**
     Adds the cells that the fruits occupies to the arrayList.
    */
    private void ICCheckFruits(){
        for( int y = 0; y < this.res; y++ ){
            for( int x = 0; x < this.res; x++ ){
                if( CollideWithFruit( new FVector( x, y ) ) ){
                    this.inhabitedCells[x][y] = true;
                }
            }
        }
    }

    /**
     Checks if a given vector collides with any fruits at the 
     same position.
    */
    private boolean CollideWithFruit( FVector vector ){
        for( Entity f : this.fruits ){
            if( vector.IsTheSame( f.GetPosition() ) ){
                return true;
            }
        }
        return false;
    }



    /**
     Accesses the snake entity and turns it right.
    */
    public void TurnSnakeRight(){
        this.snake.UpdateVelocityRight();
    }

    /**
     Accesses the snake entity and turns it left.
    */
    public void TurnSnakeLeft(){
        this.snake.UpdateVelocityLeft();
    }

    /**
    Adds to the length of the snake entity.
    */
    public void AddSnakeBody(){
        this.snake.AddToSnakeBody();
    }



    public void AddSprite( Entity_Sprite sprite ){
        this.sprites.add( sprite );
    }



    /**
    Pauses the game by disabling physics updates.
    */
    public void TogglePause(){
        if( !this.gameOver ){
            this.pause = !this.pause;
        }
    }



    // Return methods
    public float ReturnClockCycle(){
        return this.phE.ReturnClockCycle();
    }

    // PROPERTIES
    public boolean Quit(){ return this.quit; }
    public boolean GameOver(){ return this.gameOver; }
}