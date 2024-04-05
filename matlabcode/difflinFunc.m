function [difflinFlag,diffmax] = difflinFunc(XBar, u, XLin, threshold)

m = size(XBar,3);
diff = zeros(1,m);
for i = 1:m
    slin = [XLin.x(:,:,i); XLin.u(i)];
    s = [XBar(:,:,i); u(i)];
%     slin = XLin.x(:,:,i);
%     s = XBar(:,:,i);
    diff(i) = norm(s-slin)/norm(slin);
%    diff(i) = norm(s-slin);
end
diffmax = max(diff);


% slin = zeros(6,m);
% s = zeros(6,m);
% for i = m
%     slin(:,i) = [XLin.x(:,:,i); XLin.u(i)];
%     s(:,i) = [XBar(:,:,i); u(i)];
% end
% diffmax = norm(s-slin,'fro')/norm(slin,'fro');

if diffmax >= threshold
    difflinFlag = 1;
else
    difflinFlag = 0;
end

end