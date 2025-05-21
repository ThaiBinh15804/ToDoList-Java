//Load anh avatar
function previewAvatar() {
    document.getElementById('avatar-input').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
            // Kiểm tra định dạng tệp (JPG, PNG, GIF)
            const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
            if (!validTypes.includes(file.type)) {
                alert('Chỉ hỗ trợ định dạng JPG, PNG hoặc GIF.');
                event.target.value = ''; // Xóa tệp đã chọn
                return;
            }

            // Đọc và hiển thị ảnh
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatar-preview').src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });
}
document.addEventListener('DOMContentLoaded', previewAvatar);

// Dropdown menu
function setupDropdown() {
    // Đóng dropdown khi nhấp ra ngoài
    document.addEventListener('click', function(event) {
        var dropdowns = document.getElementsByClassName('dropdown-content');
        for (var i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.style.display === 'block' && !event.target.closest('.dropdown')) {
                openDropdown.style.display = 'none';
            }
        }
    });
    document.querySelector('.dropdown').addEventListener('click', function(event) {
        event.stopPropagation();
        var dropdownContent = this.querySelector('.dropdown-content');
        dropdownContent.style.display = dropdownContent.style.display === 'block' ? 'none' : 'block';
    });
}
document.addEventListener('DOMContentLoaded', setupDropdown);

// Thong bao lỗi
function closeToast(toastId = 'error-toast') {
    const toast = document.getElementById(toastId);
    if (toast) {
        toast.classList.add('hidden');
    }
}

// Ẩn hiện mật khẩu
function togglePassword(inputId, iconElement) {
    const input = document.getElementById(inputId);
    const icon = iconElement.querySelector('i');
    if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}