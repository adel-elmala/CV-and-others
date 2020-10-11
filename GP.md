# Automated Embedded Systems Interfacing And Computer Vision Motion Capture

## Embedded Systems Interfacing

An Embedded system is a combination of computer hardware and software designed for a specific function, There are different steps involved in the Embedded system design process. These steps depend on
the design methodology. Typically in most cases, there is an interfacing step (Designing the software for controlling the different hardware components of the system)  that would consume a considerable amount of time, in designing of complex systems that process would be very complicated and needs to be handled with much care.
In this project we are concerned with the design of mechanical devices that are capable of performing a variety of tasks on command or according to instructions programmed in advance (Self driving cars, robots, prosthetic arms...etc).
We will evaluate this concept on a prosthetic hand as our example of those mechanical systems.

## A closer look on the Embedded system Software Interface

The Embedded system software interface will handle all the controls and make all the decisions required to execute the task of the our Embedded system, in a prosthetic hand that task will be to form some kind of grip or gesture, but to do that the software engineer typically need to think about many parameters that affect the execution of the arm's task, The start pose joint parameters, The end pose joint pararmeters, joint limits and other parameters that may relate to the inviroment of operation.
After putting all those parameters in consideration we begin the step of **Motion Planning**, which by the end of a successful motion plan will be formed, then **Inverse kinematics** transforms the motion plan into joint actuator trajectories.

Our first step of the project will be to automate the whole process of motion planning so the software module can learn all the parameters needed and plan the needed trajectory and execution sequence by itself.

## Computer Vision Motion Capture

The range of motion and the number of ways that humans use their hands is very large, a typical human can lift a bottle in more than 20 ways, so to only limit a prosthetic hand to a number of grips is quite insufficient considering the potential of a human hand.
We want to at least be able to capture any motion or gesture done by the human hand, and execute that movement using our motion planning software.
Motion capture can get quite complex when trying to capture human hand gestures or movements but successful approaches have been made to do just that and capture even the very fast motion of a pianist's hand.


## The Completed Software Module Operation

Our targeted operation scheme would be to give the software interface the raw controls (ex: Specific pins and voltage values), then using unsupervised reinforced learning the module will learn the parameters of the systems.
A new motion is provided and captured successfully, the module (knowing all the parameters of the systems) constructs a motion plan and the needed trajectory.

