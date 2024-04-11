package com.example.coursemangement.db

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.SQLException
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.coursemangement.models.Role
import java.util.*

class DbHelperRole(context: Context, factory: SQLiteDatabase.CursorFactory?) :
    SQLiteOpenHelper(context, DATABASE_NAME, factory, DATABASE_VERSION) {
    companion object {
        const val DATABASE_NAME = "db_course_management"
        const val DATABASE_VERSION = 1

        const val TABLE_NAME = "roles"
        const val role_id_col = "role_id"
        const val role_name_col = "role_name"
    }

    override fun onCreate(db: SQLiteDatabase?) {

        val createRoleTable = "CREATE TABLE $TABLE_NAME " +
                "($role_id_col INTEGER PRIMARY KEY, " +
                "$role_name_col TEXT)"

        // Execute SQL commands to create tables
        db?.execSQL(createRoleTable)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

}