### We will be adding in the information from the link below later. For now, please follow the instructions at the link below to setup OpenViBE. 

http://docs.openbci.com/3rd%20Party%20Software/03-OpenViBE

## Inserting markers into MATLAB via OpenViBE through LSL
For synchronous BCIs, there may be a need to stream markers in real-time to another software, along with the EEG data. A guide for doing this is shown below. 

1. Download all the files (apart from the readme) from this branch.
2. Run the OpenViBE acquisition server. Connect and then play. Run the OpenViBE designer and navigate to the directory shown below. Open mi-csp-1-acquisition-openbci-lsl.xml.
3. The original scenario was modified to include signal display boxes (raw and filtered), channel selector boxes, temporal filter (notch and bandpass) boxes, and most importantly, a LSL Export (Gipsa) box. Notice the connection from the Graz MI BCI Stimulator (at the top) to the LSL Export box. This is what allows markers to be sent over LSL. A [Github issue](https://github.com/OpenBCI/OpenBCI_GUI/issues/313) has been created so that this can be done using the OpenBCI GUI.
<br><a href="https://drive.google.com/uc?export=view&id=19wwsXxB4otgxr7jUzTy4wrr9ajqMotdL"><img src="https://drive.google.com/uc?export=view&id=19wwsXxB4otgxr7jUzTy4wrr9ajqMotdL" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
4. Open ReceiveData.m in MATLAB from the liblsl-Matlab/Examples directory from the labstreaminglayer-master folder. Make sure to add the path for LSL (i.e. <i>addpath(genpath('C:\Users\fahee\Downloads\Capstone downloads\labstreaminglayer-master\labstreaminglayer-master\LSL\liblsl-Matlab'))</i>) in the command window. If you have not setup LSL and reduced the latency for data acquisition, please see [this branch](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Streaming-via-LSL) and steps 1-6 of [this guide from this  branch](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Archives-and-Executables#run-the-standalone-openbci-gui).

5. Go back to OpenViBE and play the scenario. Go to MATLAB and run ReceiveData.m. You should now see a stream of data coming into MATLAB. After 30 seconds, the Graz stimulations will begin, and you will see the marker IDs show up in the next to last column (right-most) in the MATLAB command window. Marker ID 800 can be seen in the screenshot on the right.
<br><a href="https://drive.google.com/uc?export=view&id=1SKhJZcaF8Et1y5lssR5Zs7-IT5I6W5Vn"><img src="https://drive.google.com/uc?export=view&id=1SKhJZcaF8Et1y5lssR5Zs7-IT5I6W5Vn" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
6. The key for the marker IDs and their corresponding events are shown below. These were found by exploring the scenario .xml and related files with Notepad++.
Experiment start: 32768
Baseline start: 32775
Beep: 33282
Baseline stop: 32776
Start trial: 768
Cross: 786
End trial: 800
Feedback: 781
Left arrow: 769
Right arrow: 770
End session: 1010
Train: 33281
Experiment stop: 32770
