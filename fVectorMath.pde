static class FVectorMath{
  
  //  ----  ----  BASIC OPERATIONS  ----  ----
  // Addition
  static FVector Add( FVector vector1, FVector vector2 ){                       // Returns the addition of vector1 and vector 2.
    FVector newVector = vector1.ReturnNewInstance();
    newVector.Add( vector2 );
    return newVector;
  }

  // Subtraction
  static public FVector Subtract( FVector vector1, FVector vector2 ){                  // Returns the subtraction of vector1 and vector2.
    FVector newVector = vector1.ReturnNewInstance();
    newVector.Subtract( vector2 );
    return newVector;
  }

  // Multiplication
  static public FVector Multiply( FVector vector, float d ){                           // Returns a vector that has been multiplied by d.
    FVector newVector = vector.ReturnNewInstance();
    newVector.Multiply( d );
    return newVector;
  }

  // Division
  static public FVector Divide( FVector vector, float d ){                             // Returns a vector that has been divided by d.
    FVector newVector = vector.ReturnNewInstance();
    newVector.Divide( d );
    return newVector;
  }

  //  ----  ----  RETURN METHODS  ----  ----
  // Angle
  static public float GetAngle( FVector vector1, FVector vector2 ){
    float scalarProduct = GetScalarProduct( vector1, vector2 );
    float cosinus = scalarProduct / ( vector1.GetMagnitude() * vector2.GetMagnitude() );
    float angle = acos( cosinus );

    return angle;
  }
  
  // Magnitude
  static public float GetMagnitude( FVector vector ){
    return vector.GetMagnitude();                       // Returns the magnitude (length) of the inputed vector.
  }

  // Scalar product
  static public float GetScalarProduct( FVector vector1, FVector vector2 ){            // Returns the scalar product of two vectors.
    return vector1.GetScalarProduct( vector2 );
  }

  // Projection
  static public FVector GetProjectionVector( FVector vector1, FVector vector2 ){
    FVector newProjVector = vector1.ReturnNewInstance();
    newProjVector.Project( vector2 );
    return newProjVector;
  }

  // Is the same vector'
  static public boolean IsTheSameVector( FVector vector1, FVector vector2 ){
    if( vector1.x == vector2.x && vector1.y == vector2.y ){ return true; }
    return false;
  }


}