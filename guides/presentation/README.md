# Security Lightning Talk

This folder contains the Reveal.js presentation for your lightning talk.

## Files
- `security-presentation.md`: Your talk's content.
- `presentation.html`: The app that runs the slides.

## How to Run
1. Open your terminal in Android Studio.
2. Run these commands:
   ```bash
   cd guides/presentation
   python3 -m http.server 8000
   ```
   or node
   ```bash
   npx serve
   ```
   or ruby
   ```bash
   ruby -run -e httpd . -p 8000
   ```
3. Open your browser to: [http://localhost:8000/presentation.html](http://localhost:8000/presentation.html)

## Troubleshooting
If you see a blank screen, ensure you are running the `http.server` command and NOT just opening the file directly in your browser. Browsers block local file access for security reasons (CORS).
