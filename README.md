### Prior to creating the online code, we first recorded data using OpenViBE's Motor Imagery Scenarios and processed the data in MATLAB using the code in this branch. The guide below shows how we recorded and used the data.

Convert 
https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/blob/Archives-and-Executables/ov2mat-v0.1.zip

1. Setup OpenViBE if you have not already. Follow [this link](http://openvibe.inria.fr/drivers-openbci/) from OpenViBE's website or [this link](http://docs.openbci.com/3rd%20Party%20Software/03-OpenViBE) from OpenBCI's website. Their instructions have also been copied to the README of the [Custom-OpenViBE-Scenarios branch](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Custom-OpenViBE-Scenarios) should the links be removed/changed. We used version 2.0.1.

2. Turn on the Cyton Board and plug the dongle into a USB port on your computer.
<a href="https://drive.google.com/uc?export=view&id=1j67-qf7PX4X78ROHtoZyYRjv-Qr06ktU"><img src="https://drive.google.com/uc?export=view&id=1j67-qf7PX4X78ROHtoZyYRjv-Qr06ktU" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

3. Run the OpenViBE acquisition program. Click on connect, then play. There should be a red LED on the dongle beside the blue LED. <a href="https://drive.google.com/uc?export=view&id=1W15tFUlFO_pn1stFJ6xP6fyY_T0ZAkSM"><img src="https://drive.google.com/uc?export=view&id=1W15tFUlFO_pn1stFJ6xP6fyY_T0ZAkSM" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

4. Download [this scenario](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/blob/Custom-OpenViBE-Scenarios/mi-csp-0-signal-monitoring-openbci.xml) which has been customized from the provided OpenViBE scenarios and save it in the directory shown in the screenshot below. Run the OpenViBE Designer. Click on File, then open. Navigate to the path shown below, select the scenario you downloaded, and then click open. 
<a href="https://drive.google.com/uc?export=view&id=1sVQe7BljVZlJva6f-jdW7eKV90dHGkOk"><img src="https://drive.google.com/uc?export=view&id=1sVQe7BljVZlJva6f-jdW7eKV90dHGkOk" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

5. This is what the customized scenario looks like. You'll notice that when comparing this to the original file, the channel selector, two temporal filters (Notch for 60 Hz, Bandpass between 8-30 Hz), and LSL Export (Gipsa) boxes have been added. 
<a href="https://drive.google.com/uc?export=view&id=1Zg7cNKB49mJbMSldHkS_g01OVfMIgJ9c"><img src="https://drive.google.com/uc?export=view&id=1Zg7cNKB49mJbMSldHkS_g01OVfMIgJ9c" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

6. Click on the play icon to run the scenario. Wait until the raw and filtered signals show up. Only five electrodes over Fc1, Fc2, C3, C4, and Cz (channels 3-7 for us) are used for the purpose of our project. Once the raw signals can be observed and appear to be stable, move on to the next step.
<a href="https://drive.google.com/uc?export=view&id=1bMHwVHArgAuFCJQ9NLxQiuZYAwmdUemy"><img src="https://drive.google.com/uc?export=view&id=1bMHwVHArgAuFCJQ9NLxQiuZYAwmdUemy" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>
