<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/toastify.css" />

<%@ page import="java.util.List" %>
<%@ page import="com.example.model.TaskWithCategory" %>
<%@ page import="com.example.model.Task" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    List<TaskWithCategory> taskWithCategoryList  = (List<TaskWithCategory>) request.getAttribute("tasks");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
    com.example.model.User user = (com.example.model.User) session.getAttribute("user");
    String userId = user.user_id;
%>

<div style="display: flex; justify-content: space-between; align-items: center;">
    <div style="padding: 6px 8px; display: flex; align-items: center; column-gap: 10px;">
         <span>Sắp xếp</span>
         <select id="btn-sort" style="box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); width: 200px; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" >
                    <option value="" disabled selected>Gần đây nhất</option>
                    <option value="priority">Độ ưu tiên</option>
                    <option value="oldest">Cũ nhất</option>
         </select>

         <div style="position: relative">
            <button id="btn-filter" style="box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); display: flex; align-items: center; column-gap: 4px; padding: 8px 16px; cursor: pointer; background-color: #343a40; color: white; border-radius: 8px; border: none;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                    class="lucide lucide-funnel-icon lucide-funnel">
                    <path d="M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z"/>
                    </svg>
                    <span style="font-size: 14px;">Bộ lọc</span>
            </button>
            <div id="modal-filter" style="display: none; z-index: 99; position: absolute; top: 40px; left: 0; padding: 8px 6px; width: 180px; background-color: #f2f2f2; border-radius: 8px; border: 1px solid #dadada;">
                    <div id="modal-category-filter"></div>
                    <button id="btn-apply" style="padding: 8px 16px; background-color: #0466c8; color: white; border-radius: 8px; border: none; font-size: 14px; display: block; width: 100%;">Áp dụng</button>
            </div>
         </div>

         <div id="btn-clear" style="cursor: pointer; background-color: #ef223C; border-radius: 8px; padding: 8px 12px 10px; color: white; display: none; align-items: center; column-gap: 2px; font-size: 14px;">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-x-icon lucide-x"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
            Xóa lọc
         </div>
    </div>

     <div style=" display: flex; align-items: center; column-gap: 8px;">
        <button onclick="openCategoryModal()" style="box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); display: flex; align-items: center; column-gap: 4px; padding: 8px 10px; border-radius: 12px; background-color: #fff; border: 1px solid #dadada; color: black; font-size: 15px; cursor:pointer; ">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chart-bar-stacked-icon lucide-chart-bar-stacked"><path d="M11 13v4"/><path d="M15 5v4"/><path d="M3 3v16a2 2 0 0 0 2 2h16"/><rect x="7" y="13" width="9" height="4" rx="1"/><rect x="7" y="5" width="12" height="4" rx="1"/></svg>

                   Thể loại
        </button>
        <button onclick="openAddTaskModal()"  style="box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);padding: 10px 12px; border-radius: 12px; display: flex; align-items: center; column-gap: 4px; background-color: #0466c8; border: none; color: white; font-size: 15px; cursor:pointer;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20"
                    height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                    stroke-linejoin="round" class="lucide lucide-plus-icon lucide-plus"><path d="M5 12h14"/><path d="M12 5v14"/></svg>

                    Thêm công việc
       </button>
     </div>
</div>



<div style="padding: 12px 8px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;">
    <div style="grid-column: span 1;">
        <div style=" display: flex; align-items: center;">
            <div style="height: 10px; width: 10px; border-radius: 99px; background-color: #17A2B8"></div>
            <span style="margin-left: 8px; font-weight: 500;">Chưa bắt đầu</span>
        </div>
        <div id="chua-bat-dau-tasks" style="box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); margin-top: 10px; padding: 12px; border-radius: 10px; background-color: #C4D0EB">
              <%
                      boolean found = false;
                      for (TaskWithCategory taskWithCategory : taskWithCategoryList) {
                              Task task = taskWithCategory.task;
                              String category_name = taskWithCategory.category_name;
                               String priority = task.priority;
                               String priorityColor;

                               if ("Cao".equals(priority)) {
                                       priorityColor = "#db4c40";
                                   } else if ("Trung bình".equals(priority)) {
                                       priorityColor = "#e9c46a";
                                   } else if ("Thấp".equals(priority)) {
                                       priorityColor = "#10b981";
                                   } else {
                                       priorityColor = "#dadada";
                                   }

                              if ("Chưa bắt đầu".equals(task.status)) {
                                    found = true;
              %>
                              <div class="task-card" data-task-id="<%= task.task_id %>" onclick="openTaskModal(this)">
                                <h2 style="font-size: 18px; font-weight: 500; line-height: 12px;">
                                    <%= task.title %>
                                </h2>
                                <p style="font-size: 16px; color: #535353">
                                    <%= task.description %>
                                </p>
                                <div style="font-size: 15px; color: #535353; display: flex; align-items:center; column-gap: 4px;">
                                   <span>
                                        Thời gian bắt đầu:
                                   </span>
                                   <span style="font-weight: 500; display: block">
                                        <%= task.start_time != null ? task.start_time.format(formatter) : "N/A" %>
                                   </span>
                                </div>
                                <div style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                    <div style="padding: 4px 0; font-size: 14px; border-radius: 8px; color: black; display: flex; align-items: center; column-gap: 6px">
                                           <strong>Mức ưu tiên:</strong>
                                           <div style="padding: 4px 8px; background-color: <%= priorityColor %>; color: black; border-radius: 12px; font-weight: 500; color: white;">
                                                <%= task.priority %>
                                           </div>
                                    </div>
                                    <span class="category-name" style=" padding: 4px 12px 6px; font-size: 14px; border-radius: 12px; color: #f2f2f2; background-color: #0077b6">
                                        <%= category_name %>
                                    </span>
                                </div>
                              </div>
              <%
                         }
                  }
                  if (!found) {
                  %>
                      <p style="text-align: center; color: #283618; font-size: 15px;">Không có công việc</p>
                  <%
                      }
              %>
        </div>
    </div>
    <div style="grid-column: span 1;">
            <div style=" display: flex; align-items: center;">
                <div style="height: 10px; width: 10px; border-radius: 99px; background-color: #ffc107"></div>
                <span style="margin-left: 8px; font-weight: 500;">Đang thực hiện</span>
            </div>
           <div id="dang-thuc-hien-tasks" style="box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); margin-top: 10px; padding: 12px; border-radius: 10px; background-color: #fee440">
               <%
                   boolean found2 = false;
                   if (taskWithCategoryList != null) {
                       for (TaskWithCategory taskWithCategory : taskWithCategoryList) {
                           Task task = taskWithCategory.task;
                           String category_name = taskWithCategory.category_name;
                           String priority = task.priority;
                                                          String priorityColor;

                                                          if ("Cao".equals(priority)) {
                                                                  priorityColor = "#db4c40";
                                                              } else if ("Trung bình".equals(priority)) {
                                                                  priorityColor = "#e9c46a";
                                                              } else if ("Thấp".equals(priority)) {
                                                                  priorityColor = "#10b981";
                                                              } else {
                                                                  priorityColor = "#dadada";
                                                              }

                           if ("Đang thực hiện".equals(task.status)) {
                               found2 = true;
               %>
                               <div class="task-card" data-task-id="<%= task.task_id %>" onclick="openTaskModal(this)">
                                   <h2 style="font-size: 18px; font-weight: 500; line-height: 12px;">
                                       <%= task.title %>
                                   </h2>
                                   <p style="font-size: 16px; color: #535353">
                                       <%= task.description %>
                                   </p>
                                   <div style="font-size: 15px; color: #535353; display: flex; align-items:center; column-gap: 4px;">
                                       <span>Thời gian bắt đầu:</span>
                                       <span style="font-weight: 500; display: block">
                                           <%= task.start_time != null ? task.start_time.format(formatter) : "N/A" %>
                                       </span>
                                   </div>
                                   <div style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                       <div style="padding: 4px 0; font-size: 14px; border-radius: 8px; color: black; display: flex; align-items: center; column-gap: 6px">
                                           <strong>Mức ưu tiên:</strong>
                                           <div style="padding: 4px 8px; background-color: <%= priorityColor %>; color: black; border-radius: 12px; font-weight: 500; color: white;">
                                                <%= task.priority %>
                                           </div>
                                       </div>
                                       <span class="category-name" style="padding: 4px 12px 6px; font-size: 14px; border-radius: 12px; color: #f2f2f2; background-color: #0077b6">
                                           <%= category_name %>
                                       </span>
                                   </div>
                               </div>
               <%
                           }
                       }
                   }
                   if (!found2) {
               %>
                       <p style="text-align: center; color: #283618; font-size: 15px;">Không có công việc</p>
               <%
                   }
               %>
           </div>
    </div>
    <div style="grid-column: span 1;">
            <div style=" display: flex; align-items: center;">
                <div style="height: 10px; width: 10px; border-radius: 99px; background-color: #8bc34a"></div>
                <span style="margin-left: 8px; font-weight: 500;">Hoàn thành</span>
            </div>
            <div id="hoan-thanh-tasks" style="box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);margin-top: 10px; padding: 12px; border-radius: 10px; background-color: #80ed99">
                  <%
                           boolean found3 = false;
                           for (TaskWithCategory taskWithCategory : taskWithCategoryList) {
                                Task task = taskWithCategory.task;
                                String category_name = taskWithCategory.category_name;

                                String priority = task.priority;
                                                               String priorityColor;

                                                               if ("Cao".equals(priority)) {
                                                                       priorityColor = "#db4c40";
                                                                   } else if ("Trung bình".equals(priority)) {
                                                                       priorityColor = "#e9c46a";
                                                                   } else if ("Thấp".equals(priority)) {
                                                                       priorityColor = "#10b981";
                                                                   } else {
                                                                       priorityColor = "#dadada";
                                                                   }

                                if ("Hoàn thành".equals(task.status)) {
                                    found3 = true;
                  %>
                                  <div class="task-card"  data-task-id="<%= task.task_id %>" onclick="openTaskModal(this)">
                                        <h2 style="font-size: 18px; font-weight: 500; line-height: 12px;">
                                            <%= task.title %>
                                        </h2>
                                        <p style="font-size: 16px; color: #535353">
                                            <%= task.description %>
                                        </p>
                                       <div style="font-size: 15px; color: #535353; display: flex; align-items:center; column-gap: 4px;">
                                           <span>
                                                 Thời gian bắt đầu:
                                           </span>
                                           <span style="font-weight: 500; display: block">
                                                 <%= task.start_time != null ? task.start_time.format(formatter) : "N/A" %>
                                           </span>
                                      </div>
                                       <div style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                                                          <div style="padding: 4px 0; font-size: 14px; border-radius: 8px; color: black; display: flex; align-items: center; column-gap: 6px">
                                                                                 <strong>Mức ưu tiên:</strong>
                                        <div style="padding: 4px 8px; background-color: <%= priorityColor %>; color: black; border-radius: 12px; font-weight: 500; color: white;">
                                                                                        <%= task.priority %>
                                        </div>
                                                                          </div>
                                                                          <span class="category-name" style=" padding: 4px 12px; font-size: 14px; border-radius: 12px; color: #f2f2f2; background-color: #0077b6">
                                                                              <%= category_name %>
                                                                          </span>
                                                                      </div>
                                </div>
                  <%
                                             }

                                     }
                                     if (!found3) {
                                 %>
                                          <p style="text-align: center; color: #283618; font-size: 15px;">Không có công việc</p>
                                 <%
                               }
                   %>
            </div>
    </div>
</div>

<div id="taskModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
     background-color: rgba(0,0,0,0.4); z-index: 999; align-items: center; justify-content: center;">
     <div style=" border-radius: 10px; width: 700px; position: relative;">
        <div style="background-color: #f2f2f2; padding: 10px 16px 10px; border-top-left-radius: 12px; border-top-right-radius: 12px;">
            Thông tin công việc
        </div>
        <button onclick="closeTaskModal()" style="position: absolute; top: 8px; right: 8px; background-color: transparent; border: none;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                class="lucide lucide-x-icon lucide-x"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
        </button>
        <form onsubmit="submitUpdateTask(event)" style="background-color: white; padding: 10px 16px 20px; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;">
                    <div style="margin-top: 5px; display: flex; align-items: center; column-gap: 8px;">
                            <div style="flex: 1; font-size: 15px; font-weight: 500;">
                                  <span style="display: block;">Mã công việc:</span>
                                  <input style="background-color: #f2f2f2; margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada"  type="text" id="modal-id" readonly disable="false"/>
                            </div>
                            <div style="flex: 1; font-size: 15px; font-weight: 500;">
                                  <span style="display: block;">Thể loại:</span>
                                  <select id="modal-category" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" >

                                  </select>
                            </div>
                    </div>
                    <div style="margin-top: 15px; font-size: 15px; font-weight: 500; margin-bottom: 0px;">
                        <span style='display: block'>Tên công việc:</span>
                        <input style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada"  type="text" id="modal-title"/>
                    </div>
                    <div style="margin-top: 15px; font-size: 15px; font-weight: 500;">
                        <span style="display: block;">Mô tả công việc:</span>
                        <textarea id="modal-description" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" rows="5"></textarea>
                    </div>
                    <div style="margin-top: 15px; display: flex; align-items: center; column-gap: 8px;">
                        <div style="flex:1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Trạng thái:</span>
                             <select id="modal-status" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" >
                                  <option value="Chưa bắt đầu">Chưa bắt đầu</option>
                                  <option value="Đang thực hiện">Đang thực hiện</option>
                                  <option value="Hoàn thành">Hoàn thành</option>
                             </select>
                        </div>
                        <div style="flex: 1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Mức độ ưu tiên:</span>
                             <select id="modal-priority" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" >
                                  <option value="Thấp">Thấp</option>
                                  <option value="Trung bình">Trung bình</option>
                                  <option value="Cao">Cao</option>
                             </select>
                        </div>
                    </div>

                    <div style="margin-top: 15px; display: flex; align-items: center; column-gap: 8px;">
                        <div style="flex:1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Thời gian bắt đầu:</span>
                             <input style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada" type="datetime-local" id="modal-start-time" />

                        </div>
                        <div style="flex: 1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Thời gian kết thúc:</span>
                             <input style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada" type="datetime-local" id="modal-end-time" />
                        </div>
                    </div>

                    <div style="margin-top: 15px; display: flex; align-items: center; column-gap: 8px;">
                        <div style="flex: 1; font-size: 15px; font-weight: 500;">
                              <span style="display: block;">Ngày tạo:</span>
                              <input disable="false" readonly style="background-color: #f2f2f2; margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada" type="datetime-local" id="modal-created-at" />
                         </div>
                         <div style="flex: 1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Ngày cập nhật:</span>
                             <input disable="false" readonly style="background-color: #f2f2f2; margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada" type="datetime-local" id="modal-updated-at" />
                         </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; column-gap: 10px; margin-top: 15px;">
                        <button type="button" id="delete-task-btn" style="padding: 8px 12px; border-radius:12px; background-color: #db4c40; border: none; color: white; font-size: 15px;">Xóa</button>
                        <button type="submit" id="update-task-btn" style="padding: 8px 12px; border-radius:12px; background-color: #0466c8; border: none; color: white; font-size: 15px;">Cập nhật</button>
                    </div>
        </form>
    </div>
</div>


<div id="taskModal-2" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4); z-index: 999; align-items: center; justify-content: center;">
     <div style=" width: 700px; position: relative;">
        <div style="background-color: #f2f2f2; padding: 10px 16px 10px; border-top-left-radius: 12px; border-top-right-radius: 12px;">
            Thông tin công việc
        </div>

        <button onclick="closeTaskModal2()" style="position: absolute; top: 8px; right: 8px; background-color: transparent; border: none;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                class="lucide lucide-x-icon lucide-x"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
        </button>
        <form onsubmit="submitAddTask(event)" style="background-color: white; padding: 10px 16px 20px; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;">
                    <div style="margin-top: 5px;">

                            <div style=" font-size: 15px; font-weight: 500;">
                                  <span style="display: block;">Thể loại:</span>
                                  <select id="modal-category-2" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" >

                                  </select>
                            </div>
                    </div>
                    <div style="margin-top: 15px; font-size: 15px; font-weight: 500; margin-bottom: 0px;">
                        <span style='display: block'>Tên công việc:</span>
                        <input style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada"  type="text" id="modal-title-2"/>
                    </div>
                    <div style="margin-top: 15px; font-size: 15px; font-weight: 500;">
                        <span style="display: block;">Mô tả công việc:</span>
                        <textarea id="modal-description-2" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" rows="5"></textarea>
                    </div>
                    <div style="margin-top: 15px; display: flex; align-items: center; column-gap: 8px;">
                        <div style="flex:1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Trạng thái:</span>
                             <select id="modal-status-2" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" >
                                  <option value="Chưa bắt đầu">Chưa bắt đầu</option>
                                  <option value="Đang thực hiện">Đang thực hiện</option>
                                  <option value="Hoàn thành">Hoàn thành</option>
                             </select>
                        </div>
                        <div style="flex: 1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Mức độ ưu tiên:</span>
                             <select id="modal-priority-2" style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada; resize: vertical;" >
                                  <option value="Thấp">Thấp</option>
                                  <option value="Trung bình">Trung bình</option>
                                  <option value="Cao">Cao</option>
                             </select>
                        </div>
                    </div>

                    <div style="margin-top: 15px; display: flex; align-items: center; column-gap: 8px;">
                        <div style="flex:1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Thời gian bắt đầu:</span>
                             <input style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada" type="datetime-local" id="modal-start-time-2" />

                        </div>
                        <div style="flex: 1; font-size: 15px; font-weight: 500;">
                             <span style="display: block;">Thời gian kết thúc:</span>
                             <input style="margin-top: 5px; width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #dadada" type="datetime-local" id="modal-end-time-2" />
                        </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; column-gap: 10px; margin-top: 15px;">
                        <button type="submit" id="update-task-btn" style="padding: 8px 12px; border-radius:12px; background-color: #0466c8; border: none; color: white; font-size: 15px;">Thêm công việc</button>
                    </div>
        </form>
</div>
</div>
<div id="confirm-delete-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
    background-color: rgba(0, 0, 0, 0.5); justify-content: center; align-items: center; z-index: 9999;">
    <div style="background: white; padding: 24px; border-radius: 12px; width: 400px; max-width: 90%;">
        <h3 style="margin: 0; font-size: 18px;">Xác nhận xóa công việc</h3>
        <p style="margin-top: 12px;">Bạn có chắc chắn muốn xóa công việc này không?</p>
        <div style="margin-top: 20px; display: flex; justify-content: flex-end; column-gap: 10px;">
            <button onclick="closeDeleteModal()" style="padding: 8px 12px; border-radius: 8px; background: #ccc; border: none; font-size: 14px;">Hủy</button>
            <button onclick="confirmDelete()" style="padding: 8px 12px; border-radius: 8px; background: #db4c40; border: none; color: white; font-size: 14px;">Xóa</button>
        </div>
    </div>
</div>


<div id="modal-popup-category" style="display: none; position: fixed; top: 0; left: 0;  width: 100%;height: 100%; background-color: rgba(0,0,0,0.4); z-index: 999; align-items: center; justify-content: center;">
    <div style="border-radius: 12px; width: 500px; position: relative">
         <div style="background-color: #f2f2f2; padding: 10px 16px 10px; border-top-left-radius: 12px; border-top-right-radius: 12px;">
                    Danh sách thể loại
       </div>

        <button onclick="closeCategoryModal()" style="position: absolute; top: 8px; right: 8px; background-color: transparent; border: none;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                                class="lucide lucide-x-icon lucide-x"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
        </button>

        <div style="padding: 10px 16px 14px; background-color: white;  border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;">
           <table id="category-table" class="custom-table">
               <tbody id="category-container">
                   <!-- Các dòng sẽ được render ở đây bằng JS -->
               </tbody>
           </table>

            <div id='add-category-form' style='display: none; margin-top: 10px; background: white; padding: 16px; border-radius: 12px; width: 100%; box-shadow: 0 4px 12px rgba(0,0,0,0.1); position: relative; border: 1px solid #dadada;'>
                            <button onclick="closeAddCategoryModal()" style="position: absolute; top: 8px; right: 8px; background-color: transparent; border: none;">
                                                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                                            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                                                            class="lucide lucide-x-icon lucide-x"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
                                    </button>
                            <h3 style="margin: 0 0 16px; font-size: 17px;">Thêm thể loại</h3>

                              <form onsubmit="submitAddCategory(event)" style="display: flex; flex-direction: column; row-gap: 12px;">
                                <input
                                  type="text"
                                  id="new-category-name"
                                  placeholder="Nhập tên thể loại"
                                  style="padding: 10px 12px; border-radius: 8px; border: 1px solid #ccc; font-size: 14px;"
                                />

                                <button
                                  onclick="addCategory()"
                                  style="padding: 10px 12px; border-radius: 8px; background: #28a745; color: white; border: none; font-size: 14px; cursor: pointer;"
                                >
                                  Thêm thể loại
                                </button>
                              </form>
           </div>

           <div id='btn-add-category' style="display: flex; justify-content: flex-end;">
             <button  onclick="openAddCategoryModal()"  style="font-size: 14px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); margin-top: 10px; padding: 6px 12px; border-radius: 12px; display: flex; align-items: center; background-color: #0466c8; border: none; color: white; font-size: 14px; cursor:pointer;">
                                           <svg xmlns="http://www.w3.org/2000/svg" width="20"
                                           height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                           stroke-linejoin="round" class="lucide lucide-plus-icon lucide-plus"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                     Thêm
             </button>
           </div>
        </div>
</div>



<div id="confirm-delete-modal-category" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
    background-color: rgba(0, 0, 0, 0.5); justify-content: center; align-items: center; z-index: 9999;">
    <div style="background: white; padding: 24px; border-radius: 12px; width: 400px; max-width: 90%;">
        <h3 style="margin: 0; font-size: 18px;">Xác nhận xóa thể loại</h3>
        <p style="margin-top: 12px;">Bạn có chắc chắn muốn xóa thể loại này không?</p>
        <div style="margin-top: 20px; display: flex; justify-content: flex-end; column-gap: 10px;">
            <button onclick="closeDeleteModalCategory()" style="padding: 8px 12px; border-radius: 8px; background: #ccc; border: none; font-size: 14px;">Hủy</button>
            <button onclick="confirmDeleteCategory()" style="padding: 8px 12px; border-radius: 8px; background: #db4c40; border: none; color: white; font-size: 14px;">Xóa</button>
        </div>
    </div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/toastify.js"></script>
 <script>
     const contextPath = "<%= request.getContextPath() %>"
     console.log(contextPath)

    if (typeof encodeURIComponent !== 'function') {
        console.error('encodeURIComponent is not a function. Restoring it.');
        window.encodeURIComponent = function(str) {
            if (typeof str !== 'string') str = String(str);
            return encodeURI(str).replace(/[!'()*]/g, function(c) {
                return '%' + c.charCodeAt(0).toString(16).toUpperCase();
            });
        };
    }

    console.log('encodeURIComponent type:', typeof encodeURIComponent);


    function getQueryParam(param) {
        const urlParams = new URLSearchParams(window.location.search);
        console.log(urlParams);
        return urlParams.get(param) || "";
    }

     document.addEventListener("DOMContentLoaded", function () {
       let checkClear = false;
       let selectedCategoryIds = []; // danh sách thể loại task hiện tại
       let currentSort = ""; // kiểu sắp xếp hiện tại
       let searchQuery = getQueryParam("searchQuery");

       console.log("Seach query",searchQuery);

       const sortBtn = document.getElementById("btn-sort");
       const filterBtn = document.getElementById("btn-filter");
       const clearBtn = document.getElementById("btn-clear");

       // Cập nhật input tìm kiếm với searchQuery từ URL
       document.getElementById("searchInput").value = searchQuery;

       // Kiểm tra trạng thái ban đầu của nút clear
       checkClear = searchQuery !== "" || selectedCategoryIds.length > 0 || currentSort !== "";
       clearBtn.style.display = checkClear ? "flex" : "none";

       // Check for editTaskId in URL and open modal if present
       const editTaskId = getQueryParam("editTaskId");
       console.log(editTaskId);
       if (editTaskId) {
           openTaskModalForEdit(editTaskId);
           // Hide notification dropdown (assumed ID: notificationModal)
           const notificationModal = document.getElementById("notificationModal");
           if (notificationModal) {
               notificationModal.style.display = "none";
           }
       }

       fetchAndRenderTasks();

       // Xử lý nút lọc
       filterBtn.addEventListener("click", function () {
           const modalFilter = document.getElementById("modal-filter");
           const currentDisplay = window.getComputedStyle(modalFilter).display;
         if (currentDisplay === "none") {
               modalFilter.style.display = "block";
               fetch(`\${contextPath}/GetAllCategories`)
             .then((res) => res.json())
             .then((categories) => {
                       const container = document.getElementById("modal-category-filter");
                       container.innerHTML = "";
               categories.forEach((category) => {
                           const wrapper = document.createElement("div");
                           wrapper.className = "wrapper";
                           const checkbox = document.createElement("input");
                           checkbox.value = category.category_id;
                           checkbox.type = "checkbox";
                           checkbox.id = `cat-${category.category_id}`;
                           checkbox.name = "category-filter";
                           checkbox.style.transform = "scale(1)";
                           checkbox.style.marginRight = "8px";
                           const label = document.createElement("label");
                           label.setAttribute("for", checkbox.id);
                           label.innerText = category.name;
                           label.style.fontSize = "14px";
                           wrapper.appendChild(checkbox);
                           wrapper.appendChild(label);
                           container.appendChild(wrapper);
                 if (selectedCategoryIds.includes(category.category_id)) {
                               checkbox.checked = true;
                 }
                       });
                       const applyBtn = document.getElementById("btn-apply");
               applyBtn.addEventListener("click", function () {
                           const checkedBoxes = document.querySelectorAll("input[name='category-filter']:checked");
                           selectedCategoryIds = Array.from(checkedBoxes).map((cb) => cb.value);
                           modalFilter.style.display = "none";
                           checkClear = searchQuery !== "" || selectedCategoryIds.length > 0 || currentSort !== "";
                           clearBtn.style.display = checkClear ? "flex" : "none";
                           fetchAndRenderTasks();
                       });
                   });
         } else {
               modalFilter.style.display = "none";
         }
       });

       // Xử lý sắp xếp
       sortBtn.addEventListener("change", function () {
           currentSort = this.value;
           checkClear = searchQuery !== "" || selectedCategoryIds.length > 0 || currentSort !== "";
           clearBtn.style.display = checkClear ? "flex" : "none";
           fetchAndRenderTasks();
       });

       // Xử lý nút xóa lọc
       clearBtn.addEventListener("click", function () {
           selectedCategoryIds = [];
           currentSort = "";
           searchQuery = "";
           document.getElementById("searchInput").value = "";
           sortBtn.value = "";
           checkClear = false;
           clearBtn.style.display = "none";
           // Xóa tham số searchQuery khỏi URL
           window.history.replaceState({}, document.title, `\${contextPath}/MyTask`);
           fetchAndRenderTasks();
       });

       function fetchAndRenderTasks() {
         const fetchUrl = "<%= request.getContextPath() %>/GetTasksFilterAndSort"
          let body = {
              user_id: "<%= userId %>",
              categoryIds: selectedCategoryIds,
              sortBy: currentSort
          };
          if (searchQuery) {
              fetchUrl = `/ToDoList/searchTasks`;
              body = { searchQuery: searchQuery };
          }

          console.log(body);
          console.log(fetchUrl);

         fetch(fetchUrl, {
           method: "POST",
           headers: {
             "Content-Type": "application/json"
           },
           body: JSON.stringify(body)
         })
           .then((res) => res.json())
           .then((data) => {
             document.querySelectorAll(".task-card").forEach((taskCard) => taskCard.remove())

             const uniqueData = Array.from(new Set(data.map((item) => item.task?.task_id || "")))
               .map((taskId) => data.find((item) => item.task?.task_id === taskId))
               .filter((item) => item?.task)

             const taskGroups = {
               "chua bat dau": [],
               "dang thuc hien": [],
               "hoan thanh": []
             }

             const statusMap = {
               "Chưa bắt đầu": "chua bat dau",
               "Đang thực hiện": "dang thuc hien",
               "Hoàn thành": "hoan thanh"
             }

             uniqueData.forEach((item) => {
               const task = item.task
               const category_name = item.category_name
               const normalizedStatus = statusMap[task.status] || "chua bat dau"
               taskGroups[normalizedStatus].push({ task, category_name })
             })

             const containerMap = {
               "chua bat dau": "chua-bat-dau-tasks",
               "dang thuc hien": "dang-thuc-hien-tasks",
               "hoan thanh": "hoan-thanh-tasks"
             }

             Object.keys(taskGroups).forEach((status) => {
               const containerId = containerMap[status]
               const taskListContainer = document.getElementById(containerId)

               if (taskGroups[status].length === 0) {
                 taskListContainer.innerHTML = '<p style="text-align: center; color: #283618; font-size: 15px;">Không có công việc</p>'
               } else {
                 let taskHtml = ""
                 taskGroups[status].forEach(({ task, category_name }) => {
                   taskHtml += createTaskCard(task, category_name)
                 })
                 taskListContainer.innerHTML = taskHtml
               }
             })
           })
           .catch((error) => {
                   console.error("Lỗi trong quá trình fetch:", error);
                   Toastify({
                       text: "❌ Lỗi khi tải công việc!",
                       duration: 2000,
                       gravity: "top",
                       position: "right",
                       close: true,
                       style: {
                           background: "#bf4342",
                           color: "#fff",
                           borderRadius: "8px",
                           padding: "14px 20px",
                           boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                       },
                       stopOnFocus: true
                   }).showToast();
               });
       }
       function convertTime(timeStr) {
            if (!timeStr) return 'Không xác định';
               console.log("time", timeStr);
            const date = new Date(timeStr);

            // Kiểm tra date có hợp lệ không
            if (isNaN(date.getTime())) return 'Không xác định';

            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0'); // tháng bắt đầu từ 0
            const year = date.getFullYear();
            const hour = String(date.getHours()).padStart(2, '0');
            const minute = String(date.getMinutes()).padStart(2, '0');

            return hour + ":" + minute + " " + day + "-" + month + "-" + year;
          }

        function createTaskCard(task, category_name) {
           const formattedStartTime = convertTime(task.start_time);
           let priorityColor = '#dadada';
               if (task.priority === 'Cao') {
                   priorityColor = '#db4c40';
               } else if (task.priority === 'Trung bình') {
                   priorityColor = '#e9c46a';
               } else if (task.priority === 'Thấp') {
                   priorityColor = '#10b981';
               }
            return `
                         <div class="task-card" data-task-id="\${task.task_id || ''}" onclick="openTaskModal(this)">
                             <h2 style="font-size: 18px; font-weight: 500; line-height: 12px;">
                                 \${task.title || 'No title'}
                             </h2>
                             <p style="font-size: 16px; color: #535353">
                                 \${task.description}
                             </p>
                             <div style="font-size: 15px; color: #535353; display: flex; align-items: center; column-gap: 4px;">
                                 <span>Thời gian bắt đầu:</span>
                                 <span style="font-weight: 500; display: block">
                                     \${formattedStartTime}
                                 </span>
                             </div>
                             <div style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                 <div style="padding: 4px 0; font-size: 14px; border-radius: 8px; color: black; display: flex; align-items: center; column-gap: 6px">
                                     <strong>Mức ưu tiên:</strong>
                                      <div style="padding: 4px 8px; background-color: \${priorityColor}; color: black; border-radius: 12px; font-weight: 500; color: white">
                                              \${task.priority || 'N/A'}
                                      </div>
                                 </div>
                                 <span class="category-name" style="padding: 4px 12px; font-size: 14px; border-radius: 12px; color: #f2f2f2; background-color: #0077b6">
                                     \${category_name || 'No category'}
                                 </span>
                             </div>
                         </div>
                     `
          }

     })
     function openTaskModalForEdit(taskId) {
     console.log(taskId);
         fetch(`\${contextPath}/GetTaskById?task_id=\${encodeURIComponent(taskId)}`, {
             method: 'GET',
             credentials: 'same-origin'
         })
             .then(response => {
                 if (!response.ok) {
                     if (response.status === 401) {
                         Toastify({
                             text: "❌ Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại!",
                             duration: 2000,
                             gravity: "top",
                             position: "right",
                             close: true,
                             style: {
                                 background: "#bf4342",
                                 color: "#fff",
                                 borderRadius: "8px",
                                 padding: "14px 20px",
                                 boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                             },
                             stopOnFocus: true
                         }).showToast();
                         setTimeout(() => {
                             window.location.href = `\${contextPath}/Login`;
                         }, 2000);
                         return null;
                     }
                     throw new Error(`HTTP error! Status: ${response.status}`);
                 }
                 return response.json();
             })
             .then(data => {
                 if (!data) return; // Early return if redirected
                 if (data && data.task) {
                     const task = data.task;
                     const categoryName = data.category_name || '';
                     console.log(task);

                     // Populate modal fields
                     document.getElementById("modal-id").value = task.task_id || '';
                     document.getElementById("modal-title").value = task.title || '';
                     document.getElementById("modal-description").value = task.description || '';
                     document.getElementById("modal-status").value = task.status || 'Chưa bắt đầu';
                     document.getElementById("modal-priority").value = task.priority || 'Thấp';

                     // Format dates to YYYY-MM-DDThh:mm for datetime-local
                     const startTime = task.start_time ? new Date(task.start_time) : null;
                     const endTime = task.end_time ? new Date(task.end_time) : null;
                     const createdAt = task.created_at ? new Date(task.created_at) : null;
                     const updatedAt = task.updated_at ? new Date(task.updated_at) : null;

                     if (startTime && !isNaN(startTime)) {
                         document.getElementById("modal-start-time").value = toLocalDateTimeString(startTime);
                     } else {
                         document.getElementById("modal-start-time").value = '';
                     }
                     if (endTime && !isNaN(endTime)) {
                         document.getElementById("modal-end-time").value = toLocalDateTimeString(endTime);
                     } else {
                         document.getElementById("modal-end-time").value = '';
                     }
                     if (createdAt && !isNaN(createdAt)) {
                         document.getElementById("modal-created-at").value = toLocalDateTimeString(createdAt);
                     } else {
                         document.getElementById("modal-created-at").value = '';
                     }
                     if (updatedAt && !isNaN(updatedAt)) {
                         document.getElementById("modal-updated-at").value = toLocalDateTimeString(updatedAt);
                     } else {
                         document.getElementById("modal-updated-at").value = '';
                     }

                     // Fetch categories
                     fetch(`\${contextPath}/GetAllCategories`, {
                         method: 'GET',
                         credentials: 'same-origin'
                     })
                         .then(res => {
                             if (!res.ok) {
                                 throw new Error(`HTTP error! Status: ${res.status}`);
                             }
                             return res.json();
                         })
                         .then(categories => {
                             const select = document.getElementById("modal-category");
                             select.innerHTML = "";
                             categories.forEach(category => {
                                 const option = document.createElement("option");
                                 option.value = category.category_id;
                                 option.text = category.name;
                                 if (category.name === categoryName || category.category_id === task.category_id) {
                                     option.selected = true;
                                 }
                                 select.appendChild(option);
                             });
                             // Show modal
                             document.getElementById("taskModal").style.display = "flex";
                             // Clear editTaskId from URL
                             window.history.replaceState({}, document.title, `\${contextPath}/MyTask`);
                         })
                         .catch(error => {
                             console.error('Error fetching categories:', error);
                             Toastify({
                                 text: "❌ Lỗi khi tải danh mục!",
                                 duration: 2000,
                                 gravity: "top",
                                 position: "right",
                                 close: true,
                                 style: {
                                     background: "#bf4342",
                                     color: "#fff",
                                     borderRadius: "8px",
                                     padding: "14px 20px",
                                     boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                                 },
                                 stopOnFocus: true
                             }).showToast();
                         });
                 } else {
                     Toastify({
                         text: "❌ Không tìm thấy công việc!",
                         duration: 2000,
                         gravity: "top",
                         position: "right",
                         close: true,
                         style: {
                             background: "#bf4342",
                             color: "#fff",
                             borderRadius: "8px",
                             padding: "14px 20px",
                             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                         },
                         stopOnFocus: true
                     }).showToast();
                 }
             })
             .catch(error => {
                 console.error('Error fetching task:', error);
                 Toastify({
                     text: "❌ Lỗi khi tải thông tin công việc!",
                     duration: 2000,
                     gravity: "top",
                     position: "right",
                     close: true,
                     style: {
                         background: "#bf4342",
                         color: "#fff",
                         borderRadius: "8px",
                         padding: "14px 20px",
                         boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                     },
                     stopOnFocus: true
                 }).showToast();
             });
     }

     let deleteTaskId = null

     document.getElementById("delete-task-btn").addEventListener("click", function () {
       deleteTaskId = document.getElementById("modal-id").value
       document.getElementById("confirm-delete-modal").style.display = "flex"
     })

     function closeDeleteModal() {
       document.getElementById("confirm-delete-modal").style.display = "none"
       deleteTaskId = null
     }

     function confirmDelete() {
       if (!deleteTaskId) return

       fetch("<%= request.getContextPath() %>/DeleteTask", {
         method: "POST",
         headers: {
           "Content-Type": "application/json"
         },
         body: JSON.stringify({ task_id: deleteTaskId })
       }).then((response) => {
         Toastify({
           text: "✅ Xóa thành công!",
           duration: 2000, // thời gian hiển thị: 3 giây
           gravity: "top", // top or bottom
           position: "right", // left, center or right
           close: true, // có nút đóng (x)
           style: {
             background: "#008000",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true // giữ toast khi người dùng rê chuột vào
         }).showToast()
         closeDeleteModal()
         setTimeout(() => {
           window.location.reload()
         }, 1000)
       })
     }

     function submitUpdateTask(event) {
       event.preventDefault() // Ngăn form tự reload lại trang

       const task_id = document.getElementById("modal-id").value
       const user_id = "<%= userId%>"
       const title = document.getElementById("modal-title").value
       const description = document.getElementById("modal-description").value
       const status = document.getElementById("modal-status").value
       const priority = document.getElementById("modal-priority").value
       const category_id = document.getElementById("modal-category").value
       const start_time = document.getElementById("modal-start-time").value
       const end_time = document.getElementById("modal-end-time").value

       if (!title) {
         Toastify({
           text: "❌ Tên công việc không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }
       if (!description) {
         Toastify({
           text: "❌ Mô tả không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }
       if (!start_time) {
         Toastify({
           text: "❌ Thời gian bắt đầu không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }
       if (!end_time) {
         Toastify({
           text: "❌ Thời gian kết thúc không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }

       const startDate = new Date(start_time)
       const endDate = new Date(end_time)

       if (endDate < startDate) {
         Toastify({
           text: "❌ Thời gian kết thúc không được sớm hơn thời gian bắt đầu!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }

       const taskData = {
         task_id,
         user_id,
         title,
         description,
         status,
         priority,
         category_id,
         start_time,
         end_time,
         created_at: document.getElementById("modal-created-at").value, // Thêm created_at
         updated_at: document.getElementById("modal-updated-at").value // Thêm updated_at
       }

       fetch("<%= request.getContextPath() %>/UpdateTask", {
         method: "POST",
         headers: {
           "Content-Type": "application/json"
         },
         body: JSON.stringify(taskData)
       })
         .then((response) => response.json())
         .then((result) => {
           if (result.success) {
           } else {
             Toastify({
               text: "✅ Cập nhật thành công!",
               duration: 2000, // thời gian hiển thị: 3 giây
               gravity: "top", // top or bottom
               position: "right", // left, center or right
               close: true, // có nút đóng (x)
               style: {
                 background: "#008000",
                 color: "#fff",
                 borderRadius: "8px",
                 padding: "14px 20px",
                 boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
               },
               stopOnFocus: true // giữ toast khi người dùng rê chuột vào
             }).showToast()
             closeTaskModal()
             setTimeout(() => {
               window.location.reload()
             }, 1000)
           }
         })
         .catch((error) => {
           console.error("Lỗi khi gửi request:", error)
         })
     }

     function toLocalDateTimeString(date) {
       const pad = (n) => n.toString().padStart(2, "0")
       return (
         date.getFullYear() +
         "-" +
         pad(date.getMonth() + 1) +
         "-" +
         pad(date.getDate()) +
         "T" +
         pad(date.getHours()) +
         ":" +
         pad(date.getMinutes())
       )
     }

     function openTaskModal(element) {
       const taskId = element.getAttribute("data-task-id");
         console.log(taskId)
         openTaskModalForEdit(taskId);
     }

     function closeTaskModal() {
       document.getElementById("taskModal").style.display = "none"
     }

     function openAddTaskModal() {
      const btnAdd = document.getElementById("btn-add-category")
      btnAdd.style.display = "none";
       // Hiển thị modal bằng cách đặt style display thành 'flex'
       document.getElementById("taskModal-2").style.display = "flex"

       // Gửi yêu cầu fetch để lấy danh sách categories từ server
       fetch(`<%= request.getContextPath() %>/GetAllCategories`)
         .then((res) => res.json())
         .then((categories) => {
           const select = document.getElementById("modal-category-2")
           select.innerHTML = "" // Xóa các option cũ
           categories.forEach((category) => {
             const option = document.createElement("option")
             option.value = category.category_id
             option.text = category.name

             if (category.name === "Công việc") {
               option.selected = true
             }

             select.appendChild(option)
           })
         })
     }

     function closeTaskModal2() {
       document.getElementById("taskModal-2").style.display = "none"
     }

     function submitAddTask(event) {
       event.preventDefault() // Ngăn form tự reload lại trang
       const user_id = "<%= userId%>"
       const title = document.getElementById("modal-title-2").value
       const description = document.getElementById("modal-description-2").value
       const status = document.getElementById("modal-status-2").value
       const priority = document.getElementById("modal-priority-2").value
       const category_id = document.getElementById("modal-category-2").value
       const start_time = document.getElementById("modal-start-time-2").value
       const end_time = document.getElementById("modal-end-time-2").value

       if (!title) {
         Toastify({
           text: "❌ Tên công việc không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }
       if (!description) {
         Toastify({
           text: "❌ Mô tả không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }
       if (!start_time) {
         Toastify({
           text: "❌ Thời gian bắt đầu không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }
       if (!end_time) {
         Toastify({
           text: "❌ Thời gian kết thúc không được để trống!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }

       const startDate = new Date(start_time)
       const endDate = new Date(end_time)

       if (endDate < startDate) {
         Toastify({
           text: "❌ Thời gian kết thúc không được sớm hơn thời gian bắt đầu!",
           duration: 2000,
           gravity: "top",
           position: "right",
           close: true,
           style: {
             background: "#bf4342",
             color: "#fff",
             borderRadius: "8px",
             padding: "14px 20px",
             boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
           },
           stopOnFocus: true
         }).showToast()
         return
       }

       const taskData = {
         user_id,
         title,
         description,
         status,
         priority,
         category_id,
         start_time,
         end_time
       }

       fetch("<%= request.getContextPath() %>/AddTask", {
         method: "POST",
         headers: {
           "Content-Type": "application/json"
         },
         body: JSON.stringify(taskData)
       })
         .then((response) => response.json())
         .then((result) => {
           Toastify({
             text: "✅ Thêm mới thành công!",
             duration: 2000, // thời gian hiển thị: 3 giây
             gravity: "top", // top or bottom
             position: "right", // left, center or right
             close: true, // có nút đóng (x)
             style: {
               background: "#008000",
               color: "#fff",
               borderRadius: "8px",
               padding: "14px 20px",
               boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
             },
             stopOnFocus: true // giữ toast khi người dùng rê chuột vào
           }).showToast()
           closeTaskModal2()
           setTimeout(() => {
             window.location.reload()
           }, 1000)
         })
         .catch((error) => {
           console.error("Lỗi khi gửi request:", error)
         })
     }

     let deleteCategoryId = null
     function openCategoryModal() {
       document.getElementById("modal-popup-category").style.display = "flex"

       fetch(`<%= request.getContextPath() %>/GetAllCategories`)
         .then((res) => res.json())
         .then((categories) => {
           const container = document.getElementById("category-container")
           container.innerHTML = ""

           categories.forEach((category) => {
             const row = document.createElement("tr")
             const cell = document.createElement("td")

             const inputText = document.createElement("input")
             inputText.value = category.name
             inputText.type = "text"
             inputText.id = `category-${category.category_id}`
             inputText.name = "category-table"
             inputText.className = "custom-input"
             inputText.disabled = "false"

             cell.appendChild(inputText)
             row.appendChild(cell)

             // Cột nút chỉnh sửa
             const cellEdit = document.createElement("td")
             cellEdit.className = "action-cell"

             const editButton = document.createElement("button")
             editButton.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pencil-icon lucide-pencil"><path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/></svg>`
             editButton.className = "btn-edit"

             // Tạo nút xác nhận (tick)
             const confirmButton = document.createElement("button")
             confirmButton.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-list-check-icon lucide-list-check"><path d="M11 18H3"/><path d="m15 18 2 2 4-4"/><path d="M16 12H3"/><path d="M16 6H3"/></svg>`
             confirmButton.className = "btn-edit"
             confirmButton.style.display = "none" // ẩn ban đầu

             editButton.onclick = () => {
               inputText.disabled = false
               inputText.focus()
               editButton.style.display = "none"
               confirmButton.style.display = "flex"
               confirmButton.style.backgroundColor = "#4361ee"
             }

             confirmButton.onclick = () => {
               const newName = inputText.value.trim()
               if (!newName) {
                 Toastify({
                   text: "❌ Thể loại không được để trống!",
                   duration: 2000,
                   gravity: "top",
                   position: "right",
                   close: true,
                   style: {
                     background: "#bf4342",
                     color: "#fff",
                     borderRadius: "8px",
                     padding: "14px 20px",
                     boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                   },
                   stopOnFocus: true
                 }).showToast()
                 inputText.focus()
                 return
               }

               if (newName === category.name.trim()) {
                       inputText.disabled = true;
                       confirmButton.style.display = "none";
                       editButton.style.display = "inline-block";
                       Toastify({
                           text: "ℹ️ Tên thể loại không thay đổi!",
                           duration: 2000,
                           gravity: "top",
                           position: "right",
                           close: true,
                           style: {
                               background: "#4361ee",
                               color: "#fff",
                               borderRadius: "8px",
                               padding: "14px 20px",
                               boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                           },
                           stopOnFocus: true
                       }).showToast();
                       return;
                   }

               // Kiểm tra tên danh mục tồn tại hay không
               fetch(
                 "<%= request.getContextPath() %>/checkCategoryName?name=" + encodeURIComponent(newName) + "&userId=" + "<%= userId%>"
               )
                 .then((res) => res.json())
                 .then((data) => {
                   if (data.exists) {
                     Toastify({
                       text: "❌ Thể loại đã tồn tại, vui lòng chọn tên khác!",
                       duration: 2000,
                       gravity: "top",
                       position: "right",
                       close: true,
                       style: {
                         background: "#bf4342",
                         color: "#fff",
                         borderRadius: "8px",
                         padding: "14px 20px",
                         boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                       },
                       stopOnFocus: true
                     }).showToast()
                     inputText.focus()
                     return
                   }

                   // Cập nhật danh mục
                   const updatedCategory = {
                     category_id: category.category_id,
                     name: newName,
                     user_id: "<%= userId%>"
                   }

                   return fetch("<%= request.getContextPath() %>/UpdateCategory", {
                     method: "POST",
                     headers: { "Content-Type": "application/json" },
                     body: JSON.stringify(updatedCategory)
                   })
                 })
                 .then(async (response) => {
                   if (!response.ok) {
                     throw new Error("Lỗi cập nhật dữ liệu!")
                   }
                   const resJson = await response.json()
                   Toastify({
                     text: "✅ Cập nhật thành công!",
                     duration: 2000, // thời gian hiển thị: 3 giây
                     gravity: "top", // top or bottom
                     position: "right", // left, center or right
                     close: true, // có nút đóng (x)
                     style: {
                       background: "#008000",
                       color: "#fff",
                       borderRadius: "8px",
                       padding: "14px 20px",
                       boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
                     },
                     stopOnFocus: true // giữ toast khi người dùng rê chuột vào
                   }).showToast()

                   inputText.disabled = true
                   confirmButton.style.display = "none"
                   editButton.style.display = "inline-block"
                 })
             }

             cellEdit.appendChild(editButton)
             cellEdit.appendChild(confirmButton)
             row.appendChild(cellEdit)

             // Ô chứa nút xóa
             const cellDelete = document.createElement("td")
             cellDelete.className = "action-cell"
             const deleteButton = document.createElement("button")
             deleteButton.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash-icon lucide-trash"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>`
             deleteButton.className = "btn-delete"
             const modalDelete = document.getElementById("confirm-delete-modal-category")

             deleteButton.onclick = () => {
               modalDelete.style.display = "flex"
               deleteCategoryId = category.category_id
             }

             cellDelete.appendChild(deleteButton)

             row.appendChild(cellDelete)
             container.appendChild(row)
           })
         })
     }

     function closeCategoryModal() {
       document.getElementById("modal-popup-category").style.display = "none"
       window.location.reload()
     }

     function closeDeleteModalCategory() {
       document.getElementById("confirm-delete-modal-category").style.display = "none"
     }

     function confirmDeleteCategory() {
       // Gọi API kiểm tra xem category có đang được task sử dụng không
       fetch(
         "<%= request.getContextPath() %>/checkCategoryInTask?categoryId=" +
           encodeURIComponent(deleteCategoryId) +
           "&userId=" + "<%= userId%>"
       )
         .then((res) => res.json())
         .then((data) => {
           if (data.exists) {
             Toastify({
               text: "❌ Không thể xóa vì thể loại đang được sử dụng trong task!",
               duration: 2000,
               gravity: "top",
               position: "right",
               close: true,
               style: {
                 background: "#bf4342",
                 color: "#fff",
                 borderRadius: "8px",
                 padding: "14px 20px",
                 boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
               },
               stopOnFocus: true
             }).showToast()
             document.getElementById("confirm-delete-modal-category").style.display = "none"
             return // Dừng tại đây, không gọi API xóa
           }

           return fetch("<%= request.getContextPath() %>/DeleteCategory", {
             method: "POST",
             headers: {
               "Content-Type": "application/x-www-form-urlencoded"
             },
             body: "category_id=" + encodeURIComponent(deleteCategoryId)
           })
         })
         .then((response) => {
           if (!response) return // Trường hợp bị chặn do category đang dùng
           return response.json()
         })
         .then((data) => {
           if (data && data.success) {
             Toastify({
               text: "✅ Xóa thể loại thành công!",
               duration: 2000, // thời gian hiển thị: 3 giây
               gravity: "top", // top or bottom
               position: "right", // left, center or right
               close: true, // có nút đóng (x)
               style: {
                 background: "#008000",
                 color: "#fff",
                 borderRadius: "8px",
                 padding: "14px 20px",
                 boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
               },
               stopOnFocus: true // giữ toast khi người dùng rê chuột vào
             }).showToast()
             openCategoryModal()
             document.getElementById("confirm-delete-modal-category").style.display = "none"
             // Xóa row khỏi UI nếu cần
             row.remove?.()
           } else if (data) {
             alert("Lỗi khi xóa thể loại: " + data.message)
           }
         })
     }

     function openAddCategoryModal() {
       document.getElementById("add-category-form").style.display = "block"
       const btnAdd = document.getElementById("btn-add-category")
       btnAdd.style.display = "none";
     }

     function closeAddCategoryModal() {
       document.getElementById("add-category-form").style.display = "none"
       const btnAdd = document.getElementById("btn-add-category")
       btnAdd.style.display = "flex";
     }

     function submitAddCategory(event) {
       const btnAdd = document.getElementById("btn-add-category")
       btnAdd.style.display = "flex";
       event.preventDefault() // Ngăn form tự reload lại trang
       const user_id = "<%= userId%>"
       let name = document.getElementById("new-category-name").value

       fetch("<%= request.getContextPath() %>/checkCategoryName?name=" + encodeURIComponent(name) + "&userId=" + user_id)
         .then((res) => res.json())
         .then((data) => {
           if (data.exists) {
             Toastify({
               text: "❌ Thể loại đã tồn tại, vui lòng chọn tên khác!",
               duration: 2000,
               gravity: "top",
               position: "right",
               close: true,
               style: {
                 background: "#bf4342",
                 color: "#fff",
                 borderRadius: "8px",
                 padding: "14px 20px",
                 boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
               },
               stopOnFocus: true
             }).showToast()
             inputText.focus()
             return
           }

           // Cập nhật danh mục
           const categoryData = {
             user_id,
             name
           }

           return fetch("<%= request.getContextPath() %>/AddCategory", {
             method: "POST",
             headers: {
               "Content-Type": "application/json"
             },
             body: JSON.stringify(categoryData)
           })
         })
         .then(async (response) => {
           if (!response.ok) {
             throw new Error("Lỗi cập nhật dữ liệu!")
           }
           const resJson = await response.json()
           Toastify({
             text: "✅ Thêm mới thành công!",
             duration: 2000, // thời gian hiển thị: 3 giây
             gravity: "top", // top or bottom
             position: "right", // left, center or right
             close: true, // có nút đóng (x)
             style: {
               background: "#008000",
               color: "#fff",
               borderRadius: "8px",
               padding: "14px 20px",
               boxShadow: "0 3px 10px rgba(0,0,0,0.2)"
             },
             stopOnFocus: true // giữ toast khi người dùng rê chuột vào
           }).showToast()
           openCategoryModal()
           name = ""
           document.getElementById("add-category-form").style.display = "none"
         })
     }
   </script>


