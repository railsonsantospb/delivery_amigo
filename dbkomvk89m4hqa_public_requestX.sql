create table "requestX"
(
    id         serial not null
        constraint "requestX_pkey"
            primary key,
    client     varchar(300),
    city       varchar(300),
    active     integer,
    price_full varchar(300),
    products   varchar(6000),
    date       varchar(300),
    address    varchar(300),
    lat        varchar(300),
    lon        varchar(300),
    email      varchar(300),
    id_cop     varchar(300),
    pay        varchar(300),
    phone      varchar(300),
    obs        varchar(3000)
);

alter table "requestX"
    owner to rgyxqnrswarutq;

INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (26, 'Railson Santos', 'Solanea', 0, '51.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #Budweiser 6x330ml=1=Ambev =21.00=Temos gelada ou natural #', '27-07-2020 11:55:01', 'Eptacio Pessoa, 234', '-6.7564919', '-35.6636148', 'railsonsantospb@gmail.com', '6', 'Em Dinheiro com Troco (de R$12)', '(83) 98142-2402', 'hggcjj');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (52, 'Railson Santos', 'Solanea', 0, '51.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #Budweiser 6x330ml=1=Ambev =21.00=Temos gelada ou natural #', '30-07-2020 09:26:22', 'Eptacio Pessoa, 234', '-6.7564929', '-35.6636073', 'railsonsantospb@gmail.com', '6', 'Em Dinheiro com Troco (de R$36)', '(83) 98142-2402', 'hhhhj');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (53, 'Railson Santos', 'Solanea', 0, '30.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #', '01-08-2020 19:00:11', 'Eptacio Pessoa, 284', '-6.7584471', '-35.6650252', 'railsonsantospb@gmail.com', '6', 'Em Dinheiro com Troco (de R$25)', '(83) 98142-2402', 'bbbbbb');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (54, 'Railson Santos', 'Solanea', 0, '30.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #', '01-08-2020 19:01:47', 'Eptacio Pessoa, 284', '-6.758416', '-35.6649851', 'railsonsantospb@gmail.com', '6', 'Em Dinheiro com Troco (de R$36)', '(83) 98142-2402', 'tv vv');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (55, 'Railson Santos', 'Solanea', 0, '30.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #', '01-08-2020 19:03:32', 'Eptacio Pessoa, 284', '-6.75836', '-35.6651567', 'railsonsantospb@gmail.com', '6', 'Em Dinheiro com Troco (de R$36)', '(83) 98142-2402', ' bbbbb');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (56, 'Railson Santos', 'Solanea', 0, '30.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #', '01-08-2020 21:59:44', ' bghfjjh, 45', '-6.7565045', '-35.6636706', 'railsonsantospb@gmail.com', '6', 'Em Dinheiro com Troco (de R$3)', '(88) 68868-5886', 'bnnbb');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (57, 'Railson Santos', '', 0, '30.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #', '03-08-2020 16:56:50', ' bghfjjh, 45', '-6.7671789', '-35.6558548', 'railsonsantospb@gmail.com', '6', 'Em Dinheiro com Troco (de R$36)', '(88) 68868-5886', 'cvcc');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (58, 'Rangel Andrade', '', 0, '42.0', 'Budweiser 6x330ml=2=Ambev =21.00=Temos gelada ou natural #', '06-08-2020 21:10:17', 'Travessa Pernambuco ', '-6.7671864', '-35.6558044', 'rangelandrade24052008@gmail.com', '6', 'Em Dinheiro com Troco (de R$8)', '(83) 99126-7263', 'gelada ');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (59, 'Railson Santos', '', 0, '30.0', 'Itaipava 12x473ml=1=Itaipava =30.00=Temos gelada ou natural #', '17-08-2020 16:32:11', ' bbnvggg', '-6.7671921', '-35.655823', 'railsonsantospb@gmail.com', '6', 'Cartão (de R$)', '(66) 86899-8989', 'bvkbb');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (60, 'Railson Santos', 'Solanea', 0, '60.0', 'RJ45=2=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '18-08-2020 07:34:50', ' bbnvggg', '-6.756501', '-35.6636243', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro com Troco (de R$66)', '(66) 86899-8989', 'bbbbb');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (61, 'Railson Santos', 'Solanea', 0, '60.0', 'RJ45=2=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '18-08-2020 07:38:14', ' bbnvggg', '-6.7565', '-35.6636269', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro com Troco (de R$6)', '(66) 86899-8989', ' bbjbvh');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (62, 'Railson Santos', 'Solanea', 0, '3000.0', 'RJ45=100=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '31-08-2020 14:36:59', 'Rua Eptacio Pessoa, 234', '-6.7565075', '-35.6636007', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro com Troco (de R$30)', '(83) 93220-223', 'Completo. ');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (63, 'railson', 'Solanea', 0, '3000.0', 'RJ45=100=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '03-09-2020 10:10:45', 'Eptacio Pessoa, 234', '-6.7564822', '-35.6636487', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro sem Troco (de R$)', '(83) 95624-4558', 'Obrigado. ');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (64, 'railson', 'Solanea', 0, '3000.0', 'RJ45=100=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '03-09-2020 10:11:53', 'Eptacio Pessoa, 234', '-6.7564883', '-35.6636248', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro com Troco (de R$25)', '(83) 95624-4558', 'vchvjg');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (96, 'railson', 'Solanea', 0, '3000.0', 'RJ45=100=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '07-09-2020 08:16:47', 'Eptacio Pessoa, 234', '-6.7564982', '-35.6636315', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro sem Troco (de R$)', '(88) 69868-6866', 'vc hchxhf');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (97, 'railson', 'Solanea', 0, '3000.0', 'RJ45=100=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '07-09-2020 08:18:47', 'Eptacio Pessoa, 234', '-6.7565148', '-35.6636401', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro sem Troco (de R$)', '(88) 69868-6866', 'vcjchghhv');
INSERT INTO public."requestX" (id, client, city, active, price_full, products, date, address, lat, lon, email, id_cop, pay, phone, obs) VALUES (98, 'railson', 'Solanea', 0, '3000.0', 'RJ45=100=Redes=30.0=O produto está disponível em um pacote com 40 unidades. #', '07-09-2020 08:19:39', 'Eptacio Pessoa, 234', '-6.7565202', '-35.6636229', 'railsonsantospb@gmail.com', '8', 'Em Dinheiro com Troco (de R$36)', '(88) 69868-6866', 'bbjhhj');