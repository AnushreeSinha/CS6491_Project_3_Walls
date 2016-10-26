class floor
{
  int maxnv = 1000; //MAX NUMBER OF POINTS IN THE POINTSET
  int maxne = 1000;// NEVER GOING TO NEED THIS EXCEPT TO PUT A CAP ON THE MAX NUMBER OF DARTS - REPRESENTATIONAL PURPOSES ONLY
  int maxnd = 2*maxne; //MAX NUMBER OF DARTS
  int maxng = maxnd ; //MAX NUMBER OF GREEN LOOPS
  
  int nv = 0 ; //INITIALLY THE GRAPH HAS NO VERTICES ONLY POINT SETS
  int ne = 0 ; // INTIALLY NO EDGES EXIST
  int nd = 2*ne;  // INITIALLY NO DARTS EXIST
  int ng = nd ; // NUMBER OF GREEN LOOPS
  
  int pv = 0; //THE VARIABLE FOR TRAVERSING POINTS
  int pe = 0; //Don't think this will be needed
  int pd = 0; // THE VARIABLE FOR TRAVERSING DARTS
  int pg = 0 ; 
  
  //GEOMETRY OF THE POINTS SHOWN AS BALLS
  pt[] G = new pt [maxnv];           // ball centers
  float[] r = new float [maxnv];     // radii
  color[] c = new color [maxnv];     // colors
  
  //VERTICES DATA STRUCTURES
  int [] D = new int[maxnv]; //ARRAY FOR STORING THE CONNECTING DART id OF A VERTEX
  int [] state = new int[maxnv]; // STORES THE STATE OF ALL THE POINTS IN THE POINT SET - 0 - MANIFOLD VERTEX , 1 - NON MANIFOLD VERTEX , 2 - INTERIOR POINT , 3 - EXTERIOR POINT
  int [] dartCount = new int[maxnv]; // USED FOR KEEPING OF TRACK OF NUMBER OF DARTS PER VERTEX AND HENCE DETERMINING ITS STATE
  
  //DARTS DATA STRUCTURES
  int [] greenLoop = new int[maxnd];
  boolean [] traversed = new boolean[maxnd];
  int [] faces = new int[maxnd];
  boolean [] E = new boolean[maxnd]; // ARRAY FOR STORING THE ALPHA EXPOSED STATE OF A DART
  int [] S = new int[maxnd]; //ARRAY FOR STORING THE SWING DART ID OF A DART
  
  
  
  
  
  floor()
  
  {
    //r = 100;
    for(int i = 0 ; i < maxnv ; i++)
    {
      G[i] = P();
      r[i]=1; c[i]=yellow;
      D[i] = -i-1;
      state[i] = 3;
      dartCount[i] = 0;
     
    }
    for(int i =0 ; i < maxnd ; i++)
    {
      
       S[i] = 0;
       greenLoop[i] = 0;
       faces[i] = 0;
       E[i] = false;
       traversed[i] = false;
    }
  
  };
  
  void declare()
  {
    for (int i=0; i<maxnv; i++) {G[i]=P(); r[i]=1; c[i]=yellow;}
  }
  
  floor addPt(pt Pp, float rp, color cp) { 
    G[nv].setTo(Pp); 
    r[nv]=rp; 
    c[nv]=cp; 
    pv=nv;
    nv++;  
    return this;} // adds a point at the end
    
  void showPts() 
    { 
    noStroke(); 
    for (int v=0; v<nv; v++) 
      {
      fill(c[v]); 
      show(G[v],r[v]); 
      //fill(c[v]); 
      //showShadow(G[v],r[v],-w/2+2);
      fill(black);
      textSize(5);
      textSize(20);
      text(str(v),G[v].x+r[v]+5,G[v].y+r[v]+5,0+5);
     
      
      }
    } 
  /*
   void pickClosest(pt M) { // for picking a vertex with the mouse
    pv=0; 
    for (int i=1; i<nv; i++) if (d(M,G[i])<=d(M,G[pv])) pv=i; 
    }
    
    
    void movePicked(vec V) { G[pv].add(V); }      // moves selected point (index p) by amount mouse moved recently
    
    void showPickedPt() {fill(yellow,100); show(G[pv],r[pv]+5); println("SHOW pv="+pv);}
   */ 
  
    
    //STATE OF POINTS FUNCTION
    //****************
    //GIVEN A VALUE R, IT KEEPS TRACK OF THE STATE OF THE POINTS IN THE POINTSET WITH THE STATE AS DEFINED ABOVE
  void stateOfPoint(float r)
  {
   
    Boolean f1 = false , f2 = false;   

    for(int i = 0 ; i < nv ; i++)
    {
      for(int j = i+1 ; j < nv ; j++)
     {
        if(!isSame(G[i],G[j]))
        {
        pt A = G[i];
        pt B = G[j];
        
        if(isCircle(A,B,r))
        {
          for(int k = 0 ; k < nv ; k++)
          {
            if(!isSame(A,G[k])&&!isSame(B,G[k]))
            {
                pt P = G[k];
                if (isInDiskOnRight(P,A,B,r))
               {
          
                   f1 = false;
                   break;
               }
               else if(!isInDiskOnRight(P,A,B,r))
               {
                   f1 = true;
               }
             }//end of isSame with k
            }//end of first k for
            
            
            for(int k = 0 ; k < nv ; k++)
          {
            if(!isSame(A,G[k])&&!isSame(B,G[k]))
            {
                pt P = G[k];
                if (isInDiskOnRight(P,B,A,r))
               {
          
                   f2 = false;
                   break;
               }
               else if(!isInDiskOnRight(P,B,A,r))
               {
                   f2 = true;
               }
             }//end of isSame with k
            }//end of second k for
            
             if((f1 == true && f2 == true) || (f1 == false && f2 == true) || (f1 == true && f2 == false) )
            {
              dartCount[i]++;
              dartCount[j]++;
             
            }
           else if(f1 == false && f2 == false)
           {
                  state[i] = 2; 
                  state[j] = 2;
           }
            
           
         }//end of if of isCircle(A,B,r) 
          
          
       }//end of if loop of !isSame(G[i],G[j]) 
        
        }//end of for loop of j
      }//end of for loop of i
      
      //CLASSIFICATION OF THE STATE OF THE POINTS
      for(int i = 0 ; i < nv ; i++)
      {

        if(dartCount[i]>2)
        state[i] = 1;
        else if(dartCount[i]>0 && dartCount[i]<=2)
        state[i] = 0;
      }
  
      for(int i = 0 ; i <nv ; i++)
      {
        if(state[i]==1)
        println(i+": "+"nonManifold");
        else if(state[i] == 0)
        println(i+": "+"manifold");
        else if(state[i] == 2)
        println(i+": "+"interior");
        else if(state[i] == 3)
        println(i+": "+"exterior");
        
      }
    
    
    }
    
    
    //***************
    
    //DRAW DARTS FUNCTION
    //****************************
    void drawDarts(float r )
{
  boolean f1 = true;
  boolean f2 = true;
 
   for (int i=0 ; i<nv; i++) 
   {
     for(int j = i+1 ; j < nv ; j++)
     {
        if(!isSame(G[i],G[j]))
     {
      {
     pt A = G[i];
     pt B = G[j];
     
     
     if(isCircle(A,B,r))
    {
      
    
      
      
       for(int k = 0 ; k < nv ; k++)
     {
       if (!(isSame(G[k],A))&&(!isSame(G[k],B)))
       {
         pt P = G[k];
         
        
         
         
         
      if (isInDiskOnRight(P,A,B,r))
      {
         
        f1 = false;
        break;
      }
      else if(!isInDiskOnRight(P,A,B,r))
      {
        f1 = true;
      }
       }
     
     }
     
     
     
      for(int k = 0 ; k < nv ; k++)
     {
       if (!(isSame(G[k],A))&&(!isSame(G[k],B)))
       {
         pt P = G[k];
     
     if (isInDiskOnRight(P,B,A,r))
      {
      
        f2 = false;
        break;
      }
      else if(!isInDiskOnRight(P,B,A,r))
      {
      f2 = true;
      }
     
       }
       
     }
     
     if(f1== true &&  f2 == true)
     {
      drawDart(A,B,color(255,0,0));
       drawDart(B,A,color(255,0,0));
      
     
     }
         
    else if(f1== false &&  f2 == true)
     {
      drawDart(A,B,color(0,255,150));
       drawDart(B,A,color(255,0,0));
     
     }
    else if(f1== true &&  f2 == false)
     {
      drawDart(B,A,color(0,255,150));
       drawDart(A,B,color(255,0,0));
     
     }
    
         }
     
      } 
     
   }
     
     }
      
     
     
   
   }
   
   
  

}
 
      
 

   
     
    
    
    
    //**********************************
    //CREATE DARTS FUNCTION
    
    
    
     void createDarts(float r)
  {
   
  
    boolean f1 = true;
  boolean f2 = true;
 
   for (int i=0; i<nv; i++) 
   {
     for(int j = i+1 ; j < nv ; j++)
     
       {
         if(!isSame(G[i],G[j]))
     {
      {
     pt A = G[i];
     pt B = G[j];
     
     
     if(isCircle(A,B,r))
    {
      
    
      
      
       for(int k = 0 ; k < nv ; k++)
     {
       if (!(isSame(G[k],A))&&(!isSame(G[k],B)))
       {
         pt P = G[k];
         
        
         
         
         
      if (isInDiskOnRight(P,A,B,r))
      {
         
        f1 = false;
        break;
      }
      else if(!isInDiskOnRight(P,A,B,r))
      {
        f1 = true;
      }
       }
     
     }
     
     
     
      for(int k = 0 ; k < nv ; k++)
     {
       if (!(isSame(G[k],A))&&(!isSame(G[k],B)))
       {
         pt P = G[k];
     
     if (isInDiskOnRight(P,B,A,r))
      {
      
        f2 = false;
        break;
      }
      else if(!isInDiskOnRight(P,B,A,r))
      {
      f2 = true;
      }
     
       }
       
     }
     
     if(f1== true &&  f2 == true)
     {
     
     E[pd] = true;
      E[pd+1] = true;
      println("d: "+pd);
      insertInSwing(i,pd);
      insertInSwing(j,pd+1);
      
      
      
      pd+=2;
      nd += 2;
       ne+=1;     
     }
         
    else if(f1== false &&  f2 == true)
     {
      
       E[pd] = false;
      E[pd+1] = true;
        println("d: "+pd);
      insertInSwing(i,pd);
      insertInSwing(j,pd+1);
       pd+=2;
      nd += 2;
      ne+=1;
     }
    else if(f1== true &&  f2 == false)
     {
     
     E[pd] = true;
      E[pd+1] = false;
        println("d: "+pd);
        
      insertInSwing(i,pd);
      insertInSwing(j,pd+1);
       pd+=2;
     nd +=2;
     ne+=1;
     }
    
         }
     
      } 
     
   }
   
   
   
  
   
   
   
   
   
       }
     
     
     
   
   }
   
  }
    
    
    
    
    
    
    
    
    //INSERTINSWING FUNCTION
    
   
//SLIGHTLY COMPLICATED VERSION OF INSERTINSWING - WORKS FINE FOR NOW
void insertInSwing(int v , int d)
{
  if(state[v]==2 || state[v]==3)
  return;
  else if(state[v]==0)
  {
    //CASE WHEN THERE ARE NO DARTS ON v
  if(D[v] == -v-1)
  {
   
    D[v] = d;
    S[d] = -v-1;
    println("dart added to vertex: "+ d+ " "+"vertex "+v);
  }
  
  //CASE WHEN THERE IS A SINGLE DART ON v
  else if ( v == -1-S[D[v]] )
  {
  
    if(det2(U(V(G[v],G[v(o(d))]))   , U(V(G[v],G[v(o(D[v]))])) )<0)
    {
    //  println("d is swing");
     S[d] = D[v];
     D[v]= d;
      
    }
    else
    {
    
      S[d] = -v-1;
      S[D[v]] = d;
    }
    println("dart added to vertex: "+ d+ " "+"vertex "+v);
  }
  }
  else if(state[v]==1)
  {
    //CASE WHEN THERE ARE NO DARTS ON v
  if(D[v] == -v-1)
  {
   
    D[v] = d;
    S[d] = -v-1;
    println("dart added to vertex: "+ d+ " "+"vertex "+v);
  }
  
  //CASE WHEN THERE IS A SINGLE DART ON v
  else if ( v == -1-S[D[v]] )
  {
   
    if(det2(U(V(G[v],G[v(o(d))]))   , U(V(G[v],G[v(o(D[v]))])) )<0)
    {
    //  println("d is swing");
     S[d] = D[v];
     D[v]= d;
      
    }
    else
    {
    
      S[d] = -v-1;
      S[D[v]] = d;
    }
    println("dart added to vertex: "+ d+ " "+"vertex "+v);
  }
  
  else
  {
    int swingD = D[v];
    int i = 0;
    int [] vertexArray = new int[dartCount[v]];
    vec [] vecArray = new vec[dartCount[v]];
    vec V = U(V(G[v],G[v(o(d))]));
    println("V: " + V.x+" "+V.y);
    println(swingD);
    while(swingD>=0)
    {
     // println(v(o(swingD)));
      vertexArray[i] = v(o(swingD));
      vecArray[i] = U(V(G[v],G[vertexArray[i]]));
     //println(vertexArray[i]);
      println("V: " +   vecArray[i].x+" "+  vecArray[i].y);
      i++;
      swingD = S[swingD];
      
    }
    float max1 = dot(V,vecArray[0]);
    
    int max1pos = 0;
    for(int k = 0 ; k < i ; k++)
    {
      if(max1<dot(V,vecArray[k]))
      {
      max1 = dot(V,vecArray[k]);
      max1pos = k;
      }
      
    }
   float max2 = dot(V,vecArray[1]);
    int max2pos = 1;
    for(int k = 0  ; k <i ; k++)
    {
      if(k!=max1pos)
      {
      
      if(max2<dot(V,vecArray[k]))
      {
      max2 = dot(V,vecArray[k]);
      max2pos = k;
      }
    }
    
    } 
    
   // println("max1pos: "+max1pos);
    // println("max2pos: "+max2pos);
    if(cw(vecArray[max1pos],V,vecArray[max2pos]))
    {
     
    // println("prompt: "+o(D[vertexArray[max1pos]]));
      if(S[o(D[vertexArray[max1pos]])] > 0)
         S[o(D[vertexArray[max1pos]])] = d;
      else
         D[v]= d;
         
        // println("prompt2: "+vertexArray[max2pos]);
         int tempV = vertexArray[max2pos];
         int tempdOfV = D[tempV];
        
      
         while(v(o(tempdOfV)) != v)
         {
           
           tempdOfV = s(tempdOfV);
            println(v(o(tempdOfV)));
         }
      // println(o(tempdOfV));
         S[d] = o(tempdOfV);
    }
    else
    {
      
    //  println("prompt: "+o(D[vertexArray[max2pos]]));
      if(S[o(D[vertexArray[max2pos]])] > 0)
         S[o(D[vertexArray[max2pos]])] = d;
      else
         D[v]= d;
         
       //  println("prompt2: "+vertexArray[max1pos]);
         int tempV = vertexArray[max1pos];
         int tempdOfV = D[tempV];
        
      
         while(v(o(tempdOfV)) != v)
         {
           
           tempdOfV = s(tempdOfV);
           // println(v(o(tempdOfV)));
         }
      // println(o(tempdOfV));
         S[d] = o(tempdOfV);
    }
     println("dart added to vertex: "+ d+ " "+"vertex "+v);
  
    
  }
  }
}   
    
    
    
    //d,e,n,s,u,p,o FUNCTIONS
    
    int d(int v)
{
  return D[v];
}

boolean e(int d)
{
  return E[d];
}

//SWING OF d 
int s(int d)
{
  if(S[d]>=0)
  return S[d];
  else
  return D[-S[d]-1];
}


//FUNCTION TO RETURN THE VERTEX ID v OF THE INPUT DART ID d
int v(int d)
{
 
  int swingD = d;
  while(swingD >= 0)
  {
    swingD = S[swingD];
  }
  //println("vertex of: "+d+" "+( -swingD-1));
  return -swingD-1;
 
 // return V[d];
  
  
}

//OPPOSITE OF A DART    
int o(int d)
{
  if (d %2 == 0)
  return d+1;
  else
  return d-1;
}    
    
int p(int d)
{
  return (o(n(o(d))));
}

int u (int d)
{
  return n(o(d));
}
//TO BE CHECKED FOR IF s IS NEGATIVE 
int n (int d)
{
  
  int next = 0;
  if(E[d]==false)
  {
  if(state[v(o(d))]==0)
  next= s(o(d));
  //NON- MANIFOLD VERTEX CASE.
  else if(state[v(o(d))]==1)
  {
   int v = v(o(d));
   int swingD = D[v];
    int i = 0;
    
     
    
   int [] vertexArray = new int[dartCount[v]];
   vec []vecArray = new vec[dartCount[v]];
   
   
   
   
   
    
    
    vec V = U(V(G[v],G[v(d)]));
   
   // println("V: " + V.x+" "+V.y);
   // println(swingD);
    while(swingD>=0)
    {
     // println(v(o(swingD)));
      vertexArray[i] = v(o(swingD));
      vecArray[i] = U(V(G[v],G[vertexArray[i]]));
     //println(vertexArray[i]);
      //println("V: " +   vecArray[i].x+" "+  vecArray[i].y);
      i++;
      swingD = S[swingD];
      
    }
    int pos = -1;
    float mindot = 100000;
    
    for(int j = 0 ; j < dartCount[v];j++)
    {
      
      if (vertexArray[j]!= v(d))
      {
        if(mindot>-dot(V,vecArray[j]))
        {
         
      mindot = -dot(V,vecArray[j]);
      
      pos = j;
        }
      }
    }
   // println
    int tempV = vertexArray[pos];
   // int tempV = 2;
    //println("tempV: "+tempV);
         int tempdOfV = D[tempV];
        
      
         while(v(o(tempdOfV)) != v)
         {
           
           tempdOfV = s(tempdOfV);
           // println(v(o(tempdOfV)));
         }
     //  println(o(tempdOfV));
         next = o(tempdOfV);
   
  }
  }
  else if (E[d]==true)
  {
    if(state[v(o(d))]==0)
  next= s(o(d));
  //NON- MANIFOLD VERTEX CASE.
  else if(state[v(o(d))]==1)
  {
   int v = v(o(d));
   int swingD = D[v];
    int i = 0;
    
     
    
   int [] vertexArray = new int[dartCount[v]];
   vec []vecArray = new vec[dartCount[v]];
   
   
   
   
   
    
    
    vec V = U(V(G[v],G[v(d)]));
   
   // println("V: " + V.x+" "+V.y);
   // println(swingD);
    while(swingD>=0)
    {
     // println(v(o(swingD)));
      vertexArray[i] = v(o(swingD));
      vecArray[i] = U(V(G[v],G[vertexArray[i]]));
     //println(vertexArray[i]);
      //println("V: " +   vecArray[i].x+" "+  vecArray[i].y);
      i++;
      swingD = S[swingD];
      
    }
    int pos = -1;
    float maxdot = -100000;
    
    for(int j = 0 ; j < dartCount[v];j++)
    {
      
      if (vertexArray[j]!= v(d))
      {
        if(maxdot<-dot(V,vecArray[j]))
        {
         
      maxdot = -dot(V,vecArray[j]);
      
      pos = j;
        }
      }
    }
   // println
    int tempV = vertexArray[pos];
   // int tempV = 2;
    //println("tempV: "+tempV);
         int tempdOfV = D[tempV];
        
      
         while(v(o(tempdOfV)) != v)
         {
           
           tempdOfV = s(tempdOfV);
           // println(v(o(tempdOfV)));
         }
     //  println(o(tempdOfV));
         next = o(tempdOfV);
   
  }
  }
  return next;
}    
    
 
    
    //GREEN LOOPS AND FACES
     
  void greenLoops(float r)
  {
   
    //boolean [] traversed = new boolean[G.nd];
   for(int i = 0 ; i < nd ; i++)
   {
     if(!E[i])
     {
      if(!traversed[i])
      {
        traversed[i] = true;
         ng ++;
         pg = ng-1;
         greenLoop[pg]=i;
         
        //println("d: "+i);
        int d = n(i);
        while(d != i)
        {
          traversed[d] = true;
         // println(d);
          d = n(d);
        }
      }
     }
   }
  }
  
 
  void createFaces()
  {
    for(int i =0 ; i< ng ; i++)
    {
      faces[i] = greenLoop[i];
    }
    
    for(int i = 0 ; i < ng ; i++)
    {
      println(v(i));
      fill(i*255,0,255);
     beginShape();
     vertex(G[v(greenLoop[i])]);
     int d = n(greenLoop[i]);
     while(d != greenLoop[i])
     {
       vertex(G[v(d)]);
       d = n(d);
     }
     endShape(CLOSE);
     
     //WALLS
     beginShape();
     vertex(G[v(greenLoop[i])]);
     vertex(G[v(greenLoop[i])].x,G[v(greenLoop[i])].y,-5);
      vertex(G[v(n(greenLoop[i]))].x,G[v(n(greenLoop[i]))].y,-5);
     vertex(G[v(n(greenLoop[i]))]);
     
    
     endShape(CLOSE);
    
     d = n(greenLoop[i]);
      while(d != greenLoop[i])
      {
     beginShape();
     vertex(G[v(d)]);
     vertex(G[v(d)].x,G[v(d)].y,-5);
      vertex(G[v(n(d))].x,G[v(n(d))].y,-5);
     vertex(G[v(n(d))]);
     endShape(CLOSE);
      d = n(d);
      }
     
    }
  }
  
    
 //FENCES
 
 void fences()
 {
   for(int i = 0 ; i < nd ; i++)
   {
     if(E[i]==true && E[o(i)] == true)
     {
       fill(color(150,150,0));
         beginShape();
     vertex(G[v(i)]);
     vertex(G[v(i)].x,G[v(i)].y,-w/4);
      vertex(G[v(n(i))].x,G[v(n(i))].y,-w/4);
     vertex(G[v(n(i))]);
     
    
     endShape(CLOSE);
     }
   }
 }
    
//ROOFS

void roofs1()
{
  pt [] Centroid = new pt[ng];
  int [] faceDarts = new int[ng];
  for(int i = 0 ; i < ng ; i++)
  {
     faceDarts[i] = 1;
      int d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       faceDarts[i]++;
       d = n(d);
     }
     
     pt [] facePoints = new pt[faceDarts[i]];
     int j = 1;
     facePoints[0] = G[v(greenLoop[i])];
     d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       facePoints[j] = G[v(d)];
       d = n(d);
       j++;
     }
     Centroid[i] = Centroid(facePoints);
     Centroid[i].z = w/12;
     //show(Centroid[i],10);
     
     fill(#8B3A3A);
     beginShape();
     vertex(G[v(greenLoop[i])].x , G[v(greenLoop[i])].y,-5);
     vertex(G[v(n(greenLoop[i]))].x,G[v(n(greenLoop[i]))].y,-5);
     vertex(Centroid[i]);
     endShape(CLOSE);
     d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       beginShape();
       vertex(G[v(d)].x , G[v(d)].y,-5);
       vertex(G[v(n(d))].x,G[v(n(d))].y,-5);
       vertex(Centroid[i]);
       endShape(CLOSE);
       d = n(d);
     }
 
  }

}

float alignementAngleS(pt C) { // axis of least inertia of sampled area
    float xx=0, xy=0, yy=0;
    for(int j=0; j<height; j++) for(int i=0; i<width; i++) {
      pt Q=P(i,j);
      if(PiP(Q))
        {
        float x = Q.x-C.x, y = Q.y-C.y;
        xx+=x*x; 
        xy+=x*y; 
        yy+=y*y;
        }
      };
    return atan2(2*xy,xx-yy)/2.;
    }
  
   boolean PiP(pt M) {  // tests whether P is in the polygon (shown as green/red dot under the mouse)
    boolean r=false;
    boolean p0=leftTurnFromO(G[0],M);
    boolean p=p0;
    for (int i=1; i<nv; i++) {
       boolean c=leftTurnFromO(G[i],M); 
       if (p!=c) { if(leftTurn(G[i-1],G[i],M)==p) r=!r; }; 
       p=c;
       }
    if (p!=p0) { if(leftTurn(G[nv-1],G[0],M)==p) r=!r; }; 
    return r;
    }
    
     boolean PiP(pt M, pt[] ng) {  // tests whether P is in the polygon (shown as green/red dot under the mouse)
    boolean r=false;
    boolean p0=leftTurnFromO(ng[0],M);
    boolean p=p0;
    for (int i=1; i<ng.length; i++) {
       boolean c=leftTurnFromO(ng[i],M); 
       if (p!=c) { if(leftTurn(ng[i-1],ng[i],M)==p) r=!r; }; 
       p=c;
       }
    if (p!=p0) { if(leftTurn(ng[nv-1],ng[0],M)==p) r=!r; }; 
    return r;
    }
    
boolean leftTurnFromO(pt B, pt C) {return C.y*B.x<C.x*B.y;}
boolean leftTurn(pt A, pt B, pt C) {return (A.y-C.y)*(B.x-A.x)>(A.x-C.x)*(B.y-A.y);}


vec calculatePrincipalAxis(pt []ng){
  pt C = Centroid(ng);
  float a = alignementAngleS(C); 
    vec V=R(V(80,0,0),a, V(1,0,0), V(0,1,0)); 
   
   return V;
   
}


//FINDING INTERSECTION POINT OF TWO LINES GIVEN 2 POINTS ON EACH LINE
pt intersectionOfTwoLines(pt A, pt B, pt C, pt D){
  float s = 0.0;
  pt P = new pt();
  vec V1 = U(V(A,B));
  vec V2 = U(R(V(C,D)));
  
  if(dot(V1,V2)==0)
    return P;
  
  else
    s = dot(V(A,C), V2)/dot(V1, V2);
    
  P=P(A,s,B);
  return P;
}

//FINDING INTERSECTION POINT OF TWO LINES GIVEN A POINT A VECTOR FOR ONE LINE AND TWO POINTS FOR THE OTHER LINE
pt intersectionOfTwoLines(pt A, vec B, pt C, pt D){
  float s = 0.0;
  pt P = new pt();
  vec V1 = U(B);
  vec V2 = U(R(V(C,D)));
  
  if(dot(V1,V2)==0)
    return P;
  
  else
    s = dot(V(A,C), V2)/dot(V1, V2);
    
  P=P(A,s,V1);
  return P;

  
}
  
  

pt [] intersectionWithPrincipalAxis(pt[] arFace, vec V, pt C)
{
  boolean Vstatus[] = new boolean[arFace.length];
  float minRight = 1000.0;
  float secMinRight = 1500.0;
  float disRight;
  int minV = -1;
  int secMinV = -1;
  
  pt A = new pt();
  pt B = new pt();
  pt X = new pt();
  pt Y = new pt();
  for(int i=0;i<arFace.length;i++){
    Vstatus[i] = isOnRightOrOnMe(arFace[i], C, P(C,5,V));
    if(Vstatus[i]==true){
      disRight = disToLine(arFace[i], C, V);
      if(minRight>disRight){
        minRight=disRight;
        minV=i;
         A = arFace[i];
      }
      else if((disRight<secMinRight && disRight!=minRight) || (disRight==minRight && i!=minV)){
        secMinRight = disRight;
        secMinV = i; 
        B = arFace[i];
  }
}
}

println("MinV is "+minV);
println("SecMinV is "+secMinV);
println("Length of arFace is "+arFace.length);
show(arFace[minV], 10);
show(arFace[secMinV], 10);

  //FOR FIRST MIN
  
  if(Vstatus[(minV+1)%arFace.length]==false)
  X = arFace[(minV+1)%arFace.length];
  else
  X = arFace[(minV-1)%arFace.length];
  
  if(Vstatus[(secMinV+1)%arFace.length]==false)
  Y = arFace[(secMinV+1)%arFace.length];
  else
  Y = arFace[(secMinV-1)%arFace.length];
 pt [] result = new pt[2];
 result[0] = intersectionOfTwoLines(C,V,A,X);
 result[1] = intersectionOfTwoLines(C,V,B,Y);
 println("Intersection Points are "+result[0].x+" "+result[0].y+" "+result[1].x+" "+result[1].y);
 return result;
}


pt intersectionAtNormal(pt P, pt C, vec V){
  pt N = new pt();
   vec CP = V(P,C);
 float dP = dot(CP, U(V));
 N = P(C, dP, U(V));
  return N;
  
}

void drawNormals(pt[] ng, pt C, vec V){
  pt [] projPoints = new pt[ng.length];
  for(int i = 0 ; i < ng.length ; i++)
  {
    projPoints[i] = new pt(-1000,-1000);
  }
  for(int i=0;i<ng.length;i++){
    pt PP = intersectionAtNormal(ng[i], C,  V);
    if(PiP( PP, ng)){
      projPoints[i] = PP;
      
    }
   // pen(yellow, 6);
    //show(PP, 5);
  }
  for(int i = 0 ; i < ng.length ; i++)
  {
    println("Projected Points: "+projPoints[i].x+" "+projPoints[i].y+" "+projPoints[i].z);
    //projPoints[i] = new pt(-1000,-1000);
  }
  
  beginShape();
  
  boolean single = false;
  boolean doub = false;

  
  
  for(int i = 0 ; i <ng.length;i++)
  {
    fill(200,i*100,150);
  if(projPoints[i].x != -1000.0)
  
  { 
    vertex(projPoints[i].x,projPoints[i].y,w/6);
    vertex(ng[i].x,ng[i].y,0);
    int k=i+1;
     if(k==ng.length)
      k=0;
    while(projPoints[k].x == -1000.0){
      println("Inside ");
      k = k+1;
      if(k==ng.length)
      k=0;
    }
    print("i = "+i+" k= "+k+"\n");
    vertex(ng[(k)%ng.length].x,ng[(k)%ng.length].y,0);
    vertex(projPoints[(k)%ng.length].x,projPoints[(k)%ng.length].y,w/6); 
  }
  }
  endShape(CLOSE);
  
  
}








void roof2()
{ 
  int [] faceDarts = new int[ng];
  for(int i = 0 ; i < ng ; i++)
  {
     faceDarts[i] = 1;
      int d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       faceDarts[i]++;
       d = n(d);
     }
     
     pt [] facePoints = new pt[faceDarts[i]];
     int j = 1;
     facePoints[0] = G[v(greenLoop[i])];
     d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       facePoints[j] = G[v(d)];
       d = n(d);
       j++;
     }
     /*
     pt [] midPoints = new pt[facePoints.length];
     for(int k = 0 ; k < facePoints.length;k+=2)
     {
       
       
     }
     */
     
     pt P1 = midpoint(facePoints[0],facePoints[3]);
     pt P2 = midpoint(facePoints[1],facePoints[2]);
     
     fill(#8B3A3A);
     beginShape();
     vertex(G[v(greenLoop[i])].x , G[v(greenLoop[i])].y,-5);
    
     vertex(P1.x,P1.y,w/6);
     vertex(P2.x,P2.y,w/6);
      vertex(G[v(n(greenLoop[i]))].x,G[v(n(greenLoop[i]))].y,-5);
     endShape(CLOSE);
     
     
     d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       beginShape();
       vertex(G[v(d)].x , G[v(d)].y,-5);
      
     vertex(P2.x,P2.y,w/6);
      vertex(P1.x,P1.y,w/6);
       vertex(G[v(n(d))].x,G[v(n(d))].y,-5);
       //vertex(Centroid[i]);
       endShape(CLOSE);
       d = n(d);
     }
     beginShape();
          vertex(G[v(greenLoop[i])].x , G[v(greenLoop[i])].y,-5);
    
     vertex(P1.x,P1.y,w/6);
    // vertex(P2.x,P2.y,w/6);
      vertex(G[v(p(greenLoop[i]))].x,G[v(p(greenLoop[i]))].y,-5);
     endShape(CLOSE);
      d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       beginShape();
       vertex(G[v(d)].x , G[v(d)].y,-5);
      
     vertex(P2.x,P2.y,w/6);
     // vertex(P1.x,P1.y,w/6);
       vertex(G[v(n(d))].x,G[v(n(d))].y,-5);
       //vertex(Centroid[i]);
       endShape(CLOSE);
       d = n(d);
     }
    // Centroid[i] = Centroid(facePoints);
    // Centroid[i].z = w/12;
     //show(Centroid[i],10);
     /*
     fill(#8B3A3A);
     beginShape();
     vertex(G[v(greenLoop[i])].x , G[v(greenLoop[i])].y,-5);
     vertex(G[v(n(greenLoop[i]))].x,G[v(n(greenLoop[i]))].y,-5);
     vertex(Centroid[i]);
     endShape(CLOSE);
     d = n(greenLoop[i]);
      while(d != greenLoop[i])
     {
       beginShape();
       vertex(G[v(d)].x , G[v(d)].y,-5);
       vertex(G[v(n(d))].x,G[v(n(d))].y,-5);
       vertex(Centroid[i]);
       endShape(CLOSE);
       d = n(d);
     }
    */ 
     
  }
  
}


pt Centroid(pt [] points)
{
  pt P = P(0,0,0);
  for(int i = 0 ; i < points.length ; i++){
    println("P is "+points[i].x+" "+points[i].y+" "+points[i].z);
    P = A(P,points[i]);
  }
 
pt Y = P(1./points.length,P);
 println("Centroid "+Y.x+" "+Y.y+" "+Y.z);
return Y;

  
  
}
    
    
//File I/O
    void saveBALLS(String fn) {
    String [] inpBALLS = new String [nv+1];
    int s=0;
    inpBALLS[s++]=str(nv);
    for (int i=0; i<nv; i++) {inpBALLS[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z)+","+str(r[i]);}
    saveStrings(fn,inpBALLS);
    };
  
  void loadPts(String fn) {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);  //loadStrings: Reads the contents of a file and creates a String array of its individual lines
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y,z;   int a, b, c;
    nv = int(ss[s++]); println("nv="+nv);
    for(int k=0; k<nv; k++) {
      int i=k+s; 
      comma=ss[i].indexOf(',');   //Retruns the index of "," in the string
      comma1 = ss[i].lastIndexOf(',');
      println(comma1);
      x=float(ss[i].substring(0, comma));
      y=float(ss[i].substring(comma+1, comma1));
      z=float(ss[i].substring(comma1+1, ss[i].length()));
      
      G[k].setTo(x/5,y/5,-w/2);
      };
    pv=0;
    }; 
  
     
    
     
     
}//End of Floor Class



//UTILITY FUNCTIONS



//UTILTIY FUNCTIONS
boolean isInDiskOnRight(pt P , pt A , pt B , float r)
{
  if(isOnRight(P,A,B))
  {
    
    if(isCircle(A,B,r))
    {
      pt C = centerOfTangentCircle(A,B,r);
      if(d(C,P)<r)
         return true;
    }
  }
  return false;
}


boolean isCircle(pt A, pt B , float r)
{
    pt C = centerOfTangentCircle(A,B,r);
  if(C.x == -1 )
  {
    return false;
  }
  else 
  return true;
}



//FUNCTION TO FIND THE CENTER OF CIRCLE THROUGH THE EDGE AB OF RADIUS r
pt centerOfTangentCircle(pt A , pt B , float r)
{
  pt C = new pt();
  pt M = P(A,0.5,V(A,B));
  float d = d(A,M);
  if(d<r)
  {
  float e = sqrt(r*r-d*d);
  
  vec N = U(R(V(A,B)));
  C = P(M,e,N);
  }
  else 
  {
    C.x = -1;
    C.y = -1;
    //println("Not a valid circle");
  }
 // println("The center of the circle-"+"("+C.x+","+C.y+")");
  return C;
  
}
//FUNCTION TO CHECK IF A POINT P IS ON THE RIGHT OF THE EDGE BETWEEN POINTS A AND B
boolean isOnRight(pt P , pt A , pt B)
{
  vec AB = V(A,B);
  vec AP = V(A,P);
  if(det2(AB,AP)>0)
  return true;
  else
  return false;
}

boolean isOnRightOrOnMe(pt P , pt A , pt B)
{
  vec AB = V(A,B);
  vec AP = V(A,P);
  if(det2(AB,AP)>=0)
  return true;
  else
  return false;
}
//DISPLAY FUNCTIONS

void showRadius(float r)
{
  if(showRadius)
  {
    text(r,10,10);
    stroke(255,0,0);
    ellipse(0,0,2*r,2*r);
    noStroke();
  }
  
}

void drawCircle(pt A , pt B , float r, color c)
{
 pt  C = centerOfTangentCircle(A,B,r);
  if(C.x != -1)
  {
    stroke(c);
    noFill();
  ellipse(C.x,C.y,2*r,2*r);
  }
  
}






/*
 void IDs(floor G) 
    {
    for (int v=0; v<G.nv; v++) 
      { 
      fill(white); 
      show(G.G[v],13); 
      fill(black); 
      if(v<10) show(G.G[v],str(v));  
      else show(G.G[v],V(-5,0),str(v)); 
      }
    noFill();
    }
 */ 
 
void drawDart(pt A, pt B, color c) 
  {
  stroke(c); fill(c); 
  drawDart(A,B);
  }
void drawDart(pt A, pt B) 
  {
  float n=d(A,B); 
  float s=max(min(0.2,10./n),6./n);       // show V as arrow from P 
  vec T = V(s,V(A,B));
  vec N = R(U(A,B));
  vec D = V(2,R(U(A,B)));
  pt P= P(P(A,T),D);
  pt R= P(P(B,-1,T),D);
  pt Q= P(P(B,-2,T),D);
  pt O= P(Q,n*s/2,N);
  show(P,Q);
  if(n>0.1) {beginShape(); v(Q); v(R); v(O); endShape(CLOSE);}
  } 








// THIS IS THE ONE YOU WANT TO USE

void drawDarts(float r ,floor G)
{
  boolean f1 = true;
  boolean f2 = true;
 
   for (int i=0 ; i<G.nv; i++) 
   {
     for(int j = i+1 ; j < G.nv ; j++)
     {
        if(!isSame(G.G[i],G.G[j]))
     {
      {
     pt A = G.G[i];
     pt B = G.G[j];
     
     
     if(isCircle(A,B,r))
    {
      
    
      
      
       for(int k = 0 ; k < G.nv ; k++)
     {
       if (!(isSame(G.G[k],A))&&(!isSame(G.G[k],B)))
       {
         pt P = G.G[k];
         
        
         
         
         
      if (isInDiskOnRight(P,A,B,r))
      {
         
        f1 = false;
        break;
      }
      else if(!isInDiskOnRight(P,A,B,r))
      {
        f1 = true;
      }
       }
     
     }
     
     
     
      for(int k = 0 ; k < G.nv ; k++)
     {
       if (!(isSame(G.G[k],A))&&(!isSame(G.G[k],B)))
       {
         pt P = G.G[k];
     
     if (isInDiskOnRight(P,B,A,r))
      {
      
        f2 = false;
        break;
      }
      else if(!isInDiskOnRight(P,B,A,r))
      {
      f2 = true;
      }
     
       }
       
     }
     
     if(f1== true &&  f2 == true)
     {
      drawDart(A,B,color(255,0,0));
       drawDart(B,A,color(255,0,0));
      
     
     }
         
    else if(f1== false &&  f2 == true)
     {
      drawDart(A,B,color(0,255,0));
       drawDart(B,A,color(255,0,0));
     
     }
    else if(f1== true &&  f2 == false)
     {
      drawDart(B,A,color(0,255,0));
       drawDart(A,B,color(255,0,0));
     
     }
    
         }
     
      } 
     
   }
     
     }
      
     
     
   
   }
   
   
  

}
 
      
pt midpoint(pt A , pt B)
{
  return P(0.5,A,0.5,B);
}



   
     
     