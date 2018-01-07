close all
clear all
clc


cemex=downloadValues('PINFRA.MX','04/01/2015','04/23/2016');
datos= cemex.adjClose;


[clasific,datosn,eduardo] = neuronascompetitivas(datos,20,3);
%%
varo=1000000;
bandera=0;
port=varo;
for j = 1:size(clasific,2)
    if(clasific(j)== 3 && bandera ==0)
        acciones = floor(varo/datosn(j+19));
        varo = varo-acciones*datosn(j+19);
        bandera=1;
        port = varo+acciones*datosn(j+19)-acciones*datosn(j+19)*.003;
    end
    if(clasific(j) == 2 && bandera == 1)
        port = varo+(acciones*datosn(j+19))-(acciones*datosn(j+19)*.003);
        acciones = 0;
        bandera = 0;
        varo = port;

    end
        portafolio(j)=port;
end
plot(portafolio)