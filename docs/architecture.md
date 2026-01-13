# Inventra Architecture

## Core Philosophy
**Company-Centric, Not User-Centric.**
- A company is the primary entity.
- Users exist only within the context of a company.
- Data is owned by the company, not the user.
- **TIN (Tax Identification Number)** is the business key for tenant isolation.

## System Components

### 1. Mobile App (Flutter)
- **Role**: Client interface for users.
- **State Management**: Provider (stores `AuthToken` and `CurrentUser` including `CompanyTIN`).
- **Key Features**:
  - **Login**: (Username + Company TIN + Password).
  - **Registration**: User enters Company TIN (Company must exist).
  - **Dashboard**: Company-scoped data.

### 2. Backend API (Go + Gin)
- **Role**: RESTful API handling business logic and data access.
- **Middleware**:
  - `AuthMiddleware`: Validates JWT.
  - `CompanyScopeMiddleware`: Extracts `company_tin` from context/token and enforces it on all DB queries.
- **Authentication**:
  - Login endpoint accepts `{username, password, company_tin}`.
  - Returns JWT containing `company_tin` claim.

### 3. Database (MySQL)
- **Strategy**: Shared Database, Logical Multi-tenancy.
- **Schema Pattern**: Every table (except `companies`) MUST have a `company_tin` column as a Foreign Key to `companies(tin)`.
- **Indexing**: Composite indexes on `(company_tin, ...)` for performance.

## Data Flow
1. **Request**: Client sends request with JWT.
2. **Auth**: Backend validates JWT, extracts `company_tin`.
3. **Query**: Repository layer verifies `company_tin` is present in every WHERE clause.
4. **Response**: Data returned is strictly for that company.
