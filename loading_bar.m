% Description:
%   Displays a loading bar in the command window. Has the ability to display a time estimate. Each
%   time this function is called, the loading bar is updated.
%
% Parameters:
%   text     - (string) : Text to display alongside the loading bar.
%   n        - (integer): Number of operations that need to be completed.
%   progress - (integer): The number of operations which have been completed.
%
% Optional Parameters:
%   operation_time  - (double) : How long it takes for an operation to finish. Displays an estimated
%                                time remaining with the loading bar.
%
% Returns:
%   progress: - (integer): The passed progress incremented by one.
function progress = loading_bar(text,n,progress,varargin)

    operation_time = varargin{1};
    percentage     = (progress/n)*10;% Let's find how much of the operation is completed(out of ten)
    progress       = progress + 1;
    
    clc
    output_string = '[';

    for ii=1:floor(percentage)% Add a hash for each 10 percent we have loaded
        output_string = strcat(output_string ,'#');
    end

    for ii=floor(percentage+1):10% Add a dash for each 10 percent we haven't loaded
        output_string = strcat(output_string,'-');
    end
    if(operation_time ~= 0)% Display the estimated time remaining
        output_string = strcat(output_string,"] About ", ...
            string(round((n-progress)*operation_time/60)),' minutes remaining');
    else
        output_string = strcat(output_string,']');
    end
    disp(text+newline+output_string)% Output loading bar to command window
end
