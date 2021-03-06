classdef StateSeries
    %STATESERIES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        States
        TimeIntervalCombined
    end
    
    methods
        function obj = StateSeries(states,ticd)
            obj.TimeIntervalCombined=ticd;
            obj.States=states(1:ticd.getNumberOfPoints);
        end
        function newobj = getResampled(obj,timeIntervalCombined)
            if isa(timeIntervalCombined,'Channel')
                timeIntervalCombined=timeIntervalCombined.getTimeIntervalCombined;
            end
            timePointsInSec=timeIntervalCombined.getTimePointsInSec;
            ts=obj.getTimeSeries;
            ts1=ts.resample(timePointsInSec,'zoh');
            states1=ts1.Data;
            newobj=StateSeries(states1,timeIntervalCombined);
        end
        function [] = plot(obj,colorMap)
            states1=obj.States;
            ticd=obj.TimeIntervalCombined;
            t=seconds(ticd.getTimePointsInSec)+ticd.getStartTime;
            hold on;
            num=1;
            if exist('colorMap','var')
                for ikey=colorMap.keys
                    statesarr=states1;
                    key=ikey{1};
                    statesarr(states1~=key)=nan;
                    statesarr(states1==key)=num;num=num+1;
                    p1=plot(t,statesarr);
                    p1.Color=colorMap(key);
                    p1.LineWidth=10;
                    
                end
            else
                states=unique(states1);
                for istate=1:numel(states)
                    statesarr=states1;
                    state=states(istate);
                    statesarr(states1~=state)=nan;
                    statesarr(states1==state)=num;num=num+1;
                    p1=plot(t,statesarr);
                    p1.LineWidth=10;
                end
            end
            ax=gca;
            ax.XLim=[t(1) t(end)];
            ax.YLim=[0 num];
            ax.Color='none';
            ax.Visible='off';
            ax.YDir='reverse';
        end
        function np=getNumberOfPoints(obj)
            np=numel(obj.States);
        end
        function idx=getIndexForWindow(obj,window)
            t1=obj.TimeIntervalCombined.getSampleFor(window(1));
            t2=obj.TimeIntervalCombined.getSampleFor(window(2));
            idx=zeros(1,obj.TimeIntervalCombined.getNumberOfPoints);
            idx(1,t1:t2)=1;
        end
        function idx=getIndexForState(obj,state)
            idx=obj.States==state;
            idx=idx';
        end
        function np=getTimeSeries(obj)
            np=timeseries(obj.States,obj.TimeIntervalCombined.getTimePointsInSec);
        end
    end
end

