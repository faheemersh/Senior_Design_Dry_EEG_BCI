function varargout = CursorMovement(varargin)
% CURSORMOVEMENT MATLAB code for CursorMovement.fig
%      CURSORMOVEMENT, by itself, creates a new CURSORMOVEMENT or raises the existing
%      singleton*.
%
%      H = CURSORMOVEMENT returns the handle to a new CURSORMOVEMENT or the handle to
%      the existing singleton*.
%
%      CURSORMOVEMENT('CALLBACK',hObject,eventData,handles,...) calls the local 
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CursorMovement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CursorMovement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CursorMovement

% Last Modified by GUIDE v2.5 21-Feb-2018 09:33:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CursorMovement_OpeningFcn, ...
                   'gui_OutputFcn',  @CursorMovement_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before CursorMovement is made visible.
function CursorMovement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CursorMovement (see VARARGIN)
% data.radii if you add another rectangle, add in the position to the end
%            of the array
Data=[];%however we get data from the OpenBCI 

%set up the axes
cla(handles.axes1,'reset')
data=struct('quadrant',[],'t',0,'recta',[],'cp',[],'Save',[],'radii',[]);

data.radii=[.85,.45,.1,.1;.05,.45,.1,.1;.45,.45,.1,.1];



% Choose default command line output for CursorMovement
handles.output = hObject;
setappdata(handles.figure1,'data',data)
figure1_WindowButtonDownFcn(hObject,eventdata,handles)
% Update handles structure
guidata(hObject, handles);
end

% UIWAIT makes CursorMovement wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CursorMovement_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
D=getappdata(handles.figure1,'data');

save('Test.mat','D');
% Get default command line output from handles structure
varargout{1} = handles.output;

end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% a          this is used to add rectangles to the plots, change the value
%            of a and add to the if statement

D=getappdata(handles.figure1,'data');

D.t=D.t+1;
a=randi(3);
D.quadrant(D.t,1)=a;
D.recta(D.t,1:4)=D.radii(D.quadrant(D.t,1),:);
if D.quadrant(D.t,1)==1 %right center
    rectangle('Position',[.85,.45,.1,.1]);
    axis([0 1 0 1])
elseif D.quadrant(D.t,1)==2 %left center
    rectangle('Position',[.05,.45,.1,.1]);
    axis([0 1 0 1])
else
    rectangle('Position',[.45,.45,.1,.1]);
    axis([0 1 0 1])
end
[x,y]=ginput(1);
D.cp(D.t,1:2)=[x,y];
c=D.cp(D.t,:);
Rec=D.recta(D.t,:);

if c(1)> Rec(1) & c(1)< (Rec(1)+Rec(3)) & c(2)>Rec(2) & c(2) < (Rec(2)+Rec(4))
    D.Save(D.t,1)=1 %got the target
else
    D.Save(D.t,1)=0 %didn't hit target
end

setappdata(handles.figure1,'data',D)
cla(handles.axes1,'reset')  
pause(1)
figure1_WindowButtonDownFcn(hObject, eventdata, handles)
D.getappdata(handles.figure1,'data');

end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
D=getappdata(handles.figure1,'data');
switch eventdata.Key
    case 'space'
        save('CursorData.mat','D')
        fprintf('Cursor Movement GUI is closed, run it again to record a new trial')
        close all 
end
end
