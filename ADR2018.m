%===========================================
% OBTAIN DATA
%===========================================
%nombre    = 'testBase';

eigvalue  = sort(eigvalue, 'descend');
eigvalue  = eigvalue/sum(eigvalue);
numEigen  = max(size(eigvalue));

x         = [ones(numEigen,1) (1:numEigen)'];
bls       = regress(eigvalue,x);

%plot((1:numEigen), eigvalue,'.b');
%hold on;
%plot(x,bls(1)+bls(2)*x,'+r','LineWidth',2);

lstErrores = [];

lstM = ones(1,numEigen);

siguienteSale = false;

if numEigen < 5
    i = numEigen;
    h=figure;
    plot((1:numEigen), eigvalue,'og--','LineWidth',2);
else
    for i=3:numEigen-2
        %close all;
        %Divide en dos subconjuntos
        ini1        = 1;
        end1        = i;

        ini2        = i;
        end2        = numEigen;


        eigvalue1 = eigvalue(ini1:end1);
        eigvalue2 = eigvalue(ini2:end2);
        x1   = x(ini1:end1,:);
        x2   = x(ini2:end2,:);


        h=figure;
        plot((1:numEigen), eigvalue,'.k','LineWidth',4);
        hold on;
        %axis([0,max(size(eigvalue)),0,max(eigvalue)]);

        bls  = regress(eigvalue,x);
        y = bls(1)+bls(2)*x(:,2);
        %plot(x(:,2),y,'+r','LineWidth',2);

        bls1 = regress(eigvalue1,x1);
        bls2 = regress(eigvalue2,x2);

        tmpx1 = x1(:,2);
        tmpy1 = bls1(1)+bls1(2)*x1(:,2);
        plot(tmpx1,tmpy1,'g','LineWidth',2);
        tmpx2 = x2(:,2);
        tmpy2 = bls2(1)+bls2(2)*x2(:,2);

        tmpM2 = tmpy2(1)-tmpy2(2);
        lstM(i) = tmpM2;


        plot(tmpx2,tmpy2,'--r','LineWidth',2);

        %Guess
        yGuess1 = bls1(1)+bls1(2)*i;
        yGuess2 = bls2(1)+bls2(2)*i;
        plot(i,yGuess1,'*g');
        plot(i,yGuess2,'*r');


        tmpError1 = abs( eigvalue(i) - yGuess1 );
        tmpError2 = abs( eigvalue(i) - yGuess2 );
        lstErrores = [lstErrores [sum(tmpError1);sum(tmpError2)]];




        %axis([-10,max(size(eigvalue))+10,0,1]);
        %set(gca,'YTickLabel',[]);
        %set(gca,'XTickLabel',[]);

        %robustdemo(tmpx1,eigvalue1);
        %robustdemo(tmpx2,eigvalue2);

        if siguienteSale            
            break;
        end
        if(abs(lstErrores(1,i-2)) > abs(lstErrores(2,i-2)))
            siguienteSale = true;
        end


        hold off;
        close all;


    end
    
    hold off;
    close all;
    i
    plot((1:numEigen), eigvalue,'.k','LineWidth',1);
    hold on;
    %plot(i, eigvalue(i),'og','LineWidth',2);
    set(gca,'box','off');
    axis tight;
    plot(tmpx1,tmpy1,'g','LineWidth',2);
    plot(tmpx2,tmpy2,'--r','LineWidth',2);
    plot(i,yGuess1,'*g');
    plot(i,yGuess2,'*r');
    
    axis([-10,224,0,(max(eigvalue)*1.2)]);
    
    xlabel("Dimension");
    ylabel("Eigenvalue");
    %set(gca,'YTickLabel',[]);
    %set(gca,'XTickLabel',[]);

    
end



imgPath = [tmpPath imgSelected "/__Originals/HypImgSub.hyp"];
print(h,nombre,'-dpng');



%plot(lstErrores(1,:),'b');
%hold on;
%plot(lstErrores(2,:),'k');

%plot(lstErrores(2,:),'r');
%[a b] = min(lstErrores(2,:))




%[B,STATS] = robustfit([1:numEigen],eigvalue);
%STATS.s
%robustdemo([1:numEigen],eigvalue);










