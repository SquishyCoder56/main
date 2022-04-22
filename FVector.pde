class FVector{
  public float x, y;

  // SVector default CONSTRUCTOR
  public FVector(){
    this.x = 0f;
    this.y = 0f;
  }

  // SVector CONSTRUCTOR
  public FVector( float x, float y ){
    this.x = x;
    this.y = y;
  }

  public FVector( int x, int y ){
    this.x = float( x );
    this.y = float( y );
  }



  //  ----  ----    COMMON OPERATIONS   ----  ----
  // Set
  public void Set( float x, float y ){                                          // Sets the coordinates to the gives coordinates.
    this.x = x;
    this.y = y;
  }
  public void Set( FVector vector ){                                            // Sets the coordinates to that of a given vector.
    Set( vector.x, vector.y );
  }

  // Add methods

  /**
  @param x '-,
  Adds this x coordinate to the vector.'
  @param y 'Adds this y coordinate to the vector.'
   */
  public void Add( float x, float y ){                                          // Adds the given x and y coordinates to the vector.
    this.x += x;
    this.y += y;
  }
  public void Add( FVector vector ){                                            // Adds the given vector.
    Add( vector.x, vector.y );
  }

  // Subtract methods
  public void Subtract( float x, float y ){                                     // Subtracts the vector by x and y coordinates.
    this.x -= x;
    this.y -= y;
  }
  public void Subtract( FVector vector ){                                        // Subtracts the vector by the inputed vector.
    Subtract( vector.x, vector.y );
  }

  // Multiply method
  public void Multiply( float d ){                                              // Multiplies the vector by d.
    this.x *= d;
    this.y *= d;
  }

  // Divide method
  public void Divide( float d ){                                                // Divides the vector by d.
    this.x /= d;
    this.y /= d;
  }

  // Project
  public void Project( FVector vector ){                                        // Projects vector onto another given vector.
    float d = GetScalarProduct( vector ) / ( vector.GetMagnitude() * vector.GetMagnitude() );
    Set( FVectorMath.Multiply( vector, d ) );
  }

  // Normalize
  public void Normalize(){
    if      ( this.x < -1f ){ this.x = -1; }
    else if ( this.x >  1f ){ this.x =  1; }
    else                    { this.x =  0; }

    if      ( this.y < -1f ){ this.y = -1; }
    else if ( this.y >  1f ){ this.y =  1; }
    else                    { this.y =  0; }
  }



  //  ----  ----    RETURN METHODS    ----  ---
  // Angle
  public float GetAngle(){
    return atan( y / x );
  }


  // Magnitudes
  public float GetMagnitude(){                                                  // Returns the magnitude (length) of the vector.
    return sqrt( this.x * this.x + this.y * this.y );
  }

  // Scalar products
  public float GetScalarProduct( FVector vector ){                              // Returns the scalar product of this vector and a second vector.
    if( GetMagnitude() == 0f || vector.GetMagnitude() == 0f ){
      return 0f;
    }
    
    return x*vector.x + y*vector.y;
  }

  public FVector ReturnNewInstance(){                                           // Returns a new instance of an FVector with the same x and y coordinates.
    return new FVector( x, y );
  }
  public float[] GetVector(){                                                   // Returns both x and y positions as a float array.
    float[] vectors = { x, y };
    return vectors;
  }
  
  public boolean IsTheSame( FVector vector ){                                   // Returns true if the given vector is the same as this vector.
    if( x == vector.x && y == vector.y ){ return true; }
    return false;
  }


  // String override
  public String toString(){
    return "( " + x +  ", " + y + " )";
  }
}