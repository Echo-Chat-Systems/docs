-- Add UUID extension if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Create schemas
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
CREATE SCHEMA IF NOT EXISTS config;
CREATE SCHEMA IF NOT EXISTS public;
CREATE SCHEMA IF NOT EXISTS secure;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Create tables
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Config
CREATE TABLE config.owners
(
    user_id bytea NOT NULL PRIMARY KEY
);

CREATE TABLE config.data
(
    key   TEXT  NOT NULL PRIMARY KEY,
    value bytea NOT NULL
);

-- Public
CREATE TABLE public.users
(
    id             bytea     NOT NULL PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    encryption_key bytea     NOT NULL,
    username       TEXT      NOT NULL,
    tag            INT       NOT NULL,
    -- All of these were moved into the profile as they are not designed to be searchable
    --pronouns    TEXT      NOT NULL DEFAULT '',
    --pfp         uuid,
    --bio         TEXT,
    --css         TEXT,
    --status      jsonb     NOT NULL DEFAULT '{}',
    profile        jsonb     NOT NULL DEFAULT '{}',
    settings       bytea     NOT NULL DEFAULT '',
    last_online    TIMESTAMP,
    is_online      BOOLEAN   NOT NULL DEFAULT FALSE,
    is_banned      BOOLEAN   NOT NULL DEFAULT FALSE
);

CREATE TABLE public.files
(
    id            uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at    TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    created_by    bytea     NOT NULL,
    metadata      jsonb     NOT NULL             DEFAULT '{}'
);

CREATE TABLE public.guilds
(
    id            uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at    TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    owner_id      bytea     NOT NULL,
    name          TEXT      NOT NULL,
    customisation jsonb     NOT NULL             DEFAULT '{}'
);

CREATE TABLE public.guild_members
(
    id                     uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at             TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    guild_id               uuid      NOT NULL,
    user_id                bytea     NOT NULL,
    nickname               TEXT,
    customisation_override jsonb     NOT NULL             DEFAULT '{}'
);

CREATE TABLE public.roles
(
    id            uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at    TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    guild_id      uuid      NOT NULL,
    name          TEXT      NOT NULL,
    customisation jsonb     NOT NULL             DEFAULT '{}',
    permissions   NUMERIC   NOT NULL             DEFAULT 0
);

CREATE TABLE public.user_roles
(
    id         uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    user_id    bytea     NOT NULL,
    role_id    uuid      NOT NULL
);

CREATE TABLE public.channels
(
    id            uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at    TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    guild_id      uuid      NOT NULL,
    name          TEXT      NOT NULL,
    type          SMALLINT  NOT NULL             DEFAULT 0,
    customisation jsonb     NOT NULL             DEFAULT '{}',
    config        jsonb     NOT NULL             DEFAULT '{}'
);

CREATE TABLE public.channel_categories
(
    id            uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at    TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    guild_id      uuid      NOT NULL,
    name          TEXT      NOT NULL,
    type          INT       NOT NULL             DEFAULT 0,
    customisation jsonb     NOT NULL             DEFAULT '{}',
    config        jsonb     NOT NULL             DEFAULT '{}'
);

CREATE TABLE public.channel_members
(
    id          uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at  TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    user_id     bytea     NOT NULL,
    channel_id  uuid      NOT NULL,
    permissions NUMERIC   NOT NULL             DEFAULT 0
);

CREATE TABLE public.invites
(
    id            uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at    TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    guild_id      uuid      NOT NULL,
    channel_id    uuid      NOT NULL,
    created_by    bytea     NOT NULL,
    uses          REAL      NOT NULL             DEFAULT -1,
    customisation jsonb     NOT NULL             DEFAULT '{}',
    expires_at    TIMESTAMP,
    target_user   bytea
);

CREATE TABLE public.messages
(
    id           uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at   TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    user_id      bytea     NOT NULL,
    channel_id   uuid      NOT NULL,
    epoch        NUMERIC, -- Epoch and sender index are optional, as not all messages will be part of a secure channel
    sender_index INT,
    body         bytea     NOT NULL,
    metadata     jsonb     NOT NULL             DEFAULT '{}'
);

CREATE TABLE public.message_attachments
(
    id         uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    message_id uuid      NOT NULL,
    file_id    uuid      NOT NULL
);

CREATE TABLE public.guild_emojis
(
    id            uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at    TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    guild_id      uuid      NOT NULL,
    created_by    bytea     NOT NULL,
    name          TEXT      NOT NULL,
    type          SMALLINT  NOT NULL             DEFAULT 0,
    customisation jsonb     NOT NULL             DEFAULT '{}',
    file_id       uuid      NOT NULL
);

-- Secured
CREATE TABLE secure.certificates
(
    id         uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    signature  bytea     NOT NULL,
    expires    TIMESTAMP NOT NULL,
    revoked    BOOLEAN   NOT NULL             DEFAULT FALSE
);

CREATE TABLE secure.channel_commits
(
    id               uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at       TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    user_id          bytea     NOT NULL,
    channel_id       uuid      NOT NULL,
    epoch            NUMERIC       NOT NULL,
    encrypted_commit bytea     NOT NULL
);

CREATE TABLE secure.mls_states
(
    id                uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at        TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    last_updated      TIMESTAMP NOT NULL             DEFAULT CURRENT_TIMESTAMP,
    channel_member_id uuid      NOT NULL,
    nonce             bytea     NOT NULL,
    epoch             NUMERIC       NOT NULL,
    encrypted_state   bytea     NOT NULL
);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Create foreign keys
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Config
ALTER TABLE config.owners
    ADD CONSTRAINT fk_owners_user FOREIGN KEY (user_id) REFERENCES public.users (id);

-- Public
ALTER TABLE public.files
    ADD CONSTRAINT fk_files_created_by FOREIGN KEY (created_by) REFERENCES public.users (id);

ALTER TABLE public.guilds
    ADD CONSTRAINT fk_guilds_owner_id FOREIGN KEY (owner_id) REFERENCES public.users (id);

ALTER TABLE public.guild_members
    ADD CONSTRAINT fk_guild_members_guild_id FOREIGN KEY (guild_id) REFERENCES public.guilds (id);
ALTER TABLE public.guild_members
    ADD CONSTRAINT fk_guild_members_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);

ALTER TABLE public.roles
    ADD CONSTRAINT fk_roles_guild_id FOREIGN KEY (guild_id) REFERENCES public.guilds (id);

ALTER TABLE public.user_roles
    ADD CONSTRAINT fk_user_roles_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE public.user_roles
    ADD CONSTRAINT fk_user_roles_role_id FOREIGN KEY (role_id) REFERENCES public.roles (id);

ALTER TABLE public.channels
    ADD CONSTRAINT fk_channels_guild_id FOREIGN KEY (guild_id) REFERENCES public.guilds (id);

ALTER TABLE public.channel_categories
    ADD CONSTRAINT fk_channel_categories_guild_id FOREIGN KEY (guild_id) REFERENCES public.guilds (id);

ALTER TABLE public.channel_members
    ADD CONSTRAINT fk_channel_members_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE public.channel_members
    ADD CONSTRAINT fk_channel_members_channel_id FOREIGN KEY (channel_id) REFERENCES public.channels (id);

ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_guild_id FOREIGN KEY (guild_id) REFERENCES public.guilds (id);
ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_channel_id FOREIGN KEY (channel_id) REFERENCES public.channels (id);
ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_created_by FOREIGN KEY (created_by) REFERENCES public.users (id);
ALTER TABLE public.invites
    ADD CONSTRAINT fk_invites_target_user FOREIGN KEY (target_user) REFERENCES public.users (id);

ALTER TABLE public.messages
    ADD CONSTRAINT fk_messages_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE public.messages
    ADD CONSTRAINT fk_messages_channel_id FOREIGN KEY (channel_id) REFERENCES public.channels (id);

ALTER TABLE public.message_attachments
    ADD CONSTRAINT fk_message_attachments_message_id FOREIGN KEY (message_id) REFERENCES public.messages (id);
ALTER TABLE public.message_attachments
    ADD CONSTRAINT fk_message_attachments_file_id FOREIGN KEY (file_id) REFERENCES public.files (id);

ALTER TABLE public.guild_emojis
    ADD CONSTRAINT fk_guild_emojis_guild_id FOREIGN KEY (guild_id) REFERENCES public.guilds (id);
ALTER TABLE public.guild_emojis
    ADD CONSTRAINT fk_guild_emojis_created_by FOREIGN KEY (created_by) REFERENCES public.users (id);
ALTER TABLE public.guild_emojis
    ADD CONSTRAINT fk_guild_emojis_file_id FOREIGN KEY (file_id) REFERENCES public.files (id);

-- Secured
ALTER TABLE secure.channel_commits
    ADD CONSTRAINT fk_channel_commits_user_id FOREIGN KEY (user_id) REFERENCES public.users (id);
ALTER TABLE secure.channel_commits
    ADD CONSTRAINT fk_channel_commits_channel_id FOREIGN KEY (channel_id) REFERENCES public.channels (id);

ALTER TABLE secure.mls_states
    ADD CONSTRAINT fk_mls_states_channel_member_id FOREIGN KEY (channel_member_id) REFERENCES public.channel_members (id);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Indexes
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Config

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Views
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Message Count View
CREATE OR REPLACE VIEW public.message_count AS
SELECT user_id,
       channel_id,
       COUNT(*) AS message_count
FROM public.messages
GROUP BY user_id, channel_id;
