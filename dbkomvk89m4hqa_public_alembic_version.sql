create table alembic_version
(
    version_num varchar(32) not null
        constraint alembic_version_pkc
            primary key
);

alter table alembic_version
    owner to rgyxqnrswarutq;

INSERT INTO public.alembic_version (version_num) VALUES ('a359f5fca5db');