classdef (Abstract) TimeFrequencyMap < Topography2D
    %TIMEFREQUENCYMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        matrix
        timePoints
        frequencyPoints
        clim
    end
    methods (Abstract)
    end
    
    methods
        function obj = TimeFrequencyMap(matrix, timePoints,frequencyPoints)
            %TIMEFREQUENCYMAP Construct an instance of this class
            %   Detailed explanation goes here

            obj@Topography2D(abs(matrix),timePoints, frequencyPoints);
            obj.timePoints=timePoints;
            obj.frequencyPoints=frequencyPoints;
            obj.matrix=matrix;
        end
        
        function obj = setTimePoints(obj,time)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.timePoints=time;
            obj=obj.setxBins(time);
        end
        function [mat, freq] = getSpectogramSamples(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            mat=obj.matrix;
            freq=obj.frequencyPoints;
        end
        function [meanfreq] = getMeanFrequency(obj,freqRange)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            mat=10*log10( abs(obj.matrix));
            freq=obj.frequencyPoints;
            freqpoints=(freqRange(1)<freq)&(freqRange(2)>freq);
            meanfreq=mean(mat(:,freqpoints),2);
        end

    end
end

