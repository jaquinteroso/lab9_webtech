# VetClinic - Lab 8: Authentication & User Roles

This version of the VetClinic application implements a secure authentication system using **Devise**. Access to the application's resources is now restricted to registered users.

## Authentication & Security

* **Restricted Access**: All resource pages (Owners, Pets, Vets, Appointments, and Treatments) now require a signed-in user. Only the Home page remains public.
* **User Profiles**: The `User` model has been extended to include `first_name` and `last_name`, which are required and managed via Devise's strong parameters.
* **Role System**: Users are assigned one of three roles: `:owner`, `:vet`, or `:admin`. These roles are currently used for identification and will be used for authorization in future labs.

## Seeded Test Users

To test the different roles and authentication states, the following users are created during `db:setup`:

| Role | Email | Password |
| --- | --- | --- |
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
This command will drop, create, migrate, and seed the database with users, owners, pets, and treatments.
```bash
bin/rails db:setup

```


3. **Start the server**:
```bash
bin/rails server


```
## Features Implemented (Previous Labs)

* **Active Storage**: Profile photos for pets with automatic 60px thumbnails.
* **Action Text**: Rich text support for clinical notes in treatments with N+1 query optimization.
* **Sanitization**: Automatic XSS protection in the rich text editor.
