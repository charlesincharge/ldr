%%%%%%%%%%%%%%%%%%%%%%%%
% John P Cunningham
% 
% 2014
%
% plot for COSYNE 2014 talk
%%%%%%%%%%%%%%%%%%%%%%%%


function [f] = plot_data_3d( X , W , data_colors , data_sizes , parms )

%%%%%%%%%%%%%%%%%
% input checking
%%%%%%%%%%%%%%%%%
if nargin < 5 || isempty(parms)
    parms.save_fig = 0;
    parms.write_vid = 0;
end
if nargin < 4 || isempty(data_sizes)
    % one size for each data point
    data_sizes = 8*ones(1,size(X,2));
end
if nargin < 3 || isempty(data_colors)
    % make a simple full blue data point for each data
    data_colors = repmat([0 0 1]' , 1 , size(X,2) );
end
% orient W basis positively
for i = 1 : size(W,2)
    if sum(W(:,i)>0) < sum(W(:,i)<0)
        W(:,i) = -W(:,i);
    end
end
% some data normalization to make it fit better in the plot (scale and
% position only, no linear transformations)
% ensure data centering, since the axes will be plotted wrt 0
X = X - repmat(mean(X,2),1,size(X,2));
% now normalize the data by the largest dimension so everything appears in
% the unit box
maxptlen = max( sqrt(sum(X.*X,1)) );
X = 1.4*X / maxptlen;

%%%%%%%%%%%%%%%%%%
% plot
%%%%%%%%%%%%%%%%%%
% some figure parameters
f = figure;
hold on;
axis off
set(gcf,'color','w');
view([28,-18])
set(f, 'position', [200 200 600 600]);
lw = 2;
wscale = 1;
xbump = 0.1;
wbump = 0.1;
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);

% plot cardinal axes
for i = 1 : 3
    plot3( -[1 i~=1] , -[1 i~=2] , -[1 i~=3] , 'k' , 'linewidth', lw );
    text('string', sprintf('$$\\mathbf{x}_%d$$',i) , 'position', -[i~=1 i~=2 i~=3]' + xbump*[i==1 i==2 i==3]' , 'fontsize', 24, 'interpreter', 'latex');
end

% plot W basis
for i = 1 : size(W,2)
    plot3( wscale*[ -0*W(1,i) W(1,i) ] , wscale*[ -0*W(2,i) W(2,i) ] , wscale*[ -0*W(3,i) W(3,i) ] , 'k' , 'linewidth', lw );
    text('string', sprintf('$$\\mathbf{w}_%d$$',i) , 'position', (wscale + wbump)*W(:,i) , 'fontsize', 24, 'interpreter', 'latex');
end

% scatter data 
for i = 1:size(X,2)
  plot3(X(1,i), X(2,i), X(3,i), 'o', 'markerfacecolor', data_colors(:,i) , 'markersize', data_sizes(1,i) , 'markeredgecolor', 'k');
end

% save as determined
if parms.save_fig
    % presumes a full pathed parms.fname_fig
    print(gcf,'-depsc',parms.fname_fig);
end
