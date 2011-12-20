/* Initialisation script for the backend database.
 */

create table institution (
    id integer primary key asc autoincrement,
    name text                                    -- Name of the organisation.
);

create table author (
    id integer primary key asc autoincrement,
    first_name text,                             -- First name.
    other_name text,                             -- Middle (or other) name.
    last_name text,                              -- Surname.
    email text,                                  -- Email address.
    institution_id integer,                      -- Organisation.
    constraint author_institution_fk foreign key (institution_id) references institution (id)
);

/* Exit after creating structures. */
.exit
