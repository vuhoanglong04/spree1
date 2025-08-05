# Project Specification: Spree eCommerce Website

## Overview

A modern eCommerce web application built on **Ruby on Rails 8.0.2** and **Spree**, featuring secure authentication (including social login), role-based authorization, real-time UI with Hotwire, file uploads via **AWS S3**, advanced search with **Elasticsearch**, Redis caching, **Stripe payment**, **background jobs**, **email delivery with SendGrid**, and **Chatwork integration for system notifications**. The system is simplified by **removing tax logic** and styled with **Tailwind CSS**.

---

## Features Table

| Feature Category           | Description                                                                                          |
| -------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Product Catalog**        | Manage products, images, variants, and categories via admin interface.                               |
| **Authentication**         | Devise-based secure login/logout/registration with **OmniAuth** for social login (Google, Facebook). |
| **Authorization (RBAC)**   | Role-based access control with **Pundit** (`Admin`, `Customer`, etc.).                               |
| **Admin Panel**            | Admin dashboard for managing orders, products, and user roles.                                       |
| **Responsive UI**          | Clean and modern **Tailwind CSS** styling with mobile-first design.                                  |
| **Search (Elasticsearch)** | Full-text product search, category filters, and sorting.                                             |
| **Caching (Redis)**        | Redis-backed fragment and page caching for fast performance.                                         |
| **Payments (Stripe)**      | Stripe integration for secure online payments.                                                       |
| **File Uploads (S3)**      | Product and user images are uploaded using **ActiveStorage + AWS S3**.                               |
| **Cart & Checkout**        | Persistent cart, add/remove products, update quantities, complete checkout.                          |
| **Promotions**             | Support for discount codes and timed sales events.                                                   |
| **Turbo/Hotwire UI**       | Real-time cart updates and UX interactions using Turbo Frames and Turbo Streams.                     |
| **Email with SendGrid**    | **Transactional emails** (order confirmation, password reset) sent via **SendGrid API**.             |
| **Background Jobs**        | Background processing using **Sidekiq** for emails, file processing, search indexing, etc.           |
| **Social Login (OAuth)**   | Allow users to log in using **Google** or **Facebook** via **OmniAuth**.                             |
| **Chat Notifications**     | Send system alerts or task messages to **Chatwork rooms** using the **`chatwork` gem**.              |             |
| **Testing**                | RSpec with FactoryBot for backend unit and request specs.                                            |

---

## Technical Stack

| Layer                  | Tool/Library                             |
| ---------------------- | ---------------------------------------- |
| **Backend**            | Ruby on Rails 8.0.2, Ruby 3.2+           |
| **Frontend**           | Tailwind CSS, Hotwire (Turbo + Stimulus) |
| **Search**             | Elasticsearch 8.x                        |
| **Caching**            | Redis                                    |
| **Uploads**            | ActiveStorage + Amazon S3                |
| **Authentication**     | Devise + OmniAuth                        |
| **Authorization**      | Pundit                                   |
| **Email**              | SendGrid                                 |
| **Payments**           | Stripe                                   |
| **Background Jobs**    | Sidekiq + Redis                          |
| **Chat Notifications** | Chatwork gem                             |
| **Database**           | PostgreSQL                               |
| **Testing**            | RSpec, FactoryBot                        |

---

## Setup Checklist

* ✅ TailwindCSS setup via `tailwindcss-rails`
* ✅ Devise + Pundit for user access
* ✅ Redis installed and running (used by Sidekiq + caching)
* ✅ Elasticsearch running (with model indexing setup)
* ✅ AWS S3 credentials stored in `credentials.yml.enc`
* ✅ SendGrid API key set in Rails credentials
* ✅ Stripe keys stored in environment/config
* ✅ OmniAuth configured for **Google** and **Facebook** login
* ✅ Chatwork API token stored in Rails credentials (`CHATWORK_API_TOKEN`)

---

## Time Estimates

| Task                                | Hours           |
| ----------------------------------- | --------------- |
| Spree + Rails base setup            | 3               |
| Auth (Devise) & Roles (Pundit)      | 4               |
| Social login (OmniAuth)             | 3               |
| Admin dashboard + Product CRUD      | 5               |
| Elasticsearch setup                 | 4               |
| Redis caching                       | 3               |
| AWS S3 upload                       | 2               |
| Cart & checkout logic               | 5               |
| Stripe integration                  | 4               |
| Background jobs with Sidekiq        | 3               |
| Email config (SendGrid) + templates | 3               |
| Chatwork notification integration   | 2               |
| Tailwind UI & layout                | 4               |
| Remove tax from backend + views     | 2               |
| Turbo Streams/Stimulus enhancements | 4               |
| Testing with RSpec                  | 4               |
| Deployment config                   | 2               |
| **Total**                           | **58–63 hours** |

---

