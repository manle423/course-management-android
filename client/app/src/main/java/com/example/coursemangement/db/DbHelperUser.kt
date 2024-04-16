package com.example.coursemangement.db

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.SQLException
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.coursemangement.models.User
import java.util.*

class DbHelperUser(context: Context, factory: SQLiteDatabase.CursorFactory?) :
    SQLiteOpenHelper(context, DATABASE_NAME, factory, DATABASE_VERSION) {
    companion object {
        const val DATABASE_NAME = "db_course_management"
        const val DATABASE_VERSION = 1

        const val TABLE_NAME = "users"
        const val user_id_col = "user_id"
        const val username_col = "username"
        const val password_col = "password"
        const val is_active_col = "is_active"
        const val role_id_col = "role_id"
    }

    override fun onCreate(db: SQLiteDatabase?) {

        val createUserTable = "CREATE TABLE $TABLE_NAME " +
                "($user_id_col TEXT PRIMARY KEY, " +
                "$username_col TEXT, " +
                "$password_col TEXT, " +
                "$is_active_col INTEGER, " +
                "$role_id_col INTEGER)"

        // Execute SQL commands to create tables
        db?.execSQL(createUserTable)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

    fun addUser(user: User): Long {
        val db = this.writableDatabase
        val values = ContentValues().apply {
            put(username_col, user.username)
            put(password_col, user.password)
            put(is_active_col, user.is_active)
            put(role_id_col, user.role_id)
        }
        val id = db.insert(TABLE_NAME, null, values)
        db.close()
        return id
    }

    fun getAllUser(): List<User> {
        val rs: ArrayList<User> = ArrayList<User>()
        val db = this.readableDatabase
        val sql = "SELECT * FROM $TABLE_NAME"
        var cursor: Cursor? = null

        try {
            cursor = db.rawQuery(sql, null)
        } catch (e: SQLException) {
            db.execSQL(sql)
            return ArrayList()
        }
        if (cursor.moveToFirst()) {
            do {
                var user = User(
                    cursor.getString(cursor.getColumnIndexOrThrow(user_id_col)),
                    cursor.getString(cursor.getColumnIndexOrThrow(username_col)),
                    cursor.getString(cursor.getColumnIndexOrThrow(password_col)),
                    cursor.getInt(cursor.getColumnIndexOrThrow(is_active_col)) > 0,
                    cursor.getLong(cursor.getColumnIndexOrThrow(role_id_col))
                )
            } while (cursor.moveToNext())

        }
        cursor.close()
        db.close()
        return rs
    }

}