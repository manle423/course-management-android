package com.example.coursemangement.db

import android.content.ContentValues
import android.database.Cursor
import android.database.SQLException
import com.example.coursemangement.dbconstants.UserConstants
import com.example.coursemangement.models.User

//data access object
class UserDAO(private val dbHelper: DbHelper) {

    fun addUser(user: User): Long {
        val db = dbHelper.writableDatabase
        val values = ContentValues().apply {
            put(UserConstants.username_col, user.username)
            put(UserConstants.password_col, user.password)
            put(UserConstants.is_active_col, user.is_active)
            put(UserConstants.role_id_col, user.role_id)
        }
        val id = db.insert(UserConstants.TABLE_NAME, null, values)
        db.close()
        return id
    }

    fun getAllUser(): List<User> {
        val rs: ArrayList<User> = ArrayList<User>()
        val db = dbHelper.readableDatabase
        val sql = "SELECT * FROM ${UserConstants.TABLE_NAME}"
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
                    cursor.getString(cursor.getColumnIndexOrThrow(UserConstants.user_id_col)),
                    cursor.getString(cursor.getColumnIndexOrThrow(UserConstants.username_col)),
                    cursor.getString(cursor.getColumnIndexOrThrow(UserConstants.password_col)),
                    cursor.getInt(cursor.getColumnIndexOrThrow(UserConstants.is_active_col)) > 0,
                    cursor.getLong(cursor.getColumnIndexOrThrow(UserConstants.role_id_col))
                )
            } while (cursor.moveToNext())

        }
        cursor.close()
        db.close()
        return rs
    }
}