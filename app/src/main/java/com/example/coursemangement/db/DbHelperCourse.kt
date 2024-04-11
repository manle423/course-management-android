package com.example.coursemangement.db

import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.SQLException
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.coursemangement.models.Course

class DbHelperCourse(context: Context, factory: SQLiteDatabase.CursorFactory?) :
    SQLiteOpenHelper(context, DATABASE_NAME, factory, DATABASE_VERSION) {
    companion object {
        const val DATABASE_NAME = "db_course_management"
        const val DATABASE_VERSION = 1

        const val TABLE_NAME = "courses"
        const val course_id_col = "course_id"
        const val course_name_col = "course_name"
        const val description_col = "description"
        const val image_col = "image"
        const val video_col = "video"
        const val category_id_col = "category_id"
        const val is_deleted_col = "is_deleted"
    }


    override fun onCreate(db: SQLiteDatabase?) {

        val createCourseTable = "CREATE TABLE $TABLE_NAME " +
                "($course_id_col TEXT PRIMARY KEY, " +
                "$course_name_col TEXT, " +
                "$description_col TEXT, " +
                "$image_col TEXT, " +
                "$video_col TEXT, " +
                "$category_id_col INTEGER, " +
                "$is_deleted_col INTEGER)"

        db?.execSQL(createCourseTable)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

    fun addCourse(course: Course): Long {
        val db = this.writableDatabase
        val values = ContentValues().apply {
            put(course_id_col, course.course_id)
            put(course_name_col, course.course_name)
            put(description_col, course.description)
            put(image_col, course.image)
            put(video_col, course.video)
            put(category_id_col, course.category_id)
        }
        val id = db.insert(TABLE_NAME, null, values)
        db.close()
        return id
    }

    @SuppressLint("Range")
    fun showCourse(): List<Course> {
        val rs: ArrayList<Course> = ArrayList<Course>()
        val sql = "SELECT * FROM $TABLE_NAME"
        val db = this.readableDatabase
        var cursor: Cursor? = null

        //read data to cursor
        try {
            cursor = db.rawQuery(sql, null)
        } catch (e: SQLException) {
            db.execSQL(sql)
            return ArrayList()
        }

        //iteration on cursor
        if (cursor.moveToFirst()) {
            do {
                val course = Course(
                    cursor.getString(cursor.getColumnIndex(course_id_col)),
                    cursor.getString(cursor.getColumnIndex(course_name_col)),
                    cursor.getString(cursor.getColumnIndex(description_col)),
                    cursor.getString(cursor.getColumnIndex(image_col)),
                    cursor.getString(cursor.getColumnIndex(video_col)),
                    cursor.getLong(cursor.getColumnIndex(category_id_col))
                )
                rs.add(course)
            } while (cursor.moveToNext())
        }
        cursor.close()
        db.close()
        return rs
    }

}