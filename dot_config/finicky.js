export default {
  defaultBrowser: "Browserosaurus",
  options: {
    // Check for updates. Default: true
    checkForUpdates: true,
    // Log every request to file. Default: false
    logRequests: true,
  },
  rewrite: [{
    match: () => true, // Execute rewrite on all incoming urls to make this example easier to understand
    url: (url) => {
        const removeKeysStartingWith = ["utm_", "uta_"]; // Remove all query parameters beginning with these strings
        const removeKeys = ["fbclid", "gclid"]; // Remove all query parameters matching these keys

        const search = url.search
            .split("&")
            .map((parameter) => parameter.split("="))
            .filter(([key]) => !removeKeysStartingWith.some((startingWith) => key.startsWith(startingWith)))
            .filter(([key]) => !removeKeys.some((removeKey) => key === removeKey));

        return {
            ...url,
            search: search.map((parameter) => parameter.join("=")).join("&"),
        };
    },
  }],
  handlers: [
    {
      // Open these urls in Firefox
      match: [
        /^https?:\/\/(www\.)?youtube.com/,
        /^https?:\/\/(www\.)?youtu\.be/,
      ],
      browser: "Firefox"
    }
  ]
}
