
# Reconstruct LandslideArea

## Summary

The `reconstructLandslideArea` function reconstructs a landslide area using digital elevation model (DEM) data and applies Gaussian smoothing based on specified zones. It allows users to process raw bathymetric and scar data, reconstruct the landslide region, and generate a smoothed elevation profile for further analysis.

## Description

The `reconstructLandslideArea` function is designed to process and analyze DEM data to reconstruct the landslide area. The function follows these steps:

1. **Data Loading**: 
   Loads bathymetric (BATHY) data and scar shape data from user-specified files.
   
2. **Grid Creation and Interpolation**: 
   Creates a grid based on the minimum and maximum coordinates in the dataset and interpolates the elevation data over this grid.
   
3. **Landslide Reconstruction**: 
   Reconstructs the landslide area by applying masks based on the scar shape data, clipping the DEM data accordingly. The missing data is then interpolated to create a continuous surface.
   
4. **Gaussian Smoothing**: 
   Applies Gaussian smoothing within a user-defined zone to smooth out the elevation data, enhancing the visualization of the reconstructed landslide area.
   
## Inputs

- **`OrigindataResolution`**: Resolution for the interpolation grid.
- **`gausscore`**: The Gaussian smoothing parameter.
- **`SCARFile`**: Path to the scar shape file.
- **`SMOOTHZoneFile`**: Path to the Gaussian smoothing zone file.
- **`BATHYFile`**: Path to the bathymetric data file.

## Outputs

- **`X, Y`**: The X and Y coordinates of the grid points after processing.
- **`Z`**: The original elevation data interpolated on the grid.
- **`reconstructedZSmooth`**: The reconstructed and smoothed elevation data after applying the Gaussian filter.

## Use Case

This function is useful for researchers and engineers working on landslide analysis, terrain visualization, and related geospatial studies. The ability to reconstruct and smooth landslide areas from raw DEM data makes it a powerful tool for generating accurate and visually appealing representations of terrain changes.

## Example Usage

```matlab
% Example of how to call the function
[X, Y, Z, reconstructedZSmooth] = reconstructLandslideArea(1, 20, 'scarfile.dat', 'smoothzone.dat', 'bathymetry.dat');
```
![Asset 6](https://github.com/user-attachments/assets/f541163e-b6a5-4853-b8a4-647a1a79ac92)


## Contributing

If you would like to contribute to this project, please submit a pull request or open an issue.

## Contact

For any questions or suggestions, feel free to contact the author at raylinking36@gmail.com
