package com.example.coursemangement.activities

import android.app.Activity
import android.app.AlertDialog
import android.content.DialogInterface
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.ContextMenu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.EditText
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.coursemangement.R
import com.example.coursemangement.adapters.CourseAdap
import com.example.coursemangement.databinding.ActivityShowListCourseBinding
import com.example.coursemangement.db.DbHelperCourse
import com.example.coursemangement.models.Course

/*
class ShowListCourseActivityNew : AppCompatActivity() {

    private lateinit var binding: ActivityShowListCourseBinding
    private lateinit var db: DbHelperCourse
    private lateinit var courseAdapter: CourseAdap
    private lateinit var courseList: MutableList<Course>
    private lateinit var courseSelected: Course

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityShowListCourseBinding.inflate(layoutInflater)
        registerForContextMenu(binding.rsvCourse)
        setContentView(binding.root)

        readCourse()
        addCourse()
        back()

    }


    override fun onCreateContextMenu(
        menu: ContextMenu,
        v: View,
        menuInfo: ContextMenu.ContextMenuInfo?
    ) {
        val inflater = MenuInflater(this)
        inflater.inflate(R.menu.context_menu_course, menu)
        super.onCreateContextMenu(menu, v, menuInfo)
    }

    override fun onResume() {
        super.onResume()
        courseAdapter.refreshData(db.getAllCourse())
    }

    override fun onContextItemSelected(item: MenuItem): Boolean {
        Log.d("ContextMenu", "Item selected: ${item.itemId}")
        return when (item.itemId) {
            R.id.mnuEdit -> {
                val info = item.menuInfo as AdapterView.AdapterContextMenuInfo
                val position = info.position
                true
            }
            R.id.mnuDelete -> {
                val info = item.menuInfo as? AdapterView.AdapterContextMenuInfo
                Log.d("info", "info: $info")
                if (info != null) {
                    val position = info.position
                    if (position >= 0 && position < courseList.size) {
                        val selectedCourse = courseList[position]
                        deleteCourse(selectedCourse)
                        true
                    } else {
                        false
                    }
                } else {
                    false
                }
            }
            R.id.mnuWatch -> {
                val info = item.menuInfo as AdapterView.AdapterContextMenuInfo
                val position = info.position
                if (position >= 0 && position < courseList.size) {
                    val selectedCourse = courseList[position]
                    watchCourse(selectedCourse)
                    true
                } else {
                    false
                }
            }
            R.id.mnuInfo -> {
                val info = item.menuInfo as? AdapterView.AdapterContextMenuInfo
                val position = info?.position ?: -1

                if (position >= 0 && position < courseList.size) {
                    val selectedCourse = courseList[position]
                    showCourse(selectedCourse)
                    true
                } else {
                    false
                }
            }

            else -> super.onContextItemSelected(item)
        }
    }

    //#region Read Course
    private fun readCourse() {
        db = DbHelperCourse(this, null)
        courseAdapter = CourseAdap(db.getAllCourse(), this)
        binding.rsvCourse.layoutManager = LinearLayoutManager(this)
        binding.rsvCourse.adapter = courseAdapter
    }
    //#endregion

    //#region Add Course
    private fun addCourse() {
        binding.btnAdd.setOnClickListener {
            val i = Intent(applicationContext, AddCourseActivity::class.java)
            addCourseLauncher.launch(i)
        }
    }

    private val addCourseLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                readCourse()
            }
        }
    //#endregion

    //#region Back
    private fun back() {
        binding.btnBack.setOnClickListener {
            finish()
        }
    }
    //#endregion

    //#region Watch Course
    private fun watchCourse(course: Course) {
        val link = course.video
        val i = Intent(Intent.ACTION_VIEW, Uri.parse(link))
        startActivity(i)
    }
    //#endregion

    //#region Info
    private fun showCourse(course: Course) {
        val dlg = AlertDialog.Builder(this)
        val inflater = this.layoutInflater
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

        dlg.setPositiveButton("Enroll", DialogInterface.OnClickListener { _, _ ->
            Toast.makeText(this, "Enroll successfully", Toast.LENGTH_LONG).show()
        })

        dlg.setNegativeButton("Back", DialogInterface.OnClickListener { _, _ ->

        })
        val b = dlg.create()
        b.show()
    }
    //#endregion

    //#region Delete Course
    private fun deleteCourse(course: Course) {
        val dlg = AlertDialog.Builder(this)
        dlg.setTitle("Delete Course")
        dlg.setMessage("Course: ${course.course_name} will be deleted. Are you sure?")

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

}
*/