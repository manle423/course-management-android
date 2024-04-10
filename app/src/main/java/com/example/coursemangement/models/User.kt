package com.example.coursemangement.models

import java.util.UUID

// data class chi de luu tru du lieu chu k co logic
data class User(
    var user_id: String = UUID.randomUUID().toString(),
    var username: String,
    var password: String,
    var is_active: Boolean,
    var role_id: Long,
)