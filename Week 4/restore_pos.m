function newpos = restore_pos(curpos,maxX,maxY)
% function newpos = restore_pos(curpos,maxX,maxY)
%
% Ensures that the position in curpos (X,Y) is between maxX, maxY, 
% by subtracting/adding the maxX/maxY as appropriate

newpos=curpos;
tmpi=find(newpos(:,1)<0);
if (~isempty(tmpi))
  newpos(tmpi,1)=newpos(tmpi,1)+maxX;
end
tmpi=find(newpos(:,1)>maxX);
if (~isempty(tmpi))
  newpos(tmpi,1)=newpos(tmpi,1)-maxX;
end
tmpi=find(newpos(:,2)<0);
if (~isempty(tmpi))
  newpos(tmpi,2)=newpos(tmpi,2)+maxY;
end
tmpi=find(newpos(:,2)>maxY);
if (~isempty(tmpi))
  newpos(tmpi,2)=newpos(tmpi,2)-maxY;
end
