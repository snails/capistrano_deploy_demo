# README

##首先配置SSH KEY
1. 在主机A“~/.ssh/”目录下执行命令“ssh-keygen -t rsa”（生成过程中，一路回车）,生成两个文件id_rsa和id_rsa_pub，这两个文件实际上是一个密钥对，id_rsa是私钥，id_rsa_pub是公钥；
2. 将文件id_rsa_pub从主机A拷贝（可以使用scp命令）到主机B“~/.ssh/”目录下；
3. 登陆到主机B上， 进入“~/.ssh/”目录，将从主机拷贝来的id_rsa_pub文件添加到文件“authorized_keys”尾部（cat id_rsa_pub>>authorized_keys）,若文件“authorized_keys”不存在，则创建；确保“~/.ssh/authorized_keys”的权限至少为600；

4. 从主机A登陆主机B，第一次登陆时主机B要自动设置known_hosts文件，所以需要输入yes，以后就不需要了。

## 部署主机上安装必要的库文件
>apt-get update

>apt-get install git gcc autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libsqlite3-dev

##安装Ruby 

请参考[Ruby-China Wiki](https://ruby-china.org/wiki/rvm-guide)

*如果有兴趣capistrano也可以自动安装ruby，分别为rvm和rbenv,这些都可以在他的[主页](https://github.com/capistrano/capistrano/wiki)找到*

##安装passenger & Nginx
>1.gem install passenger

>2.passenger-install-nginx-module #这里可能需要使用rvmsudo进行

>3.将nginx链接到/usr/local/sbin

>sudo ln -s /usr/local/nginx/sbin/nginx /usr/sbin/

##配置Nginx
1.修改hosts文件，给你的项目一个本地域名, 比如awesome_project.local

>$ sudo vim /etc/hosts

>127.0.0.1 local.dev

2.测试
>  ping local.dev
>  
>PING local.dev (127.0.0.1): 56 data bytes

>64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.090 ms

3.编辑nginx配置文件

>$ vim /usr/local/nginx/conf/nginx.conf

>nginx.conf Demo:

	worker_processes  1;

	events {

    worker_connections  1024;
 
	}

	http {
	  passenger_root /home/huyang/.rvm/gems/ruby-2.1.5@rails4/gems/passenger-4.0.55;
 	  passenger_ruby /home/huyang/.rvm/gems/ruby-2.1.5@rails4/wrappers/ruby;

      include       mime.types;
      default_type  application/octet-stream;
      sendfile        on;
      keepalive_timeout  65;

   	   server {
     	   listen       80;
     	   server_name  local.dev;
    	    root /www/demo/current/public;
    	    passenger_enabled on;
    	    rails_env production;
  	  }
	}

About Howto start nginx. visit: [Here](https://ruby-china.org/wiki/mac-nginx-passenger-rails)

##安装capistrano及配置
> 1. gem install capistrano

2.add these gems to the Gemfile

	group :development do
	  gem 'capistrano-rails'
	  gem 'passenger-capistrano'
	end

3.Install and initialize capistrano:

>bundle install

>cap install
 
4.Edit Capfile

	require 'capistrano/bundler'
	require 'capistrano/rails/assets'
	require 'capistrano/rails/migrations'
	require 'capistrano/passenger'

5.Edit deploy.rb 

请参考项目中的deploy.rb

6.编辑config/deploy/production.rb

主要是修改了ssh的端口和用户等信息，可以参考本项目下的文件

7.修改config/secrets.yml下的production项的secret_key_base

8.修改__.gitignore__,把database.yml不放到项目追踪目录上，因为里面的敏感信息比较多.这里使用database.example.yml 
后来我把它放到了shared目录中，可以在部署的时候，自动复制.

9.测试下配置文件是否正确：
>cap production deploy:check

10.如果没有错误，可以进行部署了
>cap production deploy [--trace]

* Ruby version
> 2.1.5

* Rails version
 > 4.1.8
 
* Capistrano version
* Capistrano Version: 3.3.5 (Rake Version: 10.4.2)

