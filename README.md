# Tumblr Dashboard
## Overview 🖊️
This project was developed in Jun, 2022.
The aim of this project was to participate in an interview process. The company is private.
The idea is to build a small app in charge of managing the Tumblr dashboard of my user.
To get that, this app is using a third-party framework from Tumblr called [TMTumblrSDK](https://github.com/tumblr/TMTumblrSDK).

## Third parties 🤲
To manage the usage of third parties, this project has been configured with Cocoapods, because it was the only way to use TMTumblrSDK.
Reachability is being used to know in real-time if the app has network reachability. With that, I can cover cases like when a user is out of network, or when the network signal is weak.
TMTumblrSDK is a framework to get the Tumblr data instead use the public API.
The usage of TMTumblrSDK could bring some problems like having a direct dependency on an external framework, but in this project, I’ve added an abstraction to avoid this kind of problem.

## TMTumblrSDK abstraction 💭
The easy path is to use a framework and don’t think about the problems that you’re adding there.
What happens if you have to change this framework to another different one? Your code would be too coupled.
To solve that, I’ve applied the last SOLID principle, dependency inversion. I’ve created a protocol `URLSessionProtocol` and this framework is the one that has to consume my protocol.
Using this solution if I can change the framework without changing my production code.

## Viper architecture 🔨
The architecture chosen has been VIPER because
- VIPER provides a clean architecture
- All layers are testable
- The structure can be easily understandable
- The modules are easy to replicate

## Network layer 🌐
The app is using a simple network layer to retrieve data from TMTumblrSDK.
To manage data, I’ve added a DTO response that Decode the data from the framework to our environment.
The idea is to avoid dependencies from third parties, so I’ve added an abstraction `URLSessionProtocol` that is used by `ApiClientProtocol`.
All data retrieved is done by NetworkDataManagers. These classes only fetch the data (DTO) and map this data to our business model. In this case, the app only contains one screen, `NetworkDashboardDataManager` retrieves data (`DashboardResponse`) and maps this data to our model (`Posts`).

## CoreData layer 🏬
The app is using CoreData to maintain consistency to show the data in a proper way.
To avoid problems fetching and saving data from CD, all operations are done in background using `performBackgroundTask` operation.
The app has an NSManagedObject model to manage it inside CD environment. When this data is going to be fetched or saved, there is a mapper to transform data.

## Data flow ⤵️
One of the main aims of this app is to maintain data consistency. For that, the data that will be shown on the dashboard always will come from CoreData.
In a normal situation, the app fetches data from network and updates CoreData model with it, checking post id.
If a user scrolls the app, the network layer will fetch more data updating the limit parameter.
If the app doesn’t have reachability, it will fetch data from CoreData directly.
To avoid inconsistency problems if a user is losing network connectivity, the app saves the last timestamp and uses it to fetch posts from this timestamp.

## Image management

To avoid download images more than once, the images are being stored in a File in order to catch them.

## UI 👩‍🎨
The dashboard is a UITableViewController that has only one cell type: `DashboardCell`.
This cell will allow the injection of a UIView within the information to show.
Currently, the app is prepared to show images or text. The Video is not ready yet.
To inject the view inside the cell, we have `PostCellItemFactoryProtocol` to return any type of content.

## Security 🔒
To protect secrets keys I've added a secrets xcconfig file. The idea is to include this file in gitignore and avoid to have keys in our repository. 

## Unit test ✅
I’ve added unit tests to cover all business logic parts and also the CoreData mapper part.
