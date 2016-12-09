function closeSerialPorts(varargin)
  %CLOSESERIALPORTS Summary of this function goes here
  %   Detailed explanation goes here
  
  comObjs = instrfindall;
  
%   for i = 1 : length(comObjs)
%     for n = 1 : nargin
%       if strcmp(varargin{n}.Port, comObjs(i).port)
%         comObjs( = comObjs(break
%       end
%     end
%     
%     if ~found
%       comObjs(
%     end
%   end
  
  if ~isempty(comObjs)
    fclose(comObjs);
    delete(comObjs);
  end
  
end
