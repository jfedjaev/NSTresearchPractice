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

Supervisor:	Dipl.-Ing. Zied Tayeb
Start:		24/02/2017

# Setup of working environment
## Hardware 
The hardware that is used for the project will be discussed in this section. 

* Brain Computer Interface (BCI): EMOTIV EPOC+ (used until March 22)
	* The EMOTIV EPOC+ did not work with the OpenVibe acquisition server using the official premium SDK for accessing raw signals. We tested two similar headsets with the official premium SDK without success. Emokit reverse-engineering drivers written in Python were able to access some of the data, however, the electrode and quality indicator signals were disturbed by a strong jitter. An EMOTIV EPOC+ headset with an older version number was working without any problems. We therefore assume that there were some changes done on firmware level. 
* Robotic arm: Neuronics Katana
* BIOPAC systems MP36 (from march 22)
	* After failure with EMOTIV EPOC+ headset, I decided to change the EEG signal acquisition system and went with BIOPAC MP36. It comes with a biosignal amplifier (4 channels), each with its one ground and reference electrodes for bipolar derivation recordings. 

### EMOTIV EPOC+
The EMOTIV EPOC+ headset consists of 16 electrodes in the standard 10-20 system (see figure below). It is capable of recording 128 samples/second, i.e. a sampling frequency of 128 Hz. 

<img src="/Documents/BCI-project/10-20-emotiv.gif" height="256">
<img src="/Documents/BCI-project/10-20.jpg" height="256">

__Fig. 1: Left: EMOTIV EPOC+ headset electrode placement. Right: Standard 10-20 electrode placement system__

The EMOTIV EPOC+ headset has the following specificiations:

| Number of channels                   | 14 (plus CMS/DRL references)                               |
|--------------------------------------|------------------------------------------------------------|
| Channel names (Int. 10-20 locations) | AF3, AF4, F3, F4, F7, F8, FC5, FC6, P7, P8, T7, T8, O1, O2 |
| Sampling method                      | Sequential sampling, single ADC                            |
| Sampling rate                        | ~128 Hz (2048 Hz internally)                               |
| Resolution                           | 16 bits (14 bits effective), 1 LSB = 1.95 µV               |
| Bandwidth                            | 0.2 - 45 Hz, digital notch filters at 40 and 60 Hz         |
| Dynamic range (input referred)       | 256 mVpp                                                   |
| Coupling method                      | AC coupled                                                 |
| Connectivity                         | Proprietary wireless, 2.4 GHz                              |
| Battery type                         | 12 Li-Poly                                                 |
| Battery life                         | 12 hrs                                                     |
| Impedance measurement                | Contact quality using patented system                      |

Tab. 1 - EMOTIV EPOC+ headset specifications





## Software 
Useful ressources:
* [OpenVibe Setup](http://openvibe.inria.fr/how-to-connect-emotiv-epoc-with-openvibe/)
	* For visualizing the raw EMG signals. Emotiv Premium SDK needed for access to raw hardware signals. 
* EMOTIV Control Panel
	* Free at http://www.emotiv.com

* [BCILAB Online scripting](https://sccn.ucsd.edu/wiki/BCILAB#Online_scripting)
	* For online processing of EEG signals in EEGLAB with Matlab
* [EEG Data Processing and Classification with g.BSanalyze Under Matlab](https://de.mathworks.com/company/newsletters/articles/eeg-data-processing-and-classification-with-gbsanalyze-under-matlab.html)
	
## Motor Imagery with built-in modules in OpenVibe
A more or less detailed explanation is given on the following website: [Motor Imagery](http://blog.jfrey.info/2015/03/03/openbci-motor-imagery/)

# 



