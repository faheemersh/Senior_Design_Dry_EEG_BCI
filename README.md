### This branch includes some of the archives and executables used in this project.
### Other important .exe and .zip files that couldn't be uploaded (can download from other places)
- BCILAB-devel (from their Github repo)
- Processing-3.3.6-windows64 (from their website)
- OpenBCI GUI (from their website)

### The guides below will direct you on how to:
1. Setup the standalone OpenBCI Hub and GUI
2. Run the standalone OpenBCI GUI
3. Run OpenBCI GUI using Processing (if the standalone is buggy)
4. Setup and run EEGLAB/BCILAB(devel)

### Setting up OpenBCI GUI with Cyton 32-bit 8 chan. (Windows 10)

## Setting up OpenBCI Hub and OpenBCI GUI
Note: steps 1-12 of this section copied/modified from this link on OpenBCI in case the link is changed/removed.

1. First unzip the windows application you downloaded from the downloads section of the OpenBCI Website.
<a href="https://drive.google.com/uc?export=view&id=19oMzQylRu5RJdJdSCaCmvs9G-VCvM3dr"><img src="https://drive.google.com/uc?export=view&id=19oMzQylRu5RJdJdSCaCmvs9G-VCvM3dr" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

2.	Please place the OpenBCIHub in your Program Files directory such that the structure looks like: “\Program Files\OpenBCIHub\OpenBCIHub.exe”
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

https://drive.google.com/open?id=12qqHQGb5CczxQJAYbtDJzFPLXaVZW1Lx

3. Enter the new OpenBCIHub folder and right click on the executable -> properties -> compatibility -> tick “Run this program as an administrator”.
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

4.	Create a short cut on your desktop by right clicking on the executable -> Send to -> Desktop
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

5.	Then double click the executable to run it for the first time. You must check both check boxes when prompted.
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

6.	We recommend you leave the Hub running, even when not using the OpenBCI_GUI, the hub’s impact on performance when not in use is minimal.
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

7.	Verify the hub is running in your windows tool tray.
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

8.	To quit the hub, click the OpenBCI icon, and then press the quit button.
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

9.	Please place the GUI in your Program Files directory such that the structure looks like: “\Program Files\OpenBCI_GUI\OpenBCI_GUI.exe”
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

10. If you already have a GUI installed, you may select to replace all the files.
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

11. Replacing the files may bring up another pop up that you need to accept for altering files within the Program Files folder.
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>

12.	Lastly, right click on the executable -> properties -> compatibility -> tick “Run this program as an administrator”. You should do the same thing for the OpenBCI Hub as well. 
<a href="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k"><img src="https://drive.google.com/uc?export=view&id=1VaGLtKgmv52oyLSYWz8DjYxAMVVyIB2k" style="max-width: 100%; height: auto" title="Click for the larger version." /></a>
