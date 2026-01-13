# Inventra UI Flows & Wireframes

## 1. Identity & Onboarding

### A. Landing Screen
- **Elements**: Logo, "Login" button, "Register User" button.
- **Micro-copy**: "Company-First Business Management"

### B. User Registration Flow (New User, Existing Company)
1. **Screen 1: Company Identification**
   - **Input**: `Company TIN`
   - **Action**: "Verify Company"
   - **Backend Check**: Does Company with this TIN exist?
     - *Yes*: Show Company Name, proceed.
     - *No*: Error "Company not found. Please contact your administrator."
2. **Screen 2: User Details**
   - **Display**: "Joining: [Company Name]"
   - **Inputs**: Name, Email, Username, Password.
   - **Action**: "Create Account"

### C. Login Flow
- **Inputs**:
  - `Company TIN` (Could be remembered on device)
  - `Username`
  - `Password`
- **Action**: "Login"
- **Logic**: Authenticate against `users` table where `company_tin` matches.

## 2. Dashboard (Home)
- **Header**: Company Logo/Name, User Profile Icon.
- **Stats Cards**: "Total Revenue (Month)", "Overdue Invoices", "Low Stock Items".
- **Quick Actions**: "New Invoice", "Add Client".
- **Bottom Nav**: Home, Invoices, Items, Clients, Settings.

## 3. Invoices
- **List View**: Filterable by Status (Paid, draft, etc).
- **Create Invoice**:
  - Select Client (Dropdown).
  - Add Items (Dynamic list row).
  - Auto-calc totals.
  - "Save Draft" or "Finalize".

## 4. Settings
- **Company Profile**: View-only for Staff, Editable for Admin.
- **User Management**: Admin can invite/disable users.
