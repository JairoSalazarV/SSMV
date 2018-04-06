function [endmemberindex duration] = NFINDR(imagecube,p)
%The N-FINDR algorithm
%------------------Input variables------------------------
%'imagecube' - Tht data transformed components [row column band]
%'p' - The number of endmember to be generated
%
%if band > p, the program will use automatically use Singular Value
%Decomposition to calculate the volume
%-----------------Output variables------------------------
%'endmemberindex' - The location of the final end-members (x,y)
%'duration' - Number of seconds used to run this program

%Set initial conditions
endmemberindex = [];
newvolume=0;
prevolume=-1;
[row, column, band] = size(imagecube);
switch_results=1;

%Determine the use SVD to calculate the volume or not
if(band>p),
    use_svd = 1;
else
    use_svd = 0;
end

%Start to count the CPU time
tic;
%start = cputime();

%Randomly select p initial endmembers
rand('state', sum(100*clock));
for i=1:p
    while(1)
        temp1 = round(row*rand);
        temp2 = round(column*rand);
        if(temp1>0 & temp2>0)
            break;
        end
    end
    endmemberindex=[endmemberindex,[temp1;temp2]];
end

%Generate endmember vector from reduced cub
display(endmemberindex);
endmember = [];
for i=1:p
    if(use_svd)
        endmember = [endmember squeeze(imagecube(endmemberindex(1,i),endmemberindex(2,i),:))];
    else
        endmember = [endmember squeeze(imagecube(endmemberindex(1,i),endmemberindex(2,i),1:p-1))];
    end
end

%calculate the endmember's volume
if(use_svd)
    s=svd(endmember);
    endmembervolume = 1;
    for i=1:p,
        endmembervolume = endmembervolume * s(i);
    end
else
    joinmatrix=[ones(1,p) ; endmember];
    endmembervolume = abs( det(joinmatrix) ) / factorial(p-1);
end

%The main algorithm
while newvolume > prevolume, %If the new generated endmember volume is larger than the old one, continue the algorithm
    % Use each sample vector to replace the original one, and calculate the
    % new volume
    for i=1:row,
        for j=1:column,
            for k=1:p,
                calculate = endmember;
                if(use_svd),
                    calculate(:,k) = squeeze(imagecube(i,j,:));
                    s=svd(calculate);
                    volume=1;
                    for z=1:p,
                        volume = volume * s(z);
                    end
                else
                    calculate(:,k) = squeeze(imagecube(i,j,1:p-1));
                    joinmatrix=[ones(1,p);calculate];
                    volume = abs( det(joinmatrix) ) / factorial(p-1);%The formula of the simplex volume
                end
                if volume > endmembervolume,
                    endmemberindex(:,k) = [i;j];
                    endmember = calculate;
                    endmembervolume = volume;
                end
            end
        end
    end
    prevolume = newvolume;
    newvolume = endmembervolume;
end
duration = toc;

%Swithc results for standard
if(switch_results),
    endmemberindex(3,:) = endmemberindex(1,:);
    endmemberindex(1,:) = [];
    endmemberindex=endmemberindex';
end









