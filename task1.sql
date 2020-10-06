drop table if exists info061020.likes;
drop table if exists info061020.users;
drop schema if exists info061020;

create schema info061020;
set search_path to info061020;

create table users (id serial primary key, name varchar(64) not null);
create table likes (liked_id serial, liked_by_id serial, 
primary key (liked_id, liked_by_id),
foreign key (liked_id) references users(id),
foreign key (liked_by_id) references users(id),
constraint samolike check (liked_id <> liked_by_id));

begin transaction;

insert into users (name) values ('Vanya'), ('Lox'), ('Nelox');

insert into likes values (1, 2), (2, 1), (1, 3), (3, 2);

commit;

select users.id as user_id, users.name, 
(select count(*) from likes where liked_id = users.id) as liked_him,
(select count(*) from likes where liked_by_id = users.id) as liked_by_him,
(select count(*) from likes L1 inner join likes L2
on L1.liked_by_id = L2.liked_id and L1.liked_id = L2.liked_by_id and users.id = L1.liked_by_id) as cross_likes
from users
order by liked_by_him desc;
