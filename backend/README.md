# Salary Management System

## 📌 Overview

A minimal yet functional salary management tool designed for HR managers to manage employees and derive meaningful salary insights.

The system enables efficient employee management along with analytical capabilities to support data-driven decisions.

---

## 🎯 Goals

* Manage employees (Create, Read, Update, Delete)
* Provide salary insights by country
* Provide salary insights by job title within a country
* Build a clean, maintainable, and scalable system

---

## 👤 User Persona

**HR Manager**

Needs:

* Easy employee management
* Quick access to salary statistics

---

## 🏗️ Architecture

```
Frontend (React) → Backend (Rails API) → Database (SQLite)
```

---

## 🧠 Design Approach

### 1. Separation of Concerns

* Controllers handle HTTP layer
* Business logic is encapsulated in service objects
* Models represent data and validations

---

## 📦 Core Features

### Employee Management

* Add employees
* View employee list
* Update employee details
* Delete employees

---

### Salary Insights

* Minimum, maximum, average salary per country
* Average salary by job title within a country

---

## 🗄️ Data Model

### Employee

* first_name (string)
* last_name (string)
* job_title (string)
* country (string)
* salary (integer)

---

## ⚙️ Tech Stack

### Backend

* Ruby on Rails (API mode)
* SQLite (for simplicity)

### Frontend

* React Js

---

## ⚡ Key Engineering Decisions

### 1. Service Layer

Business logic is extracted into service objects to:

* Improve readability
* Enhance testability
* Maintain separation of concerns

---

### 2. API-First Design

Backend is designed as a clean API to:

* Support independent frontend development
* Maintain flexibility

---

### 3. Simplicity First

* SQLite chosen for ease of setup
* Avoided over-engineering
* Focused on core requirements

---

## 📊 Assumptions

* Salary is stored in a single currency
* Country is treated as a simple string
* No authentication required for this version
* Dataset size (~10,000 employees) handled efficiently

---

## 🚀 Setup Instructions

### Backend

```
cd backend
bundle install
rails db:create db:migrate db:seed
rails server
```

---

### Frontend

```
cd frontend
npm install
npm run dev
```

---

## 🧪 Testing

```
cd backend
bundle exec rspec
```

Tests are:

* Fast
* Deterministic
* Focused on core business logic

---

## 📈 Future Improvements

* Pagination for employee listing
* Filtering and search capabilities
* Salary distribution visualization
* Multi-currency support
* Authentication & authorization

---

## 🤖 AI Usage

AI tools were used to:

* Accelerate initial setup
* Draft README file in a structure way

All outputs were reviewed, refined, and validated to ensure correctness and maintain quality standards.

---

## 📌 Notes

The focus of this implementation is not just functionality, but building software the right way with clarity, structure, and maintainability in mind.
