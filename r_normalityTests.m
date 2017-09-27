
%% Normality test
% One-Sample Kolmogorov Smirnov
for i = 1:5
    
    x = psc(:,i);
    
    x = (x - mean( x ) ) / std( x );
    
    [h,p,ksstat,cv] = kstest(x) 
    
    
    
    [f,x_values] = ecdf(x);
    F = plot(x_values,f);
    set(F,'LineWidth',2);
    hold on;
    G = plot(x_values,normcdf(x_values,0,1),'r-');
    set(G,'LineWidth',2);
    legend([F G],...
        'Empirical CDF','Standard Normal CDF',...
        'Location','SE');
    
end
