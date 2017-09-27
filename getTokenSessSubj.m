function voiname =  getTokenSessSubj(fileName)

voiname = '';

temp = strsplit(fileName, '_');

voiname = strcat( ['VOI1_' temp{4} temp{5} ]);



end



