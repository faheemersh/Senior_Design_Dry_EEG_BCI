### Prior to creating the online code, we first recorded data using OpenViBE's Motor Imagery Scenarios and processed the data in MATLAB using the code in this branch. The guide below shows how we recorded and used the data.

1. [Setup OpenViBE](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/Custom-OpenViBE-Scenarios) if you have not already. We used version 2.0.1.

2. Turn on the Cyton Board and plug the dongle into a USB port on your computer.

3. Run the OpenViBE acquisition server. Click on connect, then play. There should be a red LED on the dongle beside the blue LED. 

4. Download [this scenario](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/blob/Custom-OpenViBE-Scenarios/mi-csp-1-acquisition-openbci-lsl.xml) which has been customized from the provided OpenViBE scenarios and save it in the directory shown in the screenshot below. Run the OpenViBE Designer. Click on File, then open. Navigate to the path shown below, select the scenario you downloaded, and then click open. 
<a href="https://drive.google.com/uc?export=view&id=1jxQeUMzDJFaSOWnpGCQ2IJbHMufXxcET"><img src="https://drive.google.com/uc?export=view&id=1jxQeUMzDJFaSOWnpGCQ2IJbHMufXxcET" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

5. You'll notice in this scenario that when comparing this to the original file, the channel selector, two temporal filters (Notch for 60 Hz, Bandpass between 8-30 Hz), raw and filtered signal display, and LSL Export (Gipsa) boxes have been added. 

6. Click on the play icon to run the scenario. Once the scenario is finished, we can now analyze the data MATLAB. For the purpose of this example, we do 3 more recordings like this for a total of 160 left/right trials and 160 non-moving (baseline) trials worth of training data. We do one more recording for testing data. We need to convert this data so that we can process it in MATLAB. 
<a href="https://drive.google.com/uc?export=view&id=1CQXZtUzqwjHAkhtFp1FAebt0XZGcnNCD"><img src="https://drive.google.com/uc?export=view&id=1CQXZtUzqwjHAkhtFp1FAebt0XZGcnNCD" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>
7. Navigate to the path where the recordings have been saved. They should be in the following path: C:\Program Files (x86)\openvibe-2.0.1\share\openvibe\scenarios\bci-examples\motor-imagery-CSP\signals. Download and extract the archive [from our repo](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/blob/Archives-and-Executables/ov2mat-v0.1.zip) to convert the .ov files to .mat files. Move the recordings to the path containing the conversion file called convert_ov2mat.m. 

8. If you have one file, you can use convert_ov2mat.m. The syntax for using this function is <i>convert_ov2mat('inputFile.ov', 'outputFile.mat')</i>. 

9. If you have multiple recordings, then you can use convert_ovfolder.m after adding the folder to your MATLAB path. Navigate to the path containing those recordings in MATLAB. For the convert_ovfolder.m script, make sure to replace the dirPattern line with <i>dirPattern = fullfile(myFolder, myPattern)</i> and to replace the loadFile line with <i>loadFile = sprintf('%s',fn);</i>. Then run the script and make sure to add the path if MATLAB prompts you. This data is provided in the latest folder in the [Data Branch](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/tree/faheemersh-data). 
<a href="https://drive.google.com/uc?export=view&id=1uVNBsLf7DRTA8vg600Fh2e5vwyC4xBr-"><img src="https://drive.google.com/uc?export=view&id=1uVNBsLf7DRTA8vg600Fh2e5vwyC4xBr-" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

10. Rename any of the .mat files as you see fit.
<a href="https://drive.google.com/uc?export=view&id=1sHQddJJTkcOm2gTM3ld2LkqnIISr1vpi"><img src="https://drive.google.com/uc?export=view&id=1sHQddJJTkcOm2gTM3ld2LkqnIISr1vpi" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a>

11. Download all the files in this branch. Notice that this is only for the Two Binary Classifiers (left/right/not moving) version. If you would like a left/right only version, please create an issue in the repo. 

12. Copy/move all of the .mat files to the same directory as the files you downloaded from the branch. Now let's check each of the .mat files to make sure that the proper variables are stored so that we don't encounter errors when running the scripts. If the variables stored in the .mat files are of the dimensions shown below, then you won't need to make any changes. Skip to step 15. Otherwise, see the next step.
<br><a href="https://drive.google.com/uc?export=view&id=1sOgO_C5nLAufjvIBthlraAPVI_yFSG1z"><img src="https://drive.google.com/uc?export=view&id=1sOgO_C5nLAufjvIBthlraAPVI_yFSG1z" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

13. If you're at this step, that means that the stims variable is probably a 249 x 3 instead of a 248 x 3: this just means an extra marker was recorded. Double click this variable. The third column contains duration info and all of the values should be zero EXCEPT for the row containing the extra marker. Find this row, select it, right click, then delete the row. Close the window.
<br><a href="https://drive.google.com/uc?export=view&id=1bDcHkN0wUvkrxApuEmlcrbtmweWV239z"><img src="https://drive.google.com/uc?export=view&id=1bDcHkN0wUvkrxApuEmlcrbtmweWV239z" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

14. Now select all of the variables in the workspace, right click, and save as. Replace the original .mat file that had the extra row of data with this new .mat file containing the updated stims variable.

15. If you're just analyzing one recording, load the file in (double click the .mat), run twobinary_OpenViBE_processing.m, and skip to step 20. If you're analyzing multiple recordings, you'll need to run twobinary_OpenViBE_processing.m for EACH of the .mat files you created. Start by running twobinary_OpenViBE_processing.m for the first .mat file. You will see a C and D variable stored in the workspace. C contains all the non-moving (baseline trials) taken from the data recorded between the onset of the arrows (so between the end of one trial and the onset of the arrow for the next trial). The first 20 trials of the D variable are left trials and the next 20 are right trials. 

16. You have two options. You can either save these C and D variables for this recording in another .mat file and keep repeating this process over and over again for the other recordings, making sure to stack the D matrices appropriately. Or you can create a script that does this for you. An example of such a script is shown below. It uses the file titled twobinary_OpenViBE_processing_fn.m (in this branch also) which is a function version of twobinary_OpenViBE_processing.m, so this function must be saved in the same directory as the script you create (in this branch too, titled openvibedataload.m). 
<br><a href="https://drive.google.com/uc?export=view&id=1t0D4nkNqUyFa71s8XAjpLIYgcYSVUTuP"><img src="https://drive.google.com/uc?export=view&id=1t0D4nkNqUyFa71s8XAjpLIYgcYSVUTuP" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

17. The script in this branch has both a section for training and testing data. Just run the section (run section NOT run) for training data now. Delete the unnecessary variables from the workspace and keep just C and D. 
<br><a href="https://drive.google.com/uc?export=view&id=1P39SRhErWfEgh7cy7EWSEqQziXdJLyVw"><img src="https://drive.google.com/uc?export=view&id=1P39SRhErWfEgh7cy7EWSEqQziXdJLyVw" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

18. Next, run the twobinary_CSP_SVM_train.m file. You will see four plots. The first two are like those shown in step 2 of the [Analysis Wiki](https://github.com/faheemersh/Senior_Design_Dry_EEG_BCI/wiki/Analysis) page. The second two are plots of 3 features and you will need to click on the Rotate 3D button in the figure to see the plot properly. You can choose which features you would like to see by changing the values for f1, f2, and f3 in the appropriate sections, and then running just the section for the plot.

19. The following variables provide important information about the training set. Note that the classifier architecture here is different from that in the online prediction part of the online code and this is shown below. The cross-validation code created here has been developed by our group, just like most of the code in this repository. For the case of 8-fold cross-validation on 40 trials (example), in short, this code segments the data into sets of 5, chooses 7 of those sets for training and 1 for testing in one pass of the loop. In the following passes, it picks a different 7 segments (doesn't repeat) for training and a different 1 segment for testing. In this way, each pass of the for loop results in a model that is created and has its own accuracy. The average accuracies of these models are calculated once the loop is finished. 
* acctrainpred: this is the actual accuracy of the first classifier (movement/no movement)
* acc1EE: this is the actual accuracy of the second classifier (left/right)
* classLoss: this is the loss for the first classifier
* classLosslr: this is the loss for the second classifier
* avetrainAcc: this is the 10-fold cross-validation training accuracy for the first classifier
* avetestAcc: this is the 10-fold cross-validation testing accuracy for the first classifier
* avetrainAcclr: this is the 10-fold cross-validation training accuracy for the second classifier
* avetestAcclr: this is the 10-fold cross-validation testing accuracy for the second classifier
<br><a href="https://drive.google.com/uc?export=view&id=1p6yBwzJIVCg1tHHeqoCOUR_QrEI_mz3Y"><img src="https://drive.google.com/uc?export=view&id=1p6yBwzJIVCg1tHHeqoCOUR_QrEI_mz3Y" style="width: 500px; max-width: 100%; height: auto" title="Click for the larger version." /></a></br>

20. Now you will need to save some variables from this training session to use for the testing data and corresponding script. Using the Ctrl key, select the following variables:
* ProjectionCSPlr
* ProjectionCSPnm
* SVMModellr
* SVMModelnm
* X_sv
* XEE_sv
