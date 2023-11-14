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

-- Question 5 [Natsu]

-- Question 6

-- Question 7 [Collin]

-- Question 8 [Collin]

-- Question 9

-- Question 10
