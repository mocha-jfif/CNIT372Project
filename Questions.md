

**What is our goal**
> Our goal is to determine how successful a content creator on YouTube is based on metrics such as their subscriber count and view count in relation to the average video length they produce. This data can be analyzed to see how much any one factor affects the success of a creator, and if there are any combinations of factors that correlate to the success of a channel. 


**Which influencer or creator has the shortest and longest average video length, and how many subscribers do they have?**

>This question is an important basis to make the rest of the assumptions about the popularity based on video length. We will look at the average video length related to how many subscribers they have, which is then used for the next question. This is useful for both data analysts and content creators trying to grow their channels. This is a basic SQL query, selecting the names of the channels that have the shortest and longest average video length, using maximum and minimums, as well as their subscriber count. 

**Find the influencer with the highest subscriber count and with the lowest subscriber count. Using the previous influencers found, how do these influencers compare to those who have the highest and lowest metrics? (Subscribers, views, etc.)**

>This is an important comparison tool in order to determine if video length does contribute to success. Comparing the influencers based on the number of subscribers or views they have provides an indicator of whether video length contributes directly to success or not. This also is a basic SQL query, by selecting the names of the channels with the maximum subscriber count and the minimum subscriber count. 

**Find the average viewer count, number of likes, and number of comments on short videos (less than 2 minutes) and long videos (more than 10 minutes).**

>This helps determine how well short-form content does on YouTube. This can help content creators find out what kind of content will garner more views and interactions, and therefore help their channel grow more. Short-form content has become exceedingly popular thanks to new social media trends, such as TikTok and Instagram. Long-form content has historically been more popular than short-form, and longer videos generally provide more information on any given topic. We plan to use subqueries to get a list of all short and long videos, and then get average values from those lists. 

**Find the average subscriber count for content creators who primarily make short videos (less than 2 minutes) and long videos (more than 10 minutes).**

>This helps us learn how much the average viewer in interested in a specific creator’s short-form content. Modern social media usually offers content from an extremely wide range of creators in a feed that plays short videos one after another, so viewers are constantly exposed to different creators and subjects. Content creators who make longer videos typically focus on a few specific topics of interest, and their content is based on those topics. We can use PL/SQL to loop through all videos made by specific content creators and calculate their average subscriber counts. 

**Find the channel creation date for influencers who primarily make short videos and for those who primarily make long videos.**

>This helps us learn how the period of when a channel was created can influence the content they create. Short videos and hashtags are relatively newer concepts on YouTube compared to long videos, comments, and likes, so it is possible that older channels can achieve their success without adding shorts or hashtags as they have loyal subscribers who have always liked their long videos. This would be an SQL query which would select and display the creation dates of the channels and what form of videos they post mostly.  

**Find the most subscribed channels with videos typically made in the intermediate range of time (2-7 minutes). How does this compare with view count for longer and shorter videos?**

>This helps us understand the differences between short and long form content versus the bridge between the two and how these differences affect view count in corresponding videos. Also attempts to answer the question of which length of videos are usually preferred by the maximum amount of people. We will use an SQL query to find the most subscribed channels with a certain average video length. 

**Find the newest channels with a large number of subscribers (greater than 100,000). What length of video do they make on average?**

>How do the trends in video length affect the success of newer content creators? The question attempts to answer that and provide evidence for a trend in popularity of certain lengths of content and their popularity. It will be interesting to see which forms of content newer creators are favoring to grow their popularity. We will use an SQL query to find the newest channels in the dataset and then subsequently identify their video length data. 

**Find the total watch time that creators have achieved when creating long and short form content (less than two minutes vs greater than 10 minutes). Which group is cultivating a higher total watch time?**

>This question will show which content is more desirable by consumers on the platform based on the length of the content itself. We will see whether long form content is still being appreciated and paid attention to, or that short form content is simply more consumable and preferred. This will provide interesting insights into the percentage of videos are being watched and fully consumed. We will use PL/SQL to calculate the total watch time of all viewers on various short and long videos. 

**Find the average video length of a video with more than 500,000 views, and the average video length of a video with less than that.**

>This question can give an idea on which video length is more likely to be successful in terms of view count. YouTube shorts are 60 seconds or less, so if the average video length is shorter than that it will imply that short videos are more likely to be popular. This would be an SQL query where the average video length would be calculated for videos that have over 500000 views. 

**Count how many hashtags a video with over 500,000 views has, and how many a video with less views has.**

>This question can help us understand how factors like hashtags can affect the success of a video. Videos with hashtags may have more views as it is likely easier to access for non-subscribers and has a bigger chance of going viral. This would be an SQL query that would count the number of hashtags per each video that has over 500000 views. 
