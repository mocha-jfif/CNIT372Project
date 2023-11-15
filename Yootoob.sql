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
    Channel_Created DATE,
    
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

-- Question 1 [Alexis]

create or replace function mindur return number is
    minavgduration number;
begin
    select
        min(avg(v.duration_seconds))
    into
        minavgduration
    from
        gp_influencers i
    join
        gp_videos v on i.video_title = v.video_title
    group by
        i.creator_name;
    
    return minavgduration;
end;

create or replace function maxdur return number is
    maxavgduration number;
begin
    select
        max(avg(v.duration_seconds))
    into
        maxavgduration
    from
        gp_influencers i
    join
        gp_videos v on i.video_title = v.video_title
    group by
        i.creator_name;
    
    return maxavgduration;
end;

declare
    mincreate varchar2(64); 
    maxcreate varchar2(64); 
    mindur number;
    maxdur number;
    subcountmax number;
    subcountmin number;
begin
    select max(avgduration), max(creator_name)
    into maxdur, maxcreate
    from (
        select avg(v.duration_seconds) as avgduration, c.creator_name
        from gp_influencers c
        join gp_videos v on c.video_title = v.video_title
        group by c.creator_name
    );

    select min(avgduration), min(creator_name)
    into mindur, mincreate
    from (
        select avg(v.duration_seconds) as avgduration, c.creator_name
        from gp_influencers c
        join gp_videos v on c.video_title = v.video_title
        group by c.creator_name
    );
    
    select total_subscribers
    into subcountmax
    from gp_influencers
    where creator_name = maxcreate;
    
    select total_subscribers
    into subcountmin
    from gp_influencers
    where creator_name = mincreate;

    dbms_output.put_line('Influencer with maximum average duration (in seconds): ' || maxcreate);
    dbms_output.put_line('Average length: ' || maxdur);
    dbms_output.put_line('Number of subscribers: ' || subcountmax);
    dbms_output.put_line('- - - - - - - - - - - -');
    dbms_output.put_line('Influencer with minimum average duration (in seconds): ' || mincreate);
    dbms_output.put_line('Average length: ' || mindur);
    dbms_output.put_line('Number of subscribers: ' || subcountmin);
end;


-- Question 2

-- Question 3

-- Question 4 [Sean]

CREATE OR REPLACE PROCEDURE Get_Average_Subscribers (p_comparison IN VARCHAR2, p_duration IN NUMBER)
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
/

BEGIN
    Get_Average_Subscribers('greater', 600);
    Get_Average_Subscribers('less', 120);
END;
/

-- Question 5 

-- Question 6

-- Question 7 [Collin]
    
CREATE OR REPLACE PROCEDURE FindNewChannelsWithSubscribers
AS
BEGIN
    FOR ChannelInfo IN (
        SELECT
            GI.Creator_Name,
            GI.Total_Subscribers,
            AVG(GV.Duration_Seconds) AS AvgVideoLength
        FROM
            GP_Influencers GI
        JOIN GP_Videos GV ON GI.Video_Title = GV.Video_Title
        WHERE
            GI.Total_Subscribers > 100000
            AND ROW_NUMBER() OVER (PARTITION BY GI.Video_Title ORDER BY GI.Channel_Created DESC) = 1
        GROUP BY
            GI.Creator_Name, GI.Total_Subscribers
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Creator Name: ' || ChannelInfo.Creator_Name);
        DBMS_OUTPUT.PUT_LINE('Total Subscribers: ' || ChannelInfo.Total_Subscribers);
        DBMS_OUTPUT.PUT_LINE('Average Video Length: ' || ChannelInfo.AvgVideoLength);
        DBMS_OUTPUT.PUT_LINE('-----------------------');
    END LOOP;
END FindNewChannelsWithSubscribers;
/

-- Question 8 [Collin]

CREATE OR REPLACE PROCEDURE CalculateTotalViewsByDuration
AS
    vShortFormViews NUMBER := 0;
    vLongFormViews NUMBER := 0;
BEGIN

    SELECT
        NVL(SUM(GV.Total_Views), 0)
    INTO
        vShortFormViews
    FROM
        GP_Videos GV
    WHERE
        GV.Duration_Seconds < 120;


    SELECT
        NVL(SUM(GV.Total_Views), 0)
    INTO
        vLongFormViews
    FROM
        GP_Videos GV
    WHERE
        GV.Duration_Seconds > 600;


    DBMS_OUTPUT.PUT_LINE('Total Views for Short Form Content: ' || vShortFormViews);
    DBMS_OUTPUT.PUT_LINE('Total Views for Long Form Content: ' || vLongFormViews);


    IF vShortFormViews > vLongFormViews THEN
        DBMS_OUTPUT.PUT_LINE('Short Form Content has a higher total number of views.');
    ELSEIF vLongFormViews > vShortFormViews THEN
        DBMS_OUTPUT.PUT_LINE('Long Form Content has a higher total number of views.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Short Form and Long Form Content have the same total number of views.');
    END IF;
END CalculateTotalViewsByDuration;
/

-- Question 9

-- Question 10 [Natsu]

create or replace procedure count_hashtags 
is

begin
      DBMS_OUTPUT.PUT_LINE('Videos with over 500,000 views');
      DBMS_OUTPUT.PUT_LINE('-------------------------------');
      FOR vid IN (
      SELECT
         video_title, total_views, total_hashtags
      FROM (
        SELECT
            video_title, total_views, total_hashtags
        FROM gp_videos
        where total_views >= 500000
      ) subquery
   ) 
   LOOP
      DBMS_OUTPUT.PUT_LINE('Video title: ' || vid.video_title || ' Number of views: ' || vid.total_views
      || ' Total Hashtags: ' || vid.total_hashtags);
   END LOOP;
   
   DBMS_OUTPUT.PUT_LINE(' ');
   DBMS_OUTPUT.PUT_LINE('Videos with under 500,000 views');
   DBMS_OUTPUT.PUT_LINE('-------------------------------');
   FOR vid IN (
      SELECT
         video_title, total_views, total_hashtags
      FROM (
        SELECT
            video_title, total_views, total_hashtags
        FROM gp_videos
        where total_views < 500000
      ) subquery
   ) 
   LOOP
      DBMS_OUTPUT.PUT_LINE('Video title: ' || vid.video_title || ' Number of views: ' || vid.total_views
      || ' Total Hashtags: ' || vid.total_hashtags);
   END LOOP;
end;
