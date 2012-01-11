/* Initialisation script for the backend database.
 */

-- FIXME: Some of these tables need renaming to make them more logical. E.g.
-- venue vs location.

/* An organisation whose members author papers.
 */
create table institution (
    id integer primary key asc autoincrement,
    name text                                    -- Name of the organisation.
);

/* An individual who produces papers.
 */
create table author (
    id integer primary key asc autoincrement,
    first_name text,                             -- First name.
    other_name text,                             -- Middle (or other) name.
    last_name text,                              -- Surname.
    email text,                                  -- Email address.
    institution_id integer,                      -- Organisation.
    constraint author_institution_fk foreign key (institution_id) references institution (id)
);

/* A city.
 */
create table location (
    id integer primary key asc autoincrement,
    name text,                                   -- City name.
    state text,                                  -- State (optional).
    country text                                 -- Country.
);

/* A conference, journal, etc. This table contains information about the venue
 * that is persistent across years. The event table holds information about
 * specific instances of a publication venue.
 */
create table venue (
    id integer primary key asc autoincrement,
    name text                                    -- Name of the conference.
);

/* An individual instance of a venue.
 */
create table event (
    id integer primary key asc autoincrement,
    venue_id integer,
    name text,                                   -- Optional name to override
                                                 -- that of the venue.
    year integer,                                -- Year of occurence.
    month integer,                               -- Month of occurence (1-12).
    volume integer,                              -- Journal volume.
    number integer,                              -- Journal number.
    edition integer,                             -- Book edition.
    location_id integer,                         -- Where the conference took
                                                 -- place.
    constraint event_venue_fk foreign key (venue_id) references venue (id),
    constraint event_location_fk foreign key (location_id) references location (id)
);

/* An individual publication.
 */
create table paper (
    id integer primary key asc autoincrement,
    title text,                                  -- Paper title.
    author_id integer,                           -- Primary author (optional?).
                                                 -- Other authors are handled
                                                 -- by the paper_author table.
    event_id integer,                            -- The conference/journal.
    constraint paper_author_fk foreign key (author_id) references author (id),
    constraint paper_event_fk foreign key (event_id) references event (id)
);

/* Link for the many-to-many relationship between paper and author.
 */
create table paper_author (
    paper_id integer,
    author_id integer,
    constraint paper_author_paper_fk foreign key (paper_id) references paper (id),
    constraint paper_author_author_fk foreign key (author_id) references author (id),
    primary key (paper_id, author_id)
);

/* Exit after creating structures. This command doesn't seem to be obeyed. */
.exit
