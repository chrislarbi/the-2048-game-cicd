Intern Assignment Documentation
Submitted by: Chris Larbi Date: September 28, 2025 GitHub Repository:
https://github.com/chrislarbi/the-2048-game-cicd

Introduction and Project Overview
As a DevOps enthusiast, I was excited to take on this assignment—it gave me a chance to dive into real-world automation and deployment while working with a fun app like the 2048 game. The project involved containerizing the 2048 puzzle game (originally created by Gabriele Cirulli) using Docker, setting up a CI/CD pipeline with GitHub Actions, and deploying it to a staging environment. I aimed to keep things simple yet effective, focusing on best practices like secure builds and efficient workflows. This not only showcased technical skills but also highlighted how DevOps can turn a basic game into a scalable application.
The objective was straightforward: automate testing and building, deploy to a cloud platform, and document everything, including security considerations. I started with the game's static files (HTML, JS, CSS) and built from there.

Local Development and Testing
I began by forking the 2048 repo and getting it running locally to understand the app. It's a static site, so I containerized it with a Dockerfile using nginx:1.25-alpine as the base image—lightweight and reliable for serving files.
To test, I built the image with docker build -t chrislarbi/the-2048-game-cicd . and ran it locally: docker run -d -p 8081:80 chrislarbi/the-2048-game-cicd. The game popped up at http://localhost:8081, and I played a few rounds to make sure tiles merged and swipes worked. Early on, I hit a port conflict with 8080 (some process was holding it), so I switched to 8081—a quick fix but a good reminder to check system resources.
This phase was crucial for catching issues before automation. Everything ran smoothly after that, confirming the Dockerfile was solid.

CI/CD Pipeline Setup
With the local setup working, I shifted to automation using GitHub Actions. The pipeline is defined in .github/workflows/deploy.yml, and it runs on pushes to the master branch. It’s designed to test, build, and simulate staging—keeping it lean for a static app but expandable.
Key steps:
Basic Tests: Checks for core files like index.html, js/, and style/ to ensure nothing’s missing (e.g., if [ ! -f index.html ]; then exit 1; fi).
Docker Build: Builds the image as chrislarbi/the-2048-game-cicd:latest.
Trivy Scan: Scans for vulnerabilities, failing on high or critical ones—added this to catch security gaps early.
Staging Simulation: Sets a STAGING_URL to mimic a staging env, since Render’s free tier doesn’t support separate instances.

I had to troubleshoot the trigger—it wasn’t firing due to a branch mismatch, but aligning to master and fixing syntax sorted it out. Overall, this pipeline makes deployments reliable, and it was fun seeing it kick off on every push.

Deployment to Render
For deployment, I chose Render as the staging environment—it’s easy to use and handles Docker builds without extra hassle. After signing up and linking my GitHub account, I created a Web Service, selected the repo, chose Docker runtime, and left the Start Command blank so Render could build from the Dockerfile.
The live URL is https://the-2048-game-cicd.onrender.com—check it out to play! Initial deploys were rocky, showing only the header without interactive tiles, probably from file permission problems. Adding RUN chmod -R 755 /usr/share/nginx/html fixed it, and manual deploys helped sync changes after some branch tweaks.
Render’s auto-deploy on pushes ties perfectly into the CI/CD pipeline, making updates seamless.

Security Measures
Security was top of mind—I didn’t want to overlook it even for a simple game. Here’s what I put in place:
Dependency Management: I pinned the base image to nginx:1.25-alpine to avoid the risks of floating tags like latest, which could pull in vulnerabilities. This keeps the foundation stable.
Vulnerability Scanning: Added Trivy to the pipeline—it scans the built image and fails on high or critical issues, so nothing risky slips through.
File Integrity: Created a .dockerignore to skip stuff like .git and node_modules, reducing the chance of including unwanted files. Paired it with chmod -R 755 for proper permissions.
Secret Management: Skipped GitHub secrets since Render builds directly from the Dockerfile—no need for Docker Hub creds. In a production setup, I’d use them to secure registry access.
Pipeline Checks: Pre-build validation ensures key files are there, preventing incomplete or tampered builds.
Deployment Security: Render handles HTTPS and DDoS protection out of the box, adding an extra layer without much effort.
These steps made the app more robust than the original static game.

Challenges and Lessons Learned
This project wasn’t without hurdles, but they taught me a lot. Initially, I planned an AWS EC2 deployment, but admin access delays forced a switch to Render. It was frustrating at first, but Render turned out to be easier for quick setups, and I learned to adapt plans on the fly.
Other challenges included GitHub Actions not triggering due to syntax errors and branch mismatches—I fixed it by aligning everything to master. Render deploys showed partial content, traced to permissions, which I solved with chmod. Git sync issues were a pain, where local edits didn’t reflect online until I nailed the add/commit/push sequence.
Overall, these reinforced the importance of testing locally, documenting fixes, and choosing flexible tools. It was a real-world reminder that DevOps is as much about problem-solving as it is about code.
Documented Security Vulnerability
To highlight security thinking, I deliberately introduced a vulnerability early on.
Issue: Used FROM nginx:latest in the Dockerfile, risking supply chain attacks if an unpatched version was pulled, like CVEs in older Nginx builds.
Fix: Changed to FROM nginx:1.25-alpine for a pinned, secure image and added Trivy scans.
This update was in the latest commit, ensuring better protection.

Conclusion and Acknowledgments
Wrapping this up, I’m proud of how it came together—from local testing to a live Render deploy. It’s a solid demo of DevOps basics, and I’d love to expand it with more features in a team setting.
Thanks to Gabriele Cirulli for the game, and contributors like Tim Petricola for mobile support. For NPONTU, I appreciate the opportunity—this project got me even more pumped about DevOps!
