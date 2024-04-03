# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Configure Nginx server
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => '
    server {
      listen 80 default_server;
      listen [::]:80 default_server;
    
      root /var/www/html;
      index index.html index.htm;
    
      location / {
        return 200 "Hello World!\n";
      }
    
      location /redirect_me {
        return 301 https://www.example.com;
      }
    
      error_page 404 /404.html;
      location = /404.html {
        internal;
        return 200 "Ceci n\'est pas une page\n";
      }
    }
  ',
  require => Package['nginx'],
}

# Restart Nginx service
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => File['/etc/nginx/sites-available/default'],
}
