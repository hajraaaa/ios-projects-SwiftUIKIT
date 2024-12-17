# Image Collection App

This iOS application demonstrates a simple pattern for managing a collection of images using a `UICollectionView`. The app features a custom cell with an "Add Image" button that allows users to upload images from their gallery or camera. The layout is configured programmatically to provide a dynamic and user-friendly interface.

## Features

- **Collection View**: Displays a grid of images using a `UICollectionView`.
- **Custom Cell**: Each cell includes an `UIImageView` and an "Add Image" button.
- **Image Selection**: Clicking the "Add Image" button presents an action sheet for selecting an image from the gallery or camera.
- **Dynamic Layout**: The "Add Image" button cell moves to the end of the collection view after an image is added.
- **Custom Layout Configuration**: The collection view's layout is set up programmatically, including manual configuration of button attributes and values.

## Installation and Setup

### Prerequisites

- Xcode 12 or later
- iOS 13.0 or later

### Steps to Run the App

1. **Clone the Repository**
   
   git clone https://github.com/yourusername/image-collection-app.git
   
   Replace `yourusername` with your GitHub username.

3. **Open the Project in Xcode**

   Navigate to the project folder and open the `.xcodeproj` file. Xcode will launch the project.

4. **Build the Project**

   Select your target device or simulator. Press `Cmd + B` to build the project.

5. **Run the Project**

   Press `Cmd + R` to run the app on the selected device or simulator.

## How It Works

- **Collection View**: Displays a grid of images with one cell dedicated to the "Add Image" button.
- **Custom Cell**: The `CustomCell` class contains an `UIImageView` and a UIButton configured to add images.
- **Image Selection**: The "Add Image" button opens an action sheet allowing users to choose between the gallery or camera. Selected images are added to the collection view.
- **Dynamic Layout**: After adding an image, the "Add Image" button cell moves to the end of the collection view. The layout is configured programmatically to handle this dynamic behavior.
- **Custom Layout**: The collection view’s layout, including item size, spacing, and section insets, is set up programmatically, allowing for precise control over cell positioning and appearance.
