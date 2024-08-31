import tkinter as tk
from tkinter import messagebox
import os
import shutil
import zipfile
from datetime import datetime

# Define paths and version
userprofile = os.environ.get('USERPROFILE')
username = os.getlogin()
base_path = os.path.join(userprofile, 'Documents', "Harley's TFD")
version = "[V2.1]"
version_dir = version
backup_base_path = os.path.join(base_path, version_dir, 'Backup')
zip_path = os.path.join(base_path, version_dir, f'{username}_HTFD-Transfer.zip')
log_dir = os.path.join(base_path, version_dir, 'Logs')

class HarleyTFDToolApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Harley's TFD Tool")
        self.geometry("500x400")
        self.setup_logging()
        self.create_widgets()

    def setup_logging(self):
        if not os.path.exists(log_dir):
            os.makedirs(log_dir)
        now = datetime.now()
        date_str = now.strftime("%Y-%m-%d_%H-%M-%S")
        log_file = os.path.join(log_dir, f"{username}-Support_Log[{date_str}].txt")
        self.log_file = log_file
        with open(self.log_file, 'a') as f:
            f.write(f"[{now.strftime('%a %m/%d/%Y %H:%M:%S.%f')[:-3]}] Harley's TFD Tool [{version}] [Started]. Logged in user @{username}.\n")

    def log(self, message):
        now = datetime.now().strftime("[%a %m/%d/%Y %H:%M:%S.%f")[:-3] + "]"
        log_message = f"{now} Harley's TFD Tool [{version}] {message}\n"
        with open(self.log_file, 'a') as f:
            f.write(log_message)
        print(log_message.strip())

    def create_widgets(self):
        self.current_frame = None
        self.welcome_screen()

    def welcome_screen(self):
        self._destroy_current_frame()
        self.current_frame = tk.Frame(self)
        self.current_frame.pack(fill=tk.BOTH, expand=True)
        tk.Label(self.current_frame, text=f"Welcome {username} To", font=("Arial", 20, "bold"), padx=20, pady=20).pack()
        tk.Label(self.current_frame, text=f"Harley's TFD Tool {version}", font=("Arial", 20, "bold")).pack()
        tk.Label(self.current_frame, text="Manage and transfer your TFD settings with ease.", font=("Arial", 14)).pack(pady=10)
        tk.Label(self.current_frame, text=f"If support is needed, check your\n[{log_dir}]\nfor your log file and DM @HarleyTG on Discord.", font=("Arial", 12)).pack(pady=10)
        tk.Label(self.current_frame, text="Choose an option from the menu to get started.", font=("Arial", 12)).pack(pady=10)
        tk.Label(self.current_frame, text="Start: Harley's TFD Tool.", font=("Arial", 12)).pack(pady=5)
        tk.Label(self.current_frame, text="Exit: Close the tool.", font=("Arial", 12)).pack(pady=5)
        tk.Button(self.current_frame, text="Start", command=self.show_main_menu, font=("Arial", 12), bg="lightblue").pack(pady=10)
        tk.Button(self.current_frame, text="Exit", command=self.quit, font=("Arial", 12), bg="lightcoral").pack(pady=5)

    def show_main_menu(self):
        self._destroy_current_frame()
        self.current_frame = tk.Frame(self)
        self.current_frame.pack(fill=tk.BOTH, expand=True)
        tk.Label(self.current_frame, text=f"Main Menu - Harley's TFD Tool {version}", font=("Arial", 16)).pack(pady=10)
        tk.Button(self.current_frame, text="GameUserSettings Options", command=self.show_game_user_settings_menu).pack(pady=5)
        tk.Button(self.current_frame, text="Transfer (Zip/Unzip) Options", command=self.show_transfer_menu).pack(pady=5)
        tk.Button(self.current_frame, text="Delete/Reset 'TFD Saved' Folder", command=self.delete_saved).pack(pady=5)
        tk.Button(self.current_frame, text="System Menu", command=self.show_system_menu).pack(pady=5)
        tk.Button(self.current_frame, text="Display Version", command=self.show_version).pack(pady=5)
        tk.Button(self.current_frame, text="Help", command=self.show_help).pack(pady=5)
        tk.Button(self.current_frame, text="Exit", command=self.quit).pack(pady=5)

    def show_game_user_settings_menu(self):
        self._destroy_current_frame()
        self.current_frame = tk.Frame(self)
        self.current_frame.pack(fill=tk.BOTH, expand=True)
        tk.Label(self.current_frame, text=f"GameUserSettings Options - Harley's TFD Tool {version}", font=("Arial", 16)).pack(pady=10)
        tk.Button(self.current_frame, text="Backup GameUserSettings.ini", command=self.backup_game_user_settings).pack(pady=5)
        tk.Button(self.current_frame, text="Restore GameUserSettings.ini", command=self.restore_game_user_settings).pack(pady=5)
        tk.Button(self.current_frame, text="Back to Main Menu", command=self.back_to_main_menu).pack(pady=5)

    def backup_game_user_settings(self):
        src = os.path.join(userprofile, 'AppData', 'Local', 'M1', 'Saved', 'Config', 'Windows', 'GameUserSettings.ini')
        dest = os.path.join(backup_base_path, 'GameUserSettings.ini')
        try:
            if not os.path.exists(os.path.dirname(dest)):
                os.makedirs(os.path.dirname(dest))
            if os.path.exists(src):
                shutil.copy(src, dest)
                self.log("Backup successful: GameUserSettings.ini")
                messagebox.showinfo("Backup", "Backup Successful!")
            else:
                self.log("Error: GameUserSettings.ini file does not exist.")
                messagebox.showerror("Error", "GameUserSettings.ini file does not exist.")
        except Exception as e:
            self.log(f"Error during backup: {e}")
            messagebox.showerror("Error", f"Failed to backup GameUserSettings.ini\n{e}")

    def restore_game_user_settings(self):
        src = os.path.join(backup_base_path, 'GameUserSettings.ini')
        dest = os.path.join(userprofile, 'AppData', 'Local', 'M1', 'Saved', 'Config', 'Windows', 'GameUserSettings.ini')
        try:
            if os.path.exists(src):
                shutil.copy(src, dest)
                self.log("Restore successful: GameUserSettings.ini")
                messagebox.showinfo("Restore", "Restore Successful!")
            else:
                self.log("Error: Backup file GameUserSettings.ini does not exist.")
                messagebox.showerror("Error", "Backup file GameUserSettings.ini does not exist.")
        except Exception as e:
            self.log(f"Error during restore: {e}")
            messagebox.showerror("Error", f"Failed to restore GameUserSettings.ini\n{e}")

    def show_transfer_menu(self):
        self._destroy_current_frame()
        self.current_frame = tk.Frame(self)
        self.current_frame.pack(fill=tk.BOTH, expand=True)
        tk.Label(self.current_frame, text=f"Transfer Options - Harley's TFD Tool {version}", font=("Arial", 16)).pack(pady=10)
        tk.Button(self.current_frame, text="Create Transfer Zip", command=self.create_transfer_zip).pack(pady=5)
        tk.Button(self.current_frame, text="Extract Transfer Zip", command=self.extract_transfer_zip).pack(pady=5)
        tk.Button(self.current_frame, text="Back to Main Menu", command=self.back_to_main_menu).pack(pady=5)

    def create_transfer_zip(self):
        try:
            if not os.path.exists(os.path.dirname(zip_path)):
                os.makedirs(os.path.dirname(zip_path))
            with zipfile.ZipFile(zip_path, 'w') as zipf:
                for root, dirs, files in os.walk(backup_base_path):
                    for file in files:
                        file_path = os.path.join(root, file)
                        zipf.write(file_path, os.path.relpath(file_path, backup_base_path))
            self.log("Zip creation successful.")
            messagebox.showinfo("Zip Creation", "Zip Creation Successful!")
        except Exception as e:
            self.log(f"Error during zip creation: {e}")
            messagebox.showerror("Error", f"Failed to create transfer zip\n{e}")

    def extract_transfer_zip(self):
        try:
            if os.path.exists(zip_path):
                with zipfile.ZipFile(zip_path, 'r') as zipf:
                    zipf.extractall(base_path)
                self.log(f"Files extracted from {zip_path} successfully.")
                messagebox.showinfo("Files Extracted", "Files extracted successfully!")
            else:
                self.log("Error: Transfer zip file does not exist.")
                messagebox.showerror("Error", "Transfer zip file does not exist.")
        except Exception as e:
            self.log(f"Error during extraction: {e}")
            messagebox.showerror("Error", f"Failed to extract transfer zip\n{e}")

    def delete_saved(self):
        try:
            if os.path.exists(backup_base_path):
                shutil.rmtree(backup_base_path)
                self.log("Saved folder deleted.")
            if not os.path.exists(backup_base_path):
                os.makedirs(backup_base_path)
            messagebox.showinfo("Deleted", "TFD Saved folder has been deleted and recreated.")
        except Exception as e:
            self.log(f"Error during folder deletion: {e}")
            messagebox.showerror("Error", f"Failed to delete 'TFD Saved' folder\n{e}")

    def show_system_menu(self):
        self._destroy_current_frame()
        self.current_frame = tk.Frame(self)
        self.current_frame.pack(fill=tk.BOTH, expand=True)
        tk.Label(self.current_frame, text=f"System Menu - Harley's TFD Tool {version}", font=("Arial", 16)).pack(pady=10)
        tk.Button(self.current_frame, text="Open Logs Directory", command=self.open_logs_directory).pack(pady=5)
        tk.Button(self.current_frame, text="Back to Main Menu", command=self.back_to_main_menu).pack(pady=5)

    def open_logs_directory(self):
        if os.path.exists(log_dir):
            os.startfile(log_dir)
        else:
            messagebox.showerror("Error", "Log directory does not exist.")

    def show_version(self):
        messagebox.showinfo("Version", f"Harley's TFD Tool {version}")

    def show_help(self):
        messagebox.showinfo("Help", "Use this tool to manage TFD settings and transfer backups. For issues, refer to the logs or contact support.")

    def back_to_main_menu(self):
        self.show_main_menu()

    def _destroy_current_frame(self):
        if self.current_frame:
            self.current_frame.pack_forget()
            self.current_frame.destroy()
            self.current_frame = None

if __name__ == "__main__":
    app = HarleyTFDToolApp()
    app.mainloop()
