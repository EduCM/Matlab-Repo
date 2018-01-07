function xhijosbin = Mutacion(xhijosbin)

    [m n] = size(xhijosbin);
    bitx = round((n-1)*rand()) + 1;
    bity = round((m-1)*rand()) + 1;
    if(xhijosbin(bity,bitx) == '1')
        xhijosbin(bity,bitx) = '0';
    else
        xhijosbin(bity,bitx) = '1';
    end
end