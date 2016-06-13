#hypers

Develop and run code anywhere. Supports iOS currently.

##Features
- Write code on your iPhone or iPad then run the code in real time on your machine remotely
- Fast and realiable

##Development
You'll need a GitHub api key to run this app. You can register for one [here](https://github.com/settings/developers).

After you've obtain your GitHub api token ```client_id``` and ```client_secret```, you'll need to store it in ```keys.plist```. Create a new plist file at ```ios/hypers/keys.plist``` with the following fields:
```
client_id: <YOUR client_id>
client_secret: <YOUR client_secret>
```

##Remarks
Hypers uses [SpartanX](https://github.com/michael-yuji/spartanx) as its backend communication framework.
