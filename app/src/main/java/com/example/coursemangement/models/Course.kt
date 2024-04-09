package com.example.coursemangement.models

import java.util.UUID

data class Course(
    val course_id:  String = UUID.randomUUID().toString(),
    val course_name: String,
    val description: String,
    val price: Double,
    val image: String,
    val video: String,
    val category_id: Long,
    val is_deleted: Boolean,
)