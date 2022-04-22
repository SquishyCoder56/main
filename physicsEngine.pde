class PhysicsEngine{
  private int dt;
  private long lastUpdate, lastSnakeUpdate, currentUpdate;
  private long gameClock, snakeClock;

  // Default PhysicsEngine CONSTRUCTOR
  public PhysicsEngine(){
    dt = gameSettings.GameClockRate();
    lastUpdate = millis();
  }

  // PhysicsEngine CONSTRUCTOR
  public PhysicsEngine( int dt ){
    this.dt = dt;
    lastUpdate = millis();
  }

  // Updating physics of entities
  public void UpdateEntityPhysics( Entity_Snake snake, ArrayList<Entity> entities, boolean pause ){
    currentUpdate = millis();                       // Sets the start time for this loop.
    gameClock     = currentUpdate - lastUpdate;       // Calculates the gameClock time.
    snakeClock    = currentUpdate - lastSnakeUpdate;
    dt            = gameSettings.GameClockRate();

    if( gameClock >= dt ){
      if( !pause ){
        for( Entity e : entities ){                   // Loops through the passed entities[] argument and updates their physics bodies.
          if( e instanceof IntPhysicsBody ){
            ( (IntPhysicsBody)e ).UpdatePhysics( );
          }
        }
      }

      lastUpdate = currentUpdate;                   // Sets the last update to the start time of this loop.
    }

    if( snakeClock > gameSettings.snakeClockRate ){
      if( !pause ){
        snake.UpdatePhysics();
      }

      lastSnakeUpdate = currentUpdate;
    }
  }

  // Return methods
  public float ReturnClockCycle(){
    return (millis() - lastUpdate) / float(dt);
  }

  public float ReturnSnakeClockCycle(){
    return (millis() - lastSnakeUpdate) / float(dt);
  }

  public boolean CheckFruitCollision( Entity_Snake snake, ArrayList<Entity> entities ){
    for( int i = 0; i < entities.size(); i++ ){
      if( entities.get( i ) instanceof Entity_Fruit ){
        if(  FVectorMath.IsTheSameVector( entities.get( i ).GetPosition(), snake.GetPosition() ) ){
          entities.remove( i );
          return true;
        }
      }
    }
    return false;
  }
}