classdef lineH < handle
    %lH=lineH(x,y,figH) 
    %   creates line handle object
    %   use lH.markers to use default filled circles
    %   use lH.line to use remove markers and use line
    
    properties
        h
        Parent
    end
    
    methods
        function lh = lineH (XData,YData,figH)
            if isempty(XData)
                XData = 0:length(YData)-1;
            end
            lh.Parent=figH;
            lh.h = line(XData,YData,'Parent',lh.Parent);
            lh.markers();
        end
        
        function lh = markers(lh)
            set(lh.h,...
                'LineStyle','none',...
                'Marker','o',...
                'Color',[0 0.4470 0.7410],...
                'MarkerFaceColor',[0 0.4470 0.7410]...
                );  
        end
        
        function lh = openmarkers(lh)
            set(lh.h,...
                'LineStyle','none',...
                'Marker','o',...
                'MarkerFaceColor','auto'...
                );  
        end
        
        function lh = line(lh)
            set(lh.h,...
                'LineStyle','-',...
                'LineWidth',1,...
                'Marker','none',...
                'Color',[0 0.4470 0.7410],...
                'MarkerFaceColor',[0 0.4470 0.7410]...
                );  
        end
        
        function lh = linek(lh)
            set(lh.h,...
                'LineStyle','-',...
                'LineWidth',1,...
                'Marker','none',...
                'Color',[0 0 0],...
                'MarkerFaceColor',[0 0 0]...
                );  
        end
        
        function lh = lineg(lh)
            set(lh.h,...
                'LineStyle','-',...
                'LineWidth',1,...
                'Marker','none',...
                'Color',[.5 .5 .5],...
                'MarkerFaceColor',[0 0 0]...
                );  
        end
        
        function lh = liner(lh)
            set(lh.h,...
                'LineStyle','-',...
                'LineWidth',1,...
                'Marker','none',...
                'Color',[.75 0 0],...
                'MarkerFaceColor',[0 0 0]...
                );  
        end
        
        function lh = lineb(lh)
            set(lh.h,...
                'LineStyle','-',...
                'LineWidth',1,...
                'Marker','none',...
                'Color',[0 0.4431 0.7373],...
                'MarkerFaceColor',[0 0 0]...
                );  
        end
        
        function lh = linedash(lh)
            set(lh.h,...
                'LineStyle','--',...
                'LineWidth',1,...
                'Marker','none',...
                'Color',[.4 .4 .4],...
                'MarkerFaceColor',[0 0 0]...
                );  
        end
        
        function lh = linemarkers(lh)
            set(lh.h,...
                'LineStyle','-',...
                'LineWidth',1,...
                'Marker','o',...
                'Color',[0 0.4470 0.7410],...
                'MarkerFaceColor',[0 0.4470 0.7410]...
                );  
        end
        
        function lh = color(lh,colors)
            set(lh.h,'Color',colors,'MarkerFaceColor',colors);  
        end
        
        function lh = marker(lh,mstyle)
            set(lh.h,'Marker',mstyle);  
        end
        
        function lh = markercolormap(lh,varargin)
            % from http://undocumentedmatlab.com/blog/plot-markers-transparency-and-color-gradient
            if nargin==1
                cmap=pmkmp(length(lh.h.XData),'CubicL');
            else
                cmap=varargin{1};
            end
            cmap=[cmap ones(size(cmap,1),1)]';
            mhandles = lh.h.MarkerHandle;
            set(mhandles,'FaceColorBinding','interpolated',...
                'FaceColorData',uint8(cmap*255),...
                'EdgeColorBinding','interpolated',...
                'EdgeColorData',uint8(cmap*255));  
        end
        
        function lh = setName(lh,name)
            if ~ischar(name)
                error('no name provided as string')
            end
            set(lh.h,'DisplayName',name,'tag',name)
        end
        
        function lh = lowPassFilter(lh,freq,samplingInterval)
            lh.h.YData = lh.lpf(lh.h.YData,freq,samplingInterval);
        end
    end
    methods (Static = true)
        function eh=errorfill(XData,YData,YError,fillColor,figH)
            if isempty(XData)
                XData = 0:length(YData)-1;
            end
            if isempty(fillColor)
                fillColor = [.5 .75 .75];
            end
            if length(YData)>1000
               XData = decimate(XData,10);
               YData = decimate(YData,10);
               YError = decimate(YError,10);
            end
            eh.Parent=figH;
            XFill = [XData fliplr(XData)];
            YFill = [YData+YError fliplr(YData-YError)];
            eh.h = patch(XFill,YFill,fillColor,'Parent',eh.Parent);
            eh.h.FaceAlpha = 1;
            eh.h.LineStyle = 'none';
            uistack(eh.h,'down');
        end
        
        function eh=errorbars(XData,YData,YError,fillColor,figH,basename)
            if isempty(XData)
                XData = 0:length(YData)-1;
            end
            if isempty(fillColor)
                fillColor = [.5 .75 .75];
            end
            if isempty(basename)
                basename = 'error_';
            end
            XData=repmat(XData,2,1);
            eh=gobjects(1,length(XData));
            for i=1:length(XData)
               eh(i)=line(XData(:,i),...
                   [YData(i)-YError(i) YData(i)+YError(i)],'Parent',figH); 
               set(eh(i),'LineStyle','-','Marker','none','Color',fillColor);
               set(eh(i),'DisplayName',sprintf('%s%02g',basename,i))
            end
        end
        
        function filtered_data = lpf(data,freq,samplingInterval)
            % low pass filtering (freq in Hz, samplingInterval in s)
            % X is a vector or a matrix of row vectors
            % this needs zero padding that accomodates to freq
            L = size(data,2);
            if L == 1 %flip if given a column vector
                data=data';
                L = size(data,2);
            end
            
            padF = 1/4;
            padded_data = [ones(1,L*padF)*data(1) data ones(1,L*padF)*data(end)];
            
            freqStepSize = 1/(samplingInterval * L);
            freqCutoffPts = round(freq / freqStepSize);
            
            % eliminate frequencies beyond cutoff (middle of matrix given fft
            % representation)
            FFTData = fft(padded_data, [], 2);
            FFTData(:,freqCutoffPts:size(FFTData,2)-freqCutoffPts) = 0;
            padded_filtered_data = real(ifft(FFTData, [], 2));
            filtered_data = padded_filtered_data(L*padF+1:L*padF+L);
        end
    end
end

