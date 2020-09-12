create table "requestY"
(
    id        serial not null
        constraint "requestY_pkey"
            primary key,
    client    varchar(300),
    email     varchar(300),
    "copName" varchar(300)
);

alter table "requestY"
    owner to rgyxqnrswarutq;

