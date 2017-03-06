# Real-time robot arm control using motor imaginary movements decoded form EEG signals

## Research Practice in the scope of M.Sc. Electrical & Computer Engineering at Technical University of Munich

# Introduction 

Brain machine interface (BMI) is used to control a system through which people with motor
disabilities could achieve a better quality of life by improving their interaction ability with the
surrounding environment. Using BMI, patients suffering from severe motor disabilities can also
control robot arm to carry out their activity of daily living by just generating control commands using
their own EEG signals.
The main objective of this project is to implement the algorithm described in [1,2] to discriminate and
decode four motor imagery movements (left hand, right hand, both hand imaginary movement and
rest) from EEG signals. Afterwards, the developed algorithm has to be used to control a robot arm in a
real-time scenario. 

## Tasks 
This project requires the student to:
1. Implement an existing algorithm to classify four motor imaginary movements from EEG
recorded signals 
2. Test and validate the developed algorithm in a real-time scenario when the user imagines one
of the four actions, this imagination would be decoded with a BMI and the robotic arm
executes the desired movement.

## Optional Tasks
* Extend the work by using the implemented algorithm to classify reach and grasp imaginary
movements 


### Bibliography
[1] Jianjun Meng, Shuying Zhang, Angeliki Bekyo, Jaro Olsoe, Bryan Baxter, Bin He,” Noninvasive
Electroencephalogram Based Control of a Robotic Arm for Reach and Grasp Tasks”, vol 6, Scientific
Reports, 2016
[2] Yong X, Menon C. “EEG Classification of Different Imaginary Movements within the Same
Limb”. PLoS ONE, 2015

Supervisor:	Dipl.-Ing. Zied
Start:		24/02/2017

# Setup of working environment
## Hardware 
The hardware that is used for the project will be discussed in this section. 

* Brain Computer Interface (BCI): EMOTIV EPOC+
* Robotic arm: Neuronics Katana

### EMOTIV EPOC+
The EMOTIV EPOC+ headset consists of 16 electrodes in the standard 10-20 system (see figure below). It is capable of recording 128 samples/second, i.e. a sampling frequency of 128 Hz. 

<img src="/Documents/BCI-project/10-20-emotiv.gif" width="256">
<img src="/Documents/BCI-project/10-20.jpg" width="256">

__Fig. 1: EMOTIV EPOC+ headset standard 10-20 electrode placement__



## Software 
Useful ressources:
* [OpenVibe Setup](http://openvibe.inria.fr/how-to-connect-emotiv-epoc-with-openvibe/)
	* For visualizing the raw EMG signals. Emotiv Premium SDK needed for access to raw hardware signals. 
* EMOTIV Control Panel
	* Free at http://www.emotiv.com


