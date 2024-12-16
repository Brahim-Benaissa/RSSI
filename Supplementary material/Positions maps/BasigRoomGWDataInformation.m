
clc
clear

%% visual parameters 
% Select gateway indices to plot (comment out if not needed)
selected_gateway_indices = [ 1 2 3 4 5 6 7 8 9 10 ]; % Add the indices of the gateways you want to plot

% Define the percentage of random floor points to select
percentage_selected_points = 0; % Adjust this percentage as needed

% Allow the user to select an index
selected_indices_Orientation = [ ];

% Set transparency and color for face colors
roomcolor = [0.92, 0.92, 0.92]; 
alphaValue = 0.25; % Adjust transparency (0: fully transparent, 1: fully opaque)

% Set line thickness for edges
lineWidthValue = 1.2; % Adjust line thickness

%% room paramters 
% Room dimensions
length = 7.0;     % in meters
width = 4.88;      % in meters
height = 3.5;   % in meters

% Define the room vertices
vertices = [0, 0, 0;       % Vertex 1 (bottom left corner)
            length, 0, 0;   % Vertex 2 (bottom right corner)
            length, width, 0;% Vertex 3 (top right corner)
            0, width, 0;     % Vertex 4 (top left corner)
            0, 0, height;    % Vertex 5 (top left corner, elevated)
            length, 0, height;% Vertex 6 (top right corner, elevated)
            length, width, height; % Vertex 7 (bottom right corner, elevated)
            0, width, height];    % Vertex 8 (bottom left corner, elevated)

% Define the room faces using vertices
faces = [1, 2, 3, 4;   % Bottom face
         5, 6, 7, 8;   % Top face
         1, 2, 6, 5;   % Front face
         2, 3, 7, 6;   % Right face
         3, 4, 8, 7;   % Back face
         4, 1, 5, 8];  % Left face


%% GW and points paramters 

% Coordinates of red squares on the ceiling
GW = [1.7, width-0.15, 1; 0.1, width/2, 1;3.5, 0.15, 1; 6.9, width/2, 1; 5.7, width-0.15, 1;2.1, 1.14, height-0.3; 3.5, 1.14, height-0.3; 4.9, 1.14, height-0.3 ; 4.9, 3.34, height-0.3; 2.1, 3.34, height-0.3];

% Create a grid of points on the floor with indexing along the width axis
[y, x] = meshgrid(0.94:3.94, 1:6);
z = zeros(size(x));

% Extend the grid of points on the floor with 6 randomly positioned points
ExtraPointX = [3.5,     2,    5,    1,   3.5,   6]; 
ExtraPointY = [2.44, 1.44, 1.44, 3.44,   3.44,  3.44]; 
ExtraPointZ = zeros(1, 6); % Assuming all random points have a height of 0

% Concatenate the random points with the existing grid points
x = [x(:); ExtraPointX(:)];
y = [y(:); ExtraPointY(:)];
z = [z(:); ExtraPointZ(:)];

% Select a percentage of random floor points
num_random_points_to_select = round((percentage_selected_points / 100) * numel(x));
random_floor_point_indices = randperm(numel(x), num_random_points_to_select);

% points indices 

% Create indices for each point on the floor with reversed indexing
indices_top = reshape(1:numel(x), size(x)) * 2 - 1;
indices_bottom = reshape(1:numel(x), size(x)) * 2;

% Create indices for each point on the floor
indices_left = reshape(1:numel(x), size(x)) * 2 - 1;
indices_right = reshape(1:numel(x), size(x)) * 2;

%%%%%%%%%%%%%%%%%% 
%% Plot the room with thicker edge lines, grid points, and red squares on the ceiling
figure;
h = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', roomcolor, 'EdgeColor', 'k', 'FaceAlpha', alphaValue, 'LineWidth', lineWidthValue);
hold on;

% Plot selected red gateways (if specific indices are provided)
if exist('selected_gateway_indices', 'var') && ~isempty(selected_gateway_indices)
    scatter3(GW(selected_gateway_indices, 1), GW(selected_gateway_indices, 2), GW(selected_gateway_indices, 3), 100, 'r', 'filled');

% Add text tags for selected gateways
for i = 1:numel(selected_gateway_indices)
    y_offset = -0.3;  % Adjust this value to control how much to lower the text
    text(GW(selected_gateway_indices(i), 1), GW(selected_gateway_indices(i), 2) + y_offset, ...
        GW(selected_gateway_indices(i), 3), ...
        ['GW', num2str(selected_gateway_indices(i))], ...
        'FontSize', 10, 'Color', 'k', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end
else
    % Plot all red gateways
    scatter3(GW(:, 1), GW(:, 2), GW(:, 3), 100, 'r', 'filled');
    
    % Add text tags for all gateways
    for i = 1:size(GW, 1)
        text(GW(i, 1), GW(i, 2), GW(i, 3), ['GW', num2str(i)], 'FontSize', 10, 'Color', 'k', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    
    % Plot blue grid points on the floor with consecutive indices
    scatter3(x(:), y(:), z(:), 10, 'b', 'filled');
end

hold off;

xlabel('Length (meters)');
ylabel('Width (meters)');
zlabel('Height (meters)');
axis equal;
grid on;

% Adjust the view
view(25, 15);


% Save the first figure
figure_filename_png = ['3D_Room_Visualization_' num2str(selected_gateway_indices) '.png'];
figure_filename_fig = ['3D_Room_Visualization_' num2str(selected_gateway_indices) '.fig'];
print(gcf, figure_filename_png, '-dpng', '-r600');
saveas(gcf, figure_filename_fig, 'fig');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Replot the figure with the arrow
figure;

% Check if the selected_indices_Orientation is empty
if ~isempty(selected_indices_Orientation)
    % Loop through each selected index
    for idx = 1:numel(selected_indices_Orientation)
        selected_index = selected_indices_Orientation(idx);

        % Determine if the selected index is left or right
        is_left_index = mod(selected_index, 2) == 1;
        if is_left_index
            selected_point = [x((selected_index + 1) / 2), y((selected_index + 1) / 2), z((selected_index + 1) / 2)];
            arrow_direction = 180; % 180° for left
        else
            selected_point = [x(selected_index / 2), y(selected_index / 2), z(selected_index / 2)];
            arrow_direction = 0; % 0° for right
        end

        % Determine arrow end based on direction
        arrow_end = selected_point + [cosd(arrow_direction), sind(arrow_direction), 0] * 0.3;

        % Create an arrow stemming from the selected point
        arrow_line = [selected_point; arrow_end];

        % Plot the figure with the arrow and arrow direction text
        patch('Vertices', vertices, 'Faces', faces, 'FaceColor', roomcolor, 'EdgeColor', 'k', 'FaceAlpha', alphaValue, 'LineWidth', lineWidthValue);
        hold on;

        % Plot blue grid points on the floor with consecutive indices
        scatter3(x(:), y(:), z(:), 20, 'b', 'filled');

        % Plot selected percentage of random floor points in a different color (e.g., green)
        scatter3(x(random_floor_point_indices), y(random_floor_point_indices), z(random_floor_point_indices), 20, 'r', 'filled');

        text(x(:), y(:), z(:), strcat(arrayfun(@num2str, indices_left(:), 'UniformOutput', false), {'/'}, arrayfun(@num2str, indices_right(:), 'UniformOutput', false)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 6);
        plot3(arrow_line(:, 1), arrow_line(:, 2), arrow_line(:, 3), 'k', 'LineWidth', 1.5);
        
        % Add arrow direction as text next to the arrow
        if arrow_direction == 180
            text(arrow_end(1)- 0.25, arrow_end(2), arrow_end(3), [num2str(arrow_direction), '°'], 'Color', 'k', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontSize', 9);
        else
            text(arrow_end(1)- 0.1, arrow_end(2)- 0.13, arrow_end(3), [num2str(arrow_direction), '°'], 'Color', 'k', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', 'FontSize', 9);
        end

        hold off;

        xlabel('Length (meters)');
        ylabel('Width (meters)');
        zlabel('Height (meters)');
        axis equal;
        grid on;

        % Adjust the view
        view(0, 90);
    end
    hold on;
else

        % Plot the figure with the arrow and arrow direction text
        patch('Vertices', vertices, 'Faces', faces, 'FaceColor', roomcolor, 'EdgeColor', 'k', 'FaceAlpha', alphaValue, 'LineWidth', lineWidthValue);
        hold on;

        % Plot blue grid points on the floor with consecutive indices
        scatter3(x(:), y(:), z(:), 20, 'b', 'filled');

        % Plot selected percentage of random floor points in a different color (e.g., green)
        scatter3(x(random_floor_point_indices), y(random_floor_point_indices), z(random_floor_point_indices), 20, 'r', 'filled');

        text(x(:), y(:), z(:), strcat(arrayfun(@num2str, indices_left(:), 'UniformOutput', false), {'/'}, arrayfun(@num2str, indices_right(:), 'UniformOutput', false)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 6);
        
        xlabel('Length (meters)');
        ylabel('Width (meters)');
        zlabel('Height (meters)');
        axis equal;
        grid on;

        % Adjust the view
        view(0, 90);


end

% Save the second figure with arrow
figure_filename_with_arrow_png = 'data points with Arrow.png';
figure_filename_with_arrow_fig = 'data points with Arrow.fig';
print(gcf, figure_filename_with_arrow_png, '-dpng', '-r600');
saveas(gcf, figure_filename_with_arrow_fig, 'fig');