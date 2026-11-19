-- =====================================================================
--  SpaceCare: every SQL query the app uses (04_queries.sql)
--  Schema: dbms/03_schema.sql
--
--  Each query has an id and a type:
--      R1, R2, …  -- READ   (SELECT)
--      W1, W2, …  -- WRITE  (INSERT / UPDATE / DELETE)
--  Values like 1, 'priya.sharma@example.com' or 'koramangala-12-seat-boardroom'
--  are sample parameters from the seed data (npm run db:seed). In the app
--  they are bind parameters ($1, $2, …).
--
--  Run:  psql -d spacecare -f dbms/04_queries.sql
--  The WRITE section runs in one transaction that is rolled back at the
--  end, so running this file leaves the data unchanged.
--
--  Derived values are computed here, not stored (01_normalization.md §5):
--    booking total = unit_price * units + cleaning_fee + service_fee
--                    + tax_amount - discount_amount
--    space rating  = AVG(reviews.rating) through bookings
-- =====================================================================


-- =====================================================================
--  READ QUERIES
-- =====================================================================

-- ── Accounts ─────────────────────────────────────────────────────

-- R1 | READ | Login: find an active user by email
SELECT id, email, password_hash, full_name, role
FROM users
WHERE email = 'priya.sharma@example.com' AND is_active;

-- R2 | READ | Owner dashboard header: owner profile with the user's name
SELECT u.full_name, u.email, op.id AS owner_profile_id, op.business_name,
       op.verification_status, op.verified_at
FROM owner_profiles op
JOIN users u ON u.id = op.user_id
WHERE op.user_id = 2;

-- ── Browsing and search ──────────────────────────────────────────

-- R3 | READ | Home page: all cities that have at least one active listing
SELECT c.id, c.name, c.state, COUNT(s.id) AS active_spaces
FROM cities c
JOIN spaces s ON s.city_id = c.id AND s.status = 'ACTIVE'
GROUP BY c.id, c.name, c.state
ORDER BY c.name;

-- R4 | READ | Search: active spaces in a city of a given type and minimum capacity,
--             with cover image and rating, cheapest first
SELECT s.id, s.title, s.slug, s.type, s.capacity, s.price_per_hour, s.price_per_day,
       img.url AS cover_image_url,
       ROUND(AVG(rv.rating), 2) AS avg_rating,
       COUNT(rv.id)             AS review_count
FROM spaces s
JOIN cities c              ON c.id = s.city_id
LEFT JOIN space_images img ON img.space_id = s.id AND img.is_cover
LEFT JOIN bookings b       ON b.space_id = s.id
LEFT JOIN reviews rv       ON rv.booking_id = b.id
WHERE c.name = 'Bengaluru'
  AND s.type IN ('MEETING_ROOM', 'WORKSHOP')
  AND s.capacity >= 10
  AND s.status = 'ACTIVE'
GROUP BY s.id, img.url
ORDER BY s.price_per_hour ASC NULLS LAST;

-- R5 | READ | Search box: keyword in title or description (case-insensitive)
SELECT s.id, s.title, s.slug, c.name AS city
FROM spaces s
JOIN cities c ON c.id = s.city_id
WHERE s.status = 'ACTIVE'
  AND (s.title ILIKE '%studio%' OR s.description ILIKE '%studio%');

-- R6 | READ | Filter: active spaces that have ALL the chosen amenities
SELECT s.id, s.title
FROM spaces s
JOIN space_amenities sa ON sa.space_id = s.id
JOIN amenities a        ON a.id = sa.amenity_id
WHERE s.status = 'ACTIVE'
  AND a.name IN ('Wi-Fi', 'Projector')
GROUP BY s.id, s.title
HAVING COUNT(DISTINCT a.id) = 2;

-- R7 | READ | Amenity filter list: amenities and how many active spaces offer each
SELECT a.id, a.name, a.icon, COUNT(s.id) AS spaces_offering
FROM amenities a
LEFT JOIN space_amenities sa ON sa.amenity_id = a.id
LEFT JOIN spaces s           ON s.id = sa.space_id AND s.status = 'ACTIVE'
GROUP BY a.id, a.name, a.icon
ORDER BY spaces_offering DESC, a.name;

-- ── Space detail page ────────────────────────────────────────────

-- R8 | READ | Space detail: listing, owner and city by slug
SELECT s.*, c.name AS city, c.state,
       u.full_name AS owner_name, op.business_name, op.verification_status
FROM spaces s
JOIN cities c          ON c.id  = s.city_id
JOIN owner_profiles op ON op.id = s.owner_id
JOIN users u           ON u.id  = op.user_id
WHERE s.slug = 'koramangala-12-seat-boardroom';

-- R9 | READ | Space detail: photo gallery in display order
SELECT url, alt_text, is_cover
FROM space_images
WHERE space_id = 1
ORDER BY sort_order;

-- R10 | READ | Space detail: amenities as one list
SELECT s.id, STRING_AGG(a.name, ', ' ORDER BY a.name) AS amenities
FROM spaces s
JOIN space_amenities sa ON sa.space_id = s.id
JOIN amenities a        ON a.id = sa.amenity_id
WHERE s.id = 1
GROUP BY s.id;

-- R11 | READ | Space detail: weekly opening hours (0 = Sunday)
SELECT day_of_week, opens_at, closes_at
FROM availability_rules
WHERE space_id = 1
ORDER BY day_of_week, opens_at;

-- R12 | READ | Space detail: reviews with reviewer name and owner reply.
--              A review stores only booking_id; reviewer and space come
--              through the booking (3NF).
SELECT u.full_name AS reviewer, rv.rating, rv.comment, rv.owner_reply, rv.created_at
FROM reviews rv
JOIN bookings b ON b.id = rv.booking_id
JOIN users u    ON u.id = b.renter_id
WHERE b.space_id = 1
ORDER BY rv.created_at DESC;

-- R13 | READ | Space detail: average rating and review count
SELECT ROUND(AVG(rv.rating), 2) AS avg_rating, COUNT(rv.id) AS review_count
FROM bookings b
JOIN reviews rv ON rv.booking_id = b.id
WHERE b.space_id = 1;

-- ── Booking flow ─────────────────────────────────────────────────

-- R14 | READ | Availability check: is the space free for the requested slot?
--              No overlapping active booking and no overlapping blocked slot.
--              (Example: space 1, tomorrow 10:00 to 12:00.)
SELECT NOT EXISTS (
         SELECT 1 FROM bookings b
         WHERE b.space_id = 1
           AND b.status IN ('PENDING', 'CONFIRMED')
           AND tstzrange(b.starts_at, b.ends_at, '[)')
               && tstzrange(date_trunc('day', now()) + interval '1 day 10 hours',
                            date_trunc('day', now()) + interval '1 day 12 hours', '[)')
       )
       AND NOT EXISTS (
         SELECT 1 FROM blocked_slots bs
         WHERE bs.space_id = 1
           AND tstzrange(bs.starts_at, bs.ends_at, '[)')
               && tstzrange(date_trunc('day', now()) + interval '1 day 10 hours',
                            date_trunc('day', now()) + interval '1 day 12 hours', '[)')
       ) AS is_available;

-- R15 | READ | Calendar: booked and blocked periods of a space for the next 30 days
SELECT 'booking' AS kind, starts_at, ends_at
FROM bookings
WHERE space_id = 1 AND status IN ('PENDING', 'CONFIRMED')
  AND ends_at > now() AND starts_at < now() + interval '30 days'
UNION ALL
SELECT 'blocked', starts_at, ends_at
FROM blocked_slots
WHERE space_id = 1
  AND ends_at > now() AND starts_at < now() + interval '30 days'
ORDER BY starts_at;

-- R16 | READ | Booking detail: one booking with space, renter, total and payments so far
SELECT b.booking_code, b.status, s.title AS space, u.full_name AS renter,
       b.starts_at, b.ends_at, b.guests, b.pricing_unit, b.unit_price, b.units,
       b.unit_price * b.units + b.cleaning_fee + b.service_fee
         + b.tax_amount - b.discount_amount AS total_amount,
       COALESCE(SUM(p.amount) FILTER (WHERE p.kind = 'CHARGE' AND p.status = 'SUCCEEDED'), 0) AS amount_paid,
       COALESCE(SUM(p.amount) FILTER (WHERE p.kind = 'REFUND' AND p.status = 'SUCCEEDED'), 0) AS amount_refunded
FROM bookings b
JOIN spaces s ON s.id = b.space_id
JOIN users u  ON u.id = b.renter_id
LEFT JOIN payments p ON p.booking_id = b.id
WHERE b.booking_code = (SELECT MIN(booking_code) FROM bookings)
GROUP BY b.id, s.title, u.full_name;

-- R17 | READ | Booking detail: payment history
SELECT kind, method, status, amount, provider_ref, processed_at
FROM payments
WHERE booking_id = 1
ORDER BY created_at;

-- ── Renter pages ─────────────────────────────────────────────────

-- R18 | READ | My bookings: a renter's bookings, newest first, with total
SELECT b.booking_code, s.title AS space, c.name AS city, b.starts_at, b.ends_at, b.status,
       b.unit_price * b.units + b.cleaning_fee + b.service_fee
         + b.tax_amount - b.discount_amount AS total_amount
FROM bookings b
JOIN spaces s ON s.id = b.space_id
JOIN cities c ON c.id = s.city_id
WHERE b.renter_id = 5
ORDER BY b.starts_at DESC;

-- R19 | READ | My favourites
SELECT s.id, s.title, s.slug, c.name AS city, s.price_per_hour, s.price_per_day
FROM favourites f
JOIN spaces s ON s.id = f.space_id
JOIN cities c ON c.id = s.city_id
WHERE f.user_id = 5
ORDER BY f.created_at DESC;

-- R20 | READ | Review prompt: the renter's completed bookings not yet reviewed
SELECT b.id, b.booking_code, s.title AS space, b.ends_at
FROM bookings b
JOIN spaces s ON s.id = b.space_id
WHERE b.renter_id = 5
  AND b.status = 'COMPLETED'
  AND NOT EXISTS (SELECT 1 FROM reviews rv WHERE rv.booking_id = b.id);

-- ── Messages ─────────────────────────────────────────────────────

-- R21 | READ | Inbox: a user's conversations (as renter or as owner) with
--              the last message and the unread count
SELECT cv.id, s.title AS space,
       renter.full_name AS renter,
       last_msg.body AS last_message, last_msg.created_at AS last_message_at,
       (SELECT COUNT(*) FROM messages m
         WHERE m.conversation_id = cv.id AND m.sender_id <> 2 AND m.read_at IS NULL) AS unread
FROM conversations cv
JOIN spaces s          ON s.id  = cv.space_id
JOIN owner_profiles op ON op.id = s.owner_id
JOIN users renter      ON renter.id = cv.renter_id
LEFT JOIN LATERAL (
  SELECT body, created_at FROM messages m
  WHERE m.conversation_id = cv.id
  ORDER BY created_at DESC LIMIT 1
) last_msg ON true
WHERE cv.renter_id = 2 OR op.user_id = 2
ORDER BY last_msg.created_at DESC NULLS LAST;

-- R22 | READ | Conversation thread: messages in order with sender role
SELECT sender.full_name AS sender,
       CASE WHEN m.sender_id = cv.renter_id THEN 'renter' ELSE 'owner' END AS sender_role,
       m.body, m.created_at, m.read_at IS NOT NULL AS is_read
FROM conversations cv
JOIN messages m   ON m.conversation_id = cv.id
JOIN users sender ON sender.id = m.sender_id
WHERE cv.id = 1
ORDER BY m.created_at;

-- ── Owner dashboard ──────────────────────────────────────────────

-- R23 | READ | Owner's listings with booking count and rating
SELECT s.id, s.title, s.status,
       COUNT(DISTINCT b.id) AS bookings,
       ROUND(AVG(rv.rating), 2) AS avg_rating
FROM spaces s
LEFT JOIN bookings b ON b.space_id = s.id
LEFT JOIN reviews rv ON rv.booking_id = b.id
WHERE s.owner_id = 1
GROUP BY s.id, s.title, s.status
ORDER BY s.title;

-- R24 | READ | Owner's pending booking requests to accept or reject
SELECT b.id, b.booking_code, s.title AS space, u.full_name AS renter,
       b.starts_at, b.ends_at, b.guests, b.purpose
FROM bookings b
JOIN spaces s ON s.id = b.space_id
JOIN users u  ON u.id = b.renter_id
WHERE s.owner_id = 1 AND b.status = 'PENDING'
ORDER BY b.starts_at;

-- R25 | READ | Owner's upcoming confirmed bookings (next 30 days)
SELECT b.booking_code, s.title AS space, u.full_name AS renter, b.starts_at, b.ends_at
FROM bookings b
JOIN spaces s ON s.id = b.space_id
JOIN users u  ON u.id = b.renter_id
WHERE s.owner_id = 1
  AND b.status = 'CONFIRMED'
  AND b.starts_at BETWEEN now() AND now() + interval '30 days'
ORDER BY b.starts_at;

-- R26 | READ | Owner earnings: successful charges minus successful refunds, per space
SELECT s.title,
       SUM(CASE WHEN p.kind = 'CHARGE' THEN p.amount ELSE 0 END) AS charged,
       SUM(CASE WHEN p.kind = 'REFUND' THEN p.amount ELSE 0 END) AS refunded,
       SUM(CASE WHEN p.kind = 'CHARGE' THEN p.amount ELSE -p.amount END) AS net_earnings
FROM payments p
JOIN bookings b ON b.id = p.booking_id
JOIN spaces s   ON s.id = b.space_id
WHERE s.owner_id = 1 AND p.status = 'SUCCEEDED'
GROUP BY s.id, s.title
ORDER BY net_earnings DESC;

-- R27 | READ | Owner analytics: hours booked per space per month
SELECT s.title,
       date_trunc('month', b.starts_at)::date AS month,
       ROUND(SUM(EXTRACT(EPOCH FROM (b.ends_at - b.starts_at)) / 3600), 1) AS hours_booked
FROM bookings b
JOIN spaces s ON s.id = b.space_id
WHERE s.owner_id = 1 AND b.status IN ('CONFIRMED', 'COMPLETED')
GROUP BY s.title, date_trunc('month', b.starts_at)
ORDER BY month, hours_booked DESC;

-- ── Admin panel ──────────────────────────────────────────────────

-- R28 | READ | Owners waiting for verification
SELECT op.id, u.full_name, u.email, op.business_name, op.gst_number, op.created_at
FROM owner_profiles op
JOIN users u ON u.id = op.user_id
WHERE op.verification_status = 'PENDING'
ORDER BY op.created_at;

-- R29 | READ | Listings waiting for review or still in draft
SELECT s.id, s.title, s.status, u.full_name AS owner, s.created_at
FROM spaces s
JOIN owner_profiles op ON op.id = s.owner_id
JOIN users u           ON u.id = op.user_id
WHERE s.status IN ('PENDING_REVIEW', 'DRAFT')
ORDER BY s.created_at;

-- R30 | READ | Platform stats: bookings in each status
SELECT status, COUNT(*) AS bookings
FROM bookings
GROUP BY status
ORDER BY bookings DESC;

-- R31 | READ | Platform stats: gross booking value per city and share of total (CTE + window)
WITH booking_totals AS (
  SELECT b.space_id,
         b.unit_price * b.units + b.cleaning_fee + b.service_fee
           + b.tax_amount - b.discount_amount AS total
  FROM bookings b
  WHERE b.status IN ('CONFIRMED', 'COMPLETED')
)
SELECT c.name AS city,
       SUM(bt.total) AS gross_booking_value,
       ROUND(100 * SUM(bt.total) / SUM(SUM(bt.total)) OVER (), 1) AS share_pct
FROM booking_totals bt
JOIN spaces s ON s.id = bt.space_id
JOIN cities c ON c.id = s.city_id
GROUP BY c.name
ORDER BY gross_booking_value DESC;

-- R32 | READ | Platform stats: payment success rate per method
SELECT method,
       COUNT(*)                                     AS attempts,
       COUNT(*) FILTER (WHERE status = 'SUCCEEDED') AS succeeded,
       ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'SUCCEEDED') / COUNT(*), 1) AS success_pct
FROM payments
WHERE kind = 'CHARGE'
GROUP BY method
ORDER BY success_pct DESC;

-- R33 | READ | Platform stats: top-rated space in each city (ROW_NUMBER per group)
WITH space_ratings AS (
  SELECT s.id, s.title, s.city_id, AVG(rv.rating) AS avg_rating
  FROM spaces s
  JOIN bookings b ON b.space_id = s.id
  JOIN reviews rv ON rv.booking_id = b.id
  GROUP BY s.id, s.title, s.city_id
),
ranked AS (
  SELECT sr.*, ROW_NUMBER() OVER (PARTITION BY sr.city_id ORDER BY sr.avg_rating DESC, sr.title) AS rn
  FROM space_ratings sr
)
SELECT c.name AS city, r.title, ROUND(r.avg_rating, 2) AS avg_rating
FROM ranked r
JOIN cities c ON c.id = r.city_id
WHERE r.rn = 1
ORDER BY c.name;

-- R34 | READ | Finance check: confirmed or completed bookings not fully paid
SELECT b.booking_code, b.status,
       b.unit_price * b.units + b.cleaning_fee + b.service_fee
         + b.tax_amount - b.discount_amount AS total_due,
       COALESCE(paid.amount, 0) AS paid
FROM bookings b
LEFT JOIN (
  SELECT booking_id, SUM(amount) AS amount
  FROM payments
  WHERE kind = 'CHARGE' AND status = 'SUCCEEDED'
  GROUP BY booking_id
) paid ON paid.booking_id = b.id
WHERE b.status IN ('CONFIRMED', 'COMPLETED')
  AND COALESCE(paid.amount, 0)
      < b.unit_price * b.units + b.cleaning_fee + b.service_fee + b.tax_amount - b.discount_amount;

-- R35 | READ | Marketing: users who favourited a space but never booked it (EXCEPT)
SELECT u.full_name, u.email, s.title
FROM (
  SELECT user_id, space_id FROM favourites
  EXCEPT
  SELECT renter_id, space_id FROM bookings
) leads
JOIN users u  ON u.id = leads.user_id
JOIN spaces s ON s.id = leads.space_id
ORDER BY u.full_name;


-- =====================================================================
--  WRITE QUERIES
--  All run in one transaction that is rolled back at the end, so the
--  seed data is unchanged. Each one uses RETURNING so you can see the
--  row it wrote.
-- =====================================================================

BEGIN;

-- W1 | WRITE | Sign up: create a renter account
INSERT INTO users (email, phone, password_hash, full_name, updated_at)
VALUES ('new.renter@example.com', '+919822222201', 'scrypt$demo$hash', 'New Renter', now())
RETURNING id, email, role;

-- W2 | WRITE | Become an owner: create an owner profile for the new user
INSERT INTO owner_profiles (user_id, business_name, bio, updated_at)
SELECT id, 'New Renter Spaces', 'Spare room above my shop.', now()
FROM users WHERE email = 'new.renter@example.com'
RETURNING id, user_id, verification_status;

-- W3 | WRITE | Owner creates a listing (starts as DRAFT)
INSERT INTO spaces (owner_id, city_id, title, slug, description, type, address_line1,
                    postal_code, capacity, price_per_hour, updated_at)
SELECT op.id, c.id, 'Small meeting room in HSR Layout', 'hsr-small-meeting-room',
       'Six-seat room with a TV screen.', 'MEETING_ROOM', '27th Main, HSR Layout',
       '560102', 6, 500, now()
FROM owner_profiles op
JOIN users u  ON u.id = op.user_id AND u.email = 'new.renter@example.com'
JOIN cities c ON c.name = 'Bengaluru'
RETURNING id, slug, status;

-- W4 | WRITE | Owner adds a photo, amenities and opening hours to the listing
INSERT INTO space_images (space_id, url, alt_text, sort_order, is_cover)
SELECT id, 'https://images.spacecare.example/hsr-small-meeting-room/1.jpg', 'Room photo', 0, true
FROM spaces WHERE slug = 'hsr-small-meeting-room';

INSERT INTO space_amenities (space_id, amenity_id)
SELECT s.id, a.id
FROM spaces s, amenities a
WHERE s.slug = 'hsr-small-meeting-room' AND a.name IN ('Wi-Fi', 'Air conditioning');

INSERT INTO availability_rules (space_id, day_of_week, opens_at, closes_at, updated_at)
SELECT s.id, d, '09:00', '19:00', now()
FROM spaces s, generate_series(1, 5) AS d
WHERE s.slug = 'hsr-small-meeting-room';

-- W5 | WRITE | Owner submits the listing for review
UPDATE spaces
SET status = 'PENDING_REVIEW', updated_at = now()
WHERE slug = 'hsr-small-meeting-room' AND status = 'DRAFT'
RETURNING id, status;

-- W6 | WRITE | Admin approves the listing
UPDATE spaces
SET status = 'ACTIVE', updated_at = now()
WHERE slug = 'hsr-small-meeting-room' AND status = 'PENDING_REVIEW'
RETURNING id, status;

-- W7 | WRITE | Admin verifies an owner
UPDATE owner_profiles
SET verification_status = 'VERIFIED', verified_at = now(), updated_at = now()
WHERE verification_status = 'PENDING'
  AND user_id = (SELECT id FROM users WHERE email = 'vikram.singh@example.com')
RETURNING id, verification_status;

-- W8 | WRITE | Owner changes the hourly price. Existing bookings keep the
--              price agreed at booking time (bookings.unit_price).
UPDATE spaces
SET price_per_hour = ROUND(price_per_hour * 1.10, 2), updated_at = now()
WHERE slug = 'koramangala-12-seat-boardroom'
RETURNING title, price_per_hour;

-- W9 | WRITE | Owner blocks a time slot for maintenance
INSERT INTO blocked_slots (space_id, starts_at, ends_at, reason, updated_at)
SELECT id, date_trunc('day', now()) + interval '20 days 9 hours',
           date_trunc('day', now()) + interval '20 days 13 hours', 'Deep cleaning', now()
FROM spaces WHERE slug = 'koramangala-12-seat-boardroom'
RETURNING id, starts_at, ends_at;

-- W10 | WRITE | Renter requests a booking (price copied from the listing).
--               The bookings_no_overlap constraint rejects it if the slot is taken.
INSERT INTO bookings (booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose,
                      pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, updated_at)
SELECT 'SC-DEMO-00001', s.id, u.id,
       date_trunc('day', now()) + interval '25 days 10 hours',
       date_trunc('day', now()) + interval '25 days 12 hours',
       4, 'Team sync', 'HOUR', s.price_per_hour, 2, s.cleaning_fee,
       ROUND(s.price_per_hour * 2 * 0.10, 2), ROUND(s.price_per_hour * 2 * 0.18, 2), now()
FROM spaces s
JOIN users u ON u.email = 'sneha.kulkarni@example.com'
WHERE s.slug = 'koramangala-12-seat-boardroom'
RETURNING id, booking_code, status;

-- W11 | WRITE | Renter pays for the booking
INSERT INTO payments (booking_id, method, status, amount, provider_ref, processed_at, updated_at)
SELECT id, 'UPI', 'SUCCEEDED',
       unit_price * units + cleaning_fee + service_fee + tax_amount - discount_amount,
       'pay_DEMO0001', now(), now()
FROM bookings WHERE booking_code = 'SC-DEMO-00001'
RETURNING id, amount, status;

-- W12 | WRITE | Owner accepts the booking request
UPDATE bookings
SET status = 'CONFIRMED', updated_at = now()
WHERE booking_code = 'SC-DEMO-00001' AND status = 'PENDING'
RETURNING booking_code, status;

-- W13 | WRITE | Owner rejects a pending booking request
UPDATE bookings
SET status = 'REJECTED', updated_at = now()
WHERE status = 'PENDING'
  AND id = (SELECT b.id FROM bookings b
            JOIN spaces s ON s.id = b.space_id
            WHERE s.slug = 'koramangala-12-seat-boardroom' AND b.status = 'PENDING'
              AND b.booking_code <> 'SC-DEMO-00001'
            LIMIT 1)
RETURNING booking_code, status;

-- W14 | WRITE | Renter cancels a booking
UPDATE bookings
SET status = 'CANCELLED', cancelled_at = now(), cancellation_reason = 'Meeting moved online',
    updated_at = now()
WHERE booking_code = 'SC-DEMO-00001' AND status IN ('PENDING', 'CONFIRMED')
RETURNING booking_code, status, cancelled_at;

-- W15 | WRITE | Refund the cancelled booking
INSERT INTO payments (booking_id, kind, method, status, amount, provider_ref, processed_at, updated_at)
SELECT p.booking_id, 'REFUND', p.method, 'SUCCEEDED', p.amount, 'rfnd_DEMO0001', now(), now()
FROM payments p
JOIN bookings b ON b.id = p.booking_id
WHERE b.booking_code = 'SC-DEMO-00001' AND p.kind = 'CHARGE' AND p.status = 'SUCCEEDED'
RETURNING id, kind, amount;

-- W16 | WRITE | Mark past confirmed bookings as completed (daily job)
UPDATE bookings
SET status = 'COMPLETED', updated_at = now()
WHERE status = 'CONFIRMED' AND ends_at < now()
RETURNING booking_code, status;

-- W17 | WRITE | Renter writes a review for a completed booking that has no
--               review yet. The trigger only allows COMPLETED bookings and
--               the CHECK keeps rating between 1 and 5. (In the seed data
--               every completed booking is already reviewed, so this inserts
--               0 rows; in the app the booking id comes from R20.)
INSERT INTO reviews (booking_id, rating, comment, updated_at)
SELECT b.id, 4, 'Good room, a bit noisy at lunch time.', now()
FROM bookings b
WHERE b.renter_id = 5 AND b.status = 'COMPLETED'
  AND NOT EXISTS (SELECT 1 FROM reviews rv WHERE rv.booking_id = b.id)
RETURNING id, booking_id, rating;

-- W18 | WRITE | Owner replies to a review that has no reply yet
UPDATE reviews
SET owner_reply = 'Thanks! Parking passes are now available at the front desk.',
    replied_at = now(), updated_at = now()
WHERE id = 2 AND owner_reply IS NULL
RETURNING id, owner_reply;

-- W19 | WRITE | Renter saves a space to favourites (ignore if already saved)
INSERT INTO favourites (user_id, space_id)
SELECT u.id, s.id
FROM users u, spaces s
WHERE u.email = 'arjun.nair@example.com' AND s.slug = 'koramangala-12-seat-boardroom'
ON CONFLICT (user_id, space_id) DO NOTHING;

-- W20 | WRITE | Renter removes a space from favourites
DELETE FROM favourites
WHERE user_id = (SELECT id FROM users WHERE email = 'priya.sharma@example.com')
  AND space_id = (SELECT id FROM spaces WHERE slug = 'bandra-natural-light-studio');

-- W21 | WRITE | Start a conversation with an owner (or reuse the existing one)
INSERT INTO conversations (space_id, renter_id, updated_at)
SELECT s.id, u.id, now()
FROM spaces s, users u
WHERE s.slug = 'bandra-natural-light-studio' AND u.email = 'sneha.kulkarni@example.com'
ON CONFLICT (space_id, renter_id) DO UPDATE SET updated_at = now()
RETURNING id;

-- W22 | WRITE | Send a message
INSERT INTO messages (conversation_id, sender_id, body)
SELECT cv.id, cv.renter_id, 'Is the cyclorama wall available next Saturday?'
FROM conversations cv
JOIN spaces s ON s.id = cv.space_id
WHERE s.slug = 'bandra-natural-light-studio'
  AND cv.renter_id = (SELECT id FROM users WHERE email = 'sneha.kulkarni@example.com')
RETURNING id, created_at;

-- W23 | WRITE | Mark the other person's messages in a conversation as read
UPDATE messages
SET read_at = now()
WHERE conversation_id = 1 AND sender_id <> 2 AND read_at IS NULL;

-- W24 | WRITE | Owner deletes a listing that was never booked. Images,
--               amenities and hours are removed by ON DELETE CASCADE. A
--               listing with bookings is protected by ON DELETE RESTRICT.
DELETE FROM spaces
WHERE slug = 'kp-coworking-pod'
  AND NOT EXISTS (SELECT 1 FROM bookings b WHERE b.space_id = spaces.id)
RETURNING id, title;

-- W25 | WRITE | Deactivate a user account
UPDATE users
SET is_active = false, updated_at = now()
WHERE email = 'kabir.khan@example.com'
RETURNING id, is_active;

ROLLBACK;  -- undo every write above
