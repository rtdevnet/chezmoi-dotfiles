export default {
  defaultBrowser: "Browserosaurus",
  handlers: [
    {
      // Open these urls in Chrome
      match: ["youtube.com/*", "youtu.be/*"],
      browser: "Firefox"
    }
  ]
}
