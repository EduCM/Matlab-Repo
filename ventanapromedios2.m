close all
clear all
clc

[dinero,datos] = markowitz();
rendiactivo=zeros(10,1);
porceactivo=zeros(10,1);
ventactivo=zeros(10,1);
for v = 1:10

Parametros.nombre='Prueba';

Parametros.n=100;            % Tiempo de Simulación                      
Parametros.saldo=dinero(v);  % Monto a Invertir
Parametros.comi=0.0025;      % Porcentaje de Comision
Parametros.vis='0';          % 0-1-2
          
Parametros.precios=datos(:,v)';    % Precios históricos de la acción

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                               INICIALIZAR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pobladores = 80;
palabra = [6; 20];
Gen = 50;
Nvariables = 2;

xpadres = zeros(pobladores,Nvariables);
aux = zeros(pobladores,Nvariables);
xpadrespost = zeros(pobladores/2,Nvariables);
ypadres = zeros(pobladores,1);

xpadres(:,1) = round((2^palabra(1,1) - 1)*rand(pobladores,1)); % obtener los primeros pobladores para la ventana temporal
xpadres(:,2) = round((2^palabra(2,1) - 1)*rand(pobladores,1)); % obtener los primeros pobladores para el porcentaje
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            EMPIEZA EL ALGORITMO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:Gen
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %           EVALUAR LA FUNCIÓN           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    xpadresaux = (1/(2^palabra(2,1)-1))*xpadres(:,2); % Porcentaje del monto a arriesgar
    for i = 1:pobladores
        Parametros.nprom = xpadres(i,1);
        Parametros.porcen = xpadresaux(i,1);
        
        ypadres(i,1) = PromedioMovil(Parametros);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %           ORDENAR LOS PADRES           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:Nvariables
        xp_ordered = sortrows([ypadres, xpadres(:,i)],1);
        xpadrespost(:,i) = xp_ordered((pobladores/2+1):pobladores,2);
    end


    for i = 1:Nvariables
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %               CRUZAMIENTO              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        xhijosbin = Cruzamiento(xpadrespost(:,i),palabra(i,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                MUTACION                %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        xhijosbin = Mutacion(xhijosbin);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %      GENERAR LOS NUEVOS POBLADORES     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        xhijos = bin2dec(xhijosbin);
        xpadres(:,i) = [xhijos;xpadrespost(:,i)];
    end    
end
[Value,Index] = max(ypadres);
fprintf('Rendimiento Máximo:%.2f %% Ventana Temporal:%.0f días Porcentaje:%.2f %% \n', Value, xpadres(Index,1),(1/(2^palabra(2,1)-1))*xpadres(Index,2));
rendiactivo(v)  = Value;
porceactivo(v) = (1/(2^palabra(2,1)-1))*xpadres(Index,2);
ventactivo(v) = xpadres(Index,1);
end


for i = 1:10
    if ventactivo(i)==0
        porceactivo(i)=0;
    end
end
dineroinvertido=dinero*porceactivo;
dinerosobrante=dinero-dineroinvertido;
rendporta=dinero*rendiactivo;