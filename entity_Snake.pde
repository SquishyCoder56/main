class Entity_Snake extends Entity implements IntPhysicsBody{
    private ArrayList<FVector> chain;
    private FVector lastPosition;
    private FVector velocity;
    private int gridSize;

    // Flags
    private boolean velocityLock = false;
    private boolean addSnakeBody = false;

    private String[] spriteNames = {
        "snakeHeadMoving",
        "snakeHeadTrans",
        "snakeHeadTurningTrans",
        "snakeBodyMoving",
        "snakeBodyTurning", 
        "snakeTailTurning",
        "snakeTailMoving", 
        "snakeTailTrans",
        "snakeTurningArrow"
    };
    private ArrayList<Sprite> sprites;
    private float tailAlpha = 0;
    private float headAlpha = 245;

    // Entity_Snake CONSTRUCTOR     #region [CONSTRUCTOR]
    public Entity_Snake( String name, int x, int y, FVector velocity ){
        super( name, x, y );
        this.lastPosition   = new FVector();
        this.velocity       = new FVector();
        this.velocity.Set( velocity );
        
        // Setting up snake chain
        this.chain = new ArrayList<FVector>();
        for( int i = 1; i <= 3; i++ ){
            this.chain.add( new FVector( x + i, y ) );
        }
        this.gridSize = gameSettings.playAreaResolution;

        // Setting up sprites
        this.sprites = new ArrayList<Sprite>();
        for( int i = 0; i < this.spriteNames.length; i++ ){
            this.sprites.add( new Sprite( "snake", this.spriteNames[ i ] ) );
        }
    }    //#endregion


    //  ----    ----    PHYSICSENGINE FUNCTIONALITIES   ----    ----
    // Main method updating entities physics for the physics engine.    #region [UpdatePhysics]  
    public void UpdatePhysics(){
        this.lastPosition = position.ReturnNewInstance();
        LoopMovement( gameSettings.LoopMovement() );
        this.position.Add( this.velocity );
        this.chain.add( 0, this.lastPosition );
        this.chain.remove( this.chain.size() - 1 );
        
        this.velocityLock = false;
        this.addSnakeBody = false;
    }   //#endregion


    // Loops the movement of the snake around the play area.
    public void LoopMovement( boolean toggle ){
        if( toggle ){
            if( this.position.x <= 0f && this.velocity.x < 0f ){
                this.position.x += this.gridSize;
            }
            if( this.position.y <= 0f && this.velocity.y < 0f ){
                this.position.y += this.gridSize;
            }
            if( this.position.x >= ( this.gridSize - 1 ) && this.velocity.x > 0f ){
                this.position.x -= this.gridSize;
            }
            if( this.position.y >= ( this.gridSize - 1 ) && this.velocity.y > 0f ){
                this.position.y -= this.gridSize;
            }
        }
    }

    // Turns the snake its oriented left.
    public void UpdateVelocityLeft(){
        if( !velocityLock ){ 
            velocity.Set( ReturnVectorOrientedLeft( velocity ) );
            velocityLock = true;
            
            // Adding a snakeArrow
            FVector neckVelocity = CalculateNeckVelocity();
        
            // Draws the arrows when the head turns
            FVector left = ReturnVectorOrientedLeft( neckVelocity );
            FVector position = this.position.ReturnNewInstance();
            position.Add( ReturnVectorOrientedLeft( neckVelocity ) );
            gE.AddSprite( new Entity_Sprite(
                "Arrow Left",
                int(position.x), int(position.y),
                "snake", "snakeTurningArrow",
                ReturnRotation( left )
                )
            );
        }
    }

    // Turns the snake its oriented left.
    public void UpdateVelocityRight(){
        if( !this.velocityLock ){
            this.velocity.Set( ReturnVectorOrientedRight( this.velocity ) );
            this.velocityLock = true;

            // Adding a snake arrow
            FVector neckVelocity = CalculateNeckVelocity();
        
            // Draws the arrows when the head turns
            FVector right = ReturnVectorOrientedRight( neckVelocity );
            FVector position = this.position.ReturnNewInstance();
            position.Add( ReturnVectorOrientedRight( neckVelocity ) );
            gE.AddSprite( new Entity_Sprite(
                "Arrow Right",
                int(position.x), int(position.y),
                "snake", "snakeTurningArrow",
                ReturnRotation( right )
                )
            );
        }
    }


    //  ----    ----    PAINTENGINE FUNCTIONALITIES     ----    ----
    // Main method for updating entity drawings for the paint engine.   #region [Draw]
    public void Draw( int frame ){
        int     clock           = gameSettings.GameClockRate();
        FVector neckVelocity    = CalculateNeckVelocity();

        // Draws the body
        for( int i = this.chain.size() - 1; i >= 0; i-- ){
            String sprite       = "snakeBodyMoving";                // Default sprite for animation as most chains are normal moving snake sprites.
            boolean flip        = false;                            // Flips the canvas in certain situations. DEFAULT is off.
            FVector velocity    = new FVector();                    // Useful so we can keep track of where this chain is heading next.
            float rotation;                                         // Will be used to rotate the grid depending on the orientation of the chain.

            // Setting velocity between chains to figure out sprite rotation.
            if( i == 0 ){
                velocity    = FVectorMath.Subtract( this.position, this.chain.get( 0 ) );    // Subtracting with the heads position to get the velocity to the head
                sprite      = "snakeHeadTrans";

            }
            else{ velocity  = FVectorMath.Subtract( this.chain.get( i - 1 ), this.chain.get( i ) ); }
            
            if( i + 2 == this.chain.size() ){
                sprite = "snakeTailTrans";
            }

            velocity = gameSettings.CorrectFVector( velocity );
            rotation = ReturnRotation( velocity );

            // Deciding which sprites to use.
            if( i + 1 < this.chain.size() && i >= 0 ){
                // Checking if this is the neck, so that the nextVelocity will be torwards the head in that case.
                FVector nextBlock;
                if( i == 0 ){ nextBlock = this.position.ReturnNewInstance(); }
                else        { nextBlock = this.chain.get( i - 1 ); }

                // Setting velocities to tell orientation and if we are turning.
                FVector nextVelocity    = FVectorMath.Subtract( nextBlock, this.chain.get( i ) );
                nextVelocity            = gameSettings.CorrectFVector( nextVelocity );
                FVector prevVelocity    = FVectorMath.Subtract( this.chain.get( i ), this.chain.get( i + 1 ) );
                prevVelocity            = gameSettings.CorrectFVector( prevVelocity );

                // Checking if the current chain is in a corner junction
                if( !nextVelocity.IsTheSame( prevVelocity ) ){
                    if( nextVelocity.IsTheSame( ReturnVectorOrientedLeft(  prevVelocity ) ) ){    // If we are turning left
                        flip = true;

                        if      ( prevVelocity.IsTheSame( MOVEUP ) )    { rotation = 0f; }
                        else if ( prevVelocity.IsTheSame( MOVEDOWN ) )  { rotation = PI; }
                    }
                    else if ( nextVelocity.IsTheSame( ReturnVectorOrientedRight( prevVelocity ) ) ){    // If we are turning right
                        flip = false; 
                    }

                    sprite = "snakeBodyTurning";              // Sets the default sprite to the turning sprite.
                    if( i == 0 ){                                       // If this chain is right on the neck, then we set it to a turning head sprite.
                        sprite = "snakeHeadTurningTrans";
                    }
                    else if( i + 2 == chain.size() ){                   // Else if its a chain right before the tail, we set it to a turning tail sprite.
                        sprite = "snakeTailTurning";
                    }
                }
            }

            if( i + 1 == this.chain.size() ){ sprite = "snakeTailMoving"; }        // Setting the tail sprite last so it overrides anything else.

            if( i == this.chain.size() - 1 && this.addSnakeBody ){
                this.tailAlpha = Lerp( this.tailAlpha, 255, 0.1f );
                tint( #FFBF46, this.tailAlpha );
            }
            else if( gE.GameOver() ){
                tint( #CC3363, this.headAlpha ); 
            }
            else{
                noTint();
            }

            for( Sprite s : this.sprites ){
                if( s.SpriteName() == sprite ){
                    s.DrawSprite( frame, this.chain.get( i ), 1f, rotation, flip );
                    fill( 255, 0, 0, 120 );
                }
            }
        }
        
        if( gE.GameOver() ){
            this.headAlpha = Lerp( this.headAlpha, 0, 0.2f);
            tint( #CC3363, this.headAlpha );
        }

        this.sprites.get( 0 ).DrawSprite( frame, this.position, 1f, ReturnRotation( gameSettings.CorrectFVector( neckVelocity ) ), false );
        /**rect( this.position.x * gameSettings.squareSize, 
                    this.position.y * gameSettings.squareSize, 
                    gameSettings.squareSize, gameSettings.squareSize );*/
    }   //#endregion

    // RETURN METHODS
    public boolean HeadCollision(){
        for( int i = 0; i < this.chain.size() - 1; i++ ){
            if( this.position.IsTheSame( this.chain.get( i ) ) ){
                return true;
            }
        }
        if( !gameSettings.LoopMovement() && !gameSettings.OutOfBounds( new FVector( 0, 0 ), new FVector( 9, 9 ), this.position ) ){
            return true;
        }
        return false;
    }

    public boolean DoesCollideSnake( FVector vector ){
        for( FVector v : this.chain ){
            if( vector.IsTheSame( v ) ){
                return true;
            }
        }
        if( this.position.IsTheSame( vector ) ){
            return true;
        }
        return false;
    }

    // Method for getting rotation value depending on direction
    private float ReturnRotation( FVector vector ){
        if      ( vector.IsTheSame( MOVERIGHT ) )    { return 0f; }
        else if ( vector.IsTheSame( MOVELEFT ) )     { return PI; }
        else if ( vector.IsTheSame( MOVEUP ) )       { return -HALF_PI; }
        else if ( vector.IsTheSame( MOVEDOWN ) )     { return HALF_PI; }
        else                                         { return 0; }
    }
    
    // Returns a vector oriented left of this vector.
    private FVector ReturnVectorOrientedLeft( FVector vector ){
        if      ( vector.IsTheSame( MOVEUP ) )      { return MOVELEFT; }
        else if ( vector.IsTheSame( MOVEDOWN ) )    { return MOVERIGHT; }
        else if ( vector.IsTheSame( MOVELEFT ) )    { return MOVEDOWN; }
        else if ( vector.IsTheSame( MOVERIGHT ) )   { return MOVEUP; }
        else                                        { return MOVENONE; }
    }

    // Returns a vector oriented right of this vector.
    private FVector ReturnVectorOrientedRight( FVector vector ){
        if      ( vector.IsTheSame( MOVEUP ) )      { return MOVERIGHT; }
        else if ( vector.IsTheSame( MOVEDOWN ) )    { return MOVELEFT; }
        else if ( vector.IsTheSame( MOVELEFT ) )    { return MOVEUP; }
        else if ( vector.IsTheSame( MOVERIGHT ) )   { return MOVEDOWN; }
        else                                        { return MOVENONE; }
    }

    private FVector CalculateNeckVelocity(){
        return FVectorMath.Subtract( this.position, this.chain.get( 0 ) );
    }
    
    //  ----    ----    SNAKE FUNCTIONALITIES   ----    ----
    public void AddToSnakeBody(){
        int i = this.chain.size() - 1;

        FVector newChain = this.chain.get( i ).ReturnNewInstance();
        newChain.Multiply( 2f );
        newChain.Subtract( this.chain.get( i - 1 ) );

        this.chain.add( newChain );
        
        this.tailAlpha = 0;
        this.addSnakeBody = true;
    }


    // Returns a string describing the object.
    public String toString(){
        return this.name + " (Entity_Snake), " + "pos : "   + this.position + ", " + "vel : " + this.velocity + ".";
    }
}