function [ numZeroCross] = ZeroCross( idxStart, idxEnd, Data)
    %len=3045;
    %numFeatures=40;
    %len/numFeatures = 76.1250, dvs 77. 77*20
    zcd=dsp.ZeroCrossingDetector;
    
    numZeroCross=step(zcd, Data(idxStart: idxEnd));
    
    
%     winSize=ceil((idxEnd-idxStart)/numFeatures);
%     lastWin = winSize + (idxEnd-idxStart) - winSize*numFeatures;
%     Start=idxStart;
%     for j = 1:numFeatures
%         if j == numFeatures
%             winSize=lastWin;
%             release(zcd);
%             zcd=dsp.ZeroCrossingDetector;
%         end
%         %Number of zero crossings in the segments of the signal
%         numZeroCross(j) = step(zcd, Data(Start: Start+winSize));
%        
%         %Entropy in the segments of the signal
%         %e(j) =  wentropy(Data(Start:Start+winSize), 'log energy');
%         
%         Start=Start+winSize;
%     end
    

    %Features=e;
end


    

