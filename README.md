# GaitMate

[![GPL Licence](https://badges.frapsoft.com/os/gpl/gpl.png?v=103)](https://opensource.org/licenses/GPL-3.0/)

### Easily record smartphone sensor data

A flutter android app that records user's motion activity via smartphone sensor data and stores it locally when the recording is finished. The activity type can be specified when starting the recording and will be used in the naming of the stored recording, along with current date-time. It thus allows easy creation of time-series data of motion activity that can be used to train machine learning models to recognize motion activity from sensor data.

### Example

<img src="https://raw.githubusercontent.com/verrannt/gaitmate/master/GaitMate_UsageExample.gif" width="320px" />

### Stored Data

The recordings are stored in ´/storage/emulated/0/Android/org.athical.gaitmate/files/´ as .csv files. They consist of three columns, the first of which represents the accelerometer values, the second the userAccelerometer values, and the third the gyroscope values. The rows represent instances in time, sampled at 5ms intervals. The sensor values at each time-step consist of a list of decimal numbers for the three dimensions x, y, z, in that order.

### Download

An up-to-date .apk can be downloaded [here](https://drive.google.com/file/d/1TMz81fhorfauz-oLO_wV0PjJCIt5YOxT/view?usp=sharing).

### Future Features

* Share recordings from within app
* Delete recordings from within app
* Specify custom activity names
