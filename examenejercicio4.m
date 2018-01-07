close all
clear all
clc
 
%%%%%%%%%%%%%%%
%iniciar
%%%%%%%%%%%%
pobladores=40;
xmin=1;%%%
xmax=80;%%% espacio busqueda(intervalo)
palabra=10;%%% número de bits 
gen=50000;
ypadres=zeros(pobladores,1); 
xpadres1=round((2^palabra-1)*rand(pobladores,1)); %obtener los primeros padres
xpadres2=round((2^palabra-1)*rand(pobladores,1));
xpadres3=round((2^palabra-1)*rand(pobladores,1));
xpadres4=round((2^palabra-1)*rand(pobladores,1));
xpadres5=round((2^palabra-1)*rand(pobladores,1));

%%%%%%%%%%%
%empieza el algoritmo
%%%%%%%%%%%
 
for k=1:gen
    
 xpadresaux1 =(((xmax-xmin)/(2^palabra-1))*xpadres1 + xmin); 
 xpadresaux2 =(((xmax-xmin)/(2^palabra-1))*xpadres2 + xmin);
 xpadresaux3 =(((xmax-xmin)/(2^palabra-1))*xpadres3 + xmin);
 xpadresaux4 =(((xmax-xmin)/(2^palabra-1))*xpadres4 + xmin);
 xpadresaux5 =(((xmax-xmin)/(2^palabra-1))*xpadres5 + xmin);
   
     
 ypadres=170*xpadresaux1+160*xpadresaux2+175*xpadresaux3+180*xpadresaux4...
 +195*xpadresaux5+1000*max((48-xpadresaux1),0)+1000*max((79-xpadresaux1-xpadresaux2),0)...
 +1000*max((87-xpadresaux1-xpadresaux2-xpadresaux3),0)+1000*max((64-xpadresaux2-xpadresaux3),0)...
 +1000*max((82-xpadresaux3-xpadresaux4),0)+1000*max((43-xpadresaux4),0)+1000*max((52-xpadresaux4-xpadresaux5),0)...
 +1000*max((15-xpadresaux5),0);
%función a evaluar    

  
 %%%%%%%%%%%%%%
 %ordenar padres
 %%%%%%%%%%%%%%
 
 xp_ordered1=sortrows([ypadres,xpadres1],1);
 xp_ordered2=sortrows([ypadres,xpadres2],1);
 xp_ordered3=sortrows([ypadres,xpadres3],1);
 xp_ordered4=sortrows([ypadres,xpadres4],1);
 xp_ordered5=sortrows([ypadres,xpadres5],1);

 
 xpadres1=xp_ordered1(1:pobladores/2,2);
 xpadres2=xp_ordered2(1:pobladores/2,2);
 xpadres3=xp_ordered3(1:pobladores/2,2);
 xpadres4=xp_ordered4(1:pobladores/2,2);
 xpadres5=xp_ordered5(1:pobladores/2,2);

 
 
 %%%%%%%%%
 %cruzamiento
 %%%%%%%%%
 
 xhijosbin1=cruzamiento(xpadres1,palabra);
 xhijosbin2=cruzamiento(xpadres2,palabra);
 xhijosbin3=cruzamiento(xpadres3,palabra);
 xhijosbin4=cruzamiento(xpadres4,palabra);
 xhijosbin5=cruzamiento(xpadres5,palabra);
 
 %%%%%%%%
 %mutacion
 %%%%%%%%
 
 xhijosbin1=Mutacion(xhijosbin1);
 xhijosbin2=Mutacion(xhijosbin2);
 xhijosbin3=Mutacion(xhijosbin3);
 xhijosbin4=Mutacion(xhijosbin4);
 xhijosbin5=Mutacion(xhijosbin5);
 
  %%%%%%%%%%
 %generar los nuevos padres
 %%%%%%%%%%
 
 xhijos1=bin2dec(xhijosbin1);
 xhijos2=bin2dec(xhijosbin2);
 xhijos3=bin2dec(xhijosbin3);
 xhijos4=bin2dec(xhijosbin4);
 xhijos5=bin2dec(xhijosbin5);

 
 xpadres1=([xpadres1;xhijos1]);
 xpadres2=([xpadres2;xhijos2]);
 xpadres3=([xpadres3;xhijos3]);
 xpadres4=([xpadres4;xhijos4]);
 xpadres5=([xpadres5;xhijos5]);

end 
xpadresaux =round([((xmax-xmin)/(2^palabra-1))*xpadres1 + xmin,((xmax-xmin)/(2^palabra-1))*xpadres2 + xmin,...
             ((xmax-xmin)/(2^palabra-1))*xpadres3 + xmin,((xmax-xmin)/(2^palabra-1))*xpadres4 + xmin,...
             ((xmax-xmin)/(2^palabra-1))*xpadres5 + xmin]);

fprintf('El minimo para X1 es %.4f\n',xpadresaux(1,1))
fprintf('El minimo para X2 es %.4f\n',xpadresaux(1,2))
fprintf('El minimo para X3 es %.4f\n',xpadresaux(1,3))
fprintf('El minimo para X4 es %.4f\n',xpadresaux(1,4))
fprintf('El minimo para X5 es %.4f\n',xpadresaux(1,5))

salarios=[170,160,175,180,195];
costototal=sum(salarios.*xpadresaux(1,:));