package com.example.coursemangement

import android.annotation.SuppressLint
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.view.menu.MenuBuilder
import com.example.coursemangement.activities.AddCourseActivity
import com.example.coursemangement.activities.ShowListCourseActivity
import com.example.coursemangement.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private var myMenu: Menu? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        //val i = Intent(this, ShowListCourseActivity::class.java)
        //startActivity(i)

        showAllCourse()


    }

    //create option menu
    @SuppressLint("RestrictedApi")
    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        this.myMenu = menu
        val menuInflater = menuInflater
        menuInflater.inflate(R.menu.option_menu, menu)
        if(menu is MenuBuilder){
            menu.setOptionalIconsVisible(true)
        }
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId){
//            R.id.mnuLogin -> {
//                val i = Intent(applicationContext, LoginActivity::class.java)
//                startActivityForResult()
//            }
            R.id.mnuAddCourse -> {
                val i = Intent(applicationContext, AddCourseActivity::class.java)
                startActivity(i)
            }
        }
        return super.onOptionsItemSelected(item)
    }

    private fun showAllCourse() {
        binding.btnShowAllCourse.setOnClickListener{
            val i = Intent(this, ShowListCourseActivity::class.java)
            startActivity(i)
        }
    }
}