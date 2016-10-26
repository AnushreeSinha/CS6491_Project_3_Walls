void keyPressed() {
  if(key=='?') scribeText=!scribeText;
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  //if(key=='w') f.savePts("./data/savedBalls");
 // if(key=='l') f.loadPts("./data/savedBalls");
  change=true;
  }

void mouseWheel(MouseEvent event) {dz -= event.getAmount(); change=true;}

void mousePressed() {picking=true;}
  
void mouseMoved() {
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  if (keyPressed && key=='z') dz+=(float)(mouseY-pmouseY)*5; // approach view (same as wheel)
  }
  
void mouseDragged() 
  {
  }  

// **** Header, footer, help text on canvas
void displayHeader() // Displays title and authors face on screen
    { 
    scribeHeader(title,0); 
    scribeHeaderRight(name); 
    fill(white); 
    image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
    }
    
void displayFooter() { // Displays help text at the bottom
    scribeFooter(guide,1); 
    scribeFooter(menu,0); 
    }

String title ="base3D code for CS 6491 project 3 Part 2 ", name ="Anushree SINHA Sanjana GUPTA",
       menu="?:help, !:picture, ~:videotape, space (no mouse):rotate, wheel or z (no mouse):zoom",
       guide="click on a ball to select it "; // user's guide
       