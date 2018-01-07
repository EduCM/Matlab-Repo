%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                           LIMPIAR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            DATOS 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datos = 'mexicodefault.xlsx';
data=xlsread(datos);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            MATRIZ DE ENTRENAMIENTO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=round(.8*size(data,1));
X=data(1:m,1:9)';
Y=data(1:m,10)';

Xa = [ones(1,m); X(1,:); X(2,:); X(3,:); X(4,:); X(5,:); X(6,:); X(7,:); X(8,:); X(9,:);...
    X(1,:).^2;X(2,:).^2;X(3,:).^2;X(4,:).^2;X(5,:).^2;X(6,:).^2;X(7,:).^2;X(8,:).^2; X(9,:).^2;...
    X(1,:).^3;X(2,:).^3;X(3,:).^3;X(4,:).^3;X(5,:).^3;X(6,:).^3;X(7,:).^3;X(8,:).^3; X(9,:).^3;];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            MATRIZ DE ENTRENAMIENTO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W=zeros(1,size(Xa,1));

options = optimset('GradObj', 'on', 'MaxIter', 5000);
[Wopt, Jopt] = fminunc(@(W)(FunCostRL(W, Xa, Y)), W, options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                           prueba
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Xpr=data(m+1:size(data,1),1:9)';
Ypr=data(m+1:size(data,1),10)';
n=size(Xpr,2);
Xapr = [ones(1,n); Xpr(1,:); Xpr(2,:); Xpr(3,:); Xpr(4,:); Xpr(5,:); Xpr(6,:); Xpr(7,:); Xpr(8,:); Xpr(9,:);...
    Xpr(1,:).^2;Xpr(2,:).^2;Xpr(3,:).^2;Xpr(4,:).^2;Xpr(5,:).^2;Xpr(6,:).^2;Xpr(7,:).^2;Xpr(8,:).^2; Xpr(9,:).^2;...
    Xpr(1,:).^3;Xpr(2,:).^3;Xpr(3,:).^3;Xpr(4,:).^3;Xpr(5,:).^3;Xpr(6,:).^3;Xpr(7,:).^3;Xpr(8,:).^3; Xpr(9,:).^3;];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            ESTADISTICAS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=Wopt*Xapr;
Yp=((1./(1+exp(-V)))>=0.5);
porcentaje=(1-sum(abs(Yp-Ypr))/n)*100;
temp=((Yp-Ypr)<0);
falso_negativo=(sum(temp)/n)*100;
temp=((Yp-Ypr)>0);
falso_positivo=(sum(temp)/n)*100;

TP=sum((Yp==1)&(Y==1));
TN=sum((Yp==0)&(Y==0));
FP=sum((Yp==1)&(Y==0));
FN=sum((Yp==0)&(Y==1));
TOT=FN+FP+TN+TP;
Accu=(TP+TN)/TOT;
Prec=TP/(TP+FP);
Rec=TP/(TP+FN);



disp(['Porcentaje de aciertos : ' num2str(porcentaje)]);
disp(['Falso Negativo : ' num2str(falso_negativo)]);
disp(['Falso Positivo : ' num2str(falso_positivo)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            GRAFICAS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1t=30:1:100;
x2t=30:1:100;
[x1t,x2t]=meshgrid(x1t,x2t);
[nf,nc]=size(x1t);
x1tr=reshape(x1t,nf*nc,1)';
x2tr=reshape(x2t,nf*nc,1)';

Xat=[ones(1,size(x1tr,2)); x1tr;  x2tr; x1tr.^2; x2tr.^2; x1tr.*x2tr];
Ytemp=Wopt*Xat;
Ytemp=reshape(Ytemp,nf,nc);

plot(G0(:,1),G0(:,2),'bo',G1(:,1),G1(:,2),'rx','LineWidth',2);
hold on;
contour(x1t,x2t,Ytemp,[0,0],'LineWidth',2);
hold off;