package com.example.coursemangement.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.ArrayAdapter
import android.widget.Toast
import com.example.coursemangement.databinding.ActivityAddCourseBinding
import com.example.coursemangement.databinding.ActivityMainBinding
import com.example.coursemangement.db.DbHelperCourse
import com.example.coursemangement.models.Course
import java.util.*

class AddCourseActivity : AppCompatActivity() {
    private lateinit var binding: ActivityAddCourseBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAddCourseBinding.inflate(layoutInflater)
        setContentView(binding.root)
        val uniqueID = UUID.randomUUID().toString()
        binding.txtId.setText(uniqueID)

        addCourse()
        back()

        // không cho chỉnh sửa id nhưng vẫn cho phép copy
        binding.txtId.isFocusable = false
        binding.txtId.isFocusableInTouchMode = false

        binding.txtCategoryId.setOnEditorActionListener { v, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                // Ẩn bàn phím khi nhấn Done
                val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
                imm.hideSoftInputFromWindow(v.windowToken, 0)
                true
            } else {
                false
            }
        }
    }

    //#region Add Course
    private fun addCourse() {
        binding.btnSave.setOnClickListener {
            val db = DbHelperCourse(this, null)
            val txtId = binding.txtId.text.toString()
            val categoryId = binding.txtCategoryId.text.toString().toLongOrNull() ?: 0
            val course = Course(
                txtId,
                binding.txtName.text.toString(),
                binding.txtDescription.text.toString(),
                binding.txtImage.text.toString(),
                binding.txtVideo.text.toString(),
                categoryId
            )
            val rs = db.addCourse(course)
            if (rs >= 1) {
                Toast.makeText(
                    this,
                    course.course_name + " added to database",
                    Toast.LENGTH_LONG
                ).show()
                clearTextBox()
                // Tạo một UUID mới và thiết lập nó cho txtId sau khi thêm thành công
                val newUniqueId = UUID.randomUUID().toString()
                binding.txtId.setText(newUniqueId)
            } else {
                Toast.makeText(
                    this,
                    course.course_name + " cannot add to db",
                    Toast.LENGTH_LONG
                ).show()
            }
        }
    }
    //#endregion

    //#region Clear
    private fun clearTextBox() {
        binding.txtName.text.clear()
        binding.txtDescription.text.clear()
        binding.txtImage.text.clear()
        binding.txtVideo.text.clear()
        binding.txtCategoryId.text.clear()
    }
    //#endregion

    //#region Back
    private fun back() {
        binding.btnBack.setOnClickListener {
            val resultIntent = Intent()
            setResult(Activity.RESULT_OK, resultIntent)
            finish()
        }
    }
    //#endregion
}