#####################################################################
#                                                                   #
#                   fbsh: a ncurses facebook client                 #
#                                                                   #
#   author: Joel Marty (10093745@brookes.ac.uk)                     #
#   date: dec. 10th 2010                                            #
#   release 1                                                       #
#                                                                   #
####################################################################

fbsh is a facebook client written in java using an ncurses interface
fbsh needs an access token to your facebook profile

1 - On your browser, go to the following url:
https://graph.facebook.com/oauth/authorize?client_id=362c93b4c1b32565848ad4749275cbe6&redirect_uri=http://www.facebook.com/connect/login_success.html&scope=publish_stream,user_status,read_stream,offline_access

2 - Once you accept to let the application access your profile, the word
"success" should appear and the URL should look like:
http://www.facebook.com/connect/login_success.html?code=<long code>


3 - Now go to the address below, changing <code> with the code you got on previous step:
https://graph.facebook.com/oauth/access_token?client_id=362c93b4c1b32565848ad4749275cbe6&redirect_uri=http://www.facebook.com/connect/login_success.html&client_secret=0c8c8f0bbc39ee04d54cbfb04a1065f4&code=<code>

4 - A new page will appear with the text "access_token=<another long code>

5 - Open the conf/fbsh.properties file and copy/paste the access token inside

6 - The token will remain valid until you change your password

Usage:
    use the start.sh script to start the application
