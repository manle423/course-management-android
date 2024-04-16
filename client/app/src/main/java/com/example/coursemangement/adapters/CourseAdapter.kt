package com.example.coursemangement.adapters

import android.annotation.SuppressLint
import android.app.Activity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.coursemangement.R
import com.example.coursemangement.models.Course


class CourseAdapter(
    private var context: Activity,
    private var resource: Int,
    objects: List<Course>
) :
    ArrayAdapter<Course>(context, resource, objects) {
    private var objects: List<Course>

    init {
        this.objects = objects
    }

    @SuppressLint("ViewHolder")
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val inflater = context.layoutInflater
        val row = inflater.inflate(resource, null)
        val c: Course = objects[position]

        //map view

        /*
        val course_id: String,
        val course_name: String,
        val description: String,
        val image: String,
        val video: String,
        val category_id: Long,
        val is_deleted: Boolean,
        */

        val txtName = row.findViewById<TextView>(R.id.txt_name)
        val txtDescription = row.findViewById<TextView>(R.id.txt_description)

        //show data
        txtName.text = c.course_name
        txtDescription.text = c.description

        return row
    }


}


/*
class CourseAdapter(val courses: List<Course>) :
    RecyclerView.Adapter<CourseAdapter.CourseViewHolder>() {

    inner class CourseViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val txtName: TextView = itemView.findViewById(R.id.txt_name)
        val txtDescription: TextView = itemView.findViewById(R.id.txt_description)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CourseViewHolder {
        val itemView = LayoutInflater.from(parent.context)
            .inflate(R.layout.course_item, parent, false)
        return CourseViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: CourseViewHolder, position: Int) {
        val currentCourse = courses[position]
        holder.txtName.text = currentCourse.course_name
        holder.txtDescription.text = currentCourse.description
    }

    override fun getItemCount() = courses.size
}

 */