# BB2 Store Cash Income Monitoring System
## Flutter & Dart Development Checklist

### Phase 1: Project Setup
- [ ] Create Flutter project
- [ ] Configure project structure (MVC/Clean Architecture)
- [ ] Set up Git repository
- [ ] Configure local database (SQLite using Drift/Sqflite)
- [ ] Configure state management (Provider/Riverpod/Bloc)
- [ ] Create app theme and branding for BB2 Store

---

# Core Data Models

### Cash Income Model
- [ ] Create denomination model
- [ ] Create daily cash record model
- [ ] Create cash-out model
- [ ] Create net income model

### Database Tables
- [ ] Daily Income Table
- [ ] Cash-Out Table
- [ ] Daily Summary Table
- [ ] Historical Records Table

---

# Dashboard Module

### Dashboard UI
- [ ] Create dashboard screen
- [ ] Display today's gross income
- [ ] Display today's cash-out
- [ ] Display daily fund deduction (₱300)
- [ ] Display today's net income

### Dashboard Analytics
- [ ] Display highest income recorded
- [ ] Display lowest income recorded
- [ ] Display previous day's income
- [ ] Display current week's income
- [ ] Display current month's income
- [ ] Display current year's income

### Dashboard Cards
- [ ] Highest Income Card
- [ ] Lowest Income Card
- [ ] Yesterday's Income Card
- [ ] Today's Net Income Card

---

# Daily Income Recording Module

### Cash Denomination Inputs
- [ ] ₱1 denomination field
- [ ] ₱5 denomination field
- [ ] ₱10 denomination field
- [ ] ₱20 denomination field
- [ ] ₱50 denomination field
- [ ] ₱100 denomination field
- [ ] ₱200 denomination field
- [ ] ₱500 denomination field
- [ ] ₱1000 denomination field

### Automatic Calculations
- [ ] Calculate subtotal per denomination
- [ ] Calculate total cash collected
- [ ] Display gross income preview
- [ ] Auto-update calculations while typing

### Validation
- [ ] Prevent negative values
- [ ] Prevent empty submissions
- [ ] Validate numeric input

---

# Cash-Out Module

### Cash-Out Management
- [ ] Add cash-out entry
- [ ] Edit cash-out entry
- [ ] Delete cash-out entry
- [ ] Add cash-out description
- [ ] Record cash-out amount

### Cash-Out Categories
- [ ] Supplier payment
- [ ] Personal withdrawal
- [ ] Store expenses
- [ ] Miscellaneous expenses

### Calculations
- [ ] Sum all cash-outs
- [ ] Display total cash-outs

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