function headers_psc = createPSCHeaders()
% Creates the headers for the psc .mat

headers_psc = [];

session = ["s1", "s2", "s3", "s4", "s5"];
within_session = ["loc", "train", "fv1", "fv2", "trans"];

for idx_s = 1: numel(session)
    for idx_w = 1:numel(within_session)
        headers_psc = [headers_psc  session(idx_s) + "_" + within_session(idx_w)];
        
    end
end

end
