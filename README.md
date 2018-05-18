### This branch includes the required files to successfully stream data into MATLAB using the lab streaming layer (LSL).

# The guides below show how to:
Note: due to time constraints and our knowledge of MATLAB, these guides are only for MATLAB

### Setup LSL
1. Setup LSL using Python
2. LSL through OpenBCI GUI
### Receive Data in MATLAB
3. Receive data in MATLAB with ReceiveData.m via LSL, LSL MATLAB example
4. Receive data in MATLAB with vis_stream.m via LSL, LSL MATLAB viewer
5. Receive data in MATLAB with BCILAB via LSL

# Setup LSL
## 1. Setup LSL using Python
1.	Install Python 3.5.4 (Windows x86-64 executable) from <a href="https://www.python.org/downloads/windows/">this link</a>.
2.	Open command prompt. You should run this as administrator, see the screenshot. If you don’t have the command prompt listed after right clicking the start button on the taskbar, then right click on your taskbar, go to taskbar settings, and then turn off the feature that says ‘Replace Command Prompt with Windows PowerShell in the menu when I right-click the start button or press Windows-X’. Use the cd command to navigate to your Python installation, then Scripts folder. Example: <i>cd C:/Users/zhaoz/AppData/Local/Programs/Python/Python35/Scripts</i>
<br><a href="https://drive.google.com/uc?export=view&id=1FVhRQ_figI0D_wPoesSxJaWsJRSfLMA3"><img src="https://drive.google.com/uc?export=view&id=1FVhRQ_figI0D_wPoesSxJaWsJRSfLMA3" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
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
<br><a href="https://drive.google.com/uc?export=view&id=1WlmMZ1SFZQ123TQe3Wl52tXAxGS4hPIa"><img src="https://drive.google.com/uc?export=view&id=1WlmMZ1SFZQ123TQe3Wl52tXAxGS4hPIa" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
9.	Type <i>/start</i> to start streaming data to the network. 
10.	Now follow one of the methods to see the data in Matlab. Note that if Method 3 or Method 4 (Receive data in MATLAB section) return an error such as “Undefined function or variable 'lsl_loadlib'.”, then do the FIRST 4 steps of Method 5 (BCILAB) FIRST! Then try Method 3 or 4. Update: This error has to do with compiling mex files. I had this fixed via request on Github and don’t need this workaround. 

## 2. LSL through OpenBCI GUI
1.	Run the OpenBCI Hub. Then run the OpenBCI GUI with the desired parameters.
2.	In the GUI, use one of the dropdowns to choose the Networking widget.
<br><a href="https://drive.google.com/uc?export=view&id=1X8MSVMAD3fJAxK_Uq-2KNxJo6DSBhXIz"><img src="https://drive.google.com/uc?export=view&id=1X8MSVMAD3fJAxK_Uq-2KNxJo6DSBhXIz" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
3.	Click on the dropdown menu below protocol and choose LSL. Then choose TimeSeries for Data Type. Now you should follow the steps for either Method 3, 4, or 5 to view in MATLAB.
<br><a href="https://drive.google.com/uc?export=view&id=1YXBZ4_7XCcjt4loJec-MJGXsy_dpOOnm"><img src="https://drive.google.com/uc?export=view&id=1YXBZ4_7XCcjt4loJec-MJGXsy_dpOOnm" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
# Receive Data in MATLAB
## 3. Receive data in MATLAB with ReceiveData.m via LSL, LSL MATLAB example
1.	Download the lab streaming layer from <a href="https://github.com/sccn/labstreaminglayer">Github</a>. Extract it and put it in some folder.
2.	Download the liblsl-Matlab zip folder from <a href="https://github.com/faheemersh/Senior_Design_EEG_fNIRS_BCI/tree/Streaming-via-LSL/LSL stuff">Github</a> and replace the liblsl-Matlab folder in your lab streaming layer master directory. 
3.	Add the path containing ReceiveData.m by typing (for example) >> <i>addpath(genpath('C:\\Users\\fahee\\Downloads\\Capstone downloads\\labstreaminglayer-master\\labstreaminglayer-master\\LSL\\liblsl-Matlab'))</i>
4.	Type ReceiveData in the command window, even if you don’t have the file open. It should still run.
5.	If you have the default code, you will see the data populate in the command window. The first eight columns are the channels, the last one is time in seconds.
<br><a href="https://drive.google.com/uc?export=view&id=1UPykKhYz_zBgxWAsQEmyt6GhghcM28dl"><img src="https://drive.google.com/uc?export=view&id=1UPykKhYz_zBgxWAsQEmyt6GhghcM28dl" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
6.	To stop the data stream, you need to press Ctrl+C in Matlab. Then you can <i>/stop</i> in the command window.
## 4. Receive data in MATLAB with vis_stream.m via LSL, LSL MATLAB viewer
1.	Download the lab streaming layer from <a href="https://github.com/sccn/labstreaminglayer">Github</a>. Extract it and put it in some folder.
2.	Add the path containing vis_stream by typing (for example) <i>addpath('C:\\Users\\fahee\\Downloads\\Capstone downloads\\labstreaminglayer-master\\labstreaminglayer-master\\Apps\\MATLABViewer')</i>
3.	Type <i>vis_stream</i> in the command window, even if you don’t have the file open. It should still run.
4.	If it is working, you should see the following window. Make sure to change your settings so that the window looks similar to the following. You can tweak the other parameters. 
<br><a href="https://drive.google.com/uc?export=view&id=1LEgx65BFejYhl1NhJo_N2o6e_kJEWSKW"><img src="https://drive.google.com/uc?export=view&id=1LEgx65BFejYhl1NhJo_N2o6e_kJEWSKW" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
5.	Click ok. You should now be able to see a figure in MATLAB showing the stream. Stop the stream by typing <i>/stop</i> in the command prompt.
6.	For the color code for each channel see the screenshot below.
<br><a href="https://drive.google.com/uc?export=view&id=1qUeD5MhQ_74rhRSUVR6aCI2LiorPckZo"><img src="https://drive.google.com/uc?export=view&id=1qUeD5MhQ_74rhRSUVR6aCI2LiorPckZo" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
7.	Your final figures should be something like the following screenshots.
<br>Blink (Fp1 and Fp2)</br>
<br><a href="https://drive.google.com/uc?export=view&id=1E2wY4hWCQJDaOO_Gp1mwhN0BgTKjUArT"><img src="https://drive.google.com/uc?export=view&id=1E2wY4hWCQJDaOO_Gp1mwhN0BgTKjUArT" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
<br>Clenching Jaw (can see spiking, supposed to be in C3 and C4 but seems to pollute other channels)</br>
<br><a href="https://drive.google.com/uc?export=view&id=1pBDYFDEGYuvedJEEoS6QhVexPpBGwoCr"><img src="https://drive.google.com/uc?export=view&id=1pBDYFDEGYuvedJEEoS6QhVexPpBGwoCr" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
<br>Zoomed in, just sitting with eyes open, relaxed</br>
<br><a href="https://drive.google.com/uc?export=view&id=1LHAxN0XWARwEyld4uetZhsWASAuY5_Ot"><img src="https://drive.google.com/uc?export=view&id=1LHAxN0XWARwEyld4uetZhsWASAuY5_Ot" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
## 5. Receive data in MATLAB with BCILAB via LSL
1.	Download the BCILAB repo from <a href="https://github.com/sccn/BCILAB/tree/devel">Github via the developer branch</a>.
2.	Extract the folder in any directory.
3.	In MATLAB, go to the directory you installed BCILAB-devel. Then navigate to the folder \BCILAB-devel\BCILAB-devel\userscripts. OR you can add the path by typing something similar to this in the command window: <i>addpath('C:\\Users\\fahee\\Downloads\\Capstone downloads\\BCILAB-devel\\BCILAB-devel')</i>
4.	Type bcilab in the command window. Wait for it to finish. Once it is completed, you should be able to view the following window.
<br><a href="https://drive.google.com/uc?export=view&id=1mPLyLAm3YZ7gXuEalQ2Xo2tzOUt6YRk3"><img src="https://drive.google.com/uc?export=view&id=1mPLyLAm3YZ7gXuEalQ2Xo2tzOUt6YRk3" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
5.	If you aren’t able to view the window, go to your taskbar and hover over Matlab. Then right click on the window showing the BCILAB window and click move. Then press the down arrow on your keyboard. That should bring the window to your cursor.
<br><a href="https://drive.google.com/uc?export=view&id=1Bp1xOB41DKlBVuyC-XNNQVlhek2ESJyQ"><img src="https://drive.google.com/uc?export=view&id=1Bp1xOB41DKlBVuyC-XNNQVlhek2ESJyQ" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
6.	Click on Online Analysis, then Read Input from…, and the Lab Streaming Layer. 
7.	Another window should show up. Clear the marker stream query by removing whatever is in the field. The window should look like this before you click ok.
<br><a href="https://drive.google.com/uc?export=view&id=14nn3822Io1bjK-wHA_yD0ifsZJpMSKkd"><img src="https://drive.google.com/uc?export=view&id=14nn3822Io1bjK-wHA_yD0ifsZJpMSKkd" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
8.	You will see ‘Now reading…’ in the command window if this is successful. If you look at the workspace, you should see two variables (laststream_chunk_clr and laststream_range) constantly changing dimensions as BCILAB picks up the data from the LSL.
9.	You can stop the stream by going to python and typing <i>/stop</i>.
