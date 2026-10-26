CREATE TABLE colors (
	color_id BIGSERIAL NOT NULL, 
	color_name VARCHAR NOT NULL, 
	hex_value VARCHAR, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (color_id)
);

CREATE TABLE groups (
	group_id BIGSERIAL NOT NULL, 
	name VARCHAR NOT NULL, 
	unique_uuid VARCHAR NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (group_id), 
	UNIQUE (unique_uuid)
);

CREATE TABLE roles (
	role_id BIGSERIAL NOT NULL, 
	name VARCHAR NOT NULL, 
	description VARCHAR, 
	can_manage_events BOOLEAN, 
	can_invite_members BOOLEAN, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (role_id)
);

CREATE TABLE users (
	user_id BIGSERIAL NOT NULL, 
	username VARCHAR NOT NULL, 
	name VARCHAR NOT NULL, 
	surname VARCHAR NOT NULL, 
	email VARCHAR NOT NULL, 
	hashed_password VARCHAR NOT NULL, 
	role_id BIGINT DEFAULT 2 NOT NULL, 
	is_active BOOLEAN DEFAULT false, 
	last_active TIMESTAMP WITH TIME ZONE, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	policy_agreement BOOLEAN NOT NULL, 
	PRIMARY KEY (user_id), 
	UNIQUE (email), 
	FOREIGN KEY(role_id) REFERENCES roles (role_id)
);

CREATE TABLE group_members (
	group_member_id BIGSERIAL NOT NULL, 
	user_id BIGINT NOT NULL, 
	group_id BIGINT NOT NULL, 
	role_id BIGINT NOT NULL, 
	joined_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	left_at TIMESTAMP WITH TIME ZONE, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (group_member_id), 
	FOREIGN KEY(user_id) REFERENCES users (user_id), 
	FOREIGN KEY(group_id) REFERENCES groups (group_id), 
	FOREIGN KEY(role_id) REFERENCES roles (role_id)
);

CREATE TABLE invites (
	invite_id BIGSERIAL NOT NULL, 
	group_id BIGINT NOT NULL, 
	role_id BIGINT NOT NULL, 
	is_active BOOLEAN NOT NULL, 
	invite_code VARCHAR NOT NULL, 
	max_uses BIGINT, 
	current_uses BIGINT NOT NULL, 
	created_by BIGINT NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	expires_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	PRIMARY KEY (invite_id), 
	FOREIGN KEY(group_id) REFERENCES groups (group_id), 
	FOREIGN KEY(role_id) REFERENCES roles (role_id), 
	UNIQUE (invite_code), 
	FOREIGN KEY(created_by) REFERENCES users (user_id)
);

CREATE TABLE refresh_tokens (
	user_session_id BIGSERIAL NOT NULL, 
	user_id BIGINT NOT NULL, 
	token_hash VARCHAR NOT NULL, 
	expire_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	is_revoked BOOLEAN DEFAULT false NOT NULL, 
	is_active BOOLEAN DEFAULT false NOT NULL, 
	device_name VARCHAR DEFAULT '', 
	ip_address VARCHAR NOT NULL, 
	last_used_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (user_session_id), 
	FOREIGN KEY(user_id) REFERENCES users (user_id)
);

CREATE TABLE schedules (
	schedule_id BIGSERIAL NOT NULL, 
	name VARCHAR NOT NULL, 
	description VARCHAR, 
	status VARCHAR NOT NULL, 
	group_id VARCHAR, 
	created_by BIGINT NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(), 
	PRIMARY KEY (schedule_id), 
	FOREIGN KEY(group_id) REFERENCES groups (unique_uuid), 
	FOREIGN KEY(created_by) REFERENCES users (user_id)
);

CREATE TABLE events (
	event_id BIGSERIAL NOT NULL, 
	schedule_id BIGINT NOT NULL, 
	title VARCHAR NOT NULL, 
	description TEXT, 
	start_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	end_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	color_id BIGINT NOT NULL, 
	is_repeating BOOLEAN NOT NULL, 
	repeat_pattern VARCHAR, 
	status VARCHAR NOT NULL, 
	created_by BIGINT NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	updated_at TIMESTAMP WITH TIME ZONE, 
	PRIMARY KEY (event_id), 
	FOREIGN KEY(schedule_id) REFERENCES schedules (schedule_id), 
	FOREIGN KEY(color_id) REFERENCES colors (color_id), 
	FOREIGN KEY(created_by) REFERENCES users (user_id)
);

CREATE TABLE notifications (
	notification_id BIGSERIAL NOT NULL, 
	event_id BIGINT NOT NULL, 
	message VARCHAR NOT NULL, 
	destination JSON NOT NULL, 
	created_by BIGINT NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (notification_id), 
	FOREIGN KEY(event_id) REFERENCES events (event_id), 
	FOREIGN KEY(created_by) REFERENCES users (user_id)
);

