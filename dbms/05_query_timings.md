# SpaceCare: query timings

Every query in `dbms/04_queries.sql` was run **3 times** with `EXPLAIN (ANALYZE, BUFFERS)` on PostgreSQL 18 with the seed data (`dbms/seed_data.sql`). The times are the `Execution Time` PostgreSQL reports. WRITE queries run in order inside one `BEGIN ... ROLLBACK`, so the data is unchanged after each run. The full plan of every run is in `dbms/plans/<id>.txt`.

| Query | Type | What it does | Run 1 (ms) | Run 2 (ms) | Run 3 (ms) | Average (ms) | Scan type |
|-------|------|--------------|-----------:|-----------:|-----------:|-------------:|-----------|
| R1 | READ | Login: find an active user by email | 0.029 | 0.018 | 0.019 | 0.022 | Index Scan on users |
| R2 | READ | Owner dashboard header: owner profile with the user's name | 0.018 | 0.014 | 0.010 | 0.014 | Index Scan on owner_profiles, Index Scan on users |
| R3 | READ | Home page: all cities that have at least one active listing | 0.064 | 0.057 | 0.056 | 0.059 | Index Scan on spaces, Index Scan on cities |
| R4 | READ | Search: active spaces in a city of a given type and minimum capacity, with cover image and rating, cheapest first | 0.105 | 0.067 | 0.063 | 0.078 | Index Scan on spaces, Bitmap Heap Scan on cities, Bitmap Index Scan on cities_name_state_country_key, Index Scan on bookings, Index Scan on reviews, Bitmap Heap Scan on space_images, Bitmap Index Scan on space_images_space_id_sort_order_key |
| R5 | READ | Search box: keyword in title or description (case-insensitive) | 0.027 | 0.022 | 0.025 | 0.025 | Index Scan on spaces, Index Scan on cities |
| R6 | READ | Filter: active spaces that have ALL the chosen amenities | 0.077 | 0.035 | 0.036 | 0.049 | Index Scan on spaces, Bitmap Heap Scan on space_amenities, Bitmap Index Scan on space_amenities_pkey, Index Scan on amenities |
| R7 | READ | Amenity filter list: amenities and how many active spaces offer each | 0.046 | 0.050 | 0.046 | 0.047 | Seq Scan on space_amenities, Seq Scan on amenities, Index Scan on spaces |
| R8 | READ | Space detail: listing, owner and city by slug | 0.020 | 0.014 | 0.017 | 0.017 | Index Scan on spaces, Index Scan on cities, Index Scan on owner_profiles, Index Scan on users |
| R9 | READ | Space detail: photo gallery in display order | 0.007 | 0.007 | 0.008 | 0.007 | Bitmap Heap Scan on space_images, Bitmap Index Scan on space_images_space_id_sort_order_key |
| R10 | READ | Space detail: amenities as one list | 0.030 | 0.023 | 0.022 | 0.025 | Index Only Scan on spaces, Seq Scan on amenities, Bitmap Heap Scan on space_amenities, Bitmap Index Scan on space_amenities_pkey |
| R11 | READ | Space detail: weekly opening hours (0 = Sunday) | 0.043 | 0.015 | 0.013 | 0.024 | Bitmap Heap Scan on availability_rules, Bitmap Index Scan on availability_rules_space_id_day_of_week_opens_at_key |
| R12 | READ | Space detail: reviews with reviewer name and owner reply | 0.014 | 0.014 | 0.013 | 0.014 | Index Scan on bookings, Index Scan on users, Index Scan on reviews |
| R13 | READ | Space detail: average rating and review count | 0.011 | 0.008 | 0.008 | 0.009 | Index Scan on bookings, Index Scan on reviews |
| R14 | READ | Availability check: is the space free for the requested slot? No overlapping active booking and no overlapping blocked slot | 0.048 | 0.013 | 0.016 | 0.026 | Index Scan on bookings, Bitmap Heap Scan on blocked_slots, Bitmap Index Scan on blocked_slots_space_id_starts_at_ends_at_idx |
| R15 | READ | Calendar: booked and blocked periods of a space for the next 30 days | 1.520 | 0.500 | 0.480 | 0.833 | Index Scan on bookings, Index Only Scan on blocked_slots |
| R16 | READ | Booking detail: one booking with space, renter, total and payments so far | 0.141 | 0.041 | 0.037 | 0.073 | Index Only Scan on bookings, Index Scan on bookings, Index Scan on spaces, Index Scan on users, Bitmap Heap Scan on payments, Bitmap Index Scan on payments_booking_id_idx |
| R17 | READ | Booking detail: payment history | 0.007 | 0.007 | 0.006 | 0.007 | Bitmap Heap Scan on payments, Bitmap Index Scan on payments_booking_id_idx |
| R18 | READ | My bookings: a renter's bookings, newest first, with total | 0.019 | 0.012 | 0.014 | 0.015 | Index Scan on bookings, Index Scan on spaces, Index Scan on cities |
| R19 | READ | My favourites | 0.046 | 0.021 | 0.019 | 0.029 | Seq Scan on spaces, Bitmap Heap Scan on favourites, Bitmap Index Scan on favourites_pkey, Index Scan on cities |
| R20 | READ | Review prompt: the renter's completed bookings not yet reviewed | 0.013 | 0.013 | 0.013 | 0.013 | Index Scan on bookings, Index Scan on spaces, Index Only Scan on reviews |
| R21 | READ | Inbox: a user's conversations (as renter or as owner) with the last message and the unread count | 0.071 | 0.032 | 0.039 | 0.047 | Seq Scan on conversations, Seq Scan on spaces, Seq Scan on owner_profiles, Index Scan on users, Index Scan on messages, Bitmap Heap Scan on messages, Bitmap Index Scan on messages_conversation_id_created_at_idx |
| R22 | READ | Conversation thread: messages in order with sender role | 0.017 | 0.012 | 0.013 | 0.014 | Index Scan on conversations, Seq Scan on users, Bitmap Heap Scan on messages, Bitmap Index Scan on messages_conversation_id_created_at_idx |
| R23 | READ | Owner's listings with booking count and rating | 0.023 | 0.019 | 0.020 | 0.021 | Index Scan on spaces, Index Scan on bookings, Index Scan on reviews |
| R24 | READ | Owner's pending booking requests to accept or reject | 0.014 | 0.011 | 0.010 | 0.012 | Index Scan on spaces, Index Scan on bookings, Index Scan on users |
| R25 | READ | Owner's upcoming confirmed bookings (next 30 days) | 0.011 | 0.010 | 0.010 | 0.010 | Index Scan on spaces, Index Scan on bookings, Index Scan on users |
| R26 | READ | Owner earnings: successful charges minus successful refunds, per space | 0.019 | 0.022 | 0.016 | 0.019 | Index Scan on spaces, Index Scan on bookings, Index Scan on payments |
| R27 | READ | Owner analytics: hours booked per space per month | 0.020 | 0.022 | 0.019 | 0.020 | Index Scan on spaces, Index Scan on bookings |
| R28 | READ | Owners waiting for verification | 0.011 | 0.011 | 0.011 | 0.011 | Seq Scan on users, Seq Scan on owner_profiles |
| R29 | READ | Listings waiting for review or still in draft | 0.011 | 0.015 | 0.014 | 0.013 | Bitmap Heap Scan on spaces, Bitmap Index Scan on spaces_status_idx, Index Scan on owner_profiles, Index Scan on users |
| R30 | READ | Platform stats: bookings in each status | 0.011 | 0.009 | 0.010 | 0.010 | Seq Scan on bookings |
| R31 | READ | Platform stats: gross booking value per city and share of total (CTE + window) | 0.034 | 0.034 | 0.037 | 0.035 | Seq Scan on spaces, Bitmap Heap Scan on bookings, Bitmap Index Scan on bookings_status_idx, Index Scan on cities |
| R32 | READ | Platform stats: payment success rate per method | 0.015 | 0.017 | 0.012 | 0.015 | Seq Scan on payments |
| R33 | READ | Platform stats: top-rated space in each city (ROW_NUMBER per group) | 0.041 | 0.047 | 0.041 | 0.043 | Seq Scan on reviews, Seq Scan on bookings, Seq Scan on spaces, Index Scan on cities |
| R34 | READ | Finance check: confirmed or completed bookings not fully paid | 0.025 | 0.020 | 0.019 | 0.021 | Bitmap Heap Scan on bookings, Bitmap Index Scan on bookings_status_idx, Bitmap Heap Scan on payments, Bitmap Index Scan on payments_status_idx |
| R35 | READ | Marketing: users who favourited a space but never booked it (EXCEPT) | 0.020 | 0.018 | 0.017 | 0.018 | Seq Scan on favourites, Seq Scan on bookings, Seq Scan on users, Seq Scan on spaces |
| W1 | WRITE | Sign up: create a renter account | 0.200 | 0.038 | 0.036 | 0.091 | — |
| W2 | WRITE | Become an owner: create an owner profile for the new user | 0.171 | 0.069 | 0.059 | 0.100 | Index Scan on users |
| W3 | WRITE | Owner creates a listing (starts as DRAFT) | 0.150 | 0.115 | 0.112 | 0.126 | Index Scan on users, Index Scan on owner_profiles, Bitmap Heap Scan on cities, Bitmap Index Scan on cities_name_state_country_key |
| W4 | WRITE | Owner adds a photo, amenities and opening hours to the listing | 1.472 | 0.207 | 0.215 | 0.631 | Index Scan on spaces, Bitmap Heap Scan on amenities, Bitmap Index Scan on amenities_name_key |
| W5 | WRITE | Owner submits the listing for review | 0.178 | 0.102 | 0.096 | 0.125 | Index Scan on spaces |
| W6 | WRITE | Admin approves the listing | 0.050 | 0.052 | 0.044 | 0.049 | Index Scan on spaces |
| W7 | WRITE | Admin verifies an owner | 0.014 | 0.017 | 0.011 | 0.014 | Index Scan on users, Index Scan on owner_profiles |
| W8 | WRITE | Owner changes the hourly price | 0.032 | 0.031 | 0.035 | 0.033 | Index Scan on spaces |
| W9 | WRITE | Owner blocks a time slot for maintenance | 0.098 | 0.051 | 0.050 | 0.066 | Index Scan on spaces |
| W10 | WRITE | Renter requests a booking (price copied from the listing) | 0.146 | 0.093 | 0.094 | 0.111 | Index Scan on spaces, Index Scan on users |
| W11 | WRITE | Renter pays for the booking | 0.093 | 0.050 | 0.043 | 0.062 | Index Scan on bookings |
| W12 | WRITE | Owner accepts the booking request | 0.056 | 0.068 | 0.063 | 0.062 | Index Scan on bookings |
| W13 | WRITE | Owner rejects a pending booking request | 0.030 | 0.080 | 0.035 | 0.048 | Index Scan on spaces, Index Scan on bookings |
| W14 | WRITE | Renter cancels a booking | 0.043 | 0.074 | 0.042 | 0.053 | Index Scan on bookings |
| W15 | WRITE | Refund the cancelled booking | 0.067 | 0.038 | 0.038 | 0.048 | Bitmap Heap Scan on payments, Bitmap Index Scan on payments_status_idx, Index Scan on bookings |
| W16 | WRITE | Mark past confirmed bookings as completed (daily job) | 0.005 | 0.005 | 0.005 | 0.005 | Index Scan on bookings |
| W17 | WRITE | Renter writes a review for a completed booking that has no review yet | 0.008 | 0.009 | 0.007 | 0.008 | Index Scan on bookings, Index Only Scan on reviews |
| W18 | WRITE | Owner replies to a review that has no reply yet | 0.024 | 0.018 | 0.017 | 0.020 | Index Scan on reviews |
| W19 | WRITE | Renter saves a space to favourites (ignore if already saved) | 0.067 | 0.058 | 0.052 | 0.059 | Index Scan on users, Index Scan on spaces |
| W20 | WRITE | Renter removes a space from favourites | 0.010 | 0.011 | 0.010 | 0.010 | Index Scan on users, Index Scan on spaces, Index Scan on favourites |
| W21 | WRITE | Start a conversation with an owner (or reuse the existing one) | 0.111 | 0.075 | 0.075 | 0.087 | Index Scan on spaces, Index Scan on users |
| W22 | WRITE | Send a message | 0.113 | 0.154 | 0.061 | 0.109 | Index Scan on users, Index Scan on spaces, Index Scan on conversations |
| W23 | WRITE | Mark the other person's messages in a conversation as read | 0.009 | 0.010 | 0.010 | 0.010 | Bitmap Heap Scan on messages, Bitmap Index Scan on messages_conversation_id_created_at_idx |
| W24 | WRITE | Owner deletes a listing that was never booked | 0.166 | 0.151 | 0.117 | 0.145 | Index Scan on spaces, Index Scan on bookings |
| W25 | WRITE | Deactivate a user account | 0.013 | 0.011 | 0.012 | 0.012 | Index Scan on users |

## Observations

- 35 READ and 25 WRITE queries. Slowest average: R15 (0.833 ms), W4 (0.631 ms), W24 (0.145 ms), W3 (0.126 ms), W5 (0.125 ms).
- Every query finishes in well under 5 ms. Most lookups already use the primary-key, unique (`users.email`, `spaces.slug`) and foreign-key indexes from `03_schema.sql`.
- 11 of 60 queries still use a `Seq Scan` somewhere. These are the platform reports (R28–R35) and small lookup tables (`amenities`, `conversations`): the tables fit in one page, so reading the whole table is cheaper than an index lookup. With much more data, R30–R33 would need indexes on `bookings(status)`, `payments(method, status)` and `reviews(booking_id)` or a summary table.
- Run 1 is usually a little slower than runs 2 and 3 because the pages are not yet in the buffer cache (`shared read` instead of `shared hit` in the plans).
