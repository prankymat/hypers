#hypers

Develop and run code anywhere. Supporting iOS currently.

**Warning: hypers is still under active development. Please expect bugs and crashes.**

##Features
- Write code on your iPhone or iPad then run the code in real time on your machine remotely
- Fast and realiable

##Remarks
Hypers uses [SpartanX](https://github.com/michael-yuji/spartanx) as its backend communication framework.

##Development Troubleshooting
###Missing SpartanX and other libs
SpartanX and other libs for this repo is stored in git's submodules. To obtain these libraries, you must first init then update the repo's submoudles.

```bash
git clone https://github.com/prankymat/hypers.git
cd hypers
git submodule init
git submodule update  // Will clone all necessary libraries
```

###Missing keys.plist
You'll need a GitHub api key to run this app. You can register for one [here](https://github.com/settings/developers).

After you've obtain your GitHub api token ```client_id``` and ```client_secret```, you'll need to store it in ```keys.plist```. Create a new plist file at ```ios/hypers/keys.plist``` with the following fields:
```
client_id: <YOUR client_id>
client_secret: <YOUR client_secret>
```

###Contribution
Any contribution will be greatly appreciated. Feel free to discuss features and bugs in the issue tracker or fork and create a pull request to propose changes!