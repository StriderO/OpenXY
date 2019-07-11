classdef ImagepatternProvider < patterns.PatternProvider
    
    properties
        imSize
    end
    
    properties (Access = private)
        imageNames
        scanFormat(1,:) char {mustBeMember(scanFormat, {'Hexagonal', 'Square',''})}
        scanLength
        dimensions
        startLocation
        steps
    end
    
    methods
        function obj = ImagepatternProvider(...
                firstImageName, scanFormat, scanLength,...
                dimensions, startLocation, steps)
            
            firstImageName = char(firstImageName);
            
            info = imfinfo(firstImageName);
            obj@patterns.PatternProvider(...
                firstImageName, min(info.Width, info.Height));
            
            obj.scanFormat = scanFormat;
            obj.scanLength = scanLength;
            obj.dimensions = dimensions;
            obj.startLocation = startLocation;
            obj.steps = steps;
            
            obj.imageNames = obj.getImageNamesList(...
                firstImageName,...
                scanFormat,...
                scanLength,...
                dimensions,...
                startLocation,...
                steps);
            im = obj.getPatternData(1);
            sz = size(im);
            obj.imSize = im(1:2);

        end
        
        function sobj = saveobj(obj)
            sobj = saveobj@patterns.PatternProvider(obj);
            sobj.imageNames = obj.imageNames;
            sobj.scanFormat = obj.scanFormat;
            sobj.scanLength = obj.scanLength;
            sobj.dimensions = obj.dimensions;
            sobj.startLocation = obj.startLocation;
            sobj.steps = obj.steps;

        end
    end
    
    methods (Access = protected)
        function pattern = getPatternData(obj, index)
            pattern = mean(imread(obj.imageNames{index}),3);
        end
    end
    
    methods (Static)
        function obj = restore(loadStruct)
            obj = pattterns.ImagepatternProvider(...
                loadStruct.fileName,...
                loadStruct.scanFormat,...
                loadStruct.scanLength,...
                loadStruct.dimensions,...
                loadStruct.startLocation,...
                loadStruct.steps);
        end
        
        imageNames = getImageNamesList(firstImagename, scanFormat, scanLength, dimensions, startLocation, steps)
    end
end
