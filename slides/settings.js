// More info about config & dependencies:
// - https://github.com/hakimel/reveal.js#configuration
// - https://github.com/hakimel/reveal.js#dependencies
Reveal.initialize({
    dependencies: [
        { src: 'reveal.js/plugin/markdown/marked.js' },
        { src: 'reveal.js/plugin/markdown/markdown.js' },
        { src: 'reveal.js/plugin/notes/notes.js', async: true },
        { src: 'reveal.js/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } }
    ]
});
