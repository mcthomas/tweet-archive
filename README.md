# tweet-archive

Goal: Provide a functional workflow to create an offline archive of scraped tweets- uninhibited by the platform's API restrictions- as a more complete alternative to the native archive feature available from a platform account.

Note: The majority of the value here lies in the hacky shell scripts which assemble the tweet data into a static frontend that you can enjoy.  After intial setup, if you do not want the tweets pooled together (regardless of whether they are from your Likes, Bookmarks, etc.) and sorted by date posted, or you want to customize the pages' appearances, you would be best to fork this repo and customize the shell scripts to your liking.

Dependencies: 
- a twitter account (can be a temporary account)
- [WFDownloader](https://www.wfdownloader.xyz/download)
- [Docker Desktop](https://docs.docker.com/engine/install/)
- At the moment, unfortunately [Chrome](https://www.google.com/chrome/)
- A Unix-like shell

## Part 1 - Pulling Down Tweet Data

- clone down this repository and unzip it
- open WFDownloader
  - on macOS, you will likely need to allow the applets through Gatekeeper, and launch via EnableStart.command
- with WFDownloader open, navigate to _Tasks → Login via inbuilt browser_
- load the following url into the inbuilt browser and log into your account: https://twitter.com/i/flow/login
  - you may now close the inbuilt browser window if you'd prefer, since it has your current session login (or you can continue using it for retrieving urls in the following procedure if you prefer)
- **for each** page's tweets you would like to archive (e.g. the url to your likes, to your bookmarks, to your profile, to another user's profile, etc.) you will need to copy out the url of that page and follow this procedure:
  1. from the main WFDownloader window, select _Add_
      - paste the url into the _Link Address_ field
      - browse to, or set the path to, the recently downloaded and decompressed repository directory
      - select _Config_ and ensure that the _Fetch_Mode_ field is set to _Fetch media only_; then select _Accept_
      - select _Confirm_ and wait for all resolveable tweets' media links to be found
      - select _Confirm_ again to close this window, and from the main window, select _Resume_ (the new batch should already be selected)
  2. wait for the downloads in the batch to complete, and then once again select _Add_
      - your previous url and folder path should already be present in the fields; this time, select _Config_ and set the _Fetch_Mode_ field to _Fetch tweet urls for export_; then select _Accept_
      - select _Confirm_ and wait for all resolveable tweets' links to be found
      - select _Confirm_ again to close this window, and from the main window, select _Resume_ (the new batch should already be selected)
      - at this point, you should have both the media and json data, for the tweets served at the current url, saved locally
    
## Part 2 - Generating a Static Frontend

- open Docker Desktop so that it is running in the background
- open your terminal emulator and navigate to the repository directory
- run `docker build -t tweet-archive .; docker run -it --rm -v "$(pwd):/scripts" tweet-archive` (repeat these two commands any time you want to re-generate the archive after making your own changes)
  - if you have the gnu core utilities installed, you can try running `bash create_pages.sh` _instead_ of using Docker (errors may persist due to different flags available from the BSD package equivalents; this is why I suggest using Docker)

## Viewing Your Tweet Archive

- quit Chrome if it is running
- in your terminal emulator, launch a Chrome session with reduced security to disable CORS restrictions: (for you convenience, you may want to save the below command to a `.command` file, a `.cmd` file, or an alias, per your platform)
  -  macOS: `open /Applications/Google\ Chrome.app --args --user-data-dir="/var/tmp/Chrome dev session" --disable-web-security`
  -  Linux: `google-chrome --disable-web-security`
  -  Windows: `chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security`
- in your file manager, navigate to the top level of the repository directory and then _right-click open_ the index.html file _with_ this active Chrome session
- on the index page, you should see that the tweets are divided into chronological subgroups of 15 tweets per hyperlinked page (this prevents long load times for media)
  - each page is hyperlinked with the earliest tweet's post date per subgrouping
- when you're finished viewing your archive, quit Chrome to end this session with reduced security

## Known Issues

- intermittent playback issues without the `autoplay` attribute
- intermittent playback issues on local servers, partially due to using `autoplay`
- inability to open archive on alternative browsers (disabling CORS restrictions is increasingly difficult on Safari, Firefox, and others)
