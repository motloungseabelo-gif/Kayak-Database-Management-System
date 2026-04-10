# Kayak Database Management System

## Overview

This project is an Oracle SQL-based database system designed to manage kayaks, customers, and upgrade services. It demonstrates database design, relationships, SQL queries, views, and PL/SQL programming.

## Database Structure

The system consists of the following tables:

- **kayaks** – Stores kayak details
- **customer** – Stores customer information
- **upgrades** – Stores upgrade services
- **kayak_upgrades** – Links kayaks, customers, and upgrades

## Relationships

- One kayak can have many upgrades
- One customer can request multiple upgrades
- One upgrade type can be applied to many kayaks

## Features Implemented

- Table creation with primary and foreign keys
- Data insertion
- Joins and advanced queries
- View creation
- PL/SQL cursor for processing records
- User creation with role-based privileges

## Security Concept

This project demonstrates **separation of duties**:

- One user has read-only access
- Another user has insert-only access

This improves database security and accountability.

## Sample Queries

- Calculate total upgrade cost
- Display customer upgrade details
- Apply discount calculations

## Technologies Used

- Oracle SQL
- PL/SQL

## How to Run

1. Open Oracle SQL Developer  
2. Create a new connection  
3. Run the script file: `kayak-database.sql`  
4. Execute queries and view results  

## Author

**Seabelo Blessing Motloung**

- Software Developer  
  
