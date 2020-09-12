create table "user"
(
    id       serial not null
        constraint user_pkey
            primary key,
    email    varchar(300)
        constraint user_email_key
            unique,
    name     varchar(300),
    password varchar(300)
);

alter table "user"
    owner to rgyxqnrswarutq;

INSERT INTO public."user" (id, email, name, password) VALUES (1, 'railsonsantospb@gmail.com', 'railson', '123');
INSERT INTO public."user" (id, email, name, password) VALUES (34, 'leif_araujo@hotmail.com', 'givanildo ', 'kaua150308');
INSERT INTO public."user" (id, email, name, password) VALUES (35, 'playstorecnx675@gmail.com', 'Ushachinnu', 'Chinnu@143');
INSERT INTO public."user" (id, email, name, password) VALUES (36, 'blrplaystorebcp@gmail.com', 'jhon', 'Googleplay');
INSERT INTO public."user" (id, email, name, password) VALUES (37, 'vicentejr.sousa@gmail.com', 'João Vicente', 'vicentejr');