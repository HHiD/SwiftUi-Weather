For this app there’s no any dependency requirements, make sure your Xcode was update to 16.0 or above
![Xcode](https://github.com/user-attachments/assets/6313e761-16a0-4651-a15c-d7aee49c74f5)
The app take your device or simulator location as default location
First If you use simulator make sure you have config the default location in Scheme:
![Pasted Graphic 3](https://github.com/user-attachments/assets/f08fa15e-31dc-4f9a-90c9-6075fab9eb78)
Choose any default location you like
![Pasted Graphic 4](https://github.com/user-attachments/assets/00f2fdfa-bb3a-49d9-bcf4-42c535664cb7)
For test convenience there’s Latitude and Longitude Input you can type in the coordinate you want  
And will display the location info of the coordinates 
￼![1 Harbour View St, Central, Hong Kong Island Hong](https://github.com/user-attachments/assets/f661d317-2442-416a-b976-5239de1d602e)
Some coordinate for your reference:
ChengDu: 30.6667, 104.0667
Singapore: 1.2897, 103.8501
Hong Kong: 22.284681, 114.158177

The App can change to landscape
![2025-01-20 0000](https://github.com/user-attachments/assets/dd325877-2a2e-4c56-a802-4a4d9f69fb03)
The chart is able to zoom to see more detail, use real device would be more easer to test:
![Pasted Graphic 8](https://github.com/user-attachments/assets/81a9c2e1-3642-4774-9f98-69874ad1666a)
For network retry
My simulator was not install this tool, don’t know why, if you have the same conditions, follow to install an test tool 
Open Xcode and go to Xcode › Open Developer Tool › More Developer Tools... menu (or navigate to https://developer.apple.com/download/more/
![About Xcode](https://github.com/user-attachments/assets/a472567f-dc08-4976-9e62-8976353e4f43)
    1. Search for “Additional Tools for Xcode” package [Note: You may need to sign in first]
    2. Download the appropriate release package as per your Xcode version
    3. Once the download has finished, open the DMG file and navigate to the Hardware directory.
    4. Install the “Network Link Conditioner.prefPane” in your System Preferences by double-clicking on the icon.

* Once you install, a new item has been added to your System Preferences which will allow you to throttle your network connection speed.
![Require administrator to](https://github.com/user-attachments/assets/81cb53e1-5cc2-4712-aa27-1abc2aac1d68)

    You can config the retry as you want:
    ![struct NetworkingConfiguration {](https://github.com/user-attachments/assets/1c5c917e-5cab-4f21-89e4-86642c2c76f9)
