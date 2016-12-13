function setLabels(fighandle,xlabel,ylabel)
% function setLabels(fighandle,xlabel,ylabel)
set(get(fighandle,'xlabel'),'string',xlabel)
set(get(fighandle,'ylabel'),'string',ylabel)
end