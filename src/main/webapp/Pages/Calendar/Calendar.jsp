<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Lịch Công Việc</title>
    <!-- FullCalendar CSS và JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>
    <!-- Flatpickr CSS và JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            height: 100%;
            overflow: auto;
        }
        #calendar-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            overflow: auto; /* Cho phép cuộn nếu nội dung vượt kích thước */
        }
        #calendar {
            flex-grow: 1;
            width: 100%;
            max-width: 100%;
            height: 100%; /* Đảm bảo lịch chiếm hết chiều cao container */
            overflow: visible; /* Đảm bảo nội dung lịch không bị ẩn */
        }
        .fc .fc-toolbar {
            flex-wrap: wrap;
            padding: 10px;
        }
        .fc .fc-toolbar-title {
            cursor: pointer;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            display: inline-block;
        }
        .fc .fc-button {
            background-color: #007bff;
            border: none;
            padding: 8px 12px;
        }
        .fc .fc-button:hover {
            background-color: #0056b3;
        }
        .flatpickr-calendar {
            font-family: Arial, sans-serif;
            z-index: 9999;
        }
        /* Đảm bảo lưới tháng hiển thị 7x6 (35 ô) */
        .fc .fc-daygrid-month-view .fc-daygrid-body {
            display: grid !important;
            grid-template-columns: repeat(7, 1fr);
            grid-template-rows: repeat(6, 1fr);
        }
        /* Đảm bảo thời gian từ 0h đến 24h */
        .fc .fc-timegrid-slot {
            height: 40px; /* Tùy chỉnh chiều cao mỗi slot để hiển thị 24h rõ ràng */
        }
        @media (max-width: 768px) {
            #calendar-container {
                padding: 5px;
            }
            .fc .fc-toolbar-title {
                font-size: 16px;
            }
            .fc .fc-button {
                padding: 6px 10px;
                font-size: 14px;
            }
            .fc .fc-timegrid-slot {
                height: 30px; /* Giảm chiều cao slot trên thiết bị di động */
            }
        }
    </style>
</head>
<body>
    <div id="calendar-container">
        <div id="calendar"></div>
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
                slotDuration: '01:00:00', // Mỗi slot là 1 giờ
                slotLabelInterval: '01:00:00', // Hiển thị nhãn mỗi giờ
                fixedWeekCount: true, // Đảm bảo tháng luôn hiển thị 6 tuần (7x6)
                allDaySlot: false,
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
                    alert('Công việc: ' + info.event.title + '\nThời gian bắt đầu: ' + info.event.start.toLocaleString() + '\nThời gian kết thúc: ' + (info.event.end ? info.event.end.toLocaleString() : 'Không có'));
                },
                dateClick: function(info) {
                    // Nhấp vào ngày để chuyển đến ngày đó
                    calendar.gotoDate(info.date);
                    calendar.changeView('timeGridDay');
                }
            });
            calendar.render();

            // Tích hợp flatpickr vào tiêu đề lịch
            var titleElement = document.querySelector('.fc-toolbar-title');
            flatpickr(titleElement, {
                enableTime: false,
                dateFormat: 'Y-m-d',
                locale: {
                    firstDayOfWeek: 1 // Thứ Hai là ngày đầu tuần
                },
                onChange: function(selectedDates, dateStr) {
                    if (selectedDates.length > 0) {
                        calendar.gotoDate(dateStr); // Chuyển đến ngày được chọn
                    }
                }
            });
        });
    </script>
</body>
</html>