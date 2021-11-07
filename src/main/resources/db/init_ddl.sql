create table t_hu(
    hu_no int primary key
);

create table t_host(
                       h_no int auto_increment primary key,
                       h_id varchar(10) not null,
                       h_name varchar(5) not null,
                       h_password varchar(13) not null,
                       salt varchar(1000) not null,
                       hu_no int not null,
                       foreign key (hu_no) references t_hu(hu_no)
);

create table t_user(
                       u_no int auto_increment primary key,
                       u_id varchar(10) unique not null,
                       u_name varchar(5) not null,
                       u_password varchar(1000) not null,
                       salt varchar(1000) not null,
                       u_birth date not null,
                       u_wallet int unsigned default 0,
                       u_time time default 0,
                       hu_no int,
                       u_profile varchar(100),
                       r_dt datetime default now(),
                       m_dt date,
                       u_totalPayment int,
                       u_totalTime time default 0,
                       foreign key (hu_no) references t_hu(hu_no)
);

create table f_code_d(
                         i_f int auto_increment primary key,
                         val varchar(30) not null
);

create table t_food(
                       seq int auto_increment primary key,
                       i_f int,
                       f_price int not null,
                       f_pic varchar(1000) not null,
                       f_name varchar(20) not null,
                       foreign key (i_f) references f_code_d(i_f)
);

create table user_food(
                          u_no int,
                          seq int,
                          total_quantity int,
                          primary key (u_no, seq),
                          foreign key (u_no) references t_user(u_no),
                          foreign key (seq) references t_food(seq)
);

create table s_code_d(
                         s_no int auto_increment primary key,
                         s_val varchar(30) not null
);

CREATE TABLE t_seat(
                       u_no INT,
                       s_no INT,
                       s_occupied INT NOT NULL,
                       FOREIGN KEY (u_no) REFERENCES t_user(u_no),
                       FOREIGN KEY (s_no) REFERENCES s_code_d(s_no)
);