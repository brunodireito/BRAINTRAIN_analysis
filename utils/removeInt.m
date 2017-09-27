
function [strOutput] = removeInt(str)

[s1, str] = strtok(str,"_");
[s2, str] = strtok(str,"_");

strOutput = [s1 s2 str];

end