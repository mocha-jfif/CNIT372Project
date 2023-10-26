-- Let's begin!

-- Drop tables.

DROP TABLE GP_Videos;
DROP TABLE GP_Influencers;
DROP TABLE GP_Interactions;

-- Create tables.
CREATE TABLE GP_Videos (
    Video_Title VARCHAR2(256) NOT NULL,
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

-- Question 3 [Sean]

-- Question 4

-- Question 5 [Natsu]

-- Question 6

-- Question 7 [Collin]

-- Question 8 [Collin]

-- Question 9

-- Question 10
