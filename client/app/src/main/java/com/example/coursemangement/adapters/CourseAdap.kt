package com.example.coursemangement.adapters

import android.annotation.SuppressLint
import android.content.Context
import android.view.*
import android.view.ContextMenu.ContextMenuInfo
import android.view.View.OnCreateContextMenuListener
import android.widget.ImageButton
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.coursemangement.R
import com.example.coursemangement.db.DbHelperCourse
import com.example.coursemangement.models.Course


class CourseAdap(private var courses: List<Course>, context: Context) :
    RecyclerView.Adapter<CourseAdap.CourseViewHolder>() {

    private val db: DbHelperCourse = DbHelperCourse(context, null)
    private var courseSelectedPosition: Int = RecyclerView.NO_POSITION

    inner class CourseViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        private val nameTextView: TextView = itemView.findViewById(R.id.txt_name)
        private val descriptionTextView: TextView = itemView.findViewById(R.id.txt_description)

        fun bind(course: Course) {
            nameTextView.text = course.course_name
            descriptionTextView.text = course.description
        }

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CourseViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.course_item, parent, false)
        return CourseViewHolder(view)
    }

    override fun getItemCount(): Int = courses.size

    @SuppressLint("SetTextI18n")
    override fun onBindViewHolder(holder: CourseViewHolder, position: Int) {
        val course = courses[position]
        holder.bind(course)
//        holder.itemView.setOnCreateContextMenuListener { menu, _, _ ->
//            menu.setHeaderTitle("Course Options")
    }


    @SuppressLint("NotifyDataSetChanged")
    fun refreshData(newCourses: List<Course>) {
        courses = newCourses
        notifyDataSetChanged()
    }
}