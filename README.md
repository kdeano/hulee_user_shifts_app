# hulee_user_shifts_app

## Disclaimer
This project was built and tested using a Chrome window to render the flutter app. This has not been tested on a mobile device or emulator.

## Getting started
If the project is not working as intended on a mobile device or emulator, run in Chrome and add the following flag to your chrome window:

1. Go to ```flutter\bin\cache``` and remove a file named: ```flutter_tools.stamp```
2. Go to ```flutter\packages\flutter_tools\lib\src\web``` and open the file ```chrome.dart```.
3. Find ```'--disable-extensions'```
4. Add ```'--disable-web-security'```

You should now be able to run the application and successfully fetch the API data.
