# Lab 09: Introduction to Self-Hosted GitHub Runners

## Overview

This lab introduces the concept of GitHub Actions runners, comparing GitHub-hosted runners with self-hosted runners. You'll learn when and why to use each type, and gain hands-on experience running workflows on both.

## What are GitHub Actions Runners?

A **runner** is a server that executes your GitHub Actions workflows. When you trigger a workflow, GitHub needs a machine to actually run the jobs you've defined. Runners provide that compute environment.

### Types of Runners

#### 1. GitHub-Hosted Runners

**GitHub-hosted runners** are virtual machines managed entirely by GitHub. They:

- Are automatically provisioned when your workflow runs
- Come pre-installed with common tools and software
- Are destroyed after your job completes (ephemeral)
- Run in GitHub's cloud infrastructure
- Are free for public repositories (with usage limits for private repos)

**Common GitHub-hosted runner types:**
- `ubuntu-latest` (Ubuntu Linux)
- `windows-latest` (Windows Server)
- `macos-latest` (macOS)

**Advantages:**
- Zero maintenance required
- Clean environment for every run
- Automatically updated with latest tools
- Scalable (GitHub handles the infrastructure)
- No setup required

**Limitations:**
- Cannot access private networks or internal resources
- Limited customization
- Preset hardware specifications
- No persistent state between runs
- Cannot install licensed software that requires activation

#### 2. Self-Hosted Runners

**Self-hosted runners** are machines that you set up and manage yourself. They:

- Run on your own infrastructure (on-premises, cloud VMs, or containers)
- Can be physical or virtual machines
- Persist between workflow runs (unless configured otherwise)
- Can access your private networks and resources
- Can be customized with any tools or software you need

**Advantages:**
- Access to internal networks, databases, and private resources
- Full control over hardware specifications
- Pre-install custom tools, licensed software, or specific versions
- Persistent caching between runs (faster builds)
- Can meet specific security or compliance requirements
- No usage limits or costs from GitHub

**Limitations:**
- Requires setup and ongoing maintenance
- You're responsible for security updates and patches
- Need to manage runner availability and scaling
- Potential security risks if not properly isolated

## When to Use Self-Hosted Runners

Consider using self-hosted runners when you need to:

1. **Access Private Infrastructure**
   - Deploy to internal networks
   - Access on-premises databases
   - Connect to private APIs or services

2. **Use Specialized Tools**
   - Tools not available on GitHub-hosted runners
   - Specific versions of software
   - Licensed software (e.g., enterprise tools)
   - Custom security scanning tools

3. **Improve Performance**
   - Faster builds with persistent caching
   - More powerful hardware specifications
   - Reduced network latency for internal resources

4. **Meet Compliance Requirements**
   - Data must stay within specific geographic regions
   - Security policies require on-premises execution
   - Audit trails and logging requirements

5. **Cost Optimization**
   - High-volume workflows that exceed free tier
   - Long-running jobs
   - Use existing infrastructure

## Repository Structure

```
09-self-hosted-github-runner-intro/
├── README.md                          # This file
├── .gitignore                         # Git ignore patterns
├── .github/
│   └── workflows/
│       ├── gh-hosted.yml              # GitHub-hosted runner demo
│       └── self-hosted.yml            # Self-hosted runner demo
└── scripts/
    └── demo-script.sh                 # Demo script for self-hosted runner
```

## Workflows in This Repository

### 1. GitHub Hosted Runner Demo (`gh-hosted.yml`)

This workflow runs on GitHub's infrastructure using `ubuntu-latest`. It demonstrates:
- Basic system information
- Available resources
- GitHub-provided environment variables

**Trigger:** Runs on push to main/master or manually via workflow_dispatch

### 2. Self Hosted Runner Demo (`self-hosted.yml`)

This workflow runs on your self-hosted runner using labels `[self-hosted, linux, x64]`. It demonstrates:
- Custom environment details (hostname, user)
- Execution of custom scripts
- Checking for pre-installed tools (Terraform, Azure CLI, AWS CLI, Docker)

**Trigger:** Manual only (workflow_dispatch)

## For Instructors: Setting Up a Self-Hosted Runner

The workflows in this repository expect a self-hosted runner to be registered. Here's how to set one up:

### Prerequisites

- A Linux VM or physical machine (Ubuntu recommended)
- Administrative access to the GitHub repository
- Network connectivity from the runner to GitHub

### Registration Steps

1. **Navigate to Repository Settings**
   - Go to your GitHub repository
   - Click **Settings** → **Actions** → **Runners**
   - Click **New self-hosted runner**

2. **Choose Your OS**
   - Select the operating system (e.g., Linux)
   - Choose the architecture (e.g., x64)

3. **Follow GitHub's Instructions**

   GitHub will provide specific commands to run on your machine. They'll look similar to:

   ```bash
   # Create a folder
   mkdir actions-runner && cd actions-runner

   # Download the latest runner package
   curl -o actions-runner-linux-x64-2.311.0.tar.gz -L \
     https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

   # Extract the installer
   tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

   # Create the runner and start the configuration
   ./config.sh --url https://github.com/YOUR_ORG/YOUR_REPO \
     --token YOUR_REGISTRATION_TOKEN

   # Run the runner
   ./run.sh
   ```

4. **Configure the Runner**

   During configuration, you'll be prompted for:
   - **Runner name:** A unique identifier (e.g., `lab-runner-01`)
   - **Runner group:** Default is usually fine
   - **Labels:** Additional labels beyond the defaults (`self-hosted`, `linux`, `x64`)
   - **Work folder:** Where workflows will execute (default: `_work`)

5. **Install as a Service (Recommended)**

   For production use, install the runner as a service so it starts automatically:

   ```bash
   sudo ./svc.sh install
   sudo ./svc.sh start
   ```

6. **Verify Registration**

   - Return to **Settings** → **Actions** → **Runners**
   - You should see your runner listed with a green "Idle" status

### Installing Custom Tools (Optional)

To demonstrate the value of self-hosted runners, pre-install tools on your runner:

```bash
# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install AWS CLI
sudo apt install awscli

# Install Docker
sudo apt install docker.io
sudo usermod -aG docker $USER
```

### Security Considerations

- **Isolation:** Run the runner in an isolated environment (VM, container)
- **Updates:** Keep the runner and OS updated
- **Permissions:** Use a dedicated user account with minimal permissions
- **Network:** Consider firewall rules and network segmentation
- **Secrets:** Be cautious with repository secrets on self-hosted runners
- **Public Repositories:** Do NOT use self-hosted runners with public repos (security risk)

## For Students: Lab Exercises

### Exercise 1: Run the GitHub-Hosted Workflow

1. **Navigate to Actions**
   - Go to the **Actions** tab in this repository

2. **Select the Workflow**
   - Click on **"GitHub Hosted Runner Demo"** in the left sidebar

3. **Run the Workflow**
   - Click **"Run workflow"** button (top right)
   - Select the branch (usually `main` or `master`)
   - Click **"Run workflow"**

4. **Inspect the Results**
   - Click on the workflow run that just started
   - Click on the job **"run-on-gh-hosted"**
   - Examine the output from each step

   **Questions to consider:**
   - What OS and kernel version is running?
   - How many CPU cores are available?
   - How much memory does the runner have?
   - What is the runner name?

### Exercise 2: Run the Self-Hosted Workflow

**Note:** This requires the instructor to have set up a self-hosted runner first.

1. **Navigate to Actions**
   - Go to the **Actions** tab in this repository

2. **Select the Workflow**
   - Click on **"Self Hosted Runner Demo"** in the left sidebar

3. **Run the Workflow**
   - Click **"Run workflow"** button
   - Select the branch
   - Click **"Run workflow"**

4. **Inspect the Results**
   - Click on the workflow run
   - Click on the job **"run-on-self-hosted"**
   - Examine the output from each step

   **Questions to consider:**
   - What is the hostname of the runner?
   - What user is executing the workflow?
   - What custom tools are installed?
   - How does the environment differ from the GitHub-hosted runner?

### Exercise 3: Compare the Runners

Create a comparison table based on your observations:

| Aspect | GitHub-Hosted | Self-Hosted |
|--------|---------------|-------------|
| Hostname | ? | ? |
| Operating System | ? | ? |
| CPU Cores | ? | ? |
| Memory | ? | ? |
| Terraform Installed? | ? | ? |
| Azure CLI Installed? | ? | ? |
| Execution Time | ? | ? |

**Discussion Points:**
- When would you choose one runner type over the other?
- What are the trade-offs?
- How does network access differ between the two?

### Exercise 4: Modify the Demo Script (Optional)

Try modifying `scripts/demo-script.sh` to:

1. **Check for additional tools**
   ```bash
   if command -v kubectl &> /dev/null; then
     echo "Kubernetes CLI version: $(kubectl version --client --short)"
   fi
   ```

2. **Display environment variables**
   ```bash
   echo "Environment Variables:"
   env | grep -E "^(GITHUB_|RUNNER_)" | sort
   ```

3. **Test network access**
   ```bash
   echo "Testing network access to internal resource:"
   curl -I http://internal-service.local
   ```

4. **Run a Terraform command** (if installed)
   ```bash
   if command -v terraform &> /dev/null; then
     terraform version
     # Could even run terraform init/plan if you have .tf files
   fi
   ```

After making changes:
- Commit and push your changes
- Re-run the self-hosted workflow
- Observe the new output

### Exercise 5: Create Your Own Workflow (Advanced)

Create a new workflow file `.github/workflows/compare-runners.yml` that:

1. Runs the same job on both runner types
2. Compares execution time
3. Shows differences in available tools

Example structure:
```yaml
name: Compare Runners

on: workflow_dispatch

jobs:
  test-on-github:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run test
        run: ./scripts/demo-script.sh

  test-on-self-hosted:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - name: Run test
        run: ./scripts/demo-script.sh
```

## Key Takeaways

1. **GitHub-hosted runners** are great for:
   - Public repositories
   - Standard build/test workflows
   - Projects without special requirements
   - Getting started quickly

2. **Self-hosted runners** are essential for:
   - Private infrastructure access
   - Custom tooling requirements
   - Performance optimization
   - Compliance and security requirements

3. **Runner labels** determine where jobs execute:
   - `ubuntu-latest`: GitHub-hosted Ubuntu
   - `[self-hosted, linux, x64]`: Your custom runner

4. **Both types can coexist** in the same repository:
   - Use GitHub-hosted for public-facing tasks
   - Use self-hosted for deployment or internal operations

## Troubleshooting

### Self-Hosted Workflow Fails with "No runner matching the specified labels"

**Cause:** No self-hosted runner is registered or online.

**Solution:**
- Check if the instructor has set up the runner
- Verify the runner is online in **Settings** → **Actions** → **Runners**
- Ensure the labels match: `self-hosted`, `linux`, `x64`

### Demo Script Permission Denied

**Cause:** The script is not executable.

**Solution:**
```bash
chmod +x scripts/demo-script.sh
git add scripts/demo-script.sh
git commit -m "Make demo script executable"
git push
```

### GitHub-Hosted Workflow Doesn't Trigger on Push

**Cause:** The push might not be to `main` or `master` branch.

**Solution:**
- Check the branch name in `.github/workflows/gh-hosted.yml`
- Update the trigger to match your default branch
- Or trigger manually using `workflow_dispatch`

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [About Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners)
- [Adding Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners)
- [Using Self-Hosted Runners in a Workflow](https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow)
- [Runner Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#hardening-for-self-hosted-runners)

## Next Steps

After completing this lab, you should:

1. Understand the difference between GitHub-hosted and self-hosted runners
2. Know when to use each type
3. Be able to run workflows on both runner types
4. Understand runner labels and how they route jobs
5. Recognize the security considerations for self-hosted runners

In future labs, you'll learn about:
- Advanced workflow patterns
- Matrix builds across multiple runner types
- Containerized workflows
- Runner autoscaling strategies
- CI/CD pipeline optimization

## License

This lab is for educational purposes.
