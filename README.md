# VetClinic - Lab 7: Action Text & Active Storage

This version of the VetClinic application is enriched with **Active Storage** for pet profile photos and **Action Text** for rich, formatted clinical notes in treatments.

## System Dependencies

To process image variants (thumbnails), this application requires **libvips** installed on your system.

### Installation instructions:
* **Arch Linux**: `sudo pacman -S libvips`
* **macOS (Homebrew)**: `brew install vips`
* **Ubuntu/Debian**: `sudo apt install libvips`

## Setup and Running the App

Follow these steps to get the application running on a fresh database:

1.  **Install dependencies**:
    ```bash
    bundle install
    ```
2.  **Setup the database**:
    This command will drop, create, migrate, and seed the database with sample owners, pets (including photos), and treatments.
    ```bash
    bin/rails db:setup
    ```
3.  **Start the server**:
    ```bash
    bin/rails server
    ```
    *Alternatively, if using CSS/JS bundling:* `bin/dev`

## Features Implemented

* **Active Storage**:
    * Pets can have one optional photo.
    * Validations for file type (JPEG, PNG, WebP) and size (max 5 MB).
    * Automatic thumbnail generation (60px square) for the index page using variants.
* **Action Text**:
    * Treatments include `clinical_notes` with rich text support (headings, bold, lists).
    * Optimized queries using eager loading to avoid N+1 issues.

## Sanitization Check (B.4)

A security verification was performed on the Action Text editor. After attempting to inject a `<script>alert(1)</script>` tag into a treatment's clinical notes, the following was observed:
* Action Text automatically sanitized the incoming HTML.
* The script was **not** executed (no alert pop-up appeared).
* The script tags were completely stripped from the rendered output, displaying only the inner text or being removed entirely, confirming protection against XSS attacks.
