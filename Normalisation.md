Database Normalization
1. Overview
This document explains the normalization of the Nexora database schema.
The schema uses separate tables for users, properties, spaces, bookings,
payments, maintenance, inspections, reviews, notifications, and AI
activity.

The goal of normalization is to reduce duplicate data, prevent update
anomalies, and keep relationships between records consistent.
2. First Normal Form (1NF)
A table is in First Normal Form when:
- Each column contains a single, atomic value.
- Each row can be uniquely identified.
- There are no repeating groups or arrays of values stored in ordinary
  columns.
How the schema applies 1NF
The schema generally follows 1NF:
- profiles stores one user's name, email, phone, and role in
  separate columns.
- properties stores address components in separate columns.
- bookings stores one booking's start time, end time, guest count,
  and amounts in individual columns.
- property_media, space_media, and inspection_media store media
  records as separate rows instead of placing multiple media URLs in
  one property or space column.
- maintenance_updates stores each update as a separate row.
- inspection_items stores each inspection checklist item as a
  separate row.
- booking_status_history stores each status change as a separate
  row.
Example: Rather than storing several image URLs in one properties
row, the schema uses property_media with one media record per row and
a property_id foreign key.
1NF observation
The metadata, arguments, and result columns in the AI tables use
PostgreSQL jsonb. JSON is intentionally flexible and can contain
nested values. If the application needs to query or constrain individual
values inside these documents as regular relational attributes, those
values may need to be moved into separate columns or related tables.
Their presence does not by itself prove that the whole schema violates
1NF; it is a design choice that should be evaluated against how the data
is used.
3. Second Normal Form (2NF)
A table is in Second Normal Form when:
- It is already in 1NF.
- Every non-key attribute depends on the whole candidate key, not just
  part of a composite key.
How the schema applies 2NF
Most tables use a single-column primary key, so partial-key dependencies
do not arise in those tables.

The schema also has composite-key tables:
service_provider_categories
Primary key: (provider_id, category_id)

This table contains only the two columns that together identify the
provider-category relationship. It does not store a provider name or
category name that would depend on only one part of the key.
favorites
Primary key: (customer_id, space_id)

The row represents the relationship between one customer and one space.
created_at describes when that relationship was created and depends on
the relationship as a whole.
2NF observation
The composite-key tables are structured appropriately for 2NF because
they do not include descriptive attributes that depend on only one
component of their composite key.
4. Third Normal Form (3NF)
A table is in Third Normal Form when:
- It is already in 2NF.
- Non-key attributes depend on the key, the whole key, and nothing but
  the key.
- Non-key attributes do not depend transitively on other non-key
  attributes.
How the schema applies 3NF
The schema separates many entities into their own tables:
- User details are stored in profiles.
- Property details are stored in properties.
- Spaces belonging to properties are stored in spaces.
- Service categories are stored in service_categories.
- Provider details are stored in service_providers.
- Provider-to-category relationships are stored in
  service_provider_categories.
- Booking records are stored in bookings.
- Payment records are stored in payments.
- Inspection records and their checklist items are stored separately
  in inspections and inspection_items.
For example, a service category name is stored once in
service_categories. Other tables refer to it through category_id
rather than repeating the category name.
Possible 3NF improvements to review
The following are potential redundancy risks. Whether they are actual
normalization problems depends on the business rules and whether the
duplicated values are intended historical snapshots.
A. space_reviews
The table contains booking_id, customer_id, and space_id. Since
booking_id identifies a booking, the booking already determines its
customer and space.

If a review must always refer to the customer and space from its
booking, storing all three values duplicates facts and can allow
inconsistent combinations.

Possible improvement: Keep booking_id as the review's reference
and obtain the customer and space through bookings. If the extra
columns are retained for reporting or historical reasons, enforce
consistency with suitable constraints or application/database logic.
B. provider_reviews
The table contains maintenance_request_id, reviewer_id, and
provider_id. A maintenance request already identifies the requester
and may identify the assigned provider.

If those values must always match the maintenance request, storing them
again can create inconsistent data.

Possible improvement: Derive the reviewer and provider from
maintenance_requests where the business rules allow it. If the review
must preserve the provider who performed the work even after
reassignment, document that snapshot requirement and enforce it
explicitly.
C. property_expenses
The table contains both property_id and an optional
maintenance_request_id. When a maintenance request is supplied, that
request already identifies its property.

Possible improvement: Decide whether expenses can exist
independently of maintenance requests. If every linked expense must
belong to the same property as its maintenance request, enforce that
rule. If the duplicated property_id is retained to support independent
expenses or historical reporting, document the reason.
D. maintenance_requests.space_id
A maintenance request stores both property_id and an optional
space_id. A space already belongs to a property.

Possible improvement: If a request includes a space, ensure that the
space belongs to the same property recorded in the request. This is a
consistency constraint rather than a reason to remove property_id
automatically, because requests may apply to an entire property without
a specific space.
5. Relationships Supporting Normalization
  Relationship            Tables involved                 Purpose
  One user to many        profiles → properties       Keeps owner details
properties                                              separate from property
details

  One property to many    properties → spaces         Stores each rentable
spaces                                                  space independently

  One property to many    properties → property_media Avoids repeating media
media records                                           columns

  Many providers to many  service_providers ↔           Resolves a many-to-many
categories              service_categories through    relationship
service_provider_categories   

  One space to many       spaces → bookings           Keeps booking data
bookings                                                separate from space
data

  One booking to many     bookings → payments         Allows payment attempts
payments                                                or records to be stored
separately

  One inspection to many  inspections →                 Stores each inspected
checklist items         inspection_items              item independently
One maintenance request maintenance_requests →        Preserves an update
to many updates         maintenance_updates           history
6. Constraints That Support Data Integrity
The schema uses several database constraints that support consistent
relational data:
- Primary keys uniquely identify rows.
- Foreign keys connect related records and prevent references to
  missing parent records.
- Unique constraints prevent duplicate values such as profile
  emails and service category names.
- Check constraints validate booking time ranges, positive guest
  counts, and review ratings from 1 to 5.
- Enums restrict status and role columns to defined values.
- Not-null constraints require essential fields to be supplied.
Normalization and constraints solve different problems: normalization
reduces unnecessary duplication, while constraints enforce valid data
and relationships.
7. Summary
The schema is broadly organized around normalized entities and
relationships:
- 1NF: Repeating collections such as media, updates, inspection
  items, and status history are represented as separate rows.
- 2NF: Composite-key junction tables contain relationship
  attributes without obvious partial dependencies.
- 3NF: Major entities such as profiles, properties, spaces,
  service categories, providers, bookings, and inspections are
  separated.
The main areas to review for possible 3NF redundancy are
space_reviews, provider_reviews, property_expenses, and the
relationship between maintenance_requests.property_id and
maintenance_requests.space_id. These should be checked against the
intended business rules before changing the schema.