function [dinero,Precios]=markowitz()

            %Inicializar las variables del algoritmo
np=100;     %n?mero de particulas
nv=10;      %numero de variables

alfas=1000;
c1=0.001;%determinan la velocidad van entre 0-1
c2=0.001;%menor a 1 de preferencia.
niteraciones = 1000;

fpg=1000000;
fpl=ones(np,1)*1000000;
Vx=zeros(np,nv);
x=rand(np,nv);
xl=zeros(np,nv);
xg= zeros(1,nv);


%%%%%%EMPRESAS%%%%%%%

gruma=downloadValues('GRUMAB.MX','04/03/2015','04/03/2016');
oma=downloadValues('OMAB.MX','04/03/2015','04/03/2016');
pinfra=downloadValues('PINFRA.MX','04/03/2015','04/03/2016');
gapb=downloadValues('GAPB.MX','04/03/2015','04/03/2016');
mega=downloadValues('megacpo.MX','04/03/2015','04/03/2016');
volaris=downloadValues('VOLARA.MX','04/03/2015','04/03/2016');
gfnorte=downloadValues('GFNORTEO.MX','04/03/2015','04/03/2016');
walmex=downloadValues('WALMEX.MX','04/03/2015','04/03/2016');
bimbo=downloadValues('BIMBOA.MX','04/03/2015','04/03/2016');
ohlmex=downloadValues('OHLMEX.MX','04/03/2015','04/03/2016');

Precios=[gruma.adjClose oma.adjClose pinfra.adjClose gapb.adjClose mega.adjClose volaris.adjClose gfnorte.adjClose walmex.adjClose bimbo.adjClose ohlmex.adjClose];

for m=1:niteraciones
    [Rend, Risk]=fun_portafolio_prof(Precios,[x(:,1) x(:,2) x(:,3) x(:,4) x(:,5) x(:,6) x(:,7) x(:,8) x(:,9) x(:,10)]);
   yp = -(300*Rend)+(300*Risk)+alfas*abs((x(:,1)+x(:,2)+x(:,3)+x(:,4)+x(:,5)+x(:,6)+x(:,7)+x(:,8)+x(:,9)+x(:,10))-1)+alfas*max(-(x(:,1)),0)...
   +alfas*max(-(x(:,2)),0)+alfas*max((x(:,1))-1,0)+alfas*max((x(:,2))-1,0)+alfas*max((x(:,3))-1,0)+alfas*max((x(:,4))-1,0)+alfas*max((x(:,5))-1,0)...
   +alfas*max((x(:,6))-1,0)+alfas*max((x(:,7))-1,0)+alfas*max((x(:,8))-1,0)+alfas*max((x(:,9))-1,0)+alfas*max((x(:,10))-1,0)+alfas*max(-(x(:,3)),0)...
   +alfas*max(-(x(:,4)),0)+alfas*max(-(x(:,5)),0)+alfas*max(-(x(:,6)),0)+alfas*max(-(x(:,7)),0)+alfas*max(-(x(:,8)),0)+alfas*max(-(x(:,9)),0)...
   +alfas*max(-(x(:,10)),0);   %evaluaci?n de la funci?n a minimizar
    
    %seleccionar al mejor global
    [val, index]=min(yp);
    if val < fpg %Este condicional permite establecer el mínimo local hasta encontrar el mínimo global
        xg = x(index,:);%se establece el x que al evaluarlo te da el mínimo de y
        fpg=val;
    end    
    
    %seleccionar a los mejores locales
     for k=1:np
        if yp(k,1)<fpl(k,1)
           xl(k,:)= x(k,:);
           fpl(k,1) =  yp(k,1);
        end
    end
         
    %ecuaciones de movimiento
    
      
    
    for k=1:nv
     Vx(:,k)= Vx(:,k) + c1*rand(np,1).*(xg(1,k)*ones(np,1)-x(:,k))+ c2*rand(np,1).*(xl(:,k)-x(:,k)); %Vx es un factor de inercia
     x(:,k)=x(:,k)+Vx(:,k);
    end  
   dinero=1000000*xg;
end






