# Rocket.Chat Job Status Notifier

A lightweight, secure GitHub Action to send automated job status notifications (Success, Failure, Cancelled) to a Rocket.Chat channel via incoming webhooks.

While this action is open-source under the MIT license, it is primarily maintained for internal company workflows. Anyone is free to use it as-is.

## Features

- **Secure by Design:** Webhook URLs are processed strictly via environment variables and hidden from system process lists (`ps`) during execution.
- **Rich Formatting:** Generates clean Rocket.Chat attachment blocks with color-coded statuses (✅ Success, ❌ Failure, ⚠️ Cancelled).
- **Deep Linking:** Includes direct links back to the specific GitHub commit, branch/tag ref, and the specific Actions run log.

---

## Usage

Add this step to your GitHub Actions workflow file (e.g., `.github/workflows/ci.yml`). 

For accurate status reporting, ensure you use `if: always()` so the notification triggers regardless of whether preceding steps succeeded or failed.

```yaml
- name: Notify Rocket.Chat
  if: always()
  uses: your-org-or-username/your-repo-name@v1
  with:
    webhook: ${{ secrets.ROCKETCHAT_WEBHOOK }}
```

### Full Workflow Example

```yaml
name: CI Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run Build & Tests
        run: |
          npm ci
          npm run build

      - name: Send Rocket.Chat Notification
        if: always()
        uses: your-org-or-username/your-repo-name@v1
        with:
          webhook: ${{ secrets.ROCKETCHAT_WEBHOOK }}
```

## Inputs

| Input | Description | Required |
| :--- | :--- | :--- |
| `webhook` | The full Rocket.Chat Incoming Webhook URL. **Always pass this via GitHub Secrets.** | **Yes** |

---

## License

This project is licensed under the [MIT License](LICENSE).
