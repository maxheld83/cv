workflow "Render and Deploy RMarkdown Documents" {
  on = "push"
  resolves = [
    "Render", 
    "Deploy"
  ]
}

action "Render" {
  uses = "r-lib/ghactions/actions/rmarkdown@2649698"
  runs = [
    "Rscript",
    "-e",
    "rmarkdown::render(input = 'german.Rmd', output_dir = 'output', output_file = 'held_lebenslauf.pdf')",
    "-e",
    "rmarkdown::render(input = 'english.Rmd', output_dir = 'output', output_file = 'held_resume.pdf')"
  ]
}

action "Filter master" {
  needs = [
    "Render"
  ]
  uses = "actions/bin/filter@a9036ccda9df39c6ca7e1057bc4ef93709adca5f"
  args = [
    "branch master"
  ]
}

action "Deploy" {
  needs = [
    "Filter master"
  ]
  uses = "maxheld83/ghpages@v0.2.0"
  env = {
    BUILD_DIR = "output"
  }
  secrets = [
    "GH_PAT"
  ]
}
