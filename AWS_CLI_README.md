Here's your complete updated **AWS CLI Login Guide README**, now including instructions on how to set up a profile using `~/.aws/config` with an `assume-role` setup.

---

## 🔐 AWS CLI Login Guide

To authenticate and configure your AWS CLI credentials and assume roles, follow the steps below.

---

### 1. **Install AWS CLI**

If you haven't already, install the AWS CLI:
📎 [Install AWS CLI (Official Guide)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

---

### 2. **Login using `aws configure`**

Set your base credentials and default region/output:

```bash
aws configure
```

You will be prompted to enter:

```
AWS Access Key ID [None]: YOUR_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
Default region name [None]: ap-southeast-2  # or your preferred region
Default output format [None]: json          # or text / table
```

---

### 3. **Verify your login**

Check your credentials are working:

```bash
aws sts get-caller-identity
```

Expected output:

```json
{
    "UserId": "xxxxxxxxxxxxx",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-username"
}
```

---

### 4. **Configure Assume Role Profile**

Edit the AWS config file:

```bash
vi ~/.aws/config
```

Add the following configuration:

```ini
[default]
region = ap-southeast-2
output = json

[profile tf-session]
role_arn = arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME
source_profile = default
region = ap-southeast-2
output = json
```

> Replace `ACCOUNT_ID` and `ROLE_NAME` with your actual values.

---

### 5. **Use the Assume Role Profile**

To use the assumed role, run commands with the profile:

```bash
aws sts get-caller-identity --profile tf-session
```

To use the credentials in environment variables:

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME \
  --role-session-name tf-session \
  --profile default
```

Then, export the credentials from the response:

```bash
export AWS_ACCESS_KEY_ID=ASIA...
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYzEXAMPLEKEY
export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEGoaCXVzLWVhc3QtMSJGMEQC...
```

---

✅ **Tip:** You can create multiple profiles in `~/.aws/config` for different roles or environments. Use `--profile profilename` to switch between them.
