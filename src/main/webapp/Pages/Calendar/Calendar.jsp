<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            padding: 30px;
            border-radius: 12px;
            max-width: 600px;
            width: 90%;
            position: relative;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.25);
            border: 1px solid #e5e5e5;
        }
        .overlay-content h2 {
            margin: 0 0 20px;
            font-size: 1.9em;
            color: #1a1a1a;
            font-weight: 700;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .overlay-content h2 i {
            color: #007bff;
        }
        .overlay-content .task-details {
            display: grid;
            grid-template-columns: 140px 1fr;
            gap: 15px;
            align-items: start;
        }
        .overlay-content .task-details label {
            font-weight: 500;
            color: #333;
            font-size: 1em;
            padding-top: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .overlay-content .task-details label i {
            color: #007bff;
        }
        .overlay-content .task-details .value {
            font-size: 1em;
            color: #2c2c2c;
            padding: 8px 12px;
            background: #f1f4f8;
            border-radius: 6px;
            word-break: break-word;
            transition: background 0.2s;
        }
        .overlay-content .task-details .value:hover {
            background: #e6ecf2;
        }
        .overlay-content .task-details .status,
        .overlay-content .task-details .priority {
            padding: 6px 12px;
            border-radius: 12px;
            text-align: center;
            font-weight: 500;
        }
        .overlay-content .task-details .status.pending { background: #ffeaa7; color: #7c4a00; }
        .overlay-content .task-details .status.in-progress { background: #74c0fc; color: #003087; }
        .overlay-content .task-details .status.completed { background: #51cf66; color: #0a4700; }
        .overlay-content .task-details .priority.high { background: #ff6b6b; color: #fff; }
        .overlay-content .task-details .priority.medium { background: #ffd166; color: #7c4a00; }
        .overlay-content .task-details .priority.low { background: #d3d3d3; color: #333; }
        .overlay-content .task-details .priority.none { background: #f1f4f8; color: #333; }
        .overlay-content .task-details .full-width {
            grid-column: 1 / -1;
        }
        .overlay-content .task-details .description {
            background: #f1f4f8;
            padding: 12px;
            border-radius: 6px;
            min-height: 100px;
            max-height: 250px;
            overflow-y: auto;
            white-space: pre-wrap;
            line-height: 1.5;
        }
        .overlay-content .buttons {
            grid-column: 1 / -1;
            text-align: right;
            margin-top: 20px;
            display: flex;
            gap: 10px;
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
            background-color: #007bff;
            color: white;
        }
        .overlay-content .buttons .edit-btn:hover {
            background-color: #0056b3;
        }
        .overlay-content .buttons .close-btn {
            background-color: #dc3545;
            color: white;
        }
        .overlay-content .buttons .close-btn:hover {
            background-color: #c82333;
        }
        .overlay-content .close-icon {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 1.5em;
            cursor: pointer;
            color: #555;
            transition: color 0.2s;
        }
        .overlay-content .close-icon:hover {
            color: #ff0000;
        }
        @media (max-width: 768px) {
            .overlay-content {
                padding: 20px;
                max-width: 95%;
            }
            .overlay-content h2 {
                font-size: 1.6em;
            }
            .overlay-content .task-details {
                grid-template-columns: 120px 1fr;
                gap: 10px;
            }
            .overlay-content .task-details label,
            .overlay-content .task-details .value {
                font-size: 0.95em;
            }
            .overlay-content .buttons button {
                padding: 8px 16px;
                font-size: 0.95em;
            }
            .overlay-content .close-icon {
                top: 12px;
                right: 12px;
                font-size: 1.3em;
            }
        }
        @media (max-width: 480px) {
            .overlay-content .task-details {
                grid-template-columns: 1fr;
            }
            .overlay-content .task-details label {
                margin-bottom: 6px;
            }
            .overlay-content .task-details .value {
                padding: 6px 10px;
            }
            .overlay-content .buttons {
                flex-direction: column;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
    <div id="calendar-container">
        <div id="calendar"></div>
    </div>
    <div id="task-overlay" class="overlay">
        <div class="overlay-content">
            <i class="fas fa-times close-icon" onclick="closeOverlay()"></i>
            <h2><i class="fas fa-info-circle"></i> Chi tiết Công việc</h2>
            <div class="task-details">
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
                <div class="description full-width" id="task-description"></div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
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
                            return response.json().then(err => {
                                throw new Error(`HTTP ${response.status}: ${err.error || 'Unknown error'}`);
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        successCallback(data);
                    })
                    .catch(error => {
                        console.error('Error fetching events:', error);
                        alert('Không thể tải sự kiện: ' + error.message);
                        failureCallback(error);
                    });
                },
                eventClick: function(info) {
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
                    document.getElementById('task-overlay').style.display = 'flex';
                },
                dateClick: function(info) {
                    calendar.gotoDate(info.date);
                    calendar.changeView('timeGridDay');
                }
            });
            calendar.render();

            var titleElement = document.querySelector('.fc-toolbar-title');
            flatpickr(titleElement, {
                enableTime: false,
                dateFormat: 'Y-m-d',
                locale: { firstDayOfWeek: 1 },
                onChange: function(selectedDates, dateStr) {
                    if (selectedDates.length > 0) {
                        calendar.gotoDate(dateStr);
                    }
                }
            });
        });

        function closeOverlay() {
            document.getElementById('task-overlay').style.display = 'none';
        }


    </script>
</body>
</html>