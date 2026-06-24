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
- [ ] Calculate Gross Income

```text
Gross Income =
(₱1 × qty) +
(₱5 × qty) +
(₱10 × qty) +
...
(₱1000 × qty)
```

- [ ] Calculate Total Cash-Out

```text
Total Cash-Out = Sum of all cash-out entries
```

- [ ] Deduct Daily Fund

```text
Daily Fund = ₱300
```

- [ ] Calculate Net Income

```text
Net Income =
Gross Income
- Total Cash-Out
- ₱300 Daily Fund
```

### Summary Display
- [ ] Show Gross Income
- [ ] Show Total Cash-Out
- [ ] Show Daily Fund Deduction
- [ ] Show Net Income

---

# History Module

### Daily History
- [ ] View all daily records
- [ ] Search daily records
- [ ] View detailed transaction summary

### Weekly History
- [ ] Group records by week
- [ ] Display weekly totals
- [ ] Display weekly average income

### Monthly History
- [ ] Group records by month
- [ ] Display monthly income totals
- [ ] Display monthly cash-out totals
- [ ] Display monthly net income

### Yearly History
- [ ] Group records by year
- [ ] Display annual income totals
- [ ] Display annual statistics

### Filters
- [ ] Date range filter
- [ ] Weekly filter
- [ ] Monthly filter
- [ ] Yearly filter

---

# Analytics Module

### Income Statistics
- [ ] Calculate highest income day
- [ ] Calculate lowest income day
- [ ] Calculate average daily income
- [ ] Calculate average monthly income
- [ ] Calculate yearly total income

### Comparative Analytics
- [ ] Compare today vs yesterday
- [ ] Compare this week vs last week
- [ ] Compare this month vs last month

---

# Graph and Visualization Module

### Daily Income Graph
- [ ] Line chart for daily net income

### Weekly Summary Graph
- [ ] Bar chart for weekly income

### Monthly Summary Graph
- [ ] Bar chart for monthly income

### Yearly Summary Graph
- [ ] Line chart for yearly income trends

### Dashboard Graph Widget
- [ ] Income trend graph
- [ ] Highest vs Lowest income comparison
- [ ] Cash-In vs Cash-Out comparison

---

# Data Management

### Backup and Restore
- [ ] Export data to CSV
- [ ] Import data from CSV
- [ ] Local backup functionality

### Record Management
- [ ] Edit historical records
- [ ] Delete historical records
- [ ] Restore deleted records

---

# Settings Module

### App Settings
- [ ] Change daily fund amount
- [ ] Configure currency format
- [ ] Dark mode support
- [ ] Backup settings

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