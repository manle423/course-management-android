package com.example.coursemangement.activities

import android.annotation.SuppressLint
import android.content.DialogInterface
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.ContextMenu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.widget.*
import androidx.appcompat.app.AlertDialog
import com.example.coursemangement.R
import com.example.coursemangement.adapters.CourseAdapter
import com.example.coursemangement.databinding.ActivityShowListCourseBinding
import com.example.coursemangement.db.DbHelperCourse
import com.example.coursemangement.models.Course
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.w3c.dom.Text

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
    }

    override fun onCreateContextMenu(
        menu: ContextMenu?, v: View?, menuInfo: ContextMenu.ContextMenuInfo?
    ) {
        menu?.setHeaderTitle("Course Manager")
        val inflater = MenuInflater(this)
        inflater.inflate(R.menu.context_menu, menu)
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
                Course(course.course_id,
                    newName,
                    newDescription,
                    newImage,
                    newVideo,
                    newCategory)
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

    private fun reload() {
        adapter.notifyDataSetChanged()
    }


}