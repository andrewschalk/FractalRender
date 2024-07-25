%% NewtonFractal_v2
% Author: Andrew Schalk
% Date:   9/4/2023
% Description: Outputs a video that shows a graph of a fractal. The 'camera' zooms slowly into the
% fractal. Many of the properties of the video and fractal can be modified by using the options.
% The output can take a long time to render, it uses millions of inefficient calculations.

clear
clc
close all

%% Options
% Edit these to change output movie. Default values work as is.
nx=400; ny=400;            % Set amount of seed points in each dimension.
iterations   = 300;          % Number of times to run Newton's method(higher looks better)
point        = [-0.246485,-0.638168];% The location to zoom in to.
movie_length = .05;          % Length of output movie. Units of seconds.
frame_rate   = 20;           % Units of frames per second.
file_name    = "Fractal.avi";% Saves output in same folder with this name
zoom_speed   = .99;          % Scaling factor per frame.
xsize        = .1;           % Starting x dimension
ysize        = .1;           % Starting y dimension
fractal_type = "Mandelbrot"; % Type of fractal to render. Options are: "Newton" and "Mandelbrot"
render_time  = 51.6;         % How long each frame takes to rander. Only used to estimate render time for user.

% More advanced options. These don't usually need to be modified
dpi = 300;   % Resolution of movie. Units of dots per inch
eps = 0.001; % Epsilon, the tolerance for an output point to be considered at a root in Newton's method

%% Prepare to make frames
num_frames = frame_rate*movie_length;% Calculate number of frames for movie

% Let the user know how long the render is predicted to take
disp(strcat("Render will take about "+string((num_frames*render_time)/60)," minutes"+newline+"Press any key to continue"))
pause();% Waits for the user to press any key

% Set our default figure properties
set(gcf,'Visible','off');% This stops matlab from displaying every frame.
set(0,'DefaultFigureVisible','off');

%% Render and save the output
[render_time,total_render_time,frames] = generate_frames(nx,ny,iterations,eps,point,dpi,num_frames,zoom_speed,xsize, ...
    ysize,fractal_type);
save_time = save_video(file_name,frame_rate,frames);

% Reset the graph settings back to default
reset(gca);
reset(gcf);

%% Display end screen
clc
disp('----------Video Saved----------')
disp(strcat("Total render time:               ",string(minutes(datetime-total_render_time))," minutes"))
disp(strcat("Mean computation time per frame: ",string(mean(render_time*60))," seconds"))
disp(strcat("Mean save time per frame:        ",string(mean(save_time*60))," seconds"))
disp(strcat("                                 A"+newline+ "                                  S"))% Touchmark
