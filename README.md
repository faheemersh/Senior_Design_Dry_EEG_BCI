### This branch includes the required files to successfully stream data into MATLAB using the lab streaming layer (LSL).

# The guides below show how to:
Note: due to time constraints and our knowledge of MATLAB, these guides are only for MATLAB

Setup LSL
1. Setup LSL using Python
2. LSL through OpenBCI GUI
<br>Receive Data in MATLAB</br>
3. Receive data in MATLAB with ReceiveData.m via LSL, LSL MATLAB example
4. Receive data in MATLAB with vis_stream.m via LSL, LSL MATLAB viewer
5. Receive data in MATLAB with BCILAB via LSL

# Setup LSL
## 1. Setup LSL using Python
1.	Install Python 3.5.4 (Windows x86-64 executable) from <a href="https://www.python.org/downloads/windows/">this link</a>.
2.	Open command prompt. You should run this as administrator, see the screenshot. If you don’t have the command prompt listed after right clicking the start button on the taskbar, then right click on your taskbar, go to taskbar settings, and then turn off the feature that says ‘Replace Command Prompt with Windows PowerShell in the menu when I right-click the start button or press Windows-X’. Use the cd command to navigate to your Python installation, then Scripts folder. Example: <i>cd C:/Users/zhaoz/AppData/Local/Programs/Python/Python35/Scripts</i>
<a href="https://drive.google.com/uc?export=view&id=1FVhRQ_figI0D_wPoesSxJaWsJRSfLMA3"><img src="https://drive.google.com/uc?export=view&id=1FVhRQ_figI0D_wPoesSxJaWsJRSfLMA3" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>
3.	Then check that pip is installed by typing <i>pip freeze</i>. You should get a list of python packages that you’ve installed. If you haven’t installed any packages, nothing will show up and you’ll be able to type another command.
4.	Now to install packages, you need to type <i>pip install packagename</i>, where packagename needs to be replaced with the package you want to install. Install the following (note that the versions are the applicable ones at the time of writing). You don’t need to specify the version in the command window, just the name of the package.
<br>a.	numpy (1.14.0)</br>
<br>b.	pylsl (1.10.5)</br>
<br>c.	pyserial (3.4)</br>
<br>d.	pyqtgraph (0.10.0, optional to add)</br>
<br>e.	scipy (1.0.0, optional to add)</br>
5.	Once this is done, you need to make sure you can write the command <i>python commandyouwanttotype</i>, from any directory in the command prompt. If you don’t do this, to run python, you have to cd to the installation directory for your python (ex. <i>cd C:/Users/zhaoz/AppData/Local/Programs/Python/Python35</i>)  every time you want to run the python command. To do this, follow this <a href="https://github.com/BurntSushi/nfldb/wiki/Python-&-pip-Windows-installation">link</a> or follow the steps below.
<br>a.	Search “environment variable” using the search field in the taskbar and press enter. Or use cortana’s search option (the little circle next to the start button on the taskbar).</br>
<br>b.	Click on environment variables. Under the section for System variables , click on New… and give the variable name “PYTHON_HOME” (without quotes) and for the variable field, paste the full installation path of your python (ex: C:/Users/zhaoz/AppData/Local/Programs/Python/Python35). Click ok.</br> 
<br>c.	Then find the path variable and then click on edit. Then click on edit text. In the variable path field, go to the end of the field, and add the text inside the following quote “;%PYTHON_HOME%\;%PYTHON_HOME%\Scripts\”.</br>
<br>d.	Verify that this worked by opening a new command prompt window (run as administrator this time!) and type python and then you should see the version of the <i>python</i> installed.</br>
6.	Now, in the same command window (or a new one if you want to start fresh again, make sure to run as administrator!), cd to the path containing the OpenBCI_LSL file for python. Download the file from <a href="https://github.com/OpenBCI/OpenBCI_LSL">this Github repo</a> and extract to whatever folder you’d like. Example cd for this file might be: <i>cd C:/Users/fahee/Downloads/Capstone downloads/OpenBCI_LSL-master/OpenBCI_LSL-master</i>
7.	Plug in the dongle to your computer and then turn on the Cyton board on the headset.
8.	Then type this in the command window: <i>python openbci_lsl.py PORT --stream</i>. Type in the port that is occupied by the OpenBCI dongle. For me, it was COM13, so I typed <i>python openbci_lsl.py COM13 --stream</i>. See the screenshot below - this is what should show up in the command prompt if the lab streaming layer is setup correctly.
<a href="https://drive.google.com/uc?export=view&id=1WlmMZ1SFZQ123TQe3Wl52tXAxGS4hPIa"><img src="https://drive.google.com/uc?export=view&id=1WlmMZ1SFZQ123TQe3Wl52tXAxGS4hPIa" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>
9.	Type <i>/start</i> to start streaming data to the network. 
10.	Now follow one of the methods to see the data in Matlab. Note that if Method 1 or Method 2 return an error such as “Undefined function or variable 'lsl_loadlib'.”, then do the FIRST 4 steps of Method 3 (BCILAB) FIRST! Then try Method 1 or 2. Update: This error has to do with compiling mex files. I had this fixed via request on Github and don’t need this workaround. 

## 2. LSL through OpenBCI GUI

# Receive Data in MATLAB
## 3. Receive data in MATLAB with ReceiveData.m via LSL, LSL MATLAB example

## 4. Receive data in MATLAB with vis_stream.m via LSL, LSL MATLAB viewer

## 5. Receive data in MATLAB with BCILAB via LSL
