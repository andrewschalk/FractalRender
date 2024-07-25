% Description:
%   Saves a video from an array of frames
%
% Parameters:
%   file_name  - (string)     : Name of output video file.
%   frame_rate - (integer)    : Frame rate in units of fps.
%   frames     - (cell array): Array containing all the frames.
%
% Returns:
%   save_time - (datetime array): The array containing the save time for each frame
function save_time = save_video(file_name,frame_rate,frames)
    v = VideoWriter(file_name); % Initialize VideoWriter
    v.FrameRate = frame_rate;   % Set frame rate
    open(v)
    clc
    progress = 0;% This represents how many frames have been saved so far, will be passed to the loading bar
    loading_bar("----------Saving Video----------",length(frames),progress,0.03786);
    save_time(size(frames)) = 0;
    for k=1:size(frames)
        time = datetime;
        writeVideo(v,frames{k});
        progress = loading_bar("----------Saving Video----------",length(frames),progress,0.03786);
        save_time(k) = minutes(datetime-time);% Calculate how long the frame took to generate
    end
    close(v);
end