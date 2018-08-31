#create databases
#create schema p2p_sys_manage;
#create schema p2p_account;
#create schema p2p_trade_center;
#create schema p2p_data;
#create schema p2p_report;


#[sys user manager system tables]
DROP TABLE IF EXISTS p2p_sys_manage.s_user;
DROP TABLE IF EXISTS p2p_sys_manage.s_role_permission;
DROP TABLE IF EXISTS p2p_sys_manage.s_account;
DROP TABLE IF EXISTS p2p_sys_manage.s_permission;
DROP TABLE IF EXISTS p2p_sys_manage.s_account_role;
DROP TABLE IF EXISTS p2p_sys_manage.s_role_permission;

CREATE TABLE p2p_sys_manage.s_user(
	user_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'primary id',
    mobile VARCHAR(13) UNIQUE NULL COMMENT '手机号',
    real_name VARCHAR(50) NULL COMMENT '真实姓名',
    cert_no VARCHAR(30) NULL COMMENT '证件号码',
    email VARCHAR(100) NULL COMMENT '邮件地址',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注'
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT '系统用户基本信息表';

CREATE TABLE p2p_sys_manage.s_account(
	account_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'primary id',
    user_id INT NOT NULL COMMENT '用户id',
    account VARCHAR(30) UNIQUE NOT NULL COMMENT '登录账户',
    account_pwd CHAR(32) NOT NULL COMMENT '用户密码',
    account_status VARCHAR(20) NOT NULL COMMENT '账户状态see enum [AccountStatus]',
	create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注',
    FOREIGN KEY (user_id) REFERENCES s_user(user_id)
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT '系统账户信息表';

DROP TABLE IF EXISTS p2p_sys_manage.s_role;
CREATE TABLE p2p_sys_manage.s_role(
	role_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'primary id',
    role_name VARCHAR(30) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(32) UNIQUE NOT NULL COMMENT '角色代码',
    role_status VARCHAR(20) NOT NULL COMMENT '角色状态see enum [RoleStatus]',
	create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注'
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT '系统用户角色信息表';


CREATE TABLE p2p_sys_manage.s_permission(
	permission_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'primary id',
    permission_name VARCHAR(30) NOT NULL COMMENT '权限名称',
    permission_code VARCHAR(32) UNIQUE NOT NULL COMMENT '权限代码',
    permission_path VARCHAR(32) NULL COMMENT '权限访问路径',
    permission_status VARCHAR(20) NOT NULL COMMENT '权限状态see enum [PermissionStatus]',
    permission_type VARCHAR(20) NOT NULL COMMENT '权限类型see enum [PermissionType]',
    parent_permission_id INT NULL COMMENT '父级节点id',
	create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注'
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT '系统用户权限信息表';


CREATE TABLE p2p_sys_manage.s_account_role(
	account_role_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'primary id',
    account_id INT NOT NULL COMMENT '账户id',
    role_id INT NOT NULL COMMENT '角色id',
	create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注',
    UNIQUE KEY(account_id,role_id),
    FOREIGN KEY (role_id) REFERENCES s_role(role_id),
    FOREIGN KEY (account_id) REFERENCES s_account(account_id)
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT '系统用户账户和角色关联表';

CREATE TABLE p2p_sys_manage.s_role_permission(
	role_permission_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'primary id',
    role_id INT NOT NULL COMMENT '角色id',
    permission_id INT NOT NULL COMMENT '权限id',
	create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注',
    UNIQUE KEY(role_id,permission_id),
	FOREIGN KEY (role_id) REFERENCES s_role(role_id),
    FOREIGN KEY (permission_id) REFERENCES s_permission(permission_id)
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT '系统用户角色和权限关联表';


#[end sys user manager system tables]

#[p2p business system account model tables]

CREATE TABLE p2p_account.a_person(
	person_id varchar(32) PRIMARY KEY NOT NULL COMMENT 'primary id',
    mobile VARCHAR(13) NOT NULL COMMENT '手机号',
    real_name VARCHAR(100) NOT NULL COMMENT '真实姓名-encrypt',
    cert_no VARCHAR(100) NOT NULL COMMENT '证件号码-encrypt',
	real_name_md5 VARCHAR(32) NOT NULL COMMENT '真实姓名-md5',
    cert_no_md5 VARCHAR(32) NOT NULL COMMENT '证件号码-md5',
    cert_type varchar(30) not null comment '证件类型 see enum[certType]',
    real_name_auth_status varchar(30) not null comment '实名认证状态 see enum [realNameAuthStatus]',
    email VARCHAR(100) NULL COMMENT '邮件地址',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注',
    unique key(cert_no_md5)
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT 'p2p用户基本信息表';



CREATE TABLE p2p_account.a_login_account(
	login_account_id varchar(32) PRIMARY KEY NOT NULL COMMENT 'primary id',
    person_id varchar(32) NOT NULL COMMENT 'personId',
    mobile VARCHAR(13) UNIQUE NOT NULL COMMENT '注册手机号',
    account_name varchar(50) null comment '账户名称',
    account_pwd varchar(32) not null comment '账户密码-md5',
    account_status varchar(30) not null comment '账户状态 see enum [accountStatus]',
    last_login_time datetime null comment '上次登录时间',
    last_login_id datetime null comment '上次登录ip',
    last_login_client_type varchar(200) null comment '上次登录客户端类型see enum[lastLoginClientType]',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注',
    unique key(account_name)
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT 'p2p用户登录账户信息表';

CREATE TABLE p2p_account.a_login_log(
	login_log_id int AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'primary id',
    login_account_id VARCHAR(13) NULL COMMENT '登录账号id',
    mobile VARCHAR(13) null comment '手机号',
    login_ip varchar(50) DEFAULT NULL COMMENT '最后登录ip',
	login_time datetime DEFAULT NULL COMMENT '登录时间',
	login_res varchar(30) DEFAULT NULL COMMENT '登录结果 OK:成功 FAIL:失败',
	login_fail_reason varchar(256) DEFAULT NULL COMMENT '登录失败时原因',
	login_user_agent varchar(2000) DEFAULT NULL COMMENT '登录时用户客户端',
    last_login_client_type varchar(200) null comment '上次登录客户端类型see enum[lastLoginClientType]',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注'
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT 'p2p用户登录日志表';

CREATE TABLE p2p_account.a_capital_account(
	capital_account_id varchar(32) PRIMARY KEY NOT NULL COMMENT 'primary id',
    login_account_id VARCHAR(13) NULL COMMENT '登录账号id',
    person_id varchar(32) NOT NULL COMMENT 'personId',
    capital_account_status varchar(30) not null comment '资金账户状态',
    capital_account_code varchar(10) not null comment '资金账户编码',
    capital_account_role varchar(30) not null comment '资金账户角色',
    balance_amt decimal(14,4) default 0 not null comment '账户可用余额',
    freezed_amt decimal(14,4) default 0 not null comment '账户冻结金额',
    unconfirmed_amt decimal(14,4) default 0 not null comment '账户未确认金额',
    third_account_id varchar(32) null comment '三方平台资金账户id',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注'
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT 'p2p用户资金账户信息表';

CREATE TABLE p2p_account.a_third_account(
	third_account_id varchar(32) PRIMARY KEY NOT NULL COMMENT 'primary id',
    third_account_no varchar(50) null comment '三方平台资金账户编码',
    local_account_no varchar(50) null comment '本地平台资金账户编码',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    remark VARCHAR(200) NULL COMMENT '备注'
)ENGINE=INNODB  DEFAULT CHARSET=UTF8 COMMENT 'p2p用户三方平台账户信息表';


#[end p2p business system account model tables]