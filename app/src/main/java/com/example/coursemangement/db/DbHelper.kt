package com.example.coursemangement.db

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.coursemangement.dbconstants.*

class DbHelper(context: Context, factory: SQLiteDatabase.CursorFactory?) :
    SQLiteOpenHelper(context, DATABASE_NAME, factory, DATABASE_VERSION) {
    companion object {
        const val DATABASE_NAME = "db_course_management"
        const val DATABASE_VERSION = 1
    }

    override fun onCreate(db: SQLiteDatabase?) {
        val user = UserConstants
        val course = CourseConstants
        val order = OrderConstants
        val category = CategoryConstants
        val role = RoleConstants

        val createUserTable = "CREATE TABLE ${user.TABLE_NAME} " +
                "(${user.user_id_col} TEXT PRIMARY KEY, " +
                "${user.username_col} TEXT, " +
                "${user.password_col} TEXT, " +
                "${user.is_active_col} INTEGER, " +
                "${user.role_id_col} INTEGER)"

        val createCourseTable = "CREATE TABLE ${course.TABLE_NAME} " +
                "(${course.course_id_col} TEXT PRIMARY KEY, " +
                "${course.course_name_col} TEXT, " +
                "${course.description_col} TEXT, " +
                "${course.image_col} TEXT, " +
                "${course.video_col} TEXT, " +
                "${course.category_id_col} INTEGER, " +
                "${course.is_deleted_col} INTEGER)"

        val createOderTable = "CREATE TABLE ${order.TABLE_NAME} " +
                "(${order.order_id_col} TEXT PRIMARY KEY, " +
                "${order.user_id_col} TEXT, " +
                "${order.course_id_col} TEXT)"

        val createCategoryTable = "CREATE TABLE ${category.TABLE_NAME} " +
                "(${category.category_id_col} INTEGER PRIMARY KEY, " +
                "${category.category_name_col} TEXT)"

        val createRoleTable = "CREATE TABLE ${role.TABLE_NAME} " +
                "(${role.role_id_col} INTEGER PRIMARY KEY, " +
                "${role.role_name_col} TEXT)"

        // Execute SQL commands to create tables
        db?.execSQL(createUserTable)
        db?.execSQL(createCourseTable)
        db?.execSQL(createOderTable)
        db?.execSQL(createCategoryTable)
        db?.execSQL(createRoleTable)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS ${UserConstants.TABLE_NAME}")
        db?.execSQL("DROP TABLE IF EXISTS ${RoleConstants.TABLE_NAME}")
        db?.execSQL("DROP TABLE IF EXISTS ${CategoryConstants.TABLE_NAME}")
        db?.execSQL("DROP TABLE IF EXISTS ${CourseConstants.TABLE_NAME}")
        db?.execSQL("DROP TABLE IF EXISTS ${OrderConstants.TABLE_NAME}")
        onCreate(db)
    }

}