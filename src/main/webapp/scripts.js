// Load ảnh avatar
function previewAvatar() {
    document.getElementById('avatar-input')?.addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
            const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
            if (!validTypes.includes(file.type)) {
                alert('Chỉ hỗ trợ định dạng JPG, PNG hoặc GIF.');
                event.target.value = '';
                return;
            }
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatar-preview').src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });
}
document.addEventListener('DOMContentLoaded', previewAvatar);

// Đóng thông báo
function closeToast(toastId = 'error-toast') {
    const toast = document.getElementById(toastId);
    if (toast) {
        toast.classList.add('hidden');
    }
}

// Hiển thị thông báo và tự động đóng sau 2 giây
function showToast(toastId) {
    const toast = document.getElementById(toastId);
    if (toast) {
        toast.classList.remove('hidden');
        setTimeout(() => {
            closeToast(toastId);
        }, 2000);
    }
}

// Tự động hiển thị toast khi trang tải
document.addEventListener('DOMContentLoaded', function() {
    const errorToast = document.getElementById('error-toast');
    if (errorToast) {
        showToast('error-toast');
    }
    const successToast = document.getElementById('success-toast');
    if (successToast) {
        showToast('success-toast');
    }
});

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

// Get query parameter
function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param) || "";
}