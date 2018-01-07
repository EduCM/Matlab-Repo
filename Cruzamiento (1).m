function xhijosbin = Cruzamiento(xpadres,palabra)
    
    [m n] = size(xpadres);
   
    if (mod(m,2) ~= 0)
        fprintf('La dimensión de xpadres debe de ser par\n')
        return;
    end
    xpadresbin = dec2bin(xpadres,palabra);    
    p = round((palabra-3)*rand()) + 2;
    
    for i=1:2:m
        xhijosbin(i,:)   = [xpadresbin(i+1,p:palabra), xpadresbin(i,1:p-1)];
        xhijosbin(i+1,:) = [xpadresbin(i,p:palabra), xpadresbin(i+1,1:p-1)];   
    end    
end