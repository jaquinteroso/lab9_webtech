# VetClinic - Lab 9: Authorization with Pundit

This version of the VetClinic application implements a secure authentication system using **Devise** and a robust authorization system using **Pundit**. Access to the application's resources is now strictly controlled based on user roles and data ownership.

## Authorization Rules & Role Matrix

The application enforces access control through the following role matrix:

* **Admin**: Has full CRUD (Create, Read, Update, Delete) access to all records in the application.
* **Veterinarian (`:vet`)**: Has read-only access to owners, pets, and other vets. They can edit their own profile, and have CRUD access to appointments and treatments *only* if they are the assigned veterinarian.
* **Owner (`:owner`)**: Can only view and edit their own profile. They have scoped access to view, create, and manage pets and appointments that belong strictly to them. They have read-only access to vet profiles to schedule appointments. They can only view treatments associated with their own appointments.

*Note: Open self-registration has been disabled to prevent the creation of orphan accounts. Every `Owner` and `Vet` user account is strictly linked to their respective business domain record via a `user_id`.*

## Seeded Test Credentials

To test the different roles, authorization scopes, and data privacy, the following users are created during `db:setup`. Each user is linked to interrelated data (pets, appointments, treatments) to demonstrate Pundit policies in action:

| Role | Email | Password |
| :--- | :--- | :--- |
| **Admin** | `admin@vetclinic.com` | `password123` |
| **Veterinarian** | `vet@vetclinic.com` | `password123` |
| **Owner** | `owner@vetclinic.com` | `password123` |

## System Dependencies

To process image variants (thumbnails), this application requires **libvips** installed on your system.

### Installation instructions:

* **Arch Linux**: `sudo pacman -S libvips`
* **macOS (Homebrew)**: `brew install vips`
* **Ubuntu/Debian**: `sudo apt install libvips`

## Setup and Running the App

Follow these steps to get the application running on a fresh database:

1. **Install dependencies**:
```bash
bundle install
```

2. **Setup the database**:
This command will drop, create, migrate, and seed the database with correctly linked users, owners, pets, appointments, and treatments.
```bash
bin/rails db:setup
```

3. **Start the server**:
```bash
bin/dev
```

## Features Implemented (Previous Labs)

* **Authentication**: Managed via Devise with role-based attributes.
* **Active Storage**: Profile photos for pets with automatic 60px thumbnails.
* **Action Text**: Rich text support for clinical notes in treatments with N+1 query optimization.
* **Sanitization**: Automatic XSS protection in the rich text editor.
