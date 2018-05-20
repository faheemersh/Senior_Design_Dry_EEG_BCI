### We will be adding in the information from the link below later. For now, please follow the instructions at the link below to setup OpenViBE. 

http://docs.openbci.com/3rd%20Party%20Software/03-OpenViBE

## Inserting markers into MATLAB via OpenViBE through LSL
For synchronous BCIs, there may be a need to stream markers in real-time to another software, along with the EEG data. A guide for doing this is shown below. 

1. Download all the files (apart from the readme) from this branch.
2. Run the OpenViBE acquisition server. Connect and then play. Run the OpenViBE designer and navigate to the directory shown below. Open mi-csp-1-acquisition-openbci-lsl.xml.
3. The original scenario was modified to include signal display boxes (raw and filtered), channel selector boxes, temporal filter (notch and bandpass) boxes, and most importantly, a LSL Export (Gipsa) box. Notice the connection from the Graz MI BCI Stimulator (at the top) to the LSL Export box. This is what allows markers to be sent over LSL. A [Github issue](https://github.com/OpenBCI/OpenBCI_GUI/issues/313) has been created so that this can be done using the OpenBCI GUI.
