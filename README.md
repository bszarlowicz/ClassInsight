# Mentora – A Platform for Managing Extracurricular Learning
## Project Goal

The aim of this project is to develop a comprehensive system called **Mentora**, designed to streamline and optimize the organization and management of extracurricular learning activities. The platform addresses the needs of three key user groups:

- **Teachers**
- **Students**
- **Parents**

By uniting all participants in one intuitive system, Mentora enhances communication, coordination, and access to essential tools and information through automation and a user-friendly interface.

---

## Technology Overview

This section outlines the technologies used in building the Mentora platform. Choosing the right tools is crucial for software quality, performance, and maintainability. The selected stack was carefully analyzed to ensure system stability and flexibility in the face of evolving needs.

---

## Frontend – Ruby on Rails

Although Ruby on Rails is commonly known as a backend framework, this project utilizes its **full-stack capabilities** by leveraging **Hotwire** for building responsive and dynamic frontends with minimal JavaScript.

### Why Ruby on Rails?

- **Convention Over Configuration**: Reduces boilerplate code and accelerates development.
- **Don’t Repeat Yourself (DRY)**: Promotes maintainable, clean, and non-redundant code.
- **MVC Architecture (Model-View-Controller)**:
  - **Model**: Manages application data and business logic.
  - **View**: Handles presentation and UI rendering.
  - **Controller**: Acts as an intermediary, processing user input and updating views/models accordingly.
- **Hotwire Integration**: Enables modern interactivity by sending HTML from the server, avoiding complex frontend JavaScript setups. Components like Turbo and Stimulus enable fast page updates and real-time interactivity.

---

## Backend – Ruby

The backend of the application is built using **Ruby**, a dynamic, object-oriented language known for its elegant syntax and developer productivity.

### Why Ruby?

- **Simple, Readable Syntax**: Ideal for rapid development and collaboration.
- **Object-Oriented**: Everything is an object, supporting clean code architecture.
- **Test-Friendly**: Encourages writing maintainable and well-tested code.
- **Rails Compatibility**: Seamless integration with the Rails framework accelerates backend development.

---

## Database – MySQL

Mentora uses **MySQL** as its relational database management system.

### Why MySQL?

- **Performance & Reliability**: Handles large volumes of data efficiently.
- **Relational Structure**: Organizes data into connected tables using primary and foreign keys, ensuring consistency.
- **Scalability**: Can scale with system growth and evolving data requirements.
- **Easy Integration**: Works seamlessly with ActiveRecord ORM in Rails.

---

## ORM – ActiveRecord

The project utilizes **ActiveRecord**, the default ORM in Ruby on Rails, which simplifies database interactions.

- Abstracts SQL queries into Ruby methods.
- Supports migrations, validations, and associations.
- Streamlines model-database interaction using Ruby syntax.

---

## Summary

Mentora is built to provide a centralized and intelligent solution for managing extracurricular educational activities. Through careful selection of technologies—Ruby on Rails, Ruby, MySQL, and Hotwire—the platform delivers on its promise of performance, flexibility, and ease of use. The system allows teachers, students, and parents to interact seamlessly in a shared digital space, streamlining the planning and coordination of supplementary education.

---

Please check project documentation!

[presentation.pptx](https://github.com/user-attachments/files/21215874/prezentacja_obrona_ang.pptx)
[thesis.pdf](https://github.com/user-attachments/files/21215887/Bartosz_Szarlowicz_Praca_Dyplomowa_final.pdf)
