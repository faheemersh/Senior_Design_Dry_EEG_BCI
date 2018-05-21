### Prior to creating the online code, we first recorded data using OpenViBE's Motor Imagery Scenarios and processed the data in MATLAB using the code in this branch. The guide below shows how we recorded and used the data.

1. [Setup OpenViBE](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Custom-OpenViBE-Scenarios) if you have not already. We used version 2.0.1.

2. Turn on the Cyton Board and plug the dongle into a USB port on your computer.

3. Run the OpenViBE acquisition server. Click on connect, then play. There should be a red LED on the dongle beside the blue LED. 

4. Download [this scenario](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/blob/Custom-OpenViBE-Scenarios/mi-csp-1-acquisition-openbci-lsl.xml) which has been customized from the provided OpenViBE scenarios and save it in the directory shown in the screenshot below. Run the OpenViBE Designer. Click on File, then open. Navigate to the path shown below, select the scenario you downloaded, and then click open. 
<a href="https://drive.google.com/uc?export=view&id=1jxQeUMzDJFaSOWnpGCQ2IJbHMufXxcET"><img src="https://drive.google.com/uc?export=view&id=1jxQeUMzDJFaSOWnpGCQ2IJbHMufXxcET" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

5. You'll notice in this scenario that when comparing this to the original file, the channel selector, two temporal filters (Notch for 60 Hz, Bandpass between 8-30 Hz), raw and filtered signal display, and LSL Export (Gipsa) boxes have been added. 

6. Click on the play icon to run the scenario. Once the scenario is finished, we can now analyze the data MATLAB. For our purposes, we do 3 more recordings like this for a total of 160 left/right trials and 160 non-moving (baseline) trials worth of data. We need to convert this data so that we can process it in MATLAB. 

7. Navigate to the path where the recordings have been saved. They should be in the following path: C:\Program Files (x86)\openvibe-2.0.1\share\openvibe\scenarios\bci-examples\motor-imagery-CSP\signals. Download and extract the archive [from our repo](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/blob/Archives-and-Executables/ov2mat-v0.1.zip) to convert the .ov files to .mat files. Move the recordings to the path containing the conversion file called convert_ov2mat.m. 

8. If you have one file, you can use convert_ov2mat.m. If you have multiple recordings, then you can use convert_ovfolder.m. 

