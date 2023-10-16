import subprocess

def change_root_password(new_password):
    cmd = f"echo 'root:{new_password}' | sudo chpasswd"
    try:
        subprocess.check_output(cmd, shell=True)
        print("Root password changed successfully.")
    except subprocess.CalledProcessError as e:
        print("Failed to change root password:", e)

# 修改 root 用户的密码为 "新密码"
change_root_password("123456")
