function [t,numeaten]=ibm_predation(info,predator,prey)
% function numeaten=ibm_predation(info,predator,prey)
%   An individual-based movement model of predators eating prey
%   numeaten returns the time series of eating
t=0:info.dt:info.tf;
numt=length(t);
  
% Setup the plot
clf
axis square
xlim([0 info.maxX]);
ylim([0 info.maxY]);
ispeating=0;  	% Whether predators are eating
pdoneeating=0;  % The time when predators are done eating
numprey=length(prey.pos);
  
% Draw the predator as it views things
tmpres = 100;
xradius = predator.r;
yradius = predator.r;
k=0:tmpres;
xdata(1:tmpres+1)=predator.pos(1)+predator.r*cos(2*pi*k/tmpres);
ydata(1:tmpres+1)=predator.pos(2)+predator.r*sin(2*pi*k/tmpres);
tmppred_scan = patch('XData', xdata, 'YData', ydata, ...
   'FaceColor', 'green', 'EdgeColor', 'green', ...
      'FaceAlpha', 1, 'EdgeAlpha', 1);
hold on;

% Draw the predator
tmppred_body=plot(predator.pos(:,1),predator.pos(:,2),'ro');
set(tmppred_body,'markerfacecolor','r');

% Draw the prey
tmpprey=plot(prey.pos(:,1),prey.pos(:,2),'k.');

% Keep the same axes 
axis square
drawnow
  
% Update the time
%tmps=sprintf('t = %4.2f',t(iter));
tmps=sprintf('t = %4.2f',0);
tmptime_handle=text(info.maxX*1.05,info.maxY,tmps);
set(tmptime_handle,'fontsize',24);

for iter=1:numt,
  if (ispeating & (t(iter)>pdoneeating))  % Is the predator done eating?
    ispeating=0;
  end
  if (~ispeating)
    % Move predator
    predator.pos=predator.pos+predator.vel*[cos(predator.theta) sin(predator.theta)]*info.dt;
    predator.pos=restore_pos(predator.pos,info.maxX,info.maxY);
    predator.trun=predator.trun+info.dt;
    if (predator.trun>predator.tau)
      predator.theta=rand*2*pi;  % Angle of movement
      predator.trun=0;
    end
  end
 
  % Move prey
  if (numprey>0) 
    rdxy=randn(prey.num,2)*sqrt(prey.diffusion)*sqrt(info.dt);
    prey.pos=prey.pos+rdxy;
    prey.pos=restore_pos(prey.pos,info.maxX,info.maxY);
  
    % Find who is eaten
    if (~ispeating)
      tmpi=find(((predator.pos(1)-prey.pos(:,1)).^2+(predator.pos(2)-prey.pos(:,2)).^2)<(predator.r + predator.vel*info.dt).^2);
      if (length(tmpi)>0)  % Someone is detected
        tmpj=rand(length(tmpi),1)<(predator.k*info.dt*predator.f);
        if (predator.handling_time==0)
          numeaten(iter)=sum(tmpj);  % Eaten
        elseif (sum(tmpj)>0)
          numeaten(iter)=1;
          tmpj=1;
          pdoneeating=t(iter)+predator.handling_time;
          ispeating=1;
        else
          numeaten(iter)=0;
        end
      else
        numeaten(iter)=0;
      end
    else
      numeaten(iter)=0;
    end
  end 
  
  if (numeaten(iter)>0)
    % Remove the old visualization
    if (exist('tmph_eaten'))
      delete(tmph_eaten);
    end
    if (info.viz_dyn)
      tmph_eaten=plot(prey.pos(tmpi(tmpj),1),prey.pos(tmpi(tmpj),2),'bo'); 
      set(tmph_eaten,'markersize',8);
      set(tmph_eaten,'markerfacecolor','b');
      drawnow
    end
    if (info.replenish_prey)
      prey.pos(tmpi(tmpj),1)=rand(sum(tmpj),1)*info.maxX;
      prey.pos(tmpi(tmpj),2)=rand(sum(tmpj),1)*info.maxY;
    else
      prey.pos(tmpi(tmpj),:)=[];
      prey.num=prey.num-sum(tmpj);
    end
  end

  % Plot the predator and prey

  % Re-visualize
  if (info.viz_dyn)
    xdata(1:tmpres+1)=predator.pos(1)+predator.r*cos(2*pi*k/tmpres);
    ydata(1:tmpres+1)=predator.pos(2)+predator.r*sin(2*pi*k/tmpres);
    set(tmppred_scan,'xdata',xdata,'ydata',ydata);
    set(tmppred_body,'xdata',predator.pos(:,1),'ydata',predator.pos(:,2)); 
    set(tmpprey,'xdata',prey.pos(:,1),'ydata',prey.pos(:,2));
    set(tmptime_handle,'String',sprintf('t= %4.2f',t(iter)));
    drawnow
  end
end
