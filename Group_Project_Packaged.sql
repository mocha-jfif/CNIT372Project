-- Let's begin!

-- Drop tables.

DROP TABLE GP_Videos;
DROP TABLE GP_Influencers;
DROP TABLE GP_Interactions;

-- Create tables.
CREATE TABLE GP_Videos (
    Video_Title VARCHAR2(256) NOT NULL,
    Total_Views NUMBER,
    Duration_Time TIMESTAMP,
    Duration_Seconds NUMBER,
    Date_Uploaded DATE,
    Has_Subtitles VARCHAR2(3),
    Has_Description VARCHAR2(3),
    Total_Hashtags NUMBER,
    Max_Quality NUMBER,
    
    PRIMARY KEY (Video_Title)
);
    
CREATE TABLE GP_Influencers (
    Video_Title VARCHAR2(256) NOT NULL,
    Creator_Name VARCHAR2(64),
    Creator_Gender VARCHAR2(6),
    Total_Subscribers NUMBER,
    Total_Views NUMBER,
    Total_Videos NUMBER,
    Total_Playlists NUMBER,
    
    PRIMARY KEY (Video_Title)
);

CREATE TABLE GP_Interactions (
    Video_Title VARCHAR2(256) NOT NULL,
    Total_Likes NUMBER,
    Total_Comments NUMBER,
    Last_Comment_Date DATE,
    Has_Premiered VARCHAR2(3),
    Weekly_Posts NUMBER,
    
    PRIMARY KEY (Video_Title)
);

CREATE OR REPLACE PACKAGE YouTube_Analysis
AS
    -- Question 1 [Alexis]
    
    
    -- Question 2 [Alexis]
    
    
    -- Question 3 [Sean]
    PROCEDURE Get_Average_Popularity_Measurements (p_comparison IN VARCHAR2, p_duration IN NUMBER);
    
    -- Question 4 [Sean]
    PROCEDURE Get_Average_Subscribers (p_comparison IN VARCHAR2, p_duration IN NUMBER);
    
    -- Question 5 [Natsu]
    PROCEDURE video_date;
    
    -- Question 6 [Natsu]
    PROCEDURE subscribed_channels;
    
    -- Question 7 [Collin]
    
    
    -- Question 8 [Collin]
    
    
    -- Question 9 [Collin]
    
    
    -- Question 10 [Natsu]
    PROCEDURE count_hashtags;
END YouTube_Analysis;
/

CREATE OR REPLACE PACKAGE BODY YouTube_Analysis
AS  
    -- Question 3 [Sean]
    PROCEDURE Get_Average_Popularity_Measurements (p_comparison IN VARCHAR2, p_duration IN NUMBER)
    AS
        -- Define variables.
        v_total_views NUMBER := 0;
        v_total_likes NUMBER := 0;
        v_total_comments NUMBER := 0;
        v_total_videos NUMBER := 0;
        
        v_average_views NUMBER;
        v_average_likes NUMBER;
        v_average_comments NUMBER;
        
        -- Define cursors.
        CURSOR c_videos_greater IS
            SELECT GP_Videos.Video_Title, GP_Videos.Total_Views, GP_Interactions.Total_Likes, GP_Interactions.Total_Comments
            FROM GP_Videos INNER JOIN GP_Interactions
                ON GP_Videos.Video_Title = GP_Interactions.Video_Title
            WHERE Duration_Seconds >= p_duration;
        
        CURSOR c_videos_less IS
            SELECT GP_Videos.Video_Title, GP_Videos.Total_Views, GP_Interactions.Total_Likes, GP_Interactions.Total_Comments
            FROM GP_Videos INNER JOIN GP_Interactions
                ON GP_Videos.Video_Title = GP_Interactions.Video_Title
            WHERE Duration_Seconds <= p_duration;
    BEGIN
        -- Loop through c_videos_greater if the user specifies the "greater" comparison.
        IF LOWER(p_comparison) = 'greater' THEN
            FOR video IN c_videos_greater LOOP
                -- Add the current videos's views, likes, and comments to the totals and increment the amount of videos taken into consideration thus far.
                v_total_views := v_total_views + video.Total_Views;
                v_total_likes := v_total_likes + video.Total_Likes;
                v_total_comments := v_total_comments + video.Total_Comments;
                
                v_total_videos := v_total_videos + 1;
            END LOOP;
            
            -- Check if the cursor was empty.
            IF v_total_videos != 0 THEN
                -- Calculate and print the average numbers of views, likes, and comments.
                v_average_views := ROUND((v_total_views / v_total_videos), 0);
                v_average_likes := ROUND((v_total_likes / v_total_videos), 0);
                v_average_comments := ROUND((v_total_comments / v_total_videos), 0);
        
                DBMS_OUTPUT.PUT_LINE('Influencers with average video durations of ' || p_duration || ' seconds or greater have ' || v_average_views || ' views, ' || v_average_likes || ' likes, and ' || v_average_comments || ' comments on average.');
            ELSE
                -- Print an error if the cursor was empty.
                DBMS_OUTPUT.PUT_LINE('ERROR: There are no videos that match the given criteria.');
            END IF;
        -- Loop through c_videos_less if the user specifies the "less" comparison.
        ELSIF LOWER(p_comparison) = 'less' THEN
            FOR video IN c_videos_less LOOP
                -- Add the current video's views, likes, and comments to the totals and increment the amount of videos taken into consideration thus far.
                v_total_views := v_total_views + video.Total_Views;
                v_total_likes := v_total_likes + video.Total_Likes;
                v_total_comments := v_total_comments + video.Total_Comments;
                
                v_total_videos := v_total_videos + 1;
            END LOOP;
            
            -- Check if the cursor was empty.
            IF v_total_videos != 0 THEN
                -- Calculate and print the average numbers of views, likes, and comments.
                v_average_views := ROUND((v_total_views / v_total_videos), 0);
                v_average_likes := ROUND((v_total_likes / v_total_videos), 0);
                v_average_comments := ROUND((v_total_comments / v_total_videos), 0);
                
                DBMS_OUTPUT.PUT_LINE('Influencers with average video durations of ' || p_duration || ' seconds or less have ' || v_average_views || ' views, ' || v_average_likes || ' likes, and ' || v_average_comments || ' comments on average.');
            ELSE
                -- Print an error if the cursor was empty.
                DBMS_OUTPUT.PUT_LINE('ERROR: There are no videos that match the given criteria.');
            END IF;
        -- Print an error message if the comparison argument is not recognized.
        ELSE
            DBMS_OUTPUT.PUT_LINE('ERROR: Comparison argument not recognized. Please enter "greater" or "less" as the comparison argument.');
        END IF;
    END Get_Average_Popularity_Measurements;
    
    -- Question 4 [Sean]
    PROCEDURE Get_Average_Subscribers (p_comparison IN VARCHAR2, p_duration IN NUMBER)
    AS
        -- Define variables.
        v_total_subscribers NUMBER := 0;
        v_total_creators NUMBER := 0;
        
        v_average_subscribers NUMBER;
        
        -- Define cursors.
        CURSOR c_creators_greater IS
            SELECT GP_Influencers.Creator_Name, GP_Influencers.Total_Subscribers
            FROM GP_Influencers INNER JOIN GP_Videos
                ON GP_Influencers.Video_Title = GP_Videos.Video_Title
            WHERE Duration_Seconds >= p_duration;
        
        CURSOR c_creators_less IS
            SELECT GP_Influencers.Creator_Name, GP_Influencers.Total_Subscribers
            FROM GP_Influencers INNER JOIN GP_Videos
                ON GP_Influencers.Video_Title = GP_Videos.Video_Title
            WHERE Duration_Seconds <= p_duration;
    BEGIN
        -- Loop through c_creators_greater if the user specifies the "greater" comparison.
        IF LOWER(p_comparison) = 'greater' THEN
            FOR creator IN c_creators_greater LOOP
                -- Add the current creator's subscribers to the total and increment the amount of subscribers taken into consideration thus far.
                v_total_subscribers := v_total_subscribers + creator.Total_Subscribers;
                
                v_total_creators := v_total_creators + 1;
            END LOOP;
            
            -- Check if the cursor was empty.
            IF v_total_creators != 0 THEN
                -- Calculate and print the average number of subscribers.
                v_average_subscribers := ROUND((v_total_subscribers / v_total_creators), 0);
        
                DBMS_OUTPUT.PUT_LINE('Influencers with average video durations of ' || p_duration || ' seconds or greater have ' || v_average_subscribers || ' subscribers on average.');
            ELSE
                -- Print an error if the cursor was empty.
                DBMS_OUTPUT.PUT_LINE('ERROR: There are no influencers with videos that match the given criteria.');
            END IF;
        -- Loop through c_creators_less if the user specifies the "less" comparison.
        ELSIF LOWER(p_comparison) = 'less' THEN
            FOR creator IN c_creators_less LOOP
                -- Add the current creator's subscribers to the total and increment the amount of subscribers taken into consideration thus far.
                v_total_subscribers := v_total_subscribers + creator.Total_Subscribers;
                
                v_total_creators := v_total_creators + 1;
            END LOOP;
            
            -- Check if the cursor was empty.
            IF v_total_creators != 0 THEN
                -- Calculate and print the average number of subscribers.
                v_average_subscribers := ROUND((v_total_subscribers / v_total_creators), 0);
                
                DBMS_OUTPUT.PUT_LINE('Influencers with average video durations of ' || p_duration || ' seconds or less have ' || v_average_subscribers || ' subscribers on average.');
            ELSE
                -- Print an error if the cursor was empty.
                DBMS_OUTPUT.PUT_LINE('ERROR: There are no influencers with videos that match the given criteria.');
            END IF;
        -- Print an error message if the comparison argument is not recognized.
        ELSE
            DBMS_OUTPUT.PUT_LINE('ERROR: Comparison argument not recognized. Please enter "greater" or "less" as the comparison argument.');
        END IF;
    END Get_Average_Subscribers;
    
    -- Question 5 [Natsu]
    procedure video_date
    is
    begin
          DBMS_OUTPUT.PUT_LINE('Video upload years for short videos');
          DBMS_OUTPUT.PUT_LINE('----------------------------------');
          FOR vid IN (
          select to_char(date_uploaded, 'YYYY') as v, count(to_char(date_uploaded, 'YYYY')) as s
           from gp_videos
           where duration_seconds <= 120
           group by to_char(date_uploaded, 'YYYY')) 
       LOOP
          DBMS_OUTPUT.PUT_LINE('Year uploaded: ' || vid.v|| ' ' || 'Number of videos: ' || vid.s);
       END LOOP;
       
       DBMS_OUTPUT.PUT_LINE(' ');
       DBMS_OUTPUT.PUT_LINE('Video upload years for long videos');
       DBMS_OUTPUT.PUT_LINE('----------------------------------');
       
       FOR vid in 
           (
           select to_char(date_uploaded, 'YYYY') as v, count(to_char(date_uploaded, 'YYYY')) as l
           from gp_videos
           where duration_seconds >= 600
           group by to_char(date_uploaded, 'YYYY'))
        LOOP
            DBMS_OUTPUT.PUT_LINE('Year uploaded: ' || vid.v || ' ' || 'Number of videos: ' || vid.l);
        END LOOP;
       
    end;
    
    -- Question 6 [Natsu]
    procedure subscribed_channels
    is
        subscriber_count NUMBER;
        creatorname VARCHAR2(64);
    
    begin
        
        select total_subscribers
        into subscriber_count
        from gp_influencers join gp_videos on gp_influencers.video_title = gp_videos.video_title
        group by total_subscribers
        having avg(duration_seconds) between 120 and 420
        order by total_subscribers desc
        fetch first 1 row only;
        
        select creator_name
        into creatorname
        from gp_influencers join gp_videos on gp_influencers.video_title = gp_videos.video_title
        where total_subscribers = subscriber_count and rownum = 1
        group by creator_name
        having avg(duration_seconds) between 120 and 420;
        
        DBMS_OUTPUT.PUT_LINE('Creator name: ' || creatorname);
        DBMS_OUTPUT.PUT_LINE('Number of Subscribers: ' || subscriber_count);
    
       
    end;
    
    -- Question 7 [Collin]
    
    
    -- Question 8 [Collin]
    
    
    -- Question 9 [Collin]
    
    
    -- Question 10 [Natsu]
    procedure count_hashtags 
    is
        hashtag_count NUMBER;
        low_hashtag_count NUMBER;
    
    begin
        DBMS_OUTPUT.PUT_LINE('Videos with over 500,000 views');
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
        
        select avg(total_hashtags)
        into hashtag_count
        from gp_videos
        where total_views > 500000;
        
        DBMS_OUTPUT.PUT_LINE(hashtag_count);
          
       
       DBMS_OUTPUT.PUT_LINE(' ');
       DBMS_OUTPUT.PUT_LINE('Videos with under 500,000 views');
       DBMS_OUTPUT.PUT_LINE('-------------------------------');
       
       select avg(total_hashtags)
       into low_hashtag_count
       from gp_videos
       where total_views <= 500000;
       
       DBMS_OUTPUT.PUT_LINE(low_hashtag_count);
       
    end;
END YouTube_Analysis;
/