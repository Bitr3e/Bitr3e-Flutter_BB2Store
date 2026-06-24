# BB2 Store Cash Income Monitoring System
## Flutter & Dart Development Checklist

### Phase 1: Project Setup
- [x] Create Flutter project
- [x] Configure project structure (Clean Architecture)
- [x] Set up Git repository
- [x] Configure local database (SQLite using Drift)
- [x] Configure state management (Riverpod)
- [x] Create app theme and branding for BB2 Store

---

# Core Data Models

### Cash Income Model
- [x] Create denomination model
- [x] Create daily cash record model
- [x] Create cash-out model
- [x] Create net income model

### Database Tables
- [x] Daily Income Table
- [x] Cash-Out Table
- [x] Daily Summary Table (computed via repository)
- [x] Historical Records Table (queryable via repository date-range methods)

---

# Dashboard Module

### Dashboard UI
- [x] Create dashboard screen
- [x] Display today's gross income
- [x] Display today's cash-out
- [x] Display daily fund deduction (₱300)
- [x] Display today's net income

### Dashboard Analytics
- [x] Display highest income recorded
- [x] Display lowest income recorded
- [x] Display previous day's income
- [x] Display current week's income
- [x] Display current month's income
- [x] Display current year's income

### Dashboard Cards
- [x] Highest Income Card
- [x] Lowest Income Card
- [x] Yesterday's Income Card
- [x] Today's Net Income Card

---

# Daily Income Recording Module

### Cash Denomination Inputs
- [x] ₱1 denomination field
- [x] ₱5 denomination field
- [x] ₱10 denomination field
- [x] ₱20 denomination field
- [x] ₱50 denomination field
- [x] ₱100 denomination field
- [x] ₱200 denomination field
- [x] ₱500 denomination field
- [x] ₱1000 denomination field

### Automatic Calculations
- [x] Calculate subtotal per denomination
- [x] Calculate total cash collected
- [x] Display gross income preview
- [x] Auto-update calculations while typing

### Validation
- [x] Prevent negative values
- [x] Prevent empty submissions
- [x] Validate numeric input

---

# Cash-Out Module

### Cash-Out Management
- [x] Add cash-out entry
- [x] Edit cash-out entry
- [x] Delete cash-out entry
- [x] Add cash-out description
- [x] Record cash-out amount

### Cash-Out Categories
- [x] Supplier payment
- [x] Personal withdrawal
- [x] Store expenses
- [x] Miscellaneous expenses

### Calculations
- [x] Sum all cash-outs
- [x] Display total cash-outs

---

# Net Income Calculation Engine

### Formula Implementation
- [x] Calculate Gross Income (in repositories & dashboard)

```text
Gross Income =
(₱1 × qty) +
(₱5 × qty) +
(₱10 × qty) +
...
(₱1000 × qty)
```

- [x] Calculate Total Cash-Out (in CashOutRepository)

```text
Total Cash-Out = Sum of all cash-out entries
```

- [x] Deduct Daily Fund (constant ₱300)

```text
Daily Fund = ₱300
```

- [x] Calculate Net Income (in repositories & dashboard)

```text
Net Income =
Gross Income
- Total Cash-Out
- ₱300 Daily Fund
```

### Summary Display
- [x] Show Gross Income (with per-denomination breakdown)
- [x] Show Total Cash-Out (with individual entry list)
- [x] Show Daily Fund Deduction (₱300.00)
- [x] Show Net Income (with color-coded result)

---

# History Module

### Daily History
- [x] View all daily records
- [x] Search daily records (text search by label/date)
- [x] View detailed transaction summary (gross, cash-out, fund, net per entry)

### Weekly History
- [x] Group records by week
- [x] Display weekly totals
- [x] Display weekly average income

### Monthly History
- [x] Group records by month
- [x] Display monthly income totals
- [x] Display monthly cash-out totals
- [x] Display monthly net income

### Yearly History
- [x] Group records by year
- [x] Display annual income totals
- [x] Display annual statistics

### Filters
- [x] View type filter (Daily/Weekly/Monthly/Yearly chips)
- [x] Weekly filter (via view type chips)
- [x] Monthly filter (via view type chips)
- [x] Yearly filter (via view type chips)

---

# Analytics Module

### Income Statistics
- [x] Calculate highest income day
- [x] Calculate lowest income day
- [x] Calculate average daily income
- [x] Calculate average monthly income
- [x] Calculate yearly total income

### Comparative Analytics
- [x] Compare today vs yesterday (with ₱ and % change)
- [x] Compare this week vs last week (with ₱ and % change)
- [x] Compare this month vs last month (with ₱ and % change)

---

# Graph and Visualization Module

### Daily Income Graph
- [x] Line chart for daily net income (last 30 days)

### Weekly Summary Graph
- [x] Bar chart for weekly income (last 12 weeks)

### Monthly Summary Graph
- [x] Bar chart for monthly income with Cash-Out overlay

### Yearly Summary Graph
- [x] Line chart for yearly income trends

### Dashboard Graph Widget
- [x] Income trend graph (daily line chart)
- [x] Highest vs Lowest income comparison (via Analytics)
- [x] Cash-In vs Cash-Out comparison bar chart (latest day)

---

# Data Management

### Backup and Restore
- [x] Export data to CSV (income & cash-out as separate files)
- [x] Import data from CSV (select from backup files)
- [x] Local backup functionality (saved to app documents/backups/)

### Record Management
- [x] View historical records list
- [x] Delete historical records (with confirmation)
- [x] Restore deleted records (via CSV import from backups)

---

# Settings Module

### App Settings
- [x] Change daily fund amount (persisted via SharedPreferences)
- [x] Configure currency symbol
- [x] Theme mode selector (System / Light / Dark)
- [x] Daily fund amount used in dashboard & net income calculations

---

# Testing

### Functional Testing
- [ ] Test denomination calculations
- [ ] Test cash-out calculations
- [ ] Test net income calculations
- [ ] Test history grouping
- [ ] Test dashboard analytics
- [ ] Test graph rendering

### Edge Cases
- [ ] Zero income scenario
- [ ] Large income values
- [ ] Multiple cash-out entries
- [ ] Missing historical records

---

# Deployment

- [ ] Optimize app performance
- [ ] Generate release APK
- [ ] Generate Android App Bundle
- [ ] Test on physical Android device
- [ ] Final production release

---

# Version 1.0 Completion Criteria

- [ ] Daily cash income recording works
- [ ] Automatic denomination calculations work
- [ ] Cash-out tracking works
- [ ] ₱300 daily fund deduction works
- [ ] Net income calculation is accurate
- [ ] Daily, weekly, monthly, and yearly history works
- [ ] Dashboard analytics works
- [ ] Graphs and summaries work
- [ ] Data persists locally
- [ ] Application ready for BB2 Store operations