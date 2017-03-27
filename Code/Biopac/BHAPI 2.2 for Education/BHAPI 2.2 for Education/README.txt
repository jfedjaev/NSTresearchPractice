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
  Documentation			Contains the BIOPAC Hardware API Reference Manual
  HardwareUtililies		Files for MP Devices (only use when directed)
  LanguageBindings		Contains Language Bindings (wrappers) for BHAPI in different programming languages
  PresetFiles			Contains files necessary for using the Channel Presets XML file
  SampleBrowser			Folder that contains the Hardware Sample Browser
  SampleProjects		Contains the sample projects and its documentation

Updates since API 2.0
---------------------
- Visual Studio 2010 support
- 64-bit support
- Bug fixes

Updates since API 1.0
---------------------
- Support for MP36 hardware 
- Bug fixing for MP150 units on computers with multiple network adapters 
- Installer creates 2 shortcuts to Sample/Help browser: 
      On the desktop: label is "BHAPI 2.0 manual" 
      START program menu: the path is "Start\Programs\BIOPAC Hardware API 2.0\BHAPI 2.0 manual" 
- MP35USB and MP36USB drivers are included into the BHAPI 2.0 for Windows Installer 
- New sample applications designed to work with MP36 device 
- CH to Output redirection added for MP35 and MP36. 
- New API call of setAnalogOutputMode()allows user to switch between 3 ouptut modes supported by MP36/MP35 devices: 
      a) Constant level voltage output for MP35 (OUTPUTVOLTAGELEVEL)
      b) Redirecting input channel signal to output channel 0 for MP36/MP35 devices
      c) Ground all output signal to zero
- New sample applications (dedicated to work with MP36 device) 
      - C# project - VideoStimulusMP36 
      - VB.NET project - ImageStimMP36 
      - LabView project - getBufferDemoMP36 
      - LabView project - startAcqDaemonDemoMP36 
      - LabView project - temperatureDemo forMp36 

Known Issues
------------
- NONE