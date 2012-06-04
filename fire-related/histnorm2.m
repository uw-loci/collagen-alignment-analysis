 % normalize the Hist by its max frequency

function [Nx,NNx,Nind] = histnor2(x,edges,nm,ploton)

% if nargs <3
%     nm = 1;  
% end
% 
% if nargs <4
%     ploton = 0;
% end

if nm == 1 %  normalized by max frequency 
    
    [Nx,Nind] = histc(x,edges);
    NNx = Nx/max(Nx);
    

if ploton 
    set(gcf,'position',[50 200 350 350])
    bar(edges,NNx,'histc');
    axis square
    xlim([edges(1) edges(end)]);
    title('Normalized hist by max frequency','fontsize',12)
    xlabel('Angle(degree)','fontsize',12)
    ylabel('Normalized Frequency','fontsize',12)
end

else  %  normalized by area = 100(a.u.)

    [Nx,Nind] = histc(x,edges);
    % [xo,no] = hist (varargin{:});
    % binwidths = diff ([min(varargin{1}) no(1:end-1)+diff(no)/2 max(varargin{1})]);
    binwidth = edges(2)-edges(1);
    NNx = 100*(Nx)/sum (Nx*binwidth); % Normalized hist has an area of 100 (a.u.) 
 if ploton 
    set(gcf,'position',[50 200 350 350])
    bar(edges,NNx,'histc');
    axis square
    xlim([edges(1) edges(end)]);
    title('Normalized hist by frequency area','fontsize',12)
    xlabel('Angle(degree)','fontsize',12)
    ylabel('Normalized Frequency','fontsize',12)
    
end
   
end

    

