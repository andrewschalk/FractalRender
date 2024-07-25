% Description:
%   Renders the frames for a fractal movie described by the given function arguments.
%
% Parameters:
%   nx,ny        - (integer)   : Amount of seed points in each dimension.
%   iterations   - (integer)   : Number of iterations to run for the fractal method.
%   eps          - (double)    : Epsilon, the tolerance for an output point to be considered at a
%                                root in Newton's method.
%   point        - (1X2 double): Point to render the movie about.
%   dpi          - (integer)   : Output dots per inch.
%   num_frames   - (integer)   : Number of frames to render.
%   zoom_speed   - (double)    : Scale factor per frame.
%   xsize,ysize  - (double)    : Starting dimension of frame.
%   fractal_type - (String)    : The type of fractal to render. Options are "Newton" and
%                                "Mandelbrot".
% Returns:
%   render_time       - (datetime array): Time that it took to render each frame.
%   total_render_time - (datetime)      : Time that it took to render all frames.
%   frames            - (cell array)    : The frames of the movie.
function [render_time,total_render_time,frames] = generate_frames(nx,ny,iterations,eps,point,dpi,num_frames,zoom_speed, ...
    xsize,ysize,fractal_type)
    progress = 0;% How many frames have been generated, will be used with loading bar
    frames{num_frames} = []; % Preallocate movie frame array
    total_render_time = datetime;% Find the start time so that we can later calculate the total render time
    loading_bar("----------Rendering Video----------",num_frames,progress,51.6);% Ititialize loading bar
    render_time(num_frames) = 0;

    for k = 1:num_frames
            time   = datetime;% This is for tracking render time of the frame
            zoom   = (zoom_speed^k);% Find the current frame scale.
            point1 = point(1);
            point2 = point(2);
        
            % Set the location of the corners of the graph by using the current
            % zoom and the point of zoom.
            xmin=-xsize*zoom+point1; xmax=xsize*zoom+point1;
            ymin=-ysize*zoom+point2; ymax=ysize*zoom+point2;


        if(fractal_type == "Newton")% Newton or mandelbrot
        
            f = @(z) z.^3-1; fp = @(z) 3*z.^2;% Equation which is seed for fractal
            root1 = 1; root2 = -1/2 + 1i*sqrt(3)/2; root3 = -1/2 - 1i*sqrt(3)/2;
            x=linspace(xmin,xmax,nx); y=linspace(ymin,ymax,ny);% Create the seed points
            [X,Y]=meshgrid(x,y);
            Z=X+1i*Y;
            for n=1:iterations% Iterates through Newton's method for the given iterations
                Z = Z - f(Z) ./ fp(Z);% Newton's fractal
            end
    
            % Determine if an output point is at a root
            Z1 = abs(Z-root1) < eps; Z2 = abs(Z-root2) < eps;
            Z3 = abs(Z-root3) < eps; Z4 = ~(Z1+Z2+Z3);
            
            figure;
    
            % These are the colors of the four graph regions. These regions being:
            % Output at root 1,2,3 or tends towards no point; respectively. 
            map = [230 126 37; 231 76 59; 35 185 154; 245 239 224]; colormap(uint8(map));
            
            Z=(Z1+2*Z2+3*Z3+4*Z4);
            % Create the axis and label the figure.
             image([xmin xmax], [ymin ymax], Z); set(gca,'YDir','normal');
        elseif(fractal_type == "Mandelbrot")
            [x,y] = meshgrid(linspace(xmin, xmax, nx), linspace(ymin, ymax, ny));

            c = x + 1i * y;
            z = zeros(size(c));
            L = zeros(size(c));
            for ii = 1:iterations
                z = z.^2 + c;
                L(z>2&L==0) = ii;
                L(z>2&L==0) = L(z>2&L==0).*z(z>2&L==0);
            end

            figure
            set(gcf,'position',[0,40,1920,1080]); 
            axes('Units','normalized','Position',[0 0 1 1]);
            L = imresize(L,.25);
            imagesc(L);
            clim([-40,500]);
            colormap jet
        else% Julia set

        end
        axis off
        frames{k} = print('-RGBImage', strcat('-r',string(dpi)));% Save the frame in the next index in the frame array
        progress = loading_bar("----------Rendering Video----------",num_frames,progress,24.2);% Update loading bar
        render_time(k) = minutes(datetime-time);% Calculate how long the frame took to generate
    end
end