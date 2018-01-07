function[clasificacion,datosn,w] = neuronascompetitivas(datos,lv,neurons)

numd=size(datos,1);
prueba=round(numd*.9);
datosh=datos(1:prueba,1);
datosn=datos(prueba+1-(lv-1):numd,1);

nd=size(datosh,1);

nv=nd-lv+1;

Md=zeros(lv,nv);
x=zeros(lv,nv);

for i=1:nv
   Md(:,i)=datosh(i:i+lv-1,1); 
   x(:,i)=(Md(:,i)-mean(Md(:,i)))/std(Md(:,i));
end

epoch = 150;
eta = 1;
n=nv;
w = zeros(neurons,lv);
h = zeros(neurons,1);
point=zeros(1,n);

    for k = 1:epoch
        s=zeros(1,neurons);
        ns=zeros(1,neurons);
        for j =1:n
            x = x(:,randperm(n));
            for i = 1:neurons
                h(i,1)= w(i,:)*x(:,j) - 1/2*(w(i,:) * w(i,:)');
            end
            [Y,I] = max(h(:,1));
            w(I,:) = w(I,:) + eta * (x(:,j)'-w(I,:));
            point(1,j)=I;
            s(1,I)=s(1,I)+sqrt(x(:,j)'*x(:,j)-2*w(I,:)*x(:,j)+w(I,:)*w(I,:)');
            ns(1,I)=ns(1,I)+1;
        end
        eta = eta*(1-k/epoch);   
        p=s./ns;
        pp=mean(p);
    end
  

for i=1:n
   figure(point(1,i));
   plot(x(:,i),'b');
   hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pronósticos
%%%%%%
nd2=size(datosn,1);
nv2=nd2-lv+1;
Md2=zeros(lv,nv2);
x2=zeros(lv,nv2);

for i=1:nv2
   Md2(:,i)=datosh(i:i+lv-1,1); 
   x2(:,i)=(Md2(:,i)-mean(Md2(:,i)))/std(Md2(:,i));
end
h = zeros(neurons,1);
clasificacion=zeros(1,nv2);


for j = 1:nv2
          
        x2 = x2(:,randperm(nv2));
        for i = 1:neurons
            h(i,1)= w(i,:)*x2(:,j) - 1/2*(w(i,:) * w(i,:)');    
        end    
        [Y,I] = max(h(:,1));
        clasificacion(1,j)=I;
   
end
end

%error=[5.1257,3.5256,3.2738,3.1445,2.9527,2.9259,2.9206];
%codo=plot(error)