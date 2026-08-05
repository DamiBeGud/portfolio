settings = SiteSetting.first_or_initialize
if settings.new_record?
  settings.assign_attributes(SiteSetting.default_attributes)
  settings.save!
end

TimelineEntry.find_or_create_by!(category: "experience", sort_order: 1) do |entry|
  entry.meta = "Software Developer / Recent Role"
  entry.title = "Company Name"
  entry.description = "Built and maintained production web applications with a focus on reliable delivery, readable code, and cross-functional collaboration."
end

TimelineEntry.find_or_create_by!(category: "experience", sort_order: 2) do |entry|
  entry.meta = "Developer / Earlier Role"
  entry.title = "Company Name"
  entry.description = "Contributed to feature development, testing workflows, API integrations, and user-facing improvements across the stack."
end

TimelineEntry.find_or_create_by!(category: "education", sort_order: 1) do |entry|
  entry.meta = "Degree / Program"
  entry.title = "University Name"
  entry.description = "Studied software engineering foundations, algorithms, systems design, databases, and practical product development."
end

InfoCard.find_or_create_by!(title: "Technical Skills") do |card|
  card.body = "Core technical toolkit."
  card.tags = "TypeScript, React, Node.js, Python, PostgreSQL, Testing"
  card.sort_order = 1
end

InfoCard.find_or_create_by!(title: "Expertise") do |card|
  card.body = "Frontend architecture, API design, performance tuning, design systems, accessibility, and production-focused delivery."
  card.sort_order = 2
end

InfoCard.find_or_create_by!(title: "Interests") do |card|
  card.body = "Developer tools, observability, human-centered automation, resilient interfaces, and data-informed product iteration."
  card.sort_order = 3
end

Project.find_or_create_by!(title: "Telemetry Command Center") do |project|
  project.description = "A real-time operations dashboard for service-health analytics, incident visibility, and team handoff workflows."
  project.technologies = "React, TypeScript, WebSocket, PostgreSQL"
  project.live_url = "https://example.com"
  project.source_url = "https://github.com/example/telemetry-command-center"
  project.preview_style = "default"
  project.sort_order = 1
end

Project.find_or_create_by!(title: "Studio Workflow Engine") do |project|
  project.description = "A task orchestration app that turns fragmented creative production steps into auditable, reusable workflows."
  project.technologies = "Next.js, Node.js, Prisma, Playwright"
  project.live_url = "https://example.com"
  project.source_url = "https://github.com/example/studio-workflow-engine"
  project.preview_style = "inverse"
  project.sort_order = 2
end

Project.find_or_create_by!(title: "Accessible Component Lab") do |project|
  project.description = "A documented component system with keyboard-first patterns, visual regression checks, and contrast-safe themes."
  project.technologies = "Vue, Storybook, CSS, Axe"
  project.live_url = "https://example.com"
  project.source_url = "https://github.com/example/accessible-component-lab"
  project.preview_style = "grid"
  project.sort_order = 3
end

ContactLink.find_or_create_by!(label: "GitHub") do |link|
  link.url = "https://github.com/example"
  link.sort_order = 1
end

ContactLink.find_or_create_by!(label: "LinkedIn") do |link|
  link.url = "https://www.linkedin.com/in/example"
  link.sort_order = 2
end

ContactLink.find_or_create_by!(label: "Social") do |link|
  link.url = "https://x.com/example"
  link.sort_order = 3
end
