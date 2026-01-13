# Implementation Plan: Inventra (Multi-Tenant Invoicing)

# Goal Description
Develop a company-centric, multi-tenant invoicing application where **Company TIN (Tax Identification Number)** is the primary key for tenant isolation. The system ensures that all data is strictly scoped to a company entity verified by its TIN. The tech stack is Flutter (Mobile) and Go/Gin (Backend) with MySQL.

## User Review Required
> [!IMPORTANT]
> **Data Isolation**: I am implementing "Logical Isolation" (Shared Database). This relies heavily on backend middleware to enforce `company_tin` checks. Every table must have a `company_tin` column.

## Proposed Changes

### Backend (Go/Gin) - `server/`
#### Architecture
- **Simplified**: Handlers -> Services -> Models (No Repositories).
- **Middleware**: create `CompanyScopeMiddleware` to extract `company_tin` from JWT and inject into context.
- **Existing Auth**: Logic in `auth_handler.go` is good. Consolidate where needed.

#### Database (MySQL)
- **Tables Exist**: User confirmed tables are created. I will verify schema compliance (specifically `company_tin` FK) and create migrations for any missing columns/constraints.
- **Constraint**: ALL tables must have `company_tin` as a Foreign Key to `companies(tin)`.

#### API Endpoints
- **Invoices**: CRUD endpoints, all scoped by `company_tin` from context.
- **Inventory/Clients**: CRUD endpoints scoped by `company_tin`.
- **Models**: Validate `Invoice` model enums (`InvoiceType`, `CalculationType`) match business requirements.

### Mobile App (Flutter) - `mobile/`
#### State Management
- **Shared Preferences**: Use `shared_preferences` to persist `AuthToken`, `CurrentUser`, and `CompanyTIN`.

#### Screens
- [MODIFY] `lib/screens/auth/login.dart`: Ensure it sends `company_tin`, `username`, `password`.
- [MODIFY] `lib/screens/menu.dart`: 
    - Retrieve `company_name` from SharedPreferences (stored during login).
    - Display Company Name in the Header/AppBar instead of static 'Inventra'.
    - Ensure menu items navigate to filtered views.

#### Networking
- [MODIFY] `lib/services/api_service.dart`:
    - Update `headers` method or create an Interceptor.
    - **Header Injection**: Must inject `Authorization: Bearer <token>` AND `X-Company-TIN: <tin>` (if not in token) to *every* request.

## Verification Plan

### Automated Tests
- **Backend Tests**: Verify `company_tin` isolation.
- **Mobile Tests**: Verify User Flow.

### Manual Verification
1. **Registration Flow**:
   - Register with valid TIN.
2. **Data Isolation**:
   - Create two users in different companies.
   - User A logs in -> See Company A Name on Dashboard.
   - User A creates invoice.
   - User B logs in -> See Company B Name -> Check list (Expect Empty).
