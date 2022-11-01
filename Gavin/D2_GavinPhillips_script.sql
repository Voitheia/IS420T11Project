-- Team: T11
-- Team Members:
-- Member 1: Gavin Phillips
-- Member 2: Zachary Livesay
-- Member 3: Nalia Pope
-- Member 4: Paul Rajapandi
-- Member 5: Rob Shovan

-- drop all the tables we are going to create
drop table orders;
drop table customers;
drop table inventory;
drop table menu_items;
drop table waiters;
drop table restaurants;
drop table cuisines;

-- drop all the sequences we are going to create
drop sequence cuisine_id_seq;
drop sequence restaurant_id_seq;
drop sequence waiter_id_seq;
drop sequence menu_item_id_seq;
drop sequence inventory_id_seq;
drop sequence customer_id_seq;
drop sequence order_id_seq;

-- create the cuisines table
create table cuisines (
    cuisine_id number not null,
    cuisine_name varchar2(20) not null,
    constraint cuisine_id_pk
        primary key (cuisine_id)
);

-- create the restaurants table
create table restaurants (
    restaurant_id number not null,
    restaurant_name varchar2(50) not null,
    restaurant_street_address varchar2(100) not null,
    restaurant_city varchar2(50) not null,
    restaurant_state varchar2(2) not null,
    restaurant_zipcode number not null,
    restaurant_cuisine_id number not null,
    constraint restaurant_id_pk
        primary key (restaurant_id),
    constraint restaurant_fk_cuisine_id
        foreign key (restaurant_cuisine_id)
        references cuisines (cuisine_id)
);

-- create the waiters table
create table waiters (
    waiter_id number not null,
    waiter_name varchar2(50) not null,
    waiter_restaurant_id number not null,
    constraint waiter_id_pk
        primary key (waiter_id),
    constraint waiter_fk_restaurant_id
        foreign key (waiter_restaurant_id)
        references restaurants (restaurant_id)
);

-- create the menu_items table
create table menu_items (
    menu_item_id number not null,
    menu_item_cuisine_id number not null,
    menu_item_name varchar2(20) not null,
    menu_item_price number not null,
    constraint menu_item_id_pk
        primary key (menu_item_id),
    constraint menu_fk_cuisine_id
        foreign key (menu_item_cuisine_id)
        references cuisines (cuisine_id)
);

-- create the inventory table
create table inventory (
    inventory_id number not null,
    inventory_menu_item_id number not null,
    inventory_menu_item_name varchar2(20) not null,
    inventory_restaurant_id number not null,
    inventory_quantity number not null,
    constraint inventory_id_pk
        primary key (inventory_id),
    constraint inventory_fk_menu_item_id
        foreign key (inventory_menu_item_id)
        references menu_items (menu_item_id),
    constraint inventory_fk_restaurant_id
        foreign key (inventory_restaurant_id)
        references restaurants (restaurant_id)
);

-- create the customers table
create table customers (
    customer_id number not null,
    customer_name varchar2(50) not null,
    customer_email varchar2(50) not null,
    customer_street_address varchar2(100) not null,
    customer_city varchar2(50) not null,
    customer_state varchar2(2) not null,
    customer_zipcode number not null,
    customer_credit_card number not null,
    constraint customer_id_pk
        primary key (customer_id)
);

-- create the orders table
create table orders (
    order_id number not null,
    order_restaurant_id number not null,
    order_customer_id number not null,
    order_menu_item_id number not null,
    order_waiter_id number not null,
    order_date DATE not null,
    order_amount_paid number not null,
    order_tip number not null,
    constraint order_id_pk
        primary key (order_id),
    constraint order_fk_restaurant_id
        foreign key (order_restaurant_id)
        references restaurants (restaurant_id),
    constraint order_fk_customer_id
        foreign key (order_customer_id)
        references customers (customer_id),
    constraint order_fk_menu_item_id
        foreign key (order_menu_item_id)
        references menu_items (menu_item_id),
    constraint order_fk_waiter_id
        foreign key (order_waiter_id)
        references waiters (waiter_id)
);

-- create sequences for primary keys
create sequence cuisine_id_seq start with 1;
create sequence restaurant_id_seq start with 1;
create sequence waiter_id_seq start with 1;
create sequence menu_item_id_seq start with 1;
create sequence inventory_id_seq start with 1;
create sequence customer_id_seq start with 1;
create sequence order_id_seq start with 1;

--turn on server output
set serveroutput on;

-- MEMBER 1 
-- insert sample cuisines into database
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Indian');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Nigerian');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Mexican');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'Swedish');
INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, 'German');

-- insert sample restaurants into database
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'El Guapo', '729A Frederick Rd', 'Catonsville', 'MD', 21228, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Mexican'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Suya Spot Nigerian Grill', '10309 Grand Central Ave', 'Owings Mills', 'MD', 21117, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Nigerian'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Chilis Bar and Grill', '502 Baltimore Pike', 'Bel Air', 'MD', 21014, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'American'));
INSERT INTO restaurants VALUES(restaurant_id_seq.nextval, 'Kabob and Curry', '827 Nursery Rd', 'Linthicum Heights', 'MD', 21090, (SELECT cuisine_id FROM cuisines WHERE cuisine_name = 'Indian'));

-- procedure that adds cuisine types
create or replace procedure newCuisine(cuisine_type IN varchar2)
    AS
    BEGIN
        INSERT INTO cuisines VALUES(cuisine_id_seq.nextval, cuisine_type);
    END;

-- test newCuisine procedure
exec newCuisine('Chinese');

-- procedure that adds new restaurant
create or replace procedure newRestaurant(
    r_name varchar2,
    r_street_address varchar2,
    r_city varchar2,
    r_state varchar2,
    r_zipcode number,
    r_cuisine_type varchar2
    )
    AS
    BEGIN
        INSERT INTO restaurants VALUES(
        restaurant_id_seq.nextval,
        r_name,
        r_street_address,
        r_city,
        r_state,
        r_zipcode,
        (SELECT cuisine_id FROM cuisines WHERE cuisine_name = r_cuisine_type));
    END;

-- test newRestuarant procedure
exec newRestaurant('Rathskeller', '5782 Main St', 'Elkridge', 'MD', 21075, 'German');

