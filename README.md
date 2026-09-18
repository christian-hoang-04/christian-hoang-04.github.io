# Christian Hoang

Personal website for Christian Hoang, a final-year undergraduate at FPT University, Viet Nam, working on Artificial Intelligence.

## Website

Live site: <https://christian-hoang-04.github.io/>

The site currently includes:

- About: profile, news, and contact links
- Research: current projects and publications

Teaching, Service, Experience, Awards, and Typesetting are not currently published.

## Run locally

Start a local static server from the project root:

```powershell
python -m http.server 8123
```

Then open <http://localhost:8123/>.

## Refresh the local mirror

To regenerate the customized static pages from the source mirror, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\mirror-site.ps1
```

The generated site is published through GitHub Pages from the `main` branch.
