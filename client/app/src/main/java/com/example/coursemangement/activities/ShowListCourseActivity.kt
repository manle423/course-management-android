package com.example.coursemangement.activities

import android.annotation.SuppressLint
import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.ContextMenu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.widget.*
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.example.coursemangement.R
import com.example.coursemangement.adapters.CourseAdapter
import com.example.coursemangement.databinding.ActivityShowListCourseBinding
import com.example.coursemangement.db.DbHelperCourse
import com.example.coursemangement.models.Course

class ShowListCourseActivity : AppCompatActivity() {

    private lateinit var binding: ActivityShowListCourseBinding
    private lateinit var courseSelected: Course

    //    private lateinit var adapter: ArrayAdapter<Course>
    private lateinit var adapter: CourseAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityShowListCourseBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // dang ky context menu cho listview
        registerForContextMenu(binding.lsvCourses)
        readCourse()
        back()
        addCourse()

    }

    override fun onCreateContextMenu(
        menu: ContextMenu?, v: View?, menuInfo: ContextMenu.ContextMenuInfo?
    ) {
        menu?.setHeaderTitle("Course Manager")
        val inflater = MenuInflater(this)
        inflater.inflate(R.menu.context_menu_course, menu)
        //get selected Course
        if (v?.id == R.id.lsvCourses) {
            val lsv = v as ListView
            val acm = menuInfo as AdapterView.AdapterContextMenuInfo
            courseSelected = lsv.getItemAtPosition(acm.position) as Course
        }

        super.onCreateContextMenu(menu, v, menuInfo)
    }

    override fun onContextItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.mnuEdit -> {
                updateCourse(courseSelected)
            }
            R.id.mnuDelete -> {
                deleteCourse(courseSelected)
            }
            R.id.mnuInfo -> {
                showCourse(courseSelected)
            }
            R.id.mnuWatch -> {
                watchCourse(courseSelected)
            }

        }
        return super.onContextItemSelected(item)
    }


    private fun readCourse() {
        val db = DbHelperCourse(this, null)
        val list = db.getAllCourse()
//        adapter = ArrayAdapter<Course>(this, android.R.layout.simple_list_item_1, list)
        adapter = CourseAdapter(this, R.layout.course_item, list)
        binding.lsvCourses.adapter = adapter
    }

    // xem thông tin khóa học
    private fun showCourse(course: Course) {
        val dlg = AlertDialog.Builder(this)
        val inflater = this.layoutInflater
//        val dlgView = inflater.inflate(R.layout.activity_add_course, null)
        val dlgView = inflater.inflate(R.layout.course_layout, null)
        dlg.setTitle("Course information")
        dlg.setView(dlgView)


        val txtName = dlgView.findViewById(R.id.txt_name) as EditText
        val txtDescription = dlgView.findViewById(R.id.txt_description) as EditText
        val txtImage = dlgView.findViewById(R.id.txt_image) as EditText
        val txtVideo = dlgView.findViewById(R.id.txt_video) as EditText
        val txtCategory = dlgView.findViewById(R.id.txt_category_id) as EditText

        // show old data
        txtName.setText(course.course_name)
        txtDescription.setText(course.description)
        txtImage.setText(course.image)
        txtVideo.setText(course.video)
        txtCategory.setText(course.category_id.toString())

        // read only
        txtName.isEnabled = false
        txtDescription.isEnabled = false
        txtImage.isEnabled = false
        txtVideo.isEnabled = false
        txtCategory.isEnabled = false

        dlg.setPositiveButton("Đăng ký học", DialogInterface.OnClickListener { _, _ ->
            Toast.makeText(this, "Đăng ký thành công", Toast.LENGTH_LONG).show()
        })

        dlg.setNegativeButton("Trở về", DialogInterface.OnClickListener { _, _ ->

        })
        val b = dlg.create()
        b.show()
    }

    // xem video khóa học
    private fun watchCourse(course: Course) {
        val link = course.video
        val i = Intent(Intent.ACTION_VIEW, Uri.parse(link))
        startActivity(i)
    }

    @SuppressLint("InflateParams", "MissingInflatedId")
    private fun updateCourse(course: Course) {
        val dlg = AlertDialog.Builder(this)
        val inflater = this.layoutInflater
//        val dlgView = inflater.inflate(R.layout.activity_add_course, null)
        val dlgView = inflater.inflate(R.layout.course_layout, null)
        dlg.setTitle("Edit Course")
        dlg.setMessage("Enter data below")
        dlg.setView(dlgView)

        val txtId = dlgView.findViewById(R.id.txt_id) as EditText
        val txtName = dlgView.findViewById(R.id.txt_name) as EditText
        val txtDescription = dlgView.findViewById(R.id.txt_description) as EditText
        val txtImage = dlgView.findViewById(R.id.txt_image) as EditText
        val txtVideo = dlgView.findViewById(R.id.txt_video) as EditText
        val txtCategory = dlgView.findViewById(R.id.txt_category_id) as EditText

        // show old data
        txtId.setText(course.course_id)
        txtName.setText(course.course_name)
        txtDescription.setText(course.description)
        txtImage.setText(course.image)
        txtVideo.setText(course.video)
        txtCategory.setText(course.category_id.toString())

        // read only
        txtId.isEnabled = false

        dlg.setPositiveButton("Save", DialogInterface.OnClickListener { _, _ ->
            val newName = txtName.text.toString()
            val newDescription = txtDescription.text.toString()
            val newImage = txtImage.text.toString()
            val newVideo = txtVideo.text.toString()
            val newCategory = txtCategory.text.toString().toLong()

            val updatedCourse =
                Course(
                    course.course_id,
                    newName,
                    newDescription,
                    newImage,
                    newVideo,
                    newCategory
                )
            val db = DbHelperCourse(this, null)
            val rs = db.updateCourse(updatedCourse)
            if (rs >= 1) {
                Toast.makeText(this, "Course updated", Toast.LENGTH_LONG).show()
                readCourse()
            } else Toast.makeText(this, "Error updated", Toast.LENGTH_LONG).show()
        })

        dlg.setNegativeButton("Cancel", DialogInterface.OnClickListener { _, _ -> })
        val b = dlg.create()
        b.show()
    }


    //#region Delete Course
    @SuppressLint("InflateParams")
    private fun deleteCourse(course: Course) {
        val dlg = AlertDialog.Builder(this)
        val inflater = this.layoutInflater
//        val dlgView = inflater.inflate(R.layout.course_item, null)
        dlg.setTitle("Delete Course")
        dlg.setMessage("Course: ${course.course_name} will be deleted. Are you sure?")
//        dlg.setView(dlgView)
//
//        val txtName = dlgView.findViewById(R.id.txt_name) as EditText
//        val txtDescription = dlgView.findViewById(R.id.txt_description) as EditText
//
//        // show old data
//        txtName.setText(course.course_name)
//        txtDescription.setText(course.description)
//
//        // read only
//        txtName.isEnabled = false
//        txtDescription.isEnabled = false

        dlg.setPositiveButton("Delete", DialogInterface.OnClickListener { _, _ ->
            val db = DbHelperCourse(this, null)
            val rs = db.deleteCourse(course.course_id)
            if (rs >= 1) {
                Toast.makeText(this, "Course deleted", Toast.LENGTH_LONG).show()
                readCourse()
            } else Toast.makeText(this, "Error deleted", Toast.LENGTH_LONG).show()
        })

        dlg.setNegativeButton("Cancel", DialogInterface.OnClickListener { _, _ -> })
        val b = dlg.create()
        b.show()

    }
    //#endregion


    //#region Back
    private fun back() {
        binding.btnBack.setOnClickListener {
            finish()
        }
    }
    //#endregion

    //#region Add Course
    private fun addCourse() {
        binding.btnAdd.setOnClickListener {
            val i = Intent(applicationContext, AddCourseActivity::class.java)
            addCourseLauncher.launch(i)
        }
    }
    //#endregion

    private val addCourseLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            readCourse()
        }
    }

    private fun reload() {
        adapter.notifyDataSetChanged()
    }


}