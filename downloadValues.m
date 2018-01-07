%Copyright: Manuel Alonso Martinez. 
%http://www.manoloalonso.com
%http://www.finanzascuantitativas.net
%
%Funcion que descarga las cotizaciones historicas de Yahoo Finance.
%Los parametros son: codigo de subyacente de yahoo finance, fecha de inicio
%y fecha de fin. 
%
%Los datos devueltos por la funcion son: fechas, apertura, valor mas alto 
%de la sesion, valor mas bajo de la sesion, cierre, volumen y cierre
%ajustado.
%
%Ejemplo: IBEX35 desde el 1 de Enero de 2011 al 23 de Septiembre de 2011:
%
%res=downloadValues('^IBEX','01/01/2011', '09/23/2011');
function res=downloadValues(subyacente, sDate, eDate)
    
    %Tratamiento de las fechas
    startDate = datenum(sDate);
    endDate = datenum(eDate);
    startDate = datestr(startDate,23);
    monthStartDate = num2str(round(str2double(startDate(1:2))-1));
    endDate = datestr(endDate,23);
    monthEndDate = num2str(round(str2double(endDate(1:2))-1));
    
    %Construyo la URL de Yahoo Finance de la descarga del fichero CSV
    urlstr = ['http://ichart.yahoo.com/table.csv?s=',...
        subyacente,'&a=',monthStartDate,'&b=',startDate(4:5),'&c=',...
        startDate(7:end),'&d=',monthEndDate,'&e=',endDate(4:5),'&f=',...
        endDate(7:end),'&g=d&ignore=.csv'];
    data = urlread(urlstr);

    %Busco los saltos de linea para hallar el numero de filas descargadas
    crets = findstr(data,char(10));
    %Guardo el espacio para las fechas y los demas valores descargados
    dates = cell(length(crets)-1,1);
    matrixData = zeros(length(crets)-1,6);
    %Numero de caracteres que contiene la primera linea de datos
%     numCaracteres=crets(2)-crets(1);

    for i=1:length(crets)-1
        numCaracteres=crets(i+1)-crets(i);
        % Busco las comas que hay en cada una de las lineas
        comas = strfind(data(crets(i)+1:crets(i)+numCaracteres),',');
        coma1 = comas(1);
        %Guardo la fecha de cotizacion en el cell de fechas
        dates{i} = data(crets(i)+1:crets(i)+coma1-1);
        for j=1:length(comas)-1
            %Guardo en los vectores cada uno de los datos
            matrixData(i, j) = str2double(data(crets(i)+comas(j)+...
                1:crets(i)+comas(j+1)-1));
        end
        %El ultimo dato de la linea lo recojo aqui
        matrixData(i, length(comas)) = str2double(data(crets(i)+...
            comas(j+1)+1:crets(i+1)-1));
    end

    %Separo los datos en sus vectores correspondientes y le doy la vuelta
    %a los vectores para que esten en orden ascendente
    res.dates=flipud(dates);    
    res.open=flipud(matrixData(:,1));
    res.high=flipud(matrixData(:,2));
    res.low=flipud(matrixData(:,3));
    res.close=flipud(matrixData(:,4));
    res.volume=flipud(matrixData(:,5));
    res.adjClose=flipud(matrixData(:,6));
end