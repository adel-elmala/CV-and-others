#include <GL/glut.h>
#include <math.h>

#include "srcs/glm.h"
#include "srcs/imageloader.h"
// #include <string.h>
#include <iostream>

// static int shoulder = 0, shoulder2 = 0, elbow = 0, fingerBase = 0, fingerUp = 0, rhip = 0, rhip2 = 0, rknee = 0, lknee = 0, lhip = 0, lhip2 = 0 ;
static int shoulder = -90, elbow = 90, arm = 90, Lshoulder = -90, Lelbow = -90, Larm = -90
			,hip=0,leg=0,knee=0,Lhip=0,Lleg=0,Lknee=0,base=0,flang=0;

int moving, startx, starty;
float speed = 0.25;
double angle = 0;
double angle2 = 0;
double eye[] = { 0, 0, -20 };
double center[] = { 0, 0, 0 };
double up[] = { 0, 1, 0 };
double direction[] = {0,0,20};
// direction[0] = center[0] - eye[0];
// direction[1] = center[1] - eye[1];
// direction[2] = center[2] - eye[2];
double left[] = {0,0,0};

float lab = 0.0;
float wave = 0.0;

float pos = 0;
float DRot = 90;
float Zmax, Zmin;
float VRot =0.0;
float CRound = 0.0;
float Crot  = 0.0;
float Cpos = 0.0;
bool animate = true;

GLMmodel* model;

GLMmodel* pmodel;
GLMmodel* pmodel1;
GLMmodel* pmodel2 ;
GLMmodel* pmodel3 ;
GLMmodel* pmodel4 ;



// RGBA
GLfloat light_ambient[] = { 0.0, 0.0, 0.0, 0.0 };
GLfloat light_diffuse[] = { 0.5, 0.5, 0.5,1.0 };
GLfloat light_specular[] = {1.0, 1.0, 1.0, 1.0 };
// x , y, z, w
GLfloat light_position[] = {1.0,-9.0, 0.0, 1.0 };
GLfloat lightPos1[] = {-2.0,-9.0,-5.0, 1.0 };
GLfloat lightPos2[] = {2.0,-9.0,5.0, 1.0 };

// GLfloat light_position[] = {0.5,5.0, 0.0, 1.0 };
// GLfloat lightPos1[] = {-0.5,-5.0,-2.0, 1.0 };

// GLfloat lightPos2[] = {-0.5,-5.0,-2.0, 1.0 };
// Material Properties
GLfloat mat_amb_diff[] = {0.643, 0.753, 0.934, 1.0 };
GLfloat mat_specular[] = { 0.0, 0.0, 0.0, 1.0 };
GLfloat shininess[] = {100.0 };  
void Timer1(int x);
void Timer2(int x);
void DTimer1(int x);
void carTimer(int x);
void stopTimers(int x );
void init(void)
{
    glMatrixMode(GL_PROJECTION);
	gluPerspective(65.0, (GLfloat)1024 / (GLfloat)869, 1.0, 60.0);
}

void crossProduct(double a[], double b[], double c[])
{
	c[0] = a[1] * b[2] - a[2] * b[1];
	c[1] = a[2] * b[0] - a[0] * b[2];
	c[2] = a[0] * b[1] - a[1] * b[0];
}

void normalize(double a[])
{
	double norm;
	norm = a[0] * a[0] + a[1] * a[1] + a[2] * a[2];
	norm = 1 / sqrt(norm);
	a[0] *= norm;
	a[1] *= norm;
	a[2] *= norm;
}

void rotatePoint(double a[], double theta, double p[])
{

	double temp[3];
	temp[0] = p[0];
	temp[1] = p[1];
	temp[2] = p[2];

	temp[0] = -a[2] * p[1] + a[1] * p[2];
	temp[1] = a[2] * p[0] - a[0] * p[2];
	temp[2] = -a[1] * p[0] + a[0] * p[1];

	temp[0] *= sin(theta);
	temp[1] *= sin(theta);
	temp[2] *= sin(theta);

	temp[0] += (1 - cos(theta))*(a[0] * a[0] * p[0] + a[0] * a[1] * p[1] + a[0] * a[2] * p[2]);
	temp[1] += (1 - cos(theta))*(a[0] * a[1] * p[0] + a[1] * a[1] * p[1] + a[1] * a[2] * p[2]);
	temp[2] += (1 - cos(theta))*(a[0] * a[2] * p[0] + a[1] * a[2] * p[1] + a[2] * a[2] * p[2]);

	temp[0] += cos(theta)*p[0];
	temp[1] += cos(theta)*p[1];
	temp[2] += cos(theta)*p[2];

	p[0] = temp[0];
	p[1] = temp[1];
	p[2] = temp[2];

}

void Left()
{
	// implement camera rotation arround vertical window screen axis to the left
	// used by mouse and left arrow
	rotatePoint(up,0.2,eye);
}

void Right()
{
	// implement camera rotation arround vertical window screen axis to the right
	// used by mouse and right arrow
	rotatePoint(up,-0.2,eye);
}

void Up()
{
	// implement camera rotation arround horizontal window screen axis +ve
	// used by up arrow
	crossProduct(up,direction,left);
	normalize(left);
	rotatePoint(left,0.02,eye);
}

void Down()
{	
	// implement camera rotation arround horizontal window screen axis 
	// used by down arrow
	crossProduct(up,direction,left);
	normalize(left);
	rotatePoint(left,-0.02,eye);
}

void moveForward()
{
	direction[0] = center[0] - eye[0];
	direction[1] = center[1] - eye[1];
	direction[2] = center[2] - eye[2];


	eye[0]    += direction[0] * speed;
	eye[1]    += direction[1] * speed;
	eye[2]    += direction[2] * speed;

	// center[0] += direction[0] * speed;
	// center[1] += direction[1] * speed;
	// center[2] += direction[2] * speed;
}

void moveBack()
{
	direction[0] = center[0] - eye[0];
	direction[1] = center[1] - eye[1];
	direction[2] = center[2] - eye[2];


	eye[0]    -= direction[0] * speed;
	eye[1]    -= direction[1] * speed;
	eye[2]    -= direction[2] * speed;

	// center[0] -= direction[0] * speed;
	// center[1] -= direction[1] * speed;
	// center[2] -= direction[2] * speed;
}

GLuint loadTexture(Image* image) {
      GLuint textureId;
      glGenTextures(1, &textureId); //Make room for our texture
      glBindTexture(GL_TEXTURE_2D, textureId); //Tell OpenGL which texture to edit
      //Map the image to the texture
      glTexImage2D(GL_TEXTURE_2D,                //Always GL_TEXTURE_2D
                               0,                            //0 for now
                               GL_RGB,                       //Format OpenGL uses for image
                               image->width, image->height,  //Width and height
                               0,                            //The border of the image
                               GL_RGB, //GL_RGB, because pixels are stored in RGB format
                               GL_UNSIGNED_BYTE, //GL_UNSIGNED_BYTE, because pixels are stored
                                                 //as unsigned numbers
                               image->pixels);               //The actual pixel data
      return textureId; //Returns the id of the texture
}

GLuint _textureId; //The id of the texture



//Initializes 3D rendering
void initRendering() {

      Image* image = loadBMP("textures/floor.bmp");
      _textureId = loadTexture(image);
      delete image;

      // Turn on the power
      glEnable(GL_LIGHTING);
      
      // Flip light switch
      glEnable(GL_LIGHT0);
      glEnable(GL_LIGHT1);
      glEnable(GL_LIGHT2);
      
      // assign light parameters
      glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient);
      glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse);
      glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);
      glLightfv(GL_LIGHT1, GL_AMBIENT, light_ambient);
      glLightfv(GL_LIGHT1, GL_DIFFUSE, light_diffuse);
      glLightfv(GL_LIGHT1, GL_SPECULAR, light_specular);
      glLightfv(GL_LIGHT2, GL_AMBIENT, light_ambient);
      glLightfv(GL_LIGHT2, GL_DIFFUSE, light_diffuse);
      glLightfv(GL_LIGHT2, GL_SPECULAR, light_specular);
      // Material Properties         
      glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE,mat_amb_diff);
      glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
      glMaterialfv(GL_FRONT, GL_SHININESS, shininess);
      GLfloat lightColor1[] = {1.0f, 1.0f,  1.0f, 1.0f };
      glLightfv(GL_LIGHT1, GL_DIFFUSE, lightColor1);
      glLightfv(GL_LIGHT1, GL_POSITION, lightPos1);
      glLightfv(GL_LIGHT0, GL_POSITION, light_position);
      glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor1);
      glLightfv(GL_LIGHT2, GL_POSITION, lightPos2);
      glLightfv(GL_LIGHT2, GL_DIFFUSE, lightColor1);
      
      glEnable(GL_NORMALIZE);
      //Enable smooth shading
      glShadeModel(GL_SMOOTH);
      // Enable Depth buffer
      glEnable(GL_DEPTH_TEST);
}


void screen_menu(int value)
{
	char* name = 0;

	switch (value) {
        case 'w':
            name = "textures/wood.bmp";
            break;
        case 'c':
            name = "textures/floor.bmp";
            break;
         case 'p':
            name = "textures/stripes.bmp";
            break;
         case 's':
            name = "textures/stone.bmp";
            break;
         case '1':
            if(animate){
               
               glutTimerFunc(0,carTimer,1);
               animate = false;
            }
            // if(!animate){
               
            //    glutTimerFunc(0,carTimer,0);   
            //    animate = true;
            // }

            break;
         case '2':
         glutTimerFunc(0,DTimer1,1);   
         break;
         case '3':
         	glutTimerFunc(0,Timer1,0);
            break;
         case '4':
         glutTimerFunc(0,Timer2,0);
         break;   
	}

	if (name) {
		Image* image = loadBMP(name);
      _textureId = loadTexture(image);
      delete image;
	}

	glutPostRedisplay();
}

void drawmodel3(char* path)
{
	if (!pmodel3) {
		pmodel3 = glmReadOBJ(path);

		if (!pmodel3) exit(0);
		glmUnitize(pmodel3);
		glmFacetNormals(pmodel3);
		glmVertexNormals(pmodel3, 90.0);
		glmScale(pmodel3, .15);
	}
	glmDraw(pmodel3, GLM_SMOOTH | GLM_MATERIAL);
}
void drawmodel4(char* path)
{
	if (!pmodel4) {
		pmodel4 = glmReadOBJ(path);

		if (!pmodel4) exit(0);
		glmUnitize(pmodel4);
		glmFacetNormals(pmodel4);
		glmVertexNormals(pmodel4, 90.0);
		glmScale(pmodel4, .15);
	}
	glmDraw(pmodel4, GLM_SMOOTH | GLM_MATERIAL);
}

void drawmodel2(char* path)
{
	if (!pmodel2) {
		pmodel2 = glmReadOBJ(path);

		if (!pmodel2) exit(0);
		glmUnitize(pmodel2);
		glmFacetNormals(pmodel2);
		glmVertexNormals(pmodel2, 90.0);
		glmScale(pmodel2, .15);
	}
	glmDraw(pmodel2, GLM_SMOOTH | GLM_MATERIAL);
}

void drawmodel1(char* path)
{
	if (!pmodel) {
		pmodel = glmReadOBJ(path);

		if (!pmodel) exit(0);
		glmUnitize(pmodel);
		glmFacetNormals(pmodel);
		glmVertexNormals(pmodel, 90.0);
		glmScale(pmodel, .15);
	}
	glmDraw(pmodel, GLM_SMOOTH | GLM_MATERIAL);
}
void body(void){
   //  draw head

	// draw trunck
	// call the robotic body draw function here


   // Head
   glutWireSphere(0.5,15,15);

   // Trunck
   
   glTranslatef (0.0, -1.5, 0.0);  // T1 // moved the body below the head
   glPushMatrix();
   glScalef (1.0, 2.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();


   // right arm (my view)
   glPushMatrix();
   // Shoulder
   glTranslated(0.5,1,0);
   glRotated((GLfloat) shoulder,1.0,0.0,0.0);
   glTranslated(-0.5,-1,0);
   // arm
   glTranslated(0.5,1,0);
   glRotatef ((GLfloat) arm, 0.0, 0.0, 1.0);
   glTranslated(-0.5,-1,0);

   glTranslatef (0.65, 0.5, 0);
   glPushMatrix();
   glScalef (0.3, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();

   // elbow 
   glTranslated(0.0,-0.5,0);
   glRotatef ((GLfloat) elbow, 1.0, 0.0, 0.0);
   glTranslated(0.0,0.5,0);

   glTranslatef (0.0, -1.0, 0);
   glPushMatrix();
   glScalef (0.3, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();

   // R finger 1 Base
   glTranslated(0.0,-0.58,0.0);

   glPushMatrix();
   
   glTranslated(0.05,0.08,0.0);
   glRotated(base,0,0,1);
   glTranslated(-0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(0.1,0.0,0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(0.05,-0.08,0.15);
   glRotated(flang,0,0,1);
   glTranslated(-0.05,0.08,-0.15);
   // R finger 1 flang
   glPushMatrix();
   glTranslated(0.1,-0.16,0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();

   // R finger 2 Base
   glPushMatrix();
   
   glTranslated(0.05,0.08,0.0);
   glRotated(base,0,0,1);
   glTranslated(-0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(0.1,0.0,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(0.05,-0.08,0.15);
   glRotated(flang,0,0,1);
   glTranslated(-0.05,0.08,-0.15);
   // R finger 2 flang
   glPushMatrix();
   glTranslated(0.1,-0.16,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();


   // R finger 3 Base
   glPushMatrix();
   
   glTranslated(0.05,0.08,0.0);
   glRotated(base,0,0,1);
   glTranslated(-0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(0.1,0.0,-0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(0.05,-0.08,0.15);
   glRotated(flang,0,0,1);
   glTranslated(-0.05,0.08,-0.15);
   // R finger 3 flang
   glPushMatrix();
   glTranslated(0.1,-0.16,-0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();

   
   // R finger 4 Base
   glPushMatrix();
   
   glTranslated(-0.05,0.08,0.0);
   glRotated(-base,0,0,1);
   glTranslated(0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(-0.1,0.0,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(-0.05,-0.08,0.15);
   glRotated(-flang,0,0,1);
   glTranslated(0.05,0.08,-0.15);
   // R finger 4 flang
   glPushMatrix();
   glTranslated(-0.1,-0.16,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();


   glPopMatrix();



   // left arm (my view)
   glPushMatrix();
   // Shoulder
   glTranslated(-0.5,1,0);
   glRotated((GLfloat) Lshoulder,1.0,0.0,0.0);
   glTranslated(0.5,-1,0);
   // arm
   glTranslated(-0.5,1,0);
   glRotatef ((GLfloat) Larm, 0.0, 0.0, 1.0);
   glTranslated(0.5,-1,0);

   glTranslatef (-0.65, 0.5, 0);
   glPushMatrix();
   glScalef (0.3, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();

   // elbow 
   glTranslated(0.0,-0.5,0);
   glRotated(180,0.0,1.0,0.0);
   glRotatef ((GLfloat) -Lelbow, 1.0, 0.0, 0.0);
   glTranslated(0.0,0.5,0);
   
   glTranslatef (0.0, -1.0, 0);
   glPushMatrix();
   glScalef (0.3, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();


   // R finger 1 Base
   glTranslated(0.0,-0.58,0.0);

   glPushMatrix();
   
   glTranslated(0.05,0.08,0.0);
   glRotated(base,0,0,1);
   glTranslated(-0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(0.1,0.0,0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(0.05,-0.08,0.15);
   glRotated(flang,0,0,1);
   glTranslated(-0.05,0.08,-0.15);
   // R finger 1 flang
   glPushMatrix();
   glTranslated(0.1,-0.16,0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();

   // R finger 2 Base
   glPushMatrix();
   
   glTranslated(0.05,0.08,0.0);
   glRotated(base,0,0,1);
   glTranslated(-0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(0.1,0.0,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(0.05,-0.08,0.15);
   glRotated(flang,0,0,1);
   glTranslated(-0.05,0.08,-0.15);
   // R finger 2 flang
   glPushMatrix();
   glTranslated(0.1,-0.16,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();


   // R finger 3 Base
   glPushMatrix();
   
   glTranslated(0.05,0.08,0.0);
   glRotated(base,0,0,1);
   glTranslated(-0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(0.1,0.0,-0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(0.05,-0.08,0.15);
   glRotated(flang,0,0,1);
   glTranslated(-0.05,0.08,-0.15);
   // R finger 3 flang
   glPushMatrix();
   glTranslated(0.1,-0.16,-0.15);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();

   
   // R finger 4 Base
   glPushMatrix();
   
   glTranslated(-0.05,0.08,0.0);
   glRotated(-base,0,0,1);
   glTranslated(0.05,-0.08,0.0);

   glPushMatrix();
   glTranslated(-0.1,0.0,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();

   glTranslated(-0.05,-0.08,0.15);
   glRotated(-flang,0,0,1);
   glTranslated(0.05,0.08,-0.15);
   // R finger 4 flang
   glPushMatrix();
   glTranslated(-0.1,-0.16,0.0);
   glScalef (0.1, 0.16, 0.07);
   glutWireCube (1.0);
   glPopMatrix();
   glPopMatrix();

   glPopMatrix();


   // left leg (my view)
   glPushMatrix();
   // hip
   glTranslated(-0.25,-1,0);
   glRotated((GLfloat) Lhip,0.0,0.0,1.0);
   glTranslated(0.25,1,0);
   // leg
   glTranslated(-0.25,-1,0);
   glRotatef ((GLfloat) Lleg, 1.0, 0.0, 0.0);
   glTranslated(0.25,1,0);

   glTranslatef (-0.25, -1.5, 0);
   glPushMatrix();
   glScalef (0.5, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();

   // knee
   glTranslated(0.0,-0.5,0);
   glRotatef ((GLfloat) Lknee, 1.0, 0.0, 0.0);
   glTranslated(0.0,0.5,0);

   glTranslatef (0.0, -1.0, 0);
   glPushMatrix();
   glScalef (0.5, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();
   
   // foot
   glTranslated(0,-0.5,0);
   glScalef (0.4, 0.25, 0.9);
   glutSolidCube(1.0);


   glPopMatrix();


   // left leg (my view)
   glPushMatrix();
   // hip
   glTranslated(0.25,-1,0);
   glRotated((GLfloat) hip,0.0,0.0,1.0);
   glTranslated(-0.25,1,0);
   // leg
   glTranslated(0.25,-1,0);
   glRotatef ((GLfloat) leg, 1.0, 0.0, 0.0);
   glTranslated(-0.25,1,0);

   glTranslatef (0.25, -1.5, 0);
   glPushMatrix();
   glScalef (0.5, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();

   // knee
   glTranslated(0.0,-0.5,0);
   glRotatef ((GLfloat) knee, 1.0, 0.0, 0.0);
   glTranslated(0.0,0.5,0);
   
   glTranslatef (0.0, -1.0, 0);
   glPushMatrix();
   glScalef (0.5, 1.0, 0.5);
   glutWireCube (1.0);
   glPopMatrix();
   // foot
   glTranslated(0,-0.5,0);
   glScalef (0.4, 0.25, 0.9);
   glutSolidCube(1.0);

   glPopMatrix();
}
void display(void)
{
   glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   	
	// glShadeModel(GL_FLAT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(eye[0], eye[1], eye[2], center[0], center[1], center[2], up[0], up[1], up[2]);
   
   
   // 
   glPushMatrix();
   glLightfv(GL_LIGHT1, GL_POSITION, lightPos1);
   // glLightfv(GL_LIGHT2, GL_POSITION, lightPos2);
   glLightfv(GL_LIGHT0, GL_POSITION, light_position);
   glPopMatrix();
   //materials properties
   glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE,mat_amb_diff);
   glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
   glMaterialfv(GL_FRONT, GL_SHININESS, shininess);
   glPushMatrix();
   body();
   glTranslatef(0, -3, 0);
   
   glPushMatrix();
	glEnable(GL_TEXTURE_2D);
   
   glBindTexture(GL_TEXTURE_2D, _textureId);

//       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
//       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
//       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);	
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

   glBegin(GL_QUADS);
      
      glNormal3f(0.0,-3.0,0.0);
      glTexCoord2f(0.0f, 0.0f);
      glVertex3f(-5,-0.25,10);
      glTexCoord2f(5.0f,  0.0f);
      glVertex3f(5,-0.25,10);
      glTexCoord2f(5.0f,  20.0f);
      glVertex3f(5,-0.25,-10);
      glTexCoord2f(0.0f, 20.0f);
      glVertex3f(-5,-0.25,-10);

   glEnd();
	glDisable(GL_TEXTURE_2D);

	glPopMatrix();

   glPushMatrix();
    	glTranslatef(0.0, 0.4, pos);
    	glRotatef(VRot,1,0,0);
    	glScalef(3, 3, 3);
    	drawmodel1("objects/soccerball.obj");
       
	glPopMatrix();

   glPushMatrix();
      
      glTranslatef(0.0, 2.0, 10.0);
      glRotatef(180,0,1,0);
      glScalef(15, 15, 15);
      drawmodel2("objects/al.obj");
         
	glPopMatrix();
   
   glPushMatrix();
      
      glTranslatef(1.0, 2.0, -5.0);
      glRotatef(DRot,0,1,0);
      glScalef(15, 15, 15);
      drawmodel3("objects/f-16.obj");
         
	glPopMatrix();
      glPushMatrix();
      
      glTranslatef(-4.0, 0.5, Cpos);
      glRotatef(Crot,0,1,0);
      glScalef(15, 15, 15);
      drawmodel4("objects/porsche.obj");
         
	glPopMatrix();
	
   glPopMatrix();
   //  glPushMatrix();
   //  	glTranslatef(0.0, 1.5, pos);
   //  	glRotatef(VRot,1,0,0);
   //  	glScalef(5, 5, 5);
   //  	drawmodel1("data/al.obj");
	// glPopMatrix();
//    glutSwapBuffers();

	glutSwapBuffers();
}



void Timer(int x){
	// Refresh and redraw
	glutPostRedisplay();
	glutTimerFunc(50, Timer, 0);
}
void specialKeys(int key, int x, int y)
{
	switch (key)
	{
	case GLUT_KEY_LEFT: Left(); break;
	case GLUT_KEY_RIGHT: Right(); break;
	case GLUT_KEY_UP:    Up(); break;
	case GLUT_KEY_DOWN:  Down(); break;
	}

	glutPostRedisplay();
}

void keyboard(unsigned char key, int x, int y)
{
	// List all youe keyboard keys from assignment two her for body movement
	switch (key)
	{

	case 'B':
		moveForward();
		glutPostRedisplay();
		break;
	case 'b':
		moveBack();
		glutPostRedisplay();
		break;
	
	case 's':
      if (shoulder > -180){
      shoulder = (shoulder - 5) % 360;
      }
      else shoulder = -180;
      glutPostRedisplay();
      break;
   case 'S':
   if(shoulder < 0){
      shoulder = (shoulder + 5) % 360;
   }
   else shoulder = 0;
      glutPostRedisplay();
      break;

   case 'e':
      if(elbow > -100){
      elbow = (elbow - 5) % 360;
      }
      else elbow = -100;
      glutPostRedisplay();
      break;
   case 'E':
      if(elbow < 0){
      elbow = (elbow + 5) % 360;}
      else elbow = 0;
      glutPostRedisplay();
      break;      
   case 'a':
      if (arm < 180)
      arm = (arm + 5) % 360;
      else arm = 180;
      glutPostRedisplay();
      break;
   case 'A':
      if(arm > 0 )
      arm = (arm - 5) % 360;
      else arm =0;
      glutPostRedisplay();
      break;
   case 'z':
      if ( Larm > -180 )
      Larm = (Larm - 5) % 360;
      else Larm = -180;
      glutPostRedisplay();
      break;
   case 'Z':
   if(Larm <0)
      Larm = (Larm + 5) % 360;
   else Larm =0;
      glutPostRedisplay();
      break;
   case 'x':
      if (Lshoulder > -180){
      Lshoulder = (Lshoulder - 5) % 360;
      }
      else Lshoulder = -180;
      glutPostRedisplay();
      break;
   case 'X':
   if(Lshoulder < 0){
      Lshoulder = (Lshoulder + 5) % 360;
   }
   else Lshoulder = 0;
      glutPostRedisplay();
      break;
   
   case 'd':
      if(Lelbow > -100){
      Lelbow = (Lelbow - 5) % 360;
      }
      else Lelbow = -100;


      glutPostRedisplay();
      break;
   case 'D':
      if(Lelbow < 0){
      Lelbow = (Lelbow + 5) % 360;}
      else Lelbow = 0;
      glutPostRedisplay();
      break;
   
   case 'h':
      if (hip < 60)
      hip = (hip + 5) % 360;
      else hip = 60;
      glutPostRedisplay();
      break;
   case 'H':
      if(hip > 0)
      hip = (hip - 5) % 360;
      else hip =0;
      glutPostRedisplay();
      break;

   case 'l':
      if (leg < 50 )
      leg = (leg + 5) % 360;
      else leg = 50;
      glutPostRedisplay();
      break;
   case 'L':
      if (leg > -90)
      leg = (leg - 5) % 360;
      else leg = -90;
      glutPostRedisplay();
      break;

   case 'k':
      if (knee < 90)
      knee = (knee + 5) % 360;
      else knee = 90;
      glutPostRedisplay();
      break;
   case 'K':
      if (knee > 0)
      knee = (knee - 5) % 360;
      else knee = 0;
      glutPostRedisplay();
      break;      

   case 'y':
      if (Lhip > -60)
      Lhip = (Lhip - 5) % 360;
      else Lhip = -60;
      glutPostRedisplay();
      break;
   case 'Y':
      if (Lhip < 0)
      Lhip = (Lhip + 5) % 360;
      else Lhip=0;
      glutPostRedisplay();
      break;

   case 'o':
      if(Lleg < 50)
      Lleg = (Lleg + 5) % 360;
      else Lleg =50;
      glutPostRedisplay();
      break;
   case 'O':
   if(Lleg >-90)
      Lleg = (Lleg - 5) % 360;
      else Lleg = -90;
      glutPostRedisplay();
      break;

   case 'i':
      if (Lknee < 90)
      Lknee = (Lknee + 5) % 360;
      else Lknee=90;
      glutPostRedisplay();
      break;
   case 'I':
      if (Lknee > 0 )
      Lknee = (Lknee - 5) % 90;
      else Lknee =0;
      glutPostRedisplay();
      break;      
   case 'f':
      if (base > -30)
      base = (base - 5) % 360;
      else base=-30;
      glutPostRedisplay();
      break;
   case 'F':
      if (base < 0 )
      base = (base + 5) % 90;
      else base =0;
      glutPostRedisplay();
      break;      

   case 'v':
      if (flang > -30)
      flang = (flang - 5) % 360;
      else flang=-30;
      glutPostRedisplay();
      break;
   case 'V':
      if (flang < 0 )
      flang = (flang + 5) % 90;
      else flang =0;
      glutPostRedisplay();
      break;      

   case 27:
      exit(0);
      break;
   default:
      break;
	}
}
static void mouse(int button, int state, int x, int y)
{
  if (button == GLUT_LEFT_BUTTON) {
    if (state == GLUT_DOWN) {
      moving = 1;
      startx = x;
      starty = y;
    }
    if (state == GLUT_UP) {
      moving = 0;
    }
  }
}
static void motion(int x, int y)
{
  if (moving) {
    angle = (x - startx);
    angle2 =  (y - starty);
	rotatePoint(up,-angle /100,eye);
    startx = x;
    starty = y;
    glutPostRedisplay();
  }
}
void DTimer1(int x){
if (x == 1){
   DRot -= 1;
	glutPostRedisplay();
	glutTimerFunc(30, DTimer1, 1);

}


}
void carTimer(int x){
 if (x == 1){

      if (Cpos == 10){
         CRound = 1;
         Crot = 180;
      } 

      if (Cpos == -10){
         CRound = 0;
         Crot = 0;
      }
      if(CRound == 0){
         Cpos +=0.5;
      } 

      if(CRound == 1){
         Cpos -=0.5;
      } 
   
	   glutPostRedisplay();
   
      glutTimerFunc(30, carTimer, 1);
      // std::cout<<"MOVE"<<std::endl;
 }
if (x == 0){


   	glutPostRedisplay();
      glutTimerFunc(0, carTimer, 0);
      // std::cout<<"STOP"<<std::endl;
}
   
   
}

// void stopTimers(int x ){
//       Cpos = Cpos;
//       Crot = Crot;

//    	glutPostRedisplay();
   
//       glutTimerFunc(0, stopTimers, 0);
   
   
// }
void Timer1(int x){
    // Refresh and redraw
   VRot += 5;
   if (Lelbow <= -120)
      wave = 1.0;
   if (Lelbow >= -60){
      wave = 0.0;
   } 
   if (wave == 0.0){
      Lelbow = (Lelbow - 4) % 180;
      elbow = (elbow - 4) % 180;
   } 
   if (wave == 1.0){
      Lelbow= (Lelbow + 4) % 180;
      elbow= (elbow + 4) % 180;
   } 
   if (VRot == 360)
      VRot=0;
   // std::cout<<Lelbow <<std::endl;   
   glutPostRedisplay();
   glutTimerFunc(50, Timer1, 0);
}

void Timer2(int x){
    // Refresh and redraw
    if(pos >= 9.4){
       lab = 1.0;
       VRot = 180;
       
    }
    if(pos <= 1.0){
       lab = 0.0;
       VRot = 0.0;
       leg = -20;
      
   }
    if (lab == 0 ){
       pos += 0.15;
      
       if (leg != 0){
          leg += 0.1;
       }
       
    }
    if(lab == 1){
       pos-=0.15;

    }
   //  std::cout<< pos <<  std::endl;
    glutPostRedisplay();
    glutTimerFunc(50, Timer2, 0);
}
int main(int argc, char **argv)
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_DEPTH | GLUT_RGB);
	glutInitWindowSize(1000, 1000);
	glutInitWindowPosition(100, 100);
	glutCreateWindow("body");
   initRendering(); 
	init();

	glutDisplayFunc(display);
   glutSpecialFunc(specialKeys);
	glutKeyboardFunc(keyboard);
	glutMouseFunc(mouse);
	glutMotionFunc(motion);

   Timer(0);
   glutCreateMenu(screen_menu);
	glutAddMenuEntry("Models", 0);
	glutAddMenuEntry("", 0);
	glutAddMenuEntry("wood", 'w');
	glutAddMenuEntry("chess", 'c');
   glutAddMenuEntry("stripes", 'p');
	glutAddMenuEntry("stone", 's');
   glutAddMenuEntry("Animatios", 0);
	glutAddMenuEntry("", 0);
   glutAddMenuEntry("porsche", '1');
   glutAddMenuEntry("f-16", '2');
   glutAddMenuEntry("wave", '3');
   glutAddMenuEntry("play soccer", '4');
	glutAttachMenu(GLUT_RIGHT_BUTTON);
	// glutTimerFunc(0,Timer1,0);
   // glutTimerFunc(0,Timer2,0);
   // glutTimerFunc(0,DTimer1,0);
   //  glutTimerFunc(0,carTimer,1);
   
    
	
	glutMainLoop();
	return 0;
}
