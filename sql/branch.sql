BEGIN;

    CREATE TYPE donation_period AS ENUM ('weekly', 'monthly', 'yearly');

    ALTER TABLE tips
        ADD COLUMN period donation_period,
        ADD COLUMN periodic_amount numeric(35,2);

    UPDATE tips SET period = 'weekly', periodic_amount = amount;

    ALTER TABLE tips
        ALTER COLUMN period SET NOT NULL,
        ALTER COLUMN periodic_amount SET NOT NULL;

    CREATE OR REPLACE VIEW current_tips AS
        SELECT DISTINCT ON (tipper, tippee) *
          FROM tips
      ORDER BY tipper, tippee, mtime DESC;

END;