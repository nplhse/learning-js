# learning-js

This is a very simple project of mine where I'm trying to improve my JavaScript skills. I will be using tutorials from
various sources as far as their licenses allow for that and implement them here.

# Requirements
-   Webserver (Apache, Nginx, LiteSpeed, IIS, etc.) with PHP 8.3 or higher and MySQL 8.0 as database.

# Setup
This project expects you to have local webserver via the symfony binary and a locally installed MySQL instance. 

## Install from GitHub
1. Launch a **terminal** or **console** and navigate to the webroot folder. Clone this repository from GitHub to a 
folder in the webroot of your server, e.g.
   `~/webroot/learning-js`.

    ```
    $ cd ~/webroot
    $ git clone https://github.com/nplhse/learning-js.git
    ```

2. Build the **docker containers** and install the project with all dependencies by using **composer**. 

    ```
    $ cd ~/webroot/learning-js
    $ docker compose build
    $ docker compose up -d
    $ composer install
    ```
   
3. Start the local webserver of symfonys binary and you are ready to go. Just open the site with your favorite browser!

   ```
   $ symfony serve -d
   ```

# Contributing
Any contribution to this project is appreciated, whether it is related to fixing bugs, suggestions or improvements. 

# License
See [LICENSE](LICENSE.md).
