<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/toastify.css" />
<html>
<head>
    <title>Lịch Công Việc</title>
    <!-- FullCalendar CSS và JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>
    <!-- Flatpickr CSS và JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Google Fonts (Roboto) -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap">
    <style>
        html, body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', Arial, sans-serif;
            height: 100%;
            overflow: auto;
        }
        #calendar-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
            width: 100%;
            padding: 15px;
            box-sizing: border-box;
            overflow: auto;
        }
        #calendar {
            flex-grow: 1;
            width: 100%;
            max-width: 100%;
            height: 100%;
            overflow: visible;
        }
        .fc .fc-toolbar {
            flex-wrap: wrap;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .fc .fc-toolbar-title {
            cursor: pointer;
            padding: 8px 12px;
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            background: #ffffff;
            font-weight: 500;
        }
        .fc .fc-button {
            background-color: #007bff;
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .fc .fc-button:hover {
            background-color: #0056b3;
        }
        .flatpickr-calendar {
            font-family: 'Roboto', Arial, sans-serif;
            z-index: 9999;
        }
        .fc .fc-daygrid-month-view .fc-daygrid-body {
            display: grid !important;
            grid-template-columns: repeat(7, 1fr);
            grid-template-rows: repeat(6, 1fr);
        }
        .fc .fc-timegrid-slot {
            height: 40px;
        }
        .fc .fc-timegrid-event {
            min-width: 50px;
            font-size: 0.9em;
            padding: 4px 8px;
            white-space: normal;
            overflow: hidden;
            text-overflow: ellipsis;
            border-radius: 4px;
        }
        .no-tasks-message {
            text-align: center;
            color: #555;
            font-size: 1.2em;
            margin-top: 20px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .no-tasks-message a {
            color: #007bff;
            text-decoration: none;
        }
        .no-tasks-message a:hover {
            text-decoration: underline;
        }
        @media (max-width: 768px) {
            #calendar-container {
                padding: 8px;
            }
            .fc .fc-toolbar-title {
                font-size: 16px;
            }
            .fc .fc-button {
                padding: 6px 10px;
                font-size: 14px;
            }
            .fc .fc-timegrid-slot {
                height: 30px;
            }
            .fc .fc-timegrid-event {
                font-size: 0.8em;
                min-width: 40px;
            }
            .no-tasks-message {
                font-size: 1em;
            }
        }
        /* Overlay styles */
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 10000;
            justify-content: center;
            align-items: center;
        }
        .overlay-content {
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            max-width: 600px;
            width: 90%;
            position: relative;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border: 1px solid #e0e0e0;
        }
        .overlay-content h2 {
            margin: 0 0 15px;
            font-size: 1.8em;
            color: #1a1a1a;
            font-weight: 600;
            border-bottom: 2px solid #007bff;
            padding-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .overlay-content h2 i {
            color: #007bff;
        }
        .overlay-content .task-details, .overlay-content .edit-task-form, .overlay-content .create-task-form {
            display: grid;
            grid-template-columns: 130px 1fr;
            gap: 12px;
            align-items: center;
            padding: 10px;
        }
        .overlay-content .task-details label, .overlay-content .edit-task-form label, .overlay-content .create-task-form label {
            font-weight: 500;
            color: #333;
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .overlay-content .task-details label i, .overlay-content .edit-task-form label i, .overlay-content .create-task-form label i {
            color: #007bff;
        }
        .overlay-content .task-details .value {
            font-size: 1em;
            color: #2c2c2c;
            padding: 8px 12px;
            background: #f5f7fa;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
            word-break: break-word;
            transition: background 0.2s;
        }
        .overlay-content .task-details .value:hover {
            background: #e8ecef;
        }
        .overlay-content .task-details .status,
        .overlay-content .task-details .priority {
            padding: 6px 12px;
            border-radius: 12px;
            text-align: center;
            font-weight: 500;
            border: 1px solid #e0e0e0;
        }
        .overlay-content .task-details .status.pending { background: #ffeaa7; color: #7c4a00; }
        .overlay-content .task-details .status.in-progress { background: #74c0fc; color: #003087; }
        .overlay-content .task-details .status.completed { background: #51cf66; color: #0a4700; }
        .overlay-content .task-details .priority.high { background: #ff6b6b; color: #fff; }
        .overlay-content .task-details .priority.medium { background: #ffd166; color: #7c4a00; }
        .overlay-content .task-details .priority.low { background: #d3d3d3; color: #333; }
        .overlay-content .task-details .priority.none { background: #f5f7fa; color: #333; }
        .overlay-content .task-details .full-width,
        .overlay-content .edit-task-form .full-width,
        .overlay-content .create-task-form .full-width {
            grid-column: 1 / -1;
        }
        .overlay-content .edit-task-form input,
        .overlay-content .edit-task-form select,
        .overlay-content .edit-task-form textarea,
        .overlay-content .create-task-form input,
        .overlay-content .create-task-form select,
        .overlay-content .create-task-form textarea {
            padding: 8px 12px;
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            font-size: 1em;
            width: 100%;
            box-sizing: border-box;
            background: #f5f7fa;
            transition: border-color 0.2s, background 0.2s;
        }
        .overlay-content .edit-task-form select,
        .overlay-content .create-task-form select {
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path fill="%23333" d="M7 10l5 5 5-5z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 10px center;
            padding-right: 30px;
        }
        .overlay-content .edit-task-form textarea,
        .overlay-content .create-task-form textarea {
            min-height: 120px;
            resize: vertical;
            grid-column: 1 / -1;
        }
        .overlay-content .edit-task-form input:focus,
        .overlay-content .edit-task-form select:focus,
        .overlay-content .edit-task-form textarea:focus,
        .overlay-content .create-task-form input:focus,
        .overlay-content .create-task-form select:focus,
        .overlay-content .create-task-form textarea:focus {
            border-color: #007bff;
            background: #ffffff;
            outline: none;
        }
        .overlay-content .buttons {
            grid-column: 1 / -1;
            text-align: right;
            margin-top: 15px;
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }
        .overlay-content .buttons button {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 1em;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.1s;
        }
        .overlay-content .buttons button:hover {
            transform: translateY(-1px);
        }
        .overlay-content .buttons .edit-btn {
            background-color: #ffc107;
            color: #333;
        }
        .overlay-content .buttons .edit-btn:hover {
            background-color: #e0a800;
        }
        .overlay-content .buttons .del-btn {
            background-color: #ef322f;
            color: #fff;
        }
        .overlay-content .buttons .del-btn:hover {
            background-color: #cf5250;
        }
        .overlay-content .buttons .submit-btn {
            background-color: #28a745;
            color: white;
        }
        .overlay-content .buttons .submit-btn:hover {
            background-color: #218838;
        }
        .overlay-content .buttons .cancel-btn {
            background-color: #dc3545;
            color: white;
        }
        .overlay-content .buttons .cancel-btn:hover {
            background-color: #c82333;
        }
        .overlay-content .close-icon {
            position: absolute;
            top: 12px;
            right: 12px;
            font-size: 1.4em;
            cursor: pointer;
            color: #555;
            transition: color 0.2s;
        }
        .overlay-content .close-icon:hover {
            color: #ff0000;
        }
        @media (max-width: 768px) {
            .overlay-content {
                padding: 15px;
                max-width: 95%;
            }
            .overlay-content h2 {
                font-size: 1.5em;
            }
            .overlay-content .task-details,
            .overlay-content .edit-task-form,
            .overlay-content .create-task-form {
                grid-template-columns: 100px 1fr;
                gap: 10px;
            }
            .overlay-content .task-details label,
            .overlay-content .edit-task-form label,
            .overlay-content .create-task-form label,
            .overlay-content .task-details .value,
            .overlay-content .edit-task-form input,
            .overlay-content .edit-task-form select,
            .overlay-content .edit-task-form textarea,
            .overlay-content .create-task-form input,
            .overlay-content .create-task-form select,
            .overlay-content .create-task-form textarea {
                font-size: 0.9em;
            }
            .overlay-content .buttons button {
                padding: 8px 16px;
                font-size: 0.9em;
            }
            .overlay-content .close-icon {
                top: 10px;
                right: 10px;
                font-size: 1.2em;
            }
        }
        @media (max-width: 480px) {
            .overlay-content .task-details,
            .overlay-content .edit-task-form,
            .overlay-content .create-task-form {
                grid-template-columns: 1fr;
                gap: 8px;
            }
            .overlay-content .task-details label,
            .overlay-content .edit-task-form label,
            .overlay-content .create-task-form label {
                margin-bottom: 4px;
            }
            .overlay-content .task-details .value,
            .overlay-content .edit-task-form input,
            .overlay-content .edit-task-form select,
            .overlay-content .edit-task-form textarea,
            .overlay-content .create-task-form input,
            .overlay-content .create-task-form select,
            .overlay-content .create-task-form textarea {
                padding: 6px 10px;
            }
            .overlay-content .buttons {
                flex-direction: column;
                gap: 6px;
            }
        }
    </style>
</head>
<body>
    <div id="calendar-container">
        <div id="calendar"></div>
        <div id="no-tasks-message" class="no-tasks-message" style="display: none;">
            Hiện tại bạn chưa có công việc nào.
        </div>
    </div>
    <!-- Overlay for task details and edit -->
    <div id="task-overlay" class="overlay">
        <div class="overlay-content">
            <i class="fas fa-times close-icon" onclick="closeOverlay('task-overlay')"></i>
            <h2 id="task-overlay-title"><i class="fas fa-info-circle"></i> Chi tiết Công việc</h2>
            <div id="task-details" class="task-details">
                <label><i class="fas fa-heading"></i> Tiêu đề:</label>
                <div class="value" id="task-title"></div>
                <label><i class="fas fa-folder"></i> Danh mục:</label>
                <div class="value" id="task-category"></div>
                <label><i class="fas fa-clock"></i> Bắt đầu:</label>
                <div class="value" id="task-start"></div>
                <label><i class="fas fa-clock"></i> Kết thúc:</label>
                <div class="value" id="task-end"></div>
                <label><i class="fas fa-tasks"></i> Trạng thái:</label>
                <div class="value status" id="task-status"></div>
                <label><i class="fas fa-exclamation-circle"></i> Ưu tiên:</label>
                <div class="value priority" id="task-priority"></div>
                <label class="full-width"><i class="fas fa-align-left"></i> Mô tả:</label>
                <div class="description full-width value" id="task-description"></div>
                <div class="buttons">
                    <button class="del-btn" onclick="deleteTask()">Xoá</button>
                    <button class="edit-btn" onclick="switchToEditMode()">Chỉnh sửa</button>
                </div>
            </div>
            <div id="edit-task-form" class="edit-task-form" style="display: none;">
                <label><i class="fas fa-heading"></i> Tiêu đề:</label>
                <input type="text" id="edit-task-title" required>
                <label><i class="fas fa-folder"></i> Danh mục:</label>
                <select id="edit-task-category">
                    <option value="">Không có danh mục</option>
                    <!-- Danh mục sẽ được điền động qua JavaScript -->
                </select>
                <label><i class="fas fa-clock"></i> Bắt đầu:</label>
                <input type="text" id="edit-task-start" readonly>
                <label><i class="fas fa-clock"></i> Kết thúc:</label>
                <input type="text" id="edit-task-end">
                <label><i class="fas fa-tasks"></i> Trạng thái:</label>
                <select id="edit-task-status">
                    <option value="Chưa bắt đầu">Chưa bắt đầu</option>
                    <option value="Đang thực hiện">Đang thực hiện</option>
                    <option value="Hoàn thành">Hoàn thành</option>
                </select>
                <label><i class="fas fa-exclamation-circle"></i> Ưu tiên:</label>
                <select id="edit-task-priority">
                    <option value="Thấp">Thấp</option>
                    <option value="Trung bình">Trung bình</option>
                    <option value="Cao">Cao</option>
                </select>
                <label class="full-width"><i class="fas fa-align-left"></i> Mô tả:</label>
                <textarea id="edit-task-description" class="full-width"></textarea>
                <div class="buttons">
                    <button class="submit-btn" onclick="updateTask()">Lưu</button>
                    <button class="cancel-btn" onclick="switchToDetailMode()">Hủy</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Overlay for creating task -->
    <div id="create-task-overlay" class="overlay">
        <div class="overlay-content">
            <i class="fas fa-times close-icon" onclick="closeOverlay('create-task-overlay')"></i>
            <h2><i class="fas fa-plus-circle"></i> Tạo Công Việc Mới</h2>
            <div class="create-task-form">
                <label><i class="fas fa-heading"></i> Tiêu đề:</label>
                <input type="text" id="create-task-title" required>
                <label><i class="fas fa-folder"></i> Danh mục:</label>
                <select id="create-task-category">
                    <option value="">Không có danh mục</option>
                    <!-- Danh mục sẽ được điền động qua JavaScript -->
                </select>
                <label><i class="fas fa-clock"></i> Bắt đầu:</label>
                <input type="text" id="create-task-start" readonly>
                <label><i class="fas fa-clock"></i> Kết thúc:</label>
                <input type="text" id="create-task-end">
                <label><i class="fas fa-tasks"></i> Trạng thái:</label>
                <select id="create-task-status">
                    <option value="Chưa bắt đầu">Chưa bắt đầu</option>
                    <option value="Đang thực hiện">Đang thực hiện</option>
                    <option value="Hoàn thành">Hoàn thành</option>
                </select>
                <label><i class="fas fa-exclamation-circle"></i> Ưu tiên:</label>
                <select id="create-task-priority">
                    <option value="Thấp">Thấp</option>
                    <option value="Trung bình">Trung bình</option>
                    <option value="Cao">Cao</option>
                </select>
                <label class="full-width"><i class="fas fa-align-left"></i> Mô tả:</label>
                <textarea id="create-task-description" class="full-width"></textarea>
                <div class="buttons">
                    <button class="submit-btn" onclick="createTask()">Tạo</button>
                    <button class="cancel-btn" onclick="closeOverlay('create-task-overlay')">Hủy</button>
                </div>
            </div>
        </div>
    </div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/toastify.js"></script>
    <script>
        let currentTaskId = null;

        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var noTasksMessage = document.getElementById('no-tasks-message');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                slotMinTime: '00:00:00',
                slotMaxTime: '24:00:00',
                slotDuration: '01:00:00',
                slotLabelInterval: '01:00:00',
                fixedWeekCount: true,
                allDaySlot: false,
                slotEventOverlap: false,
                events: function(fetchInfo, successCallback, failureCallback) {
                    fetch('/ToDoList/getEvents', {
                        method: 'GET'
                    })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(data => {
                                if (response.status === 401) {
                                    alert('Bạn chưa đăng nhập. Vui lòng đăng nhập lại.');
                                    window.location.href = '/ToDoList/Pages/Login/Login.jsp';
                                    return;
                                } else if (response.status === 404 && data.message) {
                                    noTasksMessage.textContent = data.message;
                                    noTasksMessage.style.display = 'block';
                                    successCallback([]);
                                    return;
                                }
                                throw new Error(data.error || data.message || 'Unknown error');
                            });
                        }
                        noTasksMessage.style.display = 'none';
                        return response.json();
                    })
                    .then(data => {
                        if (data) {
                            successCallback(data);
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching events:', error);
                        alert('Không thể tải sự kiện: ' + error.message);
                        failureCallback(error);
                    });
                },
                eventClick: function(info) {
                    console.log(info);
                    currentTaskId = info.event._def.publicId;
                    document.getElementById('task-title').textContent = info.event.title;
                    document.getElementById('task-category').textContent = info.event.extendedProps.category_name || 'Không có';
                    document.getElementById('task-start').textContent = info.event.start.toLocaleString('vi-VN', {
                        year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false
                    });
                    document.getElementById('task-end').textContent = info.event.end ? info.event.end.toLocaleString('vi-VN', {
                        year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false
                    }) : 'Không có';
                    document.getElementById('task-status').textContent = info.event.extendedProps.status || 'Không có';
                    document.getElementById('task-status').className = 'value status ' + (info.event.extendedProps.status || 'none').toLowerCase().replace(' ', '-');
                    document.getElementById('task-priority').textContent = info.event.extendedProps.priority || 'Không có';
                    document.getElementById('task-priority').className = 'value priority ' + (info.event.extendedProps.priority || 'none').toLowerCase();
                    document.getElementById('task-description').textContent = info.event.extendedProps.description || 'Không có';

                    // Điền dữ liệu cho form chỉnh sửa
                    document.getElementById('edit-task-title').value = info.event.title;
                    document.getElementById('edit-task-category').value = info.event.extendedProps.category_id || '';
                    document.getElementById('edit-task-start').value = info.event.start.toLocaleString('vi-VN', {
                        year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false
                    });
                    document.getElementById('edit-task-end').value = info.event.end.toLocaleString('vi-VN', {
                        year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false
                    });
                    document.getElementById('edit-task-status').value = info.event.extendedProps.status || 'Chưa bắt đầu';
                    document.getElementById('edit-task-priority').value = info.event.extendedProps.priority || 'Thấp';
                    document.getElementById('edit-task-description').value = info.event.extendedProps.description || '';

                    document.getElementById('task-overlay').style.display = 'flex';
                    switchToDetailMode();
                },
                dateClick: function(info) {
                    openCreateTaskOverlay(info.date);
                }
            });
            calendar.render();

            // Tích hợp flatpickr vào tiêu đề lịch
            // Tích hợp flatpickr vào tiêu đề lịch
            var titleElement = document.querySelector('.fc-toolbar-title');
            flatpickr(titleElement, {
                enableTime: false,
                dateFormat: 'd/m/Y', // Định dạng DD/MM/YYYY
                locale: {
                    firstDayOfWeek: 1, // Thứ Hai là ngày đầu tuần
                    weekdays: {
                        shorthand: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
                        longhand: ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy']
                    },
                    months: {
                        shorthand: ['Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'],
                        longhand: ['Tháng Một', 'Tháng Hai', 'Tháng Ba', 'Tháng Tư', 'Tháng Năm', 'Tháng Sáu', 'Tháng Bảy', 'Tháng Tám', 'Tháng Chín', 'Tháng Mười', 'Tháng Mười Một', 'Tháng Mười Hai']
                    }
                },
                onChange: function(selectedDates, dateStr) {
                    if (selectedDates.length > 0) {
                        // Chuyển đổi DD/MM/YYYY thành YYYY-MM-DD cho calendar.gotoDate
                        const [day, month, year] = dateStr.split('/');
                        const isoDate = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
                        calendar.gotoDate(isoDate);
                    }
                }
            });

            // Khởi tạo flatpickr cho create-task và edit-task
            flatpickr('#create-task-start', {
                enableTime: true,
                dateFormat: 'Y-m-d\\TH:i',
                time_24hr: true,
                locale: { firstDayOfWeek: 1 }
            });
            flatpickr('#create-task-end', {
                enableTime: true,
                dateFormat: 'Y-m-d\\TH:i',
                time_24hr: true,
                locale: { firstDayOfWeek: 1 }
            });
            flatpickr('#edit-task-start', {
                enableTime: true,
                dateFormat: 'Y-m-d\\TH:i',
                time_24hr: true,
                locale: { firstDayOfWeek: 1 }
            });
            flatpickr('#edit-task-end', {
                enableTime: true,
                dateFormat: 'Y-m-d\\TH:i',
                time_24hr: true,
                locale: { firstDayOfWeek: 1 }
            });

            // Lấy danh mục từ server
            fetchCategories();
        });

        function closeOverlay(overlayId) {
            document.getElementById(overlayId).style.display = 'none';
            currentTaskId = null;
        }

        function switchToEditMode() {
            document.getElementById('task-overlay-title').innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa Công việc';
            document.getElementById('task-details').style.display = 'none';
            document.getElementById('edit-task-form').style.display = 'grid';
        }

        function switchToDetailMode() {
            document.getElementById('task-overlay-title').innerHTML = '<i class="fas fa-info-circle"></i> Chi tiết Công việc';
            document.getElementById('task-details').style.display = 'grid';
            document.getElementById('edit-task-form').style.display = 'none';
        }

        function openCreateTaskOverlay(date) {
            var startDate = new Date(date);
            startDate.setHours(0, 0, 0, 0);
            document.getElementById('create-task-start').value = startDate.toLocaleString('sv-SE', {
                year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit'
            });
            document.getElementById('create-task-end').value = '';
            document.getElementById('create-task-title').value = '';
            document.getElementById('create-task-description').value = '';
            document.getElementById('create-task-status').value = 'Chưa bắt đầu';
            document.getElementById('create-task-priority').value = 'Thấp';
            document.getElementById('create-task-overlay').style.display = 'flex';
        }

        function fetchCategories() {
            fetch('/ToDoList/getCategories', {
                method: 'GET'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to fetch categories');
                }
                return response.json();
            })
            .then(data => {
                var categorySelect = document.getElementById('create-task-category');
                var editCategorySelect = document.getElementById('edit-task-category');
                categorySelect.innerHTML = '<option value="">Không có danh mục</option>';
                editCategorySelect.innerHTML = '<option value="">Không có danh mục</option>';
                data.forEach(category => {
                    var option = document.createElement('option');
                    option.value = category.category_id;
                    option.textContent = category.name;
                    categorySelect.appendChild(option.cloneNode(true));
                    editCategorySelect.appendChild(option);
                });
            })
            .catch(error => {
                console.error('Error fetching categories:', error);
                alert('Không thể tải danh mục: ' + error.message);
            });
        }

        function createTask() {
            var title = document.getElementById('create-task-title').value.trim();
            if (!title) {
                alert('Vui lòng nhập tiêu đề công việc.');
                return;
            }

            var task = {
                title: title,
                category_id: document.getElementById('create-task-category').value || null,
                description: document.getElementById('create-task-description').value.trim() || null,
                status: document.getElementById('create-task-status').value,
                priority: document.getElementById('create-task-priority').value,
                start_time: document.getElementById('create-task-start').value,
                end_time: document.getElementById('create-task-end').value ? document.getElementById('create-task-end').value : null
            };

            fetch('/ToDoList/createTask', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify(task)
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(data => {
                        throw new Error(data.error || 'Failed to create task');
                    });
                }
                return response.json();
            })
            .then(data => {
                alert(data.message || 'Tạo công việc thành công!');
                closeOverlay('create-task-overlay');
                window.location.reload();
            })
            .catch(error => {
                console.error('Error creating task:', error);
                alert('Không thể tạo công việc: ' + error.message);
            });
        }

        function updateTask() {
            try {
                // Get form values
                const title = document.getElementById('edit-task-title').value.trim();
                const startTime = document.getElementById('edit-task-start').value;
                const endTime = document.getElementById('edit-task-end').value;
                const status = document.getElementById('edit-task-status').value;
                const priority = document.getElementById('edit-task-priority').value;

                // Validate title
                if (!title) {
                    showToast('❌ Vui lòng nhập tiêu đề công việc.', true);
                    return;
                }

                // Validate status
                const validStatuses = ['Chưa bắt đầu', 'Đang thực hiện', 'Hoàn thành'];
                if (!validStatuses.includes(status)) {
                    showToast('❌ Trạng thái không hợp lệ.', true);
                    return;
                }

                // Validate priority
                const validPriorities = ['Thấp', 'Trung bình', 'Cao'];
                if (!validPriorities.includes(priority)) {
                    showToast('❌ Ưu tiên không hợp lệ.', true);
                    return;
                }

                // Validate start_time
                if (!startTime) {
                    showToast('❌ Vui lòng chọn thời gian bắt đầu.', true);
                    return;
                }
                const startDate = new Date(startTime);
                if (isNaN(startDate.getTime())) {
                    showToast('❌ Thời gian bắt đầu không hợp lệ.', true);
                    return;
                }

                // Validate end_time if provided
                if (endTime) {
                    const endDate = new Date(endTime);
                    if (isNaN(endDate.getTime())) {
                        showToast('❌ Thời gian kết thúc không hợp lệ.', true);
                        return;
                    }
                    if (endDate <= startDate) {
                        showToast('❌ Thời gian kết thúc phải sau thời gian bắt đầu.', true);
                        return;
                    }
                }

                // Construct task object
                const task = {
                    task_id: currentTaskId,
                    title: title,
                    category_id: document.getElementById('edit-task-category').value || null,
                    description: document.getElementById('edit-task-description').value.trim() || null,
                    status: status,
                    priority: priority,
                    start_time: startTime,
                    end_time: endTime || null
                };

                // Send update request
                fetch('/ToDoList/UpdateTask', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: JSON.stringify(task)
                })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(data => {
                                throw new Error(data.error || 'Failed to update task');
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        showToast('✅ ' + (data.message || 'Cập nhật công việc thành công!'), false);
                        closeOverlay('task-overlay');
                        window.location.reload();
                    })
                    .catch(error => {
                        console.error('Error updating task:', error);
                        showToast('❌ Không thể cập nhật công việc: ' + error.message, true);
                    });
            } catch (error) {
                console.error('Error in updateTask:', error);
                showToast('❌ Lỗi khi cập nhật công việc: ' + error.message, true);
            }
        }

        // Toastify helper function
        function showToast(message, isError) {
            Toastify({
                text: message,
                duration: 2000,
                gravity: 'top',
                position: 'right',
                close: true,
                style: {
                    background: isError ? '#bf4342' : '#008000',
                    color: '#fff',
                    borderRadius: '8px',
                    padding: '14px 20px',
                    boxShadow: '0 3px 10px rgba(0,0,0,0.2)'
                },
                stopOnFocus: true
            }).showToast();
        }

        function deleteTask() {
            if (!currentTaskId) {
                alert('Không tìm thấy công việc để xóa.');
                return;
            }

            fetch('/ToDoList/deleteTask', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({ task_id: currentTaskId })
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(data => {
                        throw new Error(data.error || 'Failed to delete task');
                    });
                }
                return response.json();
            })
            .then(data => {
                alert(data.message || 'Xóa công việc thành công!');
                closeOverlay('task-overlay');
                window.location.reload();
            })
            .catch(error => {
                console.error('Error deleting task:', error);
                alert('Không thể xóa công việc: ' + error.message);
            });
        }
    </script>
</body>
</html>