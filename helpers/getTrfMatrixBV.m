function TrfMatrix =  getTrfMatrixBV(bv)

    p_int(1) = bv(4) * pi / 180;
    p_int(2) = bv(5) * pi / 180;
    p_int(3) = bv(6) * pi / 180;
    p_int(4) = -bv(1);
    p_int(5) = -bv(2);
    p_int(6) = -bv(3);

    %% Rotation
    % Rotation X
    TrfMatrix_x = eye(4);
    
    TrfMatrix_x(2,2) = cos(p_int(1));
    TrfMatrix_x(2,3) = sin(p_int(1));
    TrfMatrix_x(3,2) = -sin(p_int(1));
    TrfMatrix_x(2,2) = cos(p_int(1));
    
    % Rotation y
    TrfMatrix_y = eye(4);

    TrfMatrix_y(1,1) = cos(p_int(2));
    TrfMatrix_y(1,3) = sin(p_int(2));
    TrfMatrix_y(3,1) = -sin(p_int(2));
    TrfMatrix_y(3,3) = cos(p_int(2));
    
    % Rotation z
    TrfMatrix_z = eye(4);
    
    TrfMatrix_z(1,1) = cos(p_int(3));
    TrfMatrix_z(1,2) = -sin(p_int(3));
    TrfMatrix_z(2,1) = sin(p_int(3));
    TrfMatrix_z(2,2) = cos(p_int(3));
    
    TrfMatrix = TrfMatrix_z * TrfMatrix_y * TrfMatrix_x;
    
    %% Translation
    
    TrfMatrix(1,4) =  p_int(4);
    TrfMatrix(2,4) =  p_int(5);
    TrfMatrix(3,4) =  p_int(6);

end