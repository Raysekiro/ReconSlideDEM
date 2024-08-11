function [X, Y, Z, reconstructedZSmooth] = reconLandslideDEM(OrigindataResolution, gausscore, SCARFile, SMOOTHZoneFile, BATHYFile)
    % Load the data
    DATA = load(BATHYFile);
    ScarShapedata = readmatrix(SCARFile);
    
    % Extract X, Y, Z coordinates from the data
    X = DATA(:, 1);
    Y = DATA(:, 2);
    Z = DATA(:, 3);
    
    % Define the area boundaries
    x_area_min = min(X);
    x_area_max = max(X);
    y_area_min = min(Y);
    y_area_max = max(Y);
    
    % Create a grid for interpolation
    [xq, yq] = meshgrid(x_area_min:OrigindataResolution:x_area_max, y_area_min:OrigindataResolution:y_area_max);
    zq = griddata(X, Y, Z, xq, yq, 'linear');
    Z = zq(:);
    
    % Reconstruct the landslide area
    [X, Y, reconstructedZ, reconstructedZq] = reconstructProcess(xq, yq, zq, ScarShapedata);
    
    % Apply Gaussian smoothing within the specified gauss zone
    [X, Y, reconstructedZSmooth] = applyGaussianSmoothing(xq, yq, reconstructedZq, SMOOTHZoneFile, gausscore);
    reconstructedZSmooth = reconstructedZSmooth - min(reconstructedZSmooth);
 
end

function [X, Y, reconstructedZ, reconstructedZq] = reconstructProcess(xq, yq, zq, ScarShapedata)
    % Initialize cell arrays for storing coordinates
    polygonsX = cell(1, size(ScarShapedata, 2)/2);
    polygonsY = cell(1, size(ScarShapedata, 2)/2);

    % Loop to separate X and Y coordinates and remove NaN
    for i = 1:2:size(ScarShapedata, 2)
        slideX = ScarShapedata(:, i);
        slideY = ScarShapedata(:, i+1);
        
        % Remove NaN values
        slideX = slideX(~isnan(slideX));
        slideY = slideY(~isnan(slideY));
        
        % Store in cell arrays
        polygonsX{(i+1)/2} = slideX;
        polygonsY{(i+1)/2} = slideY;
    end
    % Initialize the cumulative mask as false for all grid points
    cumulativeMask = false(size(xq));
    
    % Loop through all polygons to update the cumulative mask
    for i = 1:length(polygonsX)
        % Check if points are inside the current polygon
        [in, on] = inpolygon(xq, yq, polygonsX{i}, polygonsY{i});
        mask = in | on;  % Combine points inside and on the boundary
        
        % Update the cumulative mask to include points inside or on this polygon
        cumulativeMask = cumulativeMask | mask;
    end
    
    % Now cumulativeMask contains true for points inside any of the polygons

    % Clip the DEM data using the mask
    clippedZ = zq;
    clippedZ(cumulativeMask) = NaN; % Set values inside the polygon to NaN

    % % Interpolate over NaN values using griddata 'linear'
    xq_valid = xq(~isnan(clippedZ));
    yq_valid = yq(~isnan(clippedZ));
    zq_valid = zq(~isnan(clippedZ));

    reconstructedZq = griddata(xq_valid, yq_valid, zq_valid, xq, yq, 'linear');
    X = xq(:);
    Y = yq(:);
    reconstructedZ = reconstructedZq(:);
end

function [X, Y, blurredZ] = applyGaussianSmoothing(xq, yq, zq, SMOOTHZoneFile, gausscore)
    % Load Gaussian smoothing zone data
    gaussData = readmatrix(SMOOTHZoneFile);
    gaussX = gaussData(:, 1);
    gaussY = gaussData(:, 2);

    % Remove NaN values
    gaussX = gaussX(~isnan(gaussX));
    gaussY = gaussY(~isnan(gaussY));


    % Identify points inside the gausszone
    [in, on] = inpolygon(xq, yq, gaussX, gaussY);
    mask = in | on;  % Combine points inside and on the boundary
    % Create a subset of original elevation data
    z_blurred = imgaussfilt(zq, gausscore);
    zq(mask) = z_blurred(mask);

    X = xq(:);
    Y = yq(:);
    blurredZ = zq(:); % Flatten the array
end


