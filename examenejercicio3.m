close all
clear all
clc
 
%%%%%%%%%%%%%%%
%iniciar
%%%%%%%%%%%%
pobladores=40;
xmin=-1;%%%
xmax=2;%%% espacio busqueda(intervalo)
palabra=14;%%% número de bits 
gen=10000;
ypadres=zeros(pobladores,1); 
xpadres1=round((2^palabra-1)*rand(pobladores,1)); %obtener los primeros padres
xpadres2=round((2^palabra-1)*rand(pobladores,1));


%%%%%%%%%%%
%empieza el algoritmo
%%%%%%%%%%%
 
for k=1:gen
    
 xpadresaux1 =(((xmax-xmin)/(2^palabra-1))*xpadres1 + xmin); 
 xpadresaux2 =(((xmax-xmin)/(2^palabra-1))*xpadres2 + xmin);
  for v=1:pobladores
      if xpadresaux1(v)+xpadresaux2(v)>=1
          
   %funcion a evaluar        
          ypadres(v,1)=xpadresaux1(v)^2+xpadresaux2(v)^2;
      else
          
          ypadres(v,1)=-10*(xpadresaux1(v)+xpadresaux2(v))+20;
      end
  end
 %%%%%%%%%%%%%%
 %ordenar padres
 %%%%%%%%%%%%%%
 
 xp_ordered1=sortrows([ypadres,xpadres1],1);
 xp_ordered2=sortrows([ypadres,xpadres2],1);


 
 xpadres1=xp_ordered1(1:pobladores/2,2);
 xpadres2=xp_ordered2(1:pobladores/2,2);


 
 
 %%%%%%%%%
 %cruzamiento
 %%%%%%%%%
 
 xhijosbin1=cruzamiento(xpadres1,palabra);
 xhijosbin2=cruzamiento(xpadres2,palabra);

 %%%%%%%%
 %mutacion
 %%%%%%%%
 
 xhijosbin1=Mutacion(xhijosbin1);
 xhijosbin2=Mutacion(xhijosbin2);

 
  %%%%%%%%%%
 %generar los nuevos padres
 %%%%%%%%%%
 
 xhijos1=bin2dec(xhijosbin1);
 xhijos2=bin2dec(xhijosbin2);


 
 xpadres1=([xhijos1;xpadres1]);
 xpadres2=([xhijos2;xpadres2]);


end 
xpadresaux =[((xmax-xmin)/(2^palabra-1))*xpadres1 + xmin,((xmax-xmin)/(2^palabra-1))*xpadres2 + xmin];

fprintf('El minimo para X1 es %.4f\n',xpadresaux(pobladores/2+1,1))
fprintf('El minimo para X2 es %.4f\n',xpadresaux(pobladores/2+1,2))


