const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");

const isDevEnv = process.env.ELEVENTY_ENV === "development";

module.exports = function (eleventyConfig) {
  eleventyConfig.addPlugin(syntaxHighlight);

  eleventyConfig.addFilter("formatDate", (date) => {
    return new Intl.DateTimeFormat("en-GB", {
      year: "numeric",
      month: "short",
      day: "numeric",
    }).format(date);
  });

  function showDraft(data) {
    const isDraft = "draft" in data && data.draft !== false;
    return isDevEnv || !isDraft;
  }

  return {
    eleventyComputed: {
      eleventyExcludeFromCollections: function (data) {
        if (showDraft(data)) {
          console.log("=============", data);
          return data.eleventyExcludeFromCollections;
        } else {
          return true;
        }
      },
      permalink: function (data) {
        if (showDraft(data)) {
          return data.permalink;
        } else {
          return false;
        }
      },
    },
    dir: {
      input: ".",
      output: "docs",
    },
  };
};
