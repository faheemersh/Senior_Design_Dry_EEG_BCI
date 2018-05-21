### The guides below show how to:
* Setup OpenViBE (can be found [here](http://docs.openbci.com/3rd%20Party%20Software/03-OpenViBE) too)
* Insert markers into MATLAB via OpenViBE stimulations in real-time

## Setting up OpenViBE

1. Download and install OpenViBE from [our repo](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/blob/Archives-and-Executables/openvibe-2.0.1-setup.exe) or from [their website](http://openvibe.inria.fr/downloads/). Also download and save all the files in this branch to the directory C:\Program Files (x86)\openvibe-2.0.1\share\openvibe\scenarios\bci-examples\motor-imagery-CSP.
2. Next, run the OpenViBE acquisition server by searching from the start menu or going to the following path:
<br><a href="https://drive.google.com/uc?export=view&id=1F0YgI6PG8Lp0fkjZ8b9de_3S_aGVwkBH"><img src="https://drive.google.com/uc?export=view&id=1F0YgI6PG8Lp0fkjZ8b9de_3S_aGVwkBH" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
3. Select OpenBCI as the driver. Then go to driver properties and select the COM port that your dongle is connected to. 
<br><a href="https://drive.google.com/uc?export=view&id=1uhkwgPOBJQpwVAMbM7dusAIjNKvKco-1"><img src="https://drive.google.com/uc?export=view&id=1uhkwgPOBJQpwVAMbM7dusAIjNKvKco-1" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
4. Click connect and then play. Now open OpenViBE designer. Navigate to the path shown below. You will notice that there are a number of built-in applications in OpenViBE. We used motor-imagery-CSP and modified the scenarios to our needs. 
<br><a href="https://drive.google.com/uc?export=view&id=1-CCEDmBnPTGofHQc1sF5tILO9-qjvrNd"><img src="https://drive.google.com/uc?export=view&id=1-CCEDmBnPTGofHQc1sF5tILO9-qjvrNd" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
5. Open the two scenarios shown below. Run mi-csp-0-signal-monitoring-openbci.xml first. This is the scenario we used for our online prediction. Ensure that you can see blinks and jaw clenching before you move on to mi-csp-1-acquisition-openbci-lsl.xml. 
<br><a href="https://drive.google.com/uc?export=view&id=1XHoc8_RXoeZNh_b6utPoRoXWt4R8TwYs"><img src="https://drive.google.com/uc?export=view&id=1XHoc8_RXoeZNh_b6utPoRoXWt4R8TwYs" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
6. Stop the scenario. Then run mi-csp-1-acquisition-openbci-lsl.xml. This is what we used to record trials in OpenViBE and perform batch analysis of multiple recordings, using the code found in the [Two Binary Classifiers Branch](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Two-Binary-SVM-Classifiers-(offline-use-only)). Close and open your left/right hand when the arrow is shown if you want to record motor execution data or just imagine doing this if you want to record motor imagery data. The recorded files are saved in the path shown by double clicking the Generic stream writer.
<br><a href="https://drive.google.com/uc?export=view&id=1_XA4OgREhDM87wGsyO5A8dMvTRryn0UL"><img src="https://drive.google.com/uc?export=view&id=1_XA4OgREhDM87wGsyO5A8dMvTRryn0UL" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
7. You can explore the other scenarios in a similar manner. Each one has a different function and the notes in the scenarios provide more information about this.

## Inserting markers into MATLAB via OpenViBE through LSL
For synchronous BCIs, there may be a need to stream markers in real-time to another software, along with the EEG data. A guide for doing this is shown below. 

1. Download all the files (apart from the readme) from this branch if you have not already.
2. Run the OpenViBE acquisition server. Connect and then play. Run the OpenViBE designer and navigate to the directory shown below. Open mi-csp-1-acquisition-openbci-lsl.xml.
3. The original scenario was modified to include signal display boxes (raw and filtered), channel selector boxes, temporal filter (notch and bandpass) boxes, and most importantly, a LSL Export (Gipsa) box. Notice the connection from the Graz MI BCI Stimulator (at the top) to the LSL Export box. This is what allows markers to be sent over LSL. A [Github issue](https://github.com/OpenBCI/OpenBCI_GUI/issues/313) has been created so that this can be done using the OpenBCI GUI.
<br><a href="https://drive.google.com/uc?export=view&id=19wwsXxB4otgxr7jUzTy4wrr9ajqMotdL"><img src="https://drive.google.com/uc?export=view&id=19wwsXxB4otgxr7jUzTy4wrr9ajqMotdL" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
4. Open ReceiveData.m in MATLAB from the liblsl-Matlab/Examples directory from the labstreaminglayer-master folder. Make sure to add the path for LSL (i.e. <i>addpath(genpath('C:\Users\fahee\Downloads\Capstone downloads\labstreaminglayer-master\labstreaminglayer-master\LSL\liblsl-Matlab'))</i>) in the command window. If you have not setup LSL and reduced the latency for data acquisition, please see [this branch](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Streaming-via-LSL) and steps 1-6 of [this guide from this  branch](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Archives-and-Executables#run-the-standalone-openbci-gui).

5. Go back to OpenViBE and play the scenario. Go to MATLAB and run ReceiveData.m. You should now see a stream of data coming into MATLAB. After 30 seconds, the Graz stimulations will begin, and you will see the marker IDs show up in the next to last column (right-most) in the MATLAB command window. Marker ID 800 can be seen in the screenshot on the right.
<br><a href="https://drive.google.com/uc?export=view&id=1SKhJZcaF8Et1y5lssR5Zs7-IT5I6W5Vn"><img src="https://drive.google.com/uc?export=view&id=1SKhJZcaF8Et1y5lssR5Zs7-IT5I6W5Vn" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>
6. The key for the marker IDs and their corresponding events are shown below. These were found by exploring the scenario .xml and related files with Notepad++.
* Experiment start: 32768
* Baseline start: 32775
* Beep: 33282
* Baseline stop: 32776
* Start trial: 768
* Cross: 786
* End trial: 800
* Feedback: 781
* Left arrow: 769
* Right arrow: 770
* End session: 1010
* Train: 33281
* Experiment stop: 32770
