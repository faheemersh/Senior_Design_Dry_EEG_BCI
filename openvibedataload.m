%% Training data assortment
load('train1.mat')
[C,D]=twobinary_OpenViBE_processing_fn(samples,sampleTime,stims);
Cq=C;Dq=D;clear C;clear D;
load('train2.mat')
[C,D]=twobinary_OpenViBE_processing_fn(samples,sampleTime,stims);
Cw=C;Dw=D;clear C;clear D;
load('train3.mat')
[C,D]=twobinary_OpenViBE_processing_fn(samples,sampleTime,stims);
Ce=C;De=D;clear C;clear D;
load('train4.mat')
[C,D]=twobinary_OpenViBE_processing_fn(samples,sampleTime,stims);
Cr=C;Dr=D;clear C;clear D;
C=[Cq;Cw;Ce;Cr];
 
DDl = [Dq(1:size(Dq)/2,:,:);Dw(1:size(Dq)/2,:,:);De(1:size(Dq)/2,:,:);Dr(1:size(Dq)/2,:,:)];
DDr = [Dq(size(Dq)/2+1:size(Dq),:,:);Dw(size(Dq)/2+1:size(Dq),:,:);De(size(Dq)/2+1:size(Dq),:,:);Dr(size(Dq)/2+1:size(Dq),:,:)];
D=[DDl;DDr];

%% Testing data assortment (same code as above, just using less and different data)
load('test.mat')
[C,D]=twobinary_OpenViBE_processing_fn(samples,sampleTime,stims);
Ca=C;Da=D;clear C;clear D;
C=Ca;

DDl = [Da(1:size(Da)/2,:,:)];
DDr = [Da(size(Da)/2+1:size(Da),:,:)];
D=[DDl;DDr];

%% old data
% %% Training data assortment
% load('3-8-tr1.mat')
% Cq=C;Dq=D;clear C;clear D;
% load('3-8-tr2.mat')
% Cw=C;Dw=D;clear C;clear D;
% load('3-8-tr3.mat')
% Ce=C;De=D;clear C;clear D;
% load('3-13-tr2.mat')
% Cr=C;Dr=D;clear C;clear D;
% load('3-13-tr3.mat')
% Ct=C;Dt=D;clear C;clear D;
% load('3-13-tr5.mat')
% Cy=C;Dy=D;clear C;clear D;
% load('3-13-tr6.mat')
% Cu=C;Du=D;clear C;clear D;
% load('3-13-tr7.mat')
% Ci=C;Di=D;clear C;clear D;
% C=[Cq;Cw;Ce;Cr;Ct;Cy;Cu;Ci];
% 
% DDl = [Dq(1:size(Dq)/2,:,:);Dw(1:size(Dq)/2,:,:);De(1:size(Dq)/2,:,:);Dr(1:size(Dq)/2,:,:);Dt(1:size(Dq)/2,:,:);Dy(1:size(Dq)/2,:,:);Du(1:size(Dq)/2,:,:);Di(1:size(Dq)/2,:,:);];
% DDr = [Dq(size(Dq)/2+1:size(Dq),:,:);Dw(size(Dq)/2+1:size(Dq),:,:);De(size(Dq)/2+1:size(Dq),:,:);Dr(size(Dq)/2+1:size(Dq),:,:);Dt(size(Dq)/2+1:size(Dq),:,:);Dy(size(Dq)/2+1:size(Dq),:,:);Du(size(Dq)/2+1:size(Dq),:,:);Di(size(Dq)/2+1:size(Dq),:,:);];
% D=[DDl;DDr];
% 
% %% Testing data assortment (same code as above, just using less and different data)
% load('3-8-tr4.mat')
% Ca=C;Da=D;clear C;clear D;
% load('3-13-tr4.mat')
% Cs=C;Ds=D;clear C;clear D;
% load('3-13-tr8.mat')
% Cd=C;Dd=D;clear C;clear D;
% C=[Ca;Cs;Cd];
% 
% DDl = [Da(1:size(Da)/2,:,:);Ds(1:size(Da)/2,:,:);Dd(1:size(Da)/2,:,:)];
% DDr = [Da(size(Da)/2+1:size(Da),:,:);Ds(size(Da)/2+1:size(Da),:,:);Dd(size(Da)/2+1:size(Da),:,:);];
% D=[DDl;DDr];