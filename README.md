# FetchProject

### Summary: Include screen shots or a video of your app highlighting its features
My app is a SwiftUI-based recipe viewer built using the MVVM architecture. It fetches a list of recipes from an API and displays detailed recipe info such as name, cuisine, image, and links to source and YouTube tutorials. The UI is responsive and includes pull-to-refresh functionality. The separation of concerns provided by MVVM made the codebase easier to manage, test, and scale.

<p align="center">
  <img src="https://github.com/user-attachments/assets/64bd8545-4c62-46d3-b01a-25d5b74eae4d" alt="Simulator Screenshot - iPhone 15 Pro - 2025-04-14 at 17:10:43" width="300"/>
</p>
[Download Screen Recording](https://github.com/user-attachments/files/19746480/Screen.Recording.2568-04-14.at.21.31.51.zip)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I prioritized image caching, performance optimization, and concurrency. Since the app heavily relies on remote image loading, I implemented a custom ImageCache class that downloads, hashes, and stores images locally using a filesystem-safe SHA256 hash of the image URL. This reduces repeated downloads, speeds up scrolling performance, and ensures the cache is persistent between sessions. I also used Swift’s async/await to simplify asynchronous image loading.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent approximately 7-10 hours on the project, broken down as follows:
- 2 hours for building the base UI and recipe model
- 3 hours implementing and testing the image cache
- 2–3 hours writing unit tests, documenting, and debugging

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
- I chose to use a hashed file name instead of the URL's last path component to avoid file system issues and guarantee uniqueness—even when images have identical names or query parameters.
- Instead of third-party image libraries like SDWebImage, I used a native solution to demonstrate my understanding of file I/O, concurrency, and custom caching logic.
- I opted for simplified error handling in the image cache (e.g., silent fails for file I/O) to keep the logic clean and avoid app crashes from non-critical errors.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The current design lacks a cache expiration policy, which means cached images will persist indefinitely unless manually cleared. In a real-world scenario, I would want to implement time-based invalidation or storage size limits. Additionally, I could improve the user experience with image placeholders or loading indicators while images are being fetched.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
- My laptop crashed and both Finder and Xcode became unresponsive for half a day. I spent most of the day troubleshooting and fixing the issue before I could finalize and submit the project.
- The ImageCache class creates a dedicated directory inside the system caches folder. All images are saved with a SHA256-based filename to avoid conflicts and support long URLs.
- The cache is cleared manually via clearCache(), which could be hooked into app settings or memory warnings.
