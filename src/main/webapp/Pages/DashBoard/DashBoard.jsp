<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.TaskWithCategory" %>
<%@ page import="com.example.model.TaskStatistics" %>
<%@ page import="com.example.model.Task" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    TaskStatistics stats = (TaskStatistics) request.getAttribute("taskStats");
    List<TaskWithCategory> taskWithCategoryList = (List<TaskWithCategory>) request.getAttribute("taskWithCategoryListToday");
    List<TaskWithCategory> taskWithCategoryListCompleted = (List<TaskWithCategory>) request.getAttribute("taskWithCategoryListCompleted");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Hiển thị giá trị -->
<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; padding: 8px 12px;">

    <!-- Cột 1: Công việc -->
    <div>
      <div style="width: 100%; border: 1px solid #dadada; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); border-radius: 12px; padding: 16px 20px;">
        <div style="display: flex; align-items: center; column-gap: 8px;">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#8d99ae" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-calendar-clock-icon lucide-calendar-clock">
            <path d="M21 7.5V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h3.5"/>
            <path d="M16 2v4"/>
            <path d="M8 2v4"/>
            <path d="M3 10h5"/>
            <path d="M17.5 17.5 16 16.3V14"/>
            <circle cx="16" cy="16" r="6"/>
          </svg>
          <h2 style="color: red; font-size: 15px; font-weight: 500;">Công việc</h2>
        </div>

        <div style="margin-top: 10px; display: flex; align-items: center; gap: 5px;">
          <span id="currentDate" style="font-size: 14px; color: black"></span>
          <span style="margin-left: 10px; width: 6px; height: 6px; background-color: #8d99ae; border-radius: 99px;"></span>
          <span style="font-size: 14px; color: #8d99ae">Hôm nay</span>
        </div>

        <div style=" margin-top: 10px; border-radius: 10px;">
                    <%
                      if (taskWithCategoryList == null || taskWithCategoryList.isEmpty()) {
                    %>
                      <p style="text-align: center; color: #283618; font-size: 15px; padding: 10px 0; display: block; color: red;">Không có công việc nào trong hôm nay</p>
                    <%
                      } else {
                        for (TaskWithCategory taskWithCategory : taskWithCategoryList) {
                          if (taskWithCategory != null && taskWithCategory.task != null) {
                            Task task = taskWithCategory.task;
                            String category_name = taskWithCategory.category_name != null ? taskWithCategory.category_name : "N/A";
                            String priority = task.priority != null ? task.priority : "N/A";
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
                    %>
                      <div class="task-card" data-task-id="<%= task.task_id != null ? task.task_id : "" %>" onclick="navigateTask('<%= task.task_id %>')">
                        <h2 style="font-size: 18px; font-weight: 500; line-height: 12px;">
                          <%= task.title != null ? task.title : "N/A" %>
                        </h2>
                        <p style="font-size: 16px; color: #535353">
                          <%= task.description != null ? task.description : "N/A" %>
                        </p>
                        <div style="font-size: 15px; color: #535353; display: flex; align-items: center; column-gap: 4px;">
                          <span>Thời gian bắt đầu:</span>
                          <span style="font-weight: 500;">
                            <%= task.start_time != null ? task.start_time.format(formatter) : "N/A" %>
                          </span>
                        </div>
                        <div style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                          <div style="padding: 4px 0; font-size: 14px; border-radius: 8px; color: black; display: flex; align-items: center; column-gap: 6px">
                            <strong>Mức ưu tiên:</strong>
                            <div style="padding: 4px 8px; background-color: <%= priorityColor %>; color: white; border-radius: 12px; font-weight: 500;">
                              <%= task.priority != null ? task.priority : "N/A" %>
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
                    %>
                  </div>
      </div>
    </div>

    <!-- Cột 2: Trạng thái công việc -->
    <div>
      <div style="width: 100%; border: 1px solid #dadada; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.2); border-radius: 12px; padding: 0px 14px 10px;">
        <div style="display: flex; align-items: center; column-gap: 8px;">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chart-line-icon lucide-chart-line"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="m19 9-5 5-4-4-3 3"/></svg>
          <h2 style="color: red; font-size: 15px; font-weight: 500;">Trạng thái công việc</h2>
        </div>

        <div style="margin-top: 20px; display: flex; justify-content: center; gap: 40px;">
          <div style="text-align: center; position: relative" id="notStarted">
            <canvas id="notStartedChart" width="130" height="130"></canvas>
            <p style="color: red;">● Chưa bắt đầu</p>
          </div>
          <div style="text-align: center; position: relative" id="inProgress">
            <canvas id="inProgressChart" width="130" height="130"></canvas>
            <p style="color: blue;">● Đang thực hiện</p>
          </div>
          <div style="text-align: center; position: relative" id="completed">
            <canvas id="completedChart" width="130" height="130"></canvas>
            <p style="color: green;">● Hoàn thành</p>
          </div>
        </div>
      </div>

      <div style="margin-top: 20px; width: 100%; border: 1px solid #dadada; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.2); border-radius: 12px; padding: 16px 20px;">
              <div style="display: flex; align-items: center; column-gap: 8px;">
                  <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="green" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-circle-check-big-icon lucide-circle-check-big"><path d="M21.801 10A10 10 0 1 1 17 3.335"/><path d="m9 11 3 3L22 4"/></svg>
                <h2 style="color: red; font-size: 15px; font-weight: 500;">Công việc đã hoàn thành</h2>
              </div>

              <div style=" margin-top: 10px; border-radius: 10px; ">
                          <%
                            if (taskWithCategoryListCompleted == null || taskWithCategoryListCompleted.isEmpty()) {
                          %>
                            <p style="text-align: center; color: #283618; font-size: 15px; padding: 10px 0; color: red;">Không có công việc nào</p>
                          <%
                            } else {
                              for (TaskWithCategory taskWithCategory : taskWithCategoryListCompleted) {
                                if (taskWithCategory != null && taskWithCategory.task != null) {
                                  Task task = taskWithCategory.task;
                                  String category_name = taskWithCategory.category_name != null ? taskWithCategory.category_name : "N/A";
                                  String priority = task.priority != null ? task.priority : "N/A";
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
                          %>
                            <div class="task-card" data-task-id="<%= task.task_id != null ? task.task_id : "" %>" onclick="navigateTask('<%= task.task_id %>')">
                              <h2 style="font-size: 18px; font-weight: 500; line-height: 12px;">
                                <%= task.title != null ? task.title : "N/A" %>
                              </h2>
                              <p style="font-size: 16px; color: #535353">
                                <%= task.description != null ? task.description : "N/A" %>
                              </p>
                              <div style="font-size: 15px; color: #535353; display: flex; align-items: center; column-gap: 4px;">
                                <span>Thời gian bắt đầu:</span>
                                <span style="font-weight: 500;">
                                  <%= task.start_time != null ? task.start_time.format(formatter) : "N/A" %>
                                </span>
                              </div>
                              <div style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                <div style="padding: 4px 0; font-size: 14px; border-radius: 8px; color: black; display: flex; align-items: center; column-gap: 6px">
                                  <strong>Mức ưu tiên:</strong>
                                  <div style="padding: 4px 8px; background-color: <%= priorityColor %>; color: white; border-radius: 12px; font-weight: 500;">
                                    <%= task.priority != null ? task.priority : "N/A" %>
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
                          %>
                        </div>
            </div>
    </div>

  </div>

<script>
    const contextPath = '<%= request.getContextPath() %>';
    function navigateTask(taskId) {
        window.location.href = contextPath + '/MyTask?editTaskId=' + encodeURIComponent(taskId);
    }

    const completed = <%= stats.getCompletedPercent() %>;
    const inProgress = <%= stats.getInProgressPercent() %>;
    const notStarted = <%= stats.getNotStartedPercent() %>;

    function renderPercent(value, element) {
        const inProgress = document.getElementById(element);
        const percent = value;
        const div = document.createElement("div");
        div.innerText = percent + "%";
        div.style.marginTop = "5px";
        div.style.fontSize = "18px";
        div.style.fontWeight = "bold";
        div.className = "percent"
        inProgress.appendChild(div);
    }
    renderPercent(<%= stats.getInProgressPercent() %>, "inProgress")
    renderPercent(<%= stats.getCompletedPercent() %>, "completed")
    renderPercent(<%= stats.getNotStartedPercent() %>, "notStarted")

    function renderChart(ctxId, value, color) {
        new Chart(document.getElementById(ctxId), {
            type: 'doughnut',
            data: {
                datasets: [{
                    data: [value, 100 - value],
                    backgroundColor: [color, '#e0e0e0'],
                    borderWidth: 0,
                }]
            },
            options: {
                cutout: '70%',
                plugins: {
                    tooltip: { enabled: false },
                    legend: { display: false },
                    beforeDraw: (chart) => {
                        const { width } = chart;
                        const { height } = chart;
                        const ctx = chart.ctx;
                        ctx.restore();
                        const fontSize = (height / 4).toFixed(2);
                        ctx.font = fontSize + "px sans-serif";
                        ctx.textBaseline = "middle";
                        const text = value + "%";
                        const textX = Math.round((width - ctx.measureText(text).width) / 2);
                        const textY = height / 2;
                        ctx.fillText(text, textX, textY);
                        ctx.save();
                    }
                }
            }
        });
    }

    renderChart('completedChart', completed, 'green');
    renderChart('inProgressChart', inProgress, 'blue');
    renderChart('notStartedChart', notStarted, 'red');

    const now = new Date();
    const day = now.getDate().toString().padStart(2, '0');
    const month = (now.getMonth() + 1).toString().padStart(2, '0'); // Tháng bắt đầu từ 0
    const year = now.getFullYear();
    const currentDate = day + "/" + month + "/" + year;
    document.getElementById("currentDate").textContent = currentDate;
</script>