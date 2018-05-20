### The guide below shows how we used an external trigger with the Cyton 32-bit board. We attempted to observe a visually evoked potential (VEP) as a way to validate the performance of our system.

# External Triggering with OpenBCI
1.	First obtain an optoisolator as shown on <a href="https://www.mouser.ee/ProductDetail/Vishay-Semiconductors/CNY17F-2X006/?qs=sGAEpiMZZMteimceiIVCB7Uit3aMEvQQFLjPtOr%2f870%3d">OpenBCI’s website</a>.
2.	Setup the optoisolator as shown below (taken from OpenBCI’s external triggering page):
<br><a href="https://drive.google.com/uc?export=view&id=13AI0PjNmBja_kta2vWr4naFGDcOafNhF"><img src="https://drive.google.com/uc?export=view&id=13AI0PjNmBja_kta2vWr4naFGDcOafNhF" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
3.	The overall setup should look like the following, where a parallel port is attached to a computer containing the paradigm/stimulation software. Plug in the dongle to your computer and then turn on the cyton board. Afterwards, connect the wires from the breadboard to the cyton.
<br><a href="https://drive.google.com/uc?export=view&id=1Kb0uQz9Tf_uihwE0nc8yjW192d4pIIDS"><img src="https://drive.google.com/uc?export=view&id=1Kb0uQz9Tf_uihwE0nc8yjW192d4pIIDS" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
4.	Then open the paradigm software. For our case, we used a VEP paradigm in E-Prime 3 with the following settings: 1st checkerboard starts sending signal at 0 ms (no delay), then stops sending signal after 500 ms, then 2nd checkerboard is 0 delay, and doesn’t send any signal at all.
5.	Open the OpenBCI GUI if you have not already. Provide the file name and start the system. Then change one of the widgets to digital inputs. Start the paradigm in E-Prime and start recording with the GUI. If done correctly, the corresponding marker on the GUI will switch between 0 and 1. 
6.	A video of a successful setup is shown <a href="https://drive.google.com/file/d/1AwBl_wfWkg1qUssZFW3Z43wBrjn_uNb-/view">here</a>. If you open the text file produced from the recording, there will now be 5 columns, each representing a digital input in, after the eight EEG channels. Find the column containing D17 markers (should be in the 4th column of these 5 columns) and use it for analysis, which is done in the next section. 

# Analysis for VEP
## EEGLAB with OpenBCI GUI data
1.	Add EEGLAB’s path via command window. Ex: <i>addpath('C://Users//fahee//Downloads//Capstone downloads//eeglab_current//eeglab14_1_1b')</i>
2. Open the file save_file_view.m (VEP folder in this branch) in MATLAB. This is the script that extracts the important information from the text file produced by the OpenBCI GUI after recording. Make sure that the text file of interest is in the current path. Copy in the name of the file of interest to the code. 
<br><a href="https://drive.google.com/uc?export=view&id=1QUpLK3PB5uWzJvGcolFFW4VEiXgFB06v"><img src="https://drive.google.com/uc?export=view&id=1QUpLK3PB5uWzJvGcolFFW4VEiXgFB06v" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
3.	Make sure to alter the highlighted line to the file name of the text file. This is the input EEG data to EEGLAB. 
<br><a href="https://drive.google.com/uc?export=view&id=1oMCSOrrhkuwFMnnenW0OVfQ-98jKyFfL"><img src="https://drive.google.com/uc?export=view&id=1oMCSOrrhkuwFMnnenW0OVfQ-98jKyFfL" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
4.	Run the file. Make sure to go the end of the file and follow the steps, which are also shown below. This is to ensure the marker file is saved in the format that EEGLAB can read. 
<br><a href="https://drive.google.com/uc?export=view&id=1G7CjXTERZ-8Wzs4CzrMvCLHvvpZ1Kx1r"><img src="https://drive.google.com/uc?export=view&id=1G7CjXTERZ-8Wzs4CzrMvCLHvvpZ1Kx1r" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
5.	Open the excel file in excel and go to save as. Choose the option shown below and save in the correct directory.
<br><a href="https://drive.google.com/uc?export=view&id=1XFUfsSyY6_j44VqbLJTYkCmFUPswT0OM"><img src="https://drive.google.com/uc?export=view&id=1XFUfsSyY6_j44VqbLJTYkCmFUPswT0OM" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
6.	Type <i>eeglab</i> in the command window. Then go to file->import data->Using EEGLAB functions and plugins->From ASCII/float file or Matlab array.
<br><a href="https://drive.google.com/uc?export=view&id=1I1P5wXhbJ7hVVtSoO7InFRNGczJ47BeY"><img src="https://drive.google.com/uc?export=view&id=1I1P5wXhbJ7hVVtSoO7InFRNGczJ47BeY" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
7.	Fill in the fields as shown, making sure to select Matlab .mat file from the dropdown and browsing for the EEG data file you saved while doing this procedure. Then under the Channel Location file or info, choose the correct .ced file containing the locations of your EEG channels. The details on creating the channel locations file can be found in the following subsection (Channel Locations File). 
<br><a href="https://drive.google.com/uc?export=view&id=1LF1cvB-3srQ74W6Mm86f9JJblydwTaiD"><img src="https://drive.google.com/uc?export=view&id=1LF1cvB-3srQ74W6Mm86f9JJblydwTaiD" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
8.	Click ok. Then click ok on any following popups. After that go to File->Import event info->from Matlab array or ASCII file.
<br><a href="https://drive.google.com/uc?export=view&id=1pcTd5B_5eT7c4TFDDRDiHl-xApZ8LcE-"><img src="https://drive.google.com/uc?export=view&id=1pcTd5B_5eT7c4TFDDRDiHl-xApZ8LcE-" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
9.	Browse for the event markers file that you saved as a text file (from the excel file earlier). Fill out the parameters as shown below. Press ok.
<br><a href="https://drive.google.com/uc?export=view&id=1kxDW-3JkYujmKP3V6ZJDb7FWui3JRpip"><img src="https://drive.google.com/uc?export=view&id=1kxDW-3JkYujmKP3V6ZJDb7FWui3JRpip" style="max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
10.	Go to Tools->Extract epochs. Enter/select the following parameters in the popup. Press ok and then ok for all following pop ups (including baseline removal). 
<br><a href="https://drive.google.com/uc?export=view&id=1d8m4b-fLiJ3Ye6-bRLvQwZCwH-raUcZo"><img src="https://drive.google.com/uc?export=view&id=1d8m4b-fLiJ3Ye6-bRLvQwZCwH-raUcZo" style="width:200px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
11. The main EEGLAB window should look like the figure to the right.
<br><a href="https://drive.google.com/uc?export=view&id=1IqkbQVb-4MBhHNMlJnKU6kBn2_6r0J1z"><img src="https://drive.google.com/uc?export=view&id=1IqkbQVb-4MBhHNMlJnKU6kBn2_6r0J1z" style="width:200px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
12.	Next, go to Tools->Filter the data_>Basic FIR Filter(new). Specify the parameters as shown in the screenshot below. Click ok and you will see the filter response in another window. Click ok on the other following windows and close the filter response window if it is not necessary. Make sure to do both bandpass and
<br><a href="https://drive.google.com/uc?export=view&id=1MlDUu_a9XVnvCwmQDaYWOvZ6J9hAZjNj"><img src="https://drive.google.com/uc?export=view&id=1MlDUu_a9XVnvCwmQDaYWOvZ6J9hAZjNj" style="width:200px; height: auto" title="Click for the larger version." /></a>
</br>
13. notch filters.
<br><a href="https://drive.google.com/uc?export=view&id=15yRYguZEH-XVSKCpwFpX-n6tHjC-4hc3"><img src="https://drive.google.com/uc?export=view&id=15yRYguZEH-XVSKCpwFpX-n6tHjC-4hc3" style="width:200px; height: auto" title="Click for the larger version." /></a></br>
14. Next, visualize the data by going to Plot->Channel Data (scroll).
<br><a href="https://drive.google.com/uc?export=view&id=1G1_HHPvNoawNUqdnZSL8kqqE4yjL07mW"><img src="https://drive.google.com/uc?export=view&id=1G1_HHPvNoawNUqdnZSL8kqqE4yjL07mW" style="width:200px; height: auto" title="Click for the larger version." /></a>
</br>
