BIOPAC HARDWARE API 2.2 for Windows
-----------------------

WELCOME
-------

This is the BIOPAC Hardware API 2.2.  The product will show you how to create custom software programs that can communicate directly with BIOPAC MP devices.

License
-------
- Please see "license.txt"
- In compliance with the Apache Xerces distribution license, "NOTICE" and "LICENSE" text files are included.

Hardware Sample Browser
-----------------------
The Hardware Sample Browser consolidates all documentation for the BIOPAC Hardware API. It includes the API Reference Manual and documentation for the Sample Projects.

Documentation
-------------
Please launch the Hardware Sample Browser.

Sample Projects
---------------
The BIOPAC Hardware API includes several Sample Projects written in various programming languages. Please launch the Hardware Sample Browser to learn more about the Sample Projects.

  The sample projects are located at: [INSTALL DIRECTORY]\SampleProjects

  FOLDER DESCRIPTIONS
  -------------------
  Documentation		Contains the BIOPAC Hardware API Reference Manual
  HardwareUtililies		Files for MP Devices (only use when directed)
  LanguageBindings		Contains Language Bindings (wrappers) for BHAPI in different programming languages
  PresetFiles		Contains files necessary for using the Channel Presets XML file
  SampleBrowser		Contains the Hardware Sample Browser
  SampleProjects		Contains the sample projects and its documentation


Updates since API 2.1
---------------------
- Visual Studio 2010 support
- 64-bit support
- Bug fixes


Updates since API 2.0
---------------------
- Support for MP36R hardware added
- No support for MP35 hardware
- Executable files for 8 sample applications added to SampleProjects:
   - Cplusplus: mp1XXdemo
   - CSharp: Biofeedback
   - CSharp: GoalKick
   - CSharp: TemperatureControl
   - CSharp: VideoStimulusMP36
   - VBNET: bhapibasics
   - VBNET: FunctionGenerator
   - VBNET: ImageStimMP36


Updates since API 1.0
---------------------
- Support for MP36 hardware 
- Bug fixing for MP150 units on computers with multiple network adapters 
- Installer creates 2 shortcuts to Sample/Help browser: 
      On the desktop: label is "BHAPI 2.0 manual" 
      START program menu: the path is "Start\Programs\BIOPAC Hardware API 2.0\BHAPI 2.0 manual" 
- MP36 USB drivers are included into the BHAPI 2.0 for Windows Installer 
- New sample applications designed to work with MP36 hardware 
- CH to Output redirection added for MP36 hardware.
- New API call of setAnalogOutputMode()allows user to switch between 3 ouptut modes supported by MP36 hardware: 
      a) Constant level voltage output for MP36 hardware (OUTPUTVOLTAGELEVEL)
      b) Redirecting input channel signal to output channel 0 for MP36 hardware
      c) Ground all output signal to zero
- New sample applications (dedicated to work with MP36 device) 
      - C# project - VideoStimulusMP36 
      - VB.NET project - ImageStimMP36 
      - LabView project - getBufferDemoMP36 
      - LabView project - startAcqDaemonDemoMP36 
      - LabView project - temperatureDemo forMP36 

Known Issues
------------
- NONE