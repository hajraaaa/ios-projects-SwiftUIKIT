# Country App

This iOS application displays a list of countries alphabetically and allows users to select countries using checkboxes. The selected countries can be viewed on a separate screen. The app is built using the MVC (Model-View-Controller) design pattern.

## Features

- **Alphabetical Listing**: The app displays a list of countries grouped alphabetically using a UITableView.
- **Country Selection**: Users can select countries via checkboxes. Once a country is selected, a button labeled "Show Selected Countries" appears at the bottom of the screen.
- **Navigation to Selected Countries**: Clicking the "Show Selected Countries" button navigates to a new screen where the selected countries are displayed in a list.
- **Search Functionality**: The app includes a search bar that allows users to filter the list of countries by name.
- **Clear Selection**: The "Clear" button clears all selected countries.
- **Mark All Countries**: The "Mark All" button selects all countries in the list.

## Installation and Setup

### Prerequisites

- Xcode 12 or later
- iOS 13.0 or later

### Steps to Run the App

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/country-app.git
   ```
   Replace `yourusername` with your GitHub username.

2. **Open the Project in Xcode**
   - Navigate to the project folder and open the `.xcodeproj` file.
   - Xcode will launch the project.

3. **Build the Project**
   - Select your target device or simulator.
   - Press `Cmd + B` to build the project.

4. **Run the Project**
   - Press `Cmd + R` to run the app on the selected device or simulator.

### How It Works

- **Alphabetical Listing**: The app displays countries grouped alphabetically in a UITableView. Each section represents a letter, and the countries under each section start with that letter.
  
- **Country Selection**: Users can select countries by tapping the checkbox next to the country name. When a country is selected, it is added to the `selectedCountries` array, and the "Show Selected Countries" button appears.

- **Show Selected Countries**: When the "Show Selected Countries" button is clicked, the app navigates to a new screen that displays the list of selected countries.

- **Search Bar**: Users can type in the search bar to filter the list of countries. The app dynamically updates the list based on the search input.

- **Clear Button**: The "Clear" button deselects all selected countries, hiding the "Show Selected Countries" button and refreshing the UITableView.

- **Mark All Button**: The "Mark All" button selects all the countries displayed in the list. If any countries are selected, the "Show Selected Countries" button is shown.
