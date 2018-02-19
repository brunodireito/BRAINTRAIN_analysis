function log_outliers = r_checkOutlier(data, method)

if nargin < 2
    method = 'mean';
end

log_outliers = isoutlier(data, method);

end