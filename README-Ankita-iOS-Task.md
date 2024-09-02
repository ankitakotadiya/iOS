# iOS Engineer at Monzo: Take Home Test

### What were your priorities, and why?
Initially, I spent some time getting familiar with the codebase and understanding its existing functionality. This allowed me to identify several bugs and concerns, including issues that were causing the application to crash. 
After assessing the situation, I took note of all the problems and concerns.

My first priority was to establish a scalable architecture that would not only address the current issues but also support future growth. By restructuring the architecture, I created a solid foundation that made it easier to fix the remaining issues. 
I then proceeded to design the screens according to the provided mockups, opting for a programmatic approach to ensure future flexibility and ease of adjustments.

With the architecture in place and the UI components aligned with the design requirements, I turned my attention to the core functionality. As I developed each feature, I made sure that the implementation could be easily scaled and maintained. 
Alongside this, I addressed the tightly coupled network issues, gradually decoupling them to improve modularity.

My approach was to prioritize the development of a scalable and flexible architecture, ensuring that core functionality was robust and extensible. 
Once that foundation was set, I systematically resolved the other issues, leading to a more stable and maintainable application.

### If you had another two days, what would you have tackled next?
I've invested time in fixing as many issues as possible to ensure the application is functioning as required. 
However, to further guarantee everything is working correctly, I plan to write comprehensive test cases that will automate the verification process. 
This will help ensure that the app meets all requirements consistently. Additionally, I will collaborate closely with the cross-functional team to ensure that every aspect is thoroughly tested and nothing is overlooked.

### What would you change about the structure of the code?
For large team-based projects, I prioritize collaboration to address challenges effectively. This ensures a cohesive approach to problem-solving and project execution.

I encountered some difficulties with the existing architecture, which complicated testing and led to random crashes. Specifically, I found that views created using XIBs were challenging to scale, especially for dynamic screens.

Initially, networking, local database management, and model classes were consolidated into a single class. This setup caused various issues, which I resolved by refactoring the code. I introduced common classes to enhance reusability across the app and ensured that each entity has a single responsibility. This was achieved through dependency injection.

### What bugs did you find but not fix?
I would like to review the coordinator flow one more time to ensure it does not introduce any new issues. Additionally, there is a design element involving a search icon and placeholder positioned in the middle of the field. I want to confirm that users can type from the center of the field as intended. Based on this confirmation, I will address any necessary fixes.

I have made efforts to resolve other bugs and will continue to work closely with the quality assurance team to identify and fix any remaining issues.

### What would you change about the visual design of the app?
To enhance user experience, placing the "Favorite" button within the image block will make it more noticeable and easily accessible. Additionally, the "Favorites" button can be positioned on the navigation bar for convenient access to the user's favorite items.

Furthermore, it would be beneficial to implement an API endpoint for marking items as favorites. This would allow us to send this information to the server, ensuring that user preferences are preserved and can be retrieved in case of data loss.

Lastly, incorporating a scrollable content area within a defined bounding box would improve usability and ensure a more organized layout.

### Approximately how long you spent on this project.

