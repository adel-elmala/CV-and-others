# graphics-final-project
# SBE306B_Spring20_Project_Group_04

## Team Members:
- Name : Adel Refat Ali | Sec : 2 | Seat No.: 3 | Email: adel.elmala2025@gmail.com
- Name : Ahmed Nabil Salem | Sec: 1 | Seat No.: 10 | Email: ahmednaza7@gmail.com
- Name : Mahmoud Abdel Monem | Sec: 2  | Seat No.: 26 | Email:  hooodamonem111@gmail.com
- Name : Ahmed Osama Mohamed| Sec: 1 | Seat No.: 2 | Email: ahmedosamam.negm@gmail.com
- Name : Shaden Ahmed | Sec: 1 | Seat No.: 44 | Email: shaden.ahmedbaki@gmail.com


## Implementation:
### Final result 
<!-- ![result](https://i.ibb.co/60hstCg/implem.png) -->

![result](./screenshots/implem.png)

## Loaded objects 
### object 1
<!-- ![car](https://i.ibb.co/bstxX8R/car2.png) -->
<!-- ![car](https://i.ibb.co/smLJ4Lp/car.png) -->
![car](./screenshots/car2.png)
![car](./screenshots/car.png)

### object 2
<!-- ![al](https://i.ibb.co/nCMK2PZ/al2.png)
![al](https://i.ibb.co/rKPyJQt/al.png) -->
![al](./screenshots/al2.png)
![al](./screenshots/al.png)

### object 3
<!-- ![ball](https://i.ibb.co/ky4GtDL/ball.png) -->
![ball](./screenshots/ball.png)
`
### object 4
<!-- ![f-16](https://i.ibb.co/TRkgv8X/f-16-2.png) -->
<!-- ![f-16](https://i.ibb.co/6JfLDRX/f-16.png) -->
![f-16](./screenshots/f-16-2.png)
![f-16](./screenshots/f-16.png)


## animations

### Robot wave
<!-- ![https://vimeo.com/user115583615/review/419045016/af9ce62da6](https://vimeo.com/user115583615/review/419045016/af9ce62da6) -->
![https://vimeo.com/user115583615/review/419045016/af9ce62da6](gifs/wave.gif)
### Robot play soccer
<!-- ![https://vimeo.com/user115583615/review/419044923/8fe10457c5](https://vimeo.com/user115583615/review/419044923/8fe10457c5) -->
![https://vimeo.com/user115583615/review/419044923/8fe10457c5](gifs/ball.gif)
### Car Movement
<!-- ![https://vimeo.com/user115583615/review/419045103/cfb1d502f8](https://vimeo.com/user115583615/review/419045103/cfb1d502f8) -->

![https://vimeo.com/user115583615/review/419045103/cfb1d502f8](gifs/car.gif)

### Plane Movement
<!-- ![https://vimeo.com/user115583615/review/419045055/33750ed128](https://vimeo.com/user115583615/review/419045055/33750ed128) -->
![https://vimeo.com/user115583615/review/419045055/33750ed128](gifs/plane.gif)
## Texture Mapping
### View 1 
<!-- ![https://vimeo.com/user115583615/review/419044762/9448b7b9e7](https://vimeo.com/user115583615/review/419044762/9448b7b9e7) -->
![https://vimeo.com/user115583615/review/419044762/9448b7b9e7](gifs/texture.gif)
### View 2
<!-- ![https://vimeo.com/user115583615/review/419044849/b8a0a99f55](https://vimeo.com/user115583615/review/419044849/b8a0a99f55) -->
![https://vimeo.com/user115583615/review/419044849/b8a0a99f55](gifs/texture2.gif)

## Issues 

### Texture Mapping
- not any images can be mapped and still look nice , it has to be cropped to it's smallest element to look better.
### Lighting 
- had to figure out where to position the light source in respect to the floor to be illuminated properly.


## Idea of the animations
<!-- - The idea came to me when i was looking from my window down the street. -->
<!-- - I call it "el3ab b3eed ya 7mada bdl m2t3 elkora". -->
1. the 'car' moves along the z axis of the floor and turns around every time it reaches the edge
2. the 'plane' spin around it's Y axis 
3. the 'Robot' waves his BOTH hands
4. the 'Robot' moves his leg to kick the ball and the ball bounces every time it reaches either the 'robor' or 'al Capone'.  

## Conclusion
 - the scene is controlled from the menu, you can gradually choose objects to start moving.
 - Beside the animations controls,  you can choose the texture mapping of the floor from the same menu.

## Use in biomedical field
- it can be used to import objects constructed from several scans like mri or other imaging machines, then the user can view it in 3d scene for better view , looking to it from different angles and positions.

## Controls
### Robot controls

<!-- | Robot        | key           | controls  || -->
<!-- | ------------- |:-------------:| -----:| -----:| -->
| **Body Part**   | **key**    | **Body Part**     |**key**|
| :-------------:   |:----------:| :-----------------:| :-----:|
| Left Arm        | z - Z      |  Right Arm        | a - A |
|  Left Shoulder  | x - X      |   Right Shoulder  | s - S |
|  Left Elbow     |   d - D    |   Right Elbow     | e - E |
|Left Hip         | y -Y       |Right Hip          | h - H |
|Left leg         | o - O      |Right leg          |l -L   |
|Left Knee        |i - I       |Right Knee         |k - K  |
|Left Base        |f - F       |Right Base         |f - F  |
|Left Flang       |v - V       |Right Flang        |v - V  |

### Camera controls
|Action|Key |Action|key|
|:-----:|-----:|:-----:|-----:|
|Zoom In |B|Zoom out|b|
|left| <-- OR mouse|Right| --> OR mouse|
|Down|down-arrow|UP|up-arrow|


### Animation Controls
**_Left Click and Choose_**

### Compile 

`g++ -o out SBE306B_Spring20_Project_Group_04.cpp ./srcs/imageloader.cpp ./srcs/glm.cpp -lGL -lglut -lGLU -lm`
### Run 

`./out`
