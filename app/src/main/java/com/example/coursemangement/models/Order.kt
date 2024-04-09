package com.example.coursemangement.models

import java.util.UUID

data class Order(
    val order_id: String = UUID.randomUUID().toString(),
    val user_id: Long,
    val course_id: Long,
    val total_amount: Long,
)