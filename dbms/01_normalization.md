# SpaceCare: Normalization (UNF → 1NF → 2NF → 3NF)

SpaceCare is a marketplace where people rent short-term spaces (meeting rooms, workshops,
pop-up stores, studios, parking) from owners who have unused space. This document starts
from one flat "everything in a single sheet" relation and normalises it step by step to
**Third Normal Form (3NF)**. The final tables are the ones in `03_schema.sql`.

---

## 0. Unnormalised form (UNF)

Imagine the business kept one spreadsheet row per booking:

```
BOOKING_SHEET(
  booking_code, booking_start, booking_end, guests, booking_status,
  renter_email, renter_name, renter_phone,
  owner_email, owner_name, owner_business_name, owner_gst,
  space_title, space_type, space_address, city, state, country, capacity,
  price_per_hour, price_per_day,
  amenities            -- "Wi-Fi, Projector, AC"         (multi-valued)
  image_urls           -- "1.jpg, 2.jpg, 3.jpg"          (multi-valued)
  opening_hours        -- "Mon 09-21, Tue 09-21, ..."    (multi-valued)
  payments             -- "UPI 4500 SUCCEEDED; ..."      (repeating group)
  rating, review_comment
)
```

Problems:

- **Repeating groups / multi-valued cells:** `amenities`, `image_urls`, `opening_hours`, `payments`.
- **Update anomaly:** a space's price or an owner's phone is copied into every booking row.
- **Insert anomaly:** a new space can't be listed until someone books it.
- **Delete anomaly:** deleting a space's only booking also deletes the space and its owner.

---

## 1. First Normal Form (1NF)

**Rule:** every attribute holds one atomic value, there are no repeating groups, and each row
has a primary key.

The multi-valued columns move into their own relations, one row per value:

| Relation | Key | Came from |
| --- | --- | --- |
| `BOOKING_1NF(booking_code, …all single-valued columns…)` | `booking_code` | main sheet |
| `SPACE_AMENITY(space_title, amenity_name)` | (space_title, amenity_name) | `amenities` |
| `SPACE_IMAGE(space_title, sort_order, url, is_cover)` | (space_title, sort_order) | `image_urls` |
| `AVAILABILITY(space_title, day_of_week, opens_at, closes_at)` | (space_title, day_of_week, opens_at) | `opening_hours` |
| `PAYMENT(provider_ref, booking_code, kind, method, amount, status)` | `provider_ref` | `payments` |

The data is now in 1NF, but `BOOKING_1NF` still mixes facts about renters, owners, spaces and
cities, and the anomalies remain.

---

## 2. Second Normal Form (2NF)

**Rule:** 1NF, and no non-key attribute depends on only *part* of a composite key
(no partial dependencies).

Partial dependencies in the 1NF composite-key tables:

- `SPACE_AMENITY(space_title, amenity_name, amenity_icon)`: `amenity_icon` depends on
  `amenity_name` alone.

  → Split into `AMENITY(amenity_id, name, icon)` and `SPACE_AMENITY(space_id, amenity_id)`.
- `SPACE_IMAGE` and `AVAILABILITY`: their non-key columns depend on the whole key, so they
  are already in 2NF. They now reference `space_id` instead of `space_title`.

We also give each entity a surrogate key (`id SERIAL`), so `BOOKING_1NF` has a single-column
key and can't have partial dependencies. Its remaining problem is transitive dependencies.

---

## 3. Third Normal Form (3NF)

**Rule:** 2NF, and no non-key attribute depends on another non-key attribute
(no transitive dependencies X → Y → Z).

### Functional dependencies found in `BOOKING_1NF`

| # | Dependency | Why it violates 3NF |
| --- | --- | --- |
| FD1 | `booking_id → renter_email` and `renter_email → renter_name, renter_phone` | renter facts depend on the renter, not the booking |
| FD2 | `booking_id → space_title` and `space_id → title, type, address, capacity, prices, owner, city` | space facts depend on the space |
| FD3 | `space_id → owner_email` and `owner_email → owner_name, business_name, gst` | owner facts depend on the owner |
| FD4 | `space_id → city` and `(city, state) → country` | location hierarchy |
| FD5 | `booking_id → rating, review_comment` exists only for completed bookings | optional 1–1 fact, so it gets its own relation |

### Decomposition

| From FD | New relation |
| --- | --- |
| FD1 | `USERS(id, email, phone, password_hash, full_name, role, …)` |
| FD3 | `OWNER_PROFILES(id, user_id → USERS, business_name, gst_number, verification_status, …)` |
| FD4 | `CITIES(id, name, state, country)` |
| FD2 | `SPACES(id, owner_id → OWNER_PROFILES, city_id → CITIES, title, slug, type, status, address_line1, postal_code, latitude, longitude, capacity, area_sqft, price_per_hour, price_per_day, …)` |
| booking itself | `BOOKINGS(id, booking_code, space_id → SPACES, renter_id → USERS, starts_at, ends_at, guests, status, pricing_unit, unit_price, units, fees…)` |
| FD5 | `REVIEWS(id, booking_id UNIQUE → BOOKINGS, rating, comment, owner_reply)` |

Remaining relations: `SPACE_IMAGES`, `AMENITIES`, `SPACE_AMENITIES`, `AVAILABILITY_RULES`,
`BLOCKED_SLOTS`, `PAYMENTS`, `FAVOURITES`, `CONVERSATIONS` and `MESSAGES`.

---

## 4. Final 3NF schema (15 tables)

| Table | Primary key | Foreign keys | Functional dependencies (key → attributes) |
| --- | --- | --- | --- |
| `users` | id | none | id → email, phone, password_hash, full_name, avatar_url, role, is_active. email and phone are also candidate keys. |
| `owner_profiles` | id | user_id → users (unique, 1–1) | id → user_id, business_name, bio, gst_number, verification_status, verified_at |
| `cities` | id | none | id → name, state, country. (name, state, country) is unique. |
| `spaces` | id | owner_id → owner_profiles, city_id → cities | id → owner_id, city_id, title, slug, description, type, status, address, postal_code, lat, lng, capacity, area, prices, cleaning_fee, currency, min_booking_hours, instant_book |
| `space_images` | id | space_id → spaces | id → space_id, url, alt_text, sort_order, is_cover. (space_id, sort_order) is unique. |
| `amenities` | id | none | id → name, icon |
| `space_amenities` | (space_id, amenity_id) | space_id → spaces, amenity_id → amenities | (space_id, amenity_id) → created_at |
| `availability_rules` | id | space_id → spaces | id → space_id, day_of_week, opens_at, closes_at |
| `blocked_slots` | id | space_id → spaces | id → space_id, starts_at, ends_at, reason |
| `bookings` | id | space_id → spaces, renter_id → users | id → booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose, status, pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, discount_amount, currency, cancelled_at |
| `payments` | id | booking_id → bookings | id → booking_id, kind, method, status, amount, currency, provider_ref, processed_at |
| `reviews` | id | booking_id → bookings (unique, 1–1) | id → booking_id, rating, comment, owner_reply, replied_at |
| `favourites` | (user_id, space_id) | user_id → users, space_id → spaces | (user_id, space_id) → created_at |
| `conversations` | id | space_id → spaces, renter_id → users | id → space_id, renter_id. (space_id, renter_id) is unique. |
| `messages` | id | conversation_id → conversations, sender_id → users | id → conversation_id, sender_id, body, read_at |

In every table, each non-key attribute depends on **the key, the whole key, and nothing but
the key**, so the schema is in 3NF. Each determinant is a candidate key, so it also meets BCNF.

---

## 5. Design decisions that keep it in 3NF

1. **No derived columns.** Booking total and a space's average rating are not stored;
   they're calculated in queries:
   - total = `unit_price * units + cleaning_fee + service_fee + tax_amount - discount_amount`
   - rating = `AVG(reviews.rating)` joined through `bookings`
2. **Reviews store only `booking_id`.** The author (`bookings.renter_id`) and the space
   (`bookings.space_id`) are reached through the booking. Storing them again would create
   `review → booking → space`, a transitive dependency.
3. **Conversations don't store the owner.** It comes from `spaces.owner_id`.
4. **Price snapshot on bookings isn't duplication.** `bookings.unit_price` records the price
   *agreed for that booking*. It depends on the booking, not on `spaces.price_per_hour`,
   which the owner can change later.
5. **City hierarchy in its own table.** `state` and `country` depend on the city, not on the
   space, so they aren't repeated on every listing.
6. **Owner-only data in `owner_profiles`.** This avoids many NULL columns on `users` for renters.

---

## 6. Integrity rules enforced in the database

- **Primary, foreign and unique keys** on every relation. `ON DELETE CASCADE` applies to
  dependent data (images, amenities, availability, favourites, messages). `ON DELETE RESTRICT`
  protects history (spaces, renters and bookings that have payments).
- **CHECK constraints:** capacity, guests and units > 0; money ≥ 0; `ends_at > starts_at`;
  rating 1–5; day_of_week 0–6; valid latitude and longitude; every space has an hourly or
  daily price.
- **No double booking:** `EXCLUDE USING gist (space_id WITH =, tstzrange(starts_at, ends_at) WITH &&)`
  applies to PENDING/CONFIRMED bookings.
- **Trigger:** a review can only be inserted for a booking whose status is `COMPLETED`.
