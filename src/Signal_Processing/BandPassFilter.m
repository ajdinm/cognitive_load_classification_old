function[Data] = BandPassFilter(LowCutOff, HighCutOff, fs, Data, Order)
    wnLow = LowCutOff/(fs/2); %cut off freq
    wnHigh = HighCutOff/(fs/2);
    %[a, b]=butter(Order, [wnLow wnHigh],'bandpass'); 
    %Data=filter(a, b, Data);
    
    
    a=fir1(4000,[wnLow wnHigh])
    Data=filter(a,1,Data);
    
end