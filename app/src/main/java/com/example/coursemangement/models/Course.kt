package com.example.coursemangement.models

//import java.util.UUID

data class Course(
    val course_id: String,
    val course_name: String,
    val description: String,
    val image: String,
    val video: String,
    val category_id: Long,
    val is_deleted: Boolean,
) {
    constructor(
        course_id: String,
        course_name: String,
        description: String,
        image: String,
        video: String,
        category_id: Long
    ) : this(course_id, course_name, description, image, video, category_id, false)
}
