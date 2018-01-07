function y = PromedioMovil(Parametros)

% Parametros es una estructura con los siguientes valores
% Parametros.nombre     ----->      Nombre de la accion
% Parametros.nprom      ----->      Ventana Temporal del Promedio movil
% Parametros.n          ----->      Tiempo de Simulación
% Parametros.saldo      ----->      Monto a Invertir
% Parametros.comi       ----->      Porcentaje de Comision
% Parametros.vis        ----->      0-1-2 modo de presentar los resultados 0 - nada 1 - valores 2 - graficas 
% Parametros.porcen     ----->      Porcentaje del monto a arriesgar
% Parametros.precios    ----->      Precios históricos de la acción
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                      INICIALIZACION DE VARIABLES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   ntotal = size(Parametros.precios,2);
    nac = 0;
    saldo = Parametros.saldo;
    Promedio = zeros(Parametros.n,1);    
    nac_hist = zeros(Parametros.n,1); 
    saldo_hist = zeros(Parametros.n,1);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%
%                                 PROMEDIO MOVIL 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i=1:Parametros.n
        Promedio(i,1)=sum(Parametros.precios(:,ntotal-Parametros.n-(Parametros.nprom-1)+(i-1):ntotal-Parametros.n+(i-1)))/Parametros.nprom;
    end
    valor=Parametros.precios(1,ntotal-Parametros.n+1:ntotal)';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%
%                              VENDEDOR MOVIL 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i=1:Parametros.n
        if valor(i,1)>Promedio(i,1)
            %Comprar
            if nac==0
                nac=floor((Parametros.porcen*saldo)/((1+Parametros.comi)*valor(i,1)));
                saldo=saldo-nac*(1+Parametros.comi)*valor(i,1);
            end
        else
            %Vender
            if nac>0
                saldo=saldo+nac*(1-Parametros.comi)*valor(i,1);
                nac=0;
            end
        end
        nac_hist(i,1)=nac;
        if nac>0
            saldo_hist(i,1)=nac*valor(i,1);
        else
            saldo_hist(i,1)=saldo;
        end
    end
    
    rendimiento=((saldo_hist(:,1)-Parametros.saldo)/Parametros.saldo)*100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%
%                                PRESENTACION DE DATOS 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
     switch Parametros.vis
        case '1'
            disp([ Parametros.nombre ' - $: ' num2str(valor(Parametros.n,1)) ' Promedio: ' num2str(Promedio(Parametros.n,1)) ' Saldo: ' num2str(saldo_hist(Parametros.n,1)) ' Rendimiento%: ' num2str(rendimiento(Parametros.n,1)) ' Numero de Acciones: ' num2str(nac_hist(Parametros.n,1))]);
        case '2'
            figure;
            subplot(4,1,1),plot(1:Parametros.n,valor(:,1),'b-',1:Parametros.n,Promedio(:,1),'r-'),ylabel('Precio'),legend(num2str(valor(Parametros.n,1)),num2str(Promedio(Parametros.n,1)),'Location','NorthEastOutside'),grid;
            title([Parametros.nombre ' - Promedio = ' num2str(Parametros.nprom(:,1)) ' dias']);
            subplot(4,1,2),plot(1:Parametros.n,saldo_hist(:,1),'b-'),ylabel('Saldo'),grid,legend(num2str(saldo_hist(Parametros.n,1)),'Location','NorthEast','Location','NorthEastOutside');
            subplot(4,1,3),plot(1:Parametros.n,rendimiento(:,1),'b-'),ylabel('Rendimiento'),grid,legend(num2str(rendimiento(Parametros.n,1)),'Location','NorthEast','Location','NorthEastOutside');
            subplot(4,1,4),plot(1:Parametros.n,nac_hist(:,1),'b-'),ylabel('No Acciones'),grid,legend(num2str(nac_hist(Parametros.n,1)),'Location','NorthEast','Location','NorthEastOutside');
         otherwise
            
     end
     y =rendimiento(Parametros.n,1);
end