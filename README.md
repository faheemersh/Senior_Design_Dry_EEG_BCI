### This branch includes some of the archives and executables used in this project.
### Other important .exe and .zip files that couldn't be uploaded (can download from other places)
- BCILAB-devel (download/clone from their <a href="https://github.com/sccn/BCILAB/tree/devel">Github repo</a>)
- Processing-3.3.6-windows64 (from their <a href="https://processing.org/download/">website</a>)
- OpenBCI GUI (from their <a href="http://openbci.com/donation">website</a>)

# The guides below will direct you on how to:
1. Setup the standalone OpenBCI Hub and GUI
2. Run the standalone OpenBCI GUI
3. Run OpenBCI GUI using Processing (if the standalone is buggy)
4. Setup and run EEGLAB/BCILAB(devel)

## Setup the standaline OpenBCI Hub and OpenBCI GUI (Windows 10)
Note: steps 1-12 of this section copied/modified from <a href="http://docs.openbci.com/OpenBCI%20Software/01-OpenBCI_GUI#the-openbci-gui-installing-the-openbci-gui-as-a-standalone-application-install-openbci_gui-on-windows">this link</a> on OpenBCI in case the link is changed/removed.

1. First unzip the windows application you downloaded from the downloads section of the OpenBCI Website.
<br><a href="https://drive.google.com/uc?export=view&id=19oMzQylRu5RJdJdSCaCmvs9G-VCvM3dr"><img src="https://drive.google.com/uc?export=view&id=19oMzQylRu5RJdJdSCaCmvs9G-VCvM3dr" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

2.	Please place the OpenBCIHub in your Program Files directory such that the structure looks like: “\Program Files\OpenBCIHub\OpenBCIHub.exe”
<br><a href="https://drive.google.com/uc?export=view&id=12qqHQGb5CczxQJAYbtDJzFPLXaVZW1Lx"><img src="https://drive.google.com/uc?export=view&id=12qqHQGb5CczxQJAYbtDJzFPLXaVZW1Lx" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

3. Enter the new OpenBCIHub folder and right click on the executable -> properties -> compatibility -> tick “Run this program as an administrator”.
<br><a href="https://drive.google.com/uc?export=view&id=1a4ozqpUSFkTg9iSV48hiBTwChgTkZtHo"><img src="https://drive.google.com/uc?export=view&id=1a4ozqpUSFkTg9iSV48hiBTwChgTkZtHo" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

4.	Create a shortcut on your desktop by right clicking on the executable -> Send to -> Desktop.

5.	Then double click the executable to run it for the first time. You must check both check boxes when prompted.
<br><a href="https://drive.google.com/uc?export=view&id=178aGSBomwb5NqxNf6RbyOtsYAgVlyvWq"><img src="https://drive.google.com/uc?export=view&id=178aGSBomwb5NqxNf6RbyOtsYAgVlyvWq" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

6.	We recommend you leave the Hub running, even when not using the OpenBCI_GUI, the hub’s impact on performance when not in use is minimal.

7.	Verify the hub is running in your windows tool tray.
<br><a href="https://drive.google.com/uc?export=view&id=1yW1_kodVP567mB2rJlaKPHZ4WNMDri0i"><img src="https://drive.google.com/uc?export=view&id=1yW1_kodVP567mB2rJlaKPHZ4WNMDri0i" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

8.	To quit the hub, click the OpenBCI icon, and then press the quit button.
<br><a href="https://drive.google.com/uc?export=view&id=1_-HE-upGTgHgOx6vybWClIdkaqa_JuDa"><img src="https://drive.google.com/uc?export=view&id=1_-HE-upGTgHgOx6vybWClIdkaqa_JuDa" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

9.	Please place the GUI in your Program Files directory such that the structure looks like: “\Program Files\OpenBCI_GUI\OpenBCI_GUI.exe”
<br><a href="https://drive.google.com/uc?export=view&id=1PiGAdmMMUB1DWkENj9iqNQMXXQoAhzEp"><img src="https://drive.google.com/uc?export=view&id=1PiGAdmMMUB1DWkENj9iqNQMXXQoAhzEp" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

10. If you already have a GUI installed, you may select to replace all the files.

11. Replacing the files may bring up another pop up that you need to accept for altering files within the Program Files folder.

12.	Lastly, right click on the executable -> properties -> compatibility -> tick “Run this program as an administrator”.
<br><a href="https://drive.google.com/uc?export=view&id=1aA38drhH1MQUsPRBBfzfjTNtLhnRjjdm"><img src="https://drive.google.com/uc?export=view&id=1aA38drhH1MQUsPRBBfzfjTNtLhnRjjdm" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

## Run the standalone OpenBCI GUI
1. Download the appropriate <a href="http://www.ftdichip.com/Drivers/VCP.htm">FTDI drivers</a> for your computer.

2. Make sure the OpenBCI Hub is running. Then go to your installation directory for OpenBCI GUI and run it. It should be in your program files folder or you can use the shortcut on your desktop.

3. Plug in the dongle and turn on the Cyton board. Make sure the pin on the dongle is set to 'GPIO6' and NOT 'RESET' and that the blue LED is on. 
<br><a href="https://drive.google.com/uc?export=view&id=1cZ2AFED9Q9nVVS_9jJ7q5fs9NBzmZL1C"><img src="https://drive.google.com/uc?export=view&id=1cZ2AFED9Q9nVVS_9jJ7q5fs9NBzmZL1C" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

4. Once it opens, make sure to choose ‘LIVE (from Cyton)-->Serial (from Dongle)-->Port (for us it was COM13)-->Start system. You can change other parameters if you want. 

5. If the connection between the board, dongle, and computer is successful, then you will see the following screen.
<br><a href="https://drive.google.com/uc?export=view&id=1H_p0pTethGnjIUdI1fvttINh6Taz5PyW"><img src="https://drive.google.com/uc?export=view&id=1H_p0pTethGnjIUdI1fvttINh6Taz5PyW" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

6. Click Start Data Stream. Note that as soon as you do this, the data will record to a text file in the SavedData folder within the OpenBCI GUI folder in your program files. See a figure for the streaming data below.
<br><a href="https://drive.google.com/uc?export=view&id=1QMY6b66YodTNpkxHgxpqBb3JIivt7ytz"><img src="https://drive.google.com/uc?export=view&id=1QMY6b66YodTNpkxHgxpqBb3JIivt7ytz" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

7. You can turn off channels by clicking on their numbers in the time series widget. By using the dropdown menus, you can view other kinds of data available from the Cyton board.

8. Click ‘Stop Data Stream’ to stop streaming. 

## Run OpenBCI GUI using Processing
Note: Please use the first set of instructions to install the OpenBCI Hub first. These instructions will be added into this README in the future. For now, please follow the <a href="http://docs.openbci.com/OpenBCI%20Software/01-OpenBCI_GUI#the-openbci-gui-running-the-openbci-gui-from-the-processing-ide">OpenBCI link</a>.

## Setup and run EEGLAB/BCILAB(devel)


