package com.example.coursemangement.db

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.SQLException
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.coursemangement.models.Order
import java.util.*

class DbHelperOrder(context: Context, factory: SQLiteDatabase.CursorFactory?) :
    SQLiteOpenHelper(context, DATABASE_NAME, factory, DATABASE_VERSION) {
    companion object {
        const val DATABASE_NAME = "db_course_management"
        const val DATABASE_VERSION = 1

        const val TABLE_NAME = "orders"
        const val order_id_col = "order_id"
        const val user_id_col = "user_id"
        const val course_id_col = "course_id"
    }

    override fun onCreate(db: SQLiteDatabase?) {

        val createOrderTable = "CREATE TABLE $TABLE_NAME " +
                "($order_id_col TEXT PRIMARY KEY, " +
                "$user_id_col TEXT, " +
                "$course_id_col TEXT)"

        // Execute SQL commands to create tables
        db?.execSQL(createOrderTable)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

}