<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Task" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
%>

<div style="padding: 12px 8px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;">
    <div style="grid-column: span 1;">
        <div style=" display: flex; align-items: center;">
            <div style="height: 10px; width: 10px; border-radius: 99px; background-color: #17A2B8"></div>
            <span style="margin-left: 8px; font-weight: 500;">Chưa bắt đầu</span>
        </div>
        <div class="task-card" style="margin-top: 10px; padding: 12px; border-radius: 10px; background-color: #C4D0EB">
              <%
                       for (Task task : tasks) {
                           if ("Chưa bắt đầu".equals(task.status)) {
              %>
                              <div class="task-card"  data-task-id="<%= task.task_id %>" onclick="openTaskModal(this)">
                                <h2 style="font-size: 17px; font-weight: 500; line-height: 12px;">
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
                            </div>
              <%
                         }
                  }
              %>
        </div>
    </div>
    <div style="grid-column: span 1;">
            <div style=" display: flex; align-items: center;">
                <div style="height: 10px; width: 10px; border-radius: 99px; background-color: #ffc107"></div>
                <span style="margin-left: 8px; font-weight: 500;">Đang thực hiện</span>
            </div>
            <div style="margin-top: 10px; padding: 12px; border-radius: 10px; background-color: #C4D0EB">
                  <%
                           for (Task task : tasks) {
                               if ("Đang thực hiện".equals(task.status)) {
                  %>
                                <div class="task-card"  data-task-id="<%= task.task_id %>" onclick="openTaskModal(this)">
                                    <h2 style="font-size: 17px; font-weight: 500; line-height: 12px;">
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
                                </div>
                  <%
                             }
                      }
                  %>
            </div>

        </div>
    <div style="grid-column: span 1;">
            <div style=" display: flex; align-items: center;">
                <div style="height: 10px; width: 10px; border-radius: 99px; background-color: #8bc34a"></div>
                <span style="margin-left: 8px; font-weight: 500;">Hoàn thành</span>
            </div>
            <div  style="margin-top: 10px; padding: 12px; border-radius: 10px; background-color: #C4D0EB">
                  <%
                           for (Task task : tasks) {
                               if ("Hoàn thành".equals(task.status)) {
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
                                      /div>
                                </div>
                  <%
                             }
                      }
                  %>
            </div>
        </div>
</div>

<!-- Modal -->
<div id="taskModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
     background-color: rgba(0,0,0,0.4); z-index: 999; align-items: center; justify-content: center;">
    <div style="background: white; padding: 20px; border-radius: 10px; width: 500px; position: relative;">
        <button onclick="closeTaskModal()" style="position: absolute; top: 10px; right: 15px;">✖</button>
        <h2 id="modal-title"></h2>
        <p id="modal-description"></p>
        <p><strong>Trạng thái:</strong> <span id="modal-status"></span></p>
        <p><strong>Thời gian bắt đầu:</strong> <span id="modal-start-time"></span></p>
    </div>
</div>

<script>
    function openTaskModal(element) {
        const taskId = element.getAttribute("data-task-id");

        fetch(`<%= request.getContextPath() %>/GetTaskById?task_id=` + taskId)
            .then(response => response.json())
            .then(data => {
                if (data) {
                    document.getElementById("modal-title").innerText = data.title;
                    document.getElementById("modal-description").innerText = data.description;
                    document.getElementById("modal-status").innerText = data.status;
                    document.getElementById("modal-start-time").innerText = data.start_time || "N/A";

                    document.getElementById("taskModal").style.display = "flex";
                }
            });
    }

    function closeTaskModal() {
        document.getElementById("taskModal").style.display = "none";
    }
</script>
