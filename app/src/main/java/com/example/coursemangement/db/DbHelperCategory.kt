package com.example.coursemangement.db

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.SQLException
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.coursemangement.models.Category
import java.util.*

class DbHelperCategory(context: Context, factory: SQLiteDatabase.CursorFactory?) :
    SQLiteOpenHelper(context, DATABASE_NAME, factory, DATABASE_VERSION) {
    companion object {
        const val DATABASE_NAME = "db_course_management"
        const val DATABASE_VERSION = 1

        const val TABLE_NAME = "categories"
        const val category_id_col = "category_id"
        const val category_name_col = "category_name"
    }

    override fun onCreate(db: SQLiteDatabase?) {

        val createCategoryTable = "CREATE TABLE $TABLE_NAME " +
                "($category_id_col INTEGER PRIMARY KEY," +
                "$category_name_col TEXT)"

        // Execute SQL commands to create tables
        db?.execSQL(createCategoryTable)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

}