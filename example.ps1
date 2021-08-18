---
- name: set up ansible for windows
  hosts: '{{ target|default("localhost") }}'
  gather_facts: no
  vars:
    ansible_port: 5986
    ansible_user: "{{ win_user }}"
    ansible_password: "{{ win_password }}"
    ansible_become_password: "{{ admin_password }}"
    ansible_connection: "winrm"
    ansible_winrm_transport: "ntlm"
    ansible_winrm_server_cert_validation: "ignore"
    ansible_winrm_operation_timeout_sec: 120
    ansible_winrm_read_timeout_sec: 150

  tasks:
    - name: Create directory structure
      ansible.windows.win_file:
        path: C:\Temp
        state: directory
    
    - name: Copy a single file
      ansible.windows.win_copy:
        src: files/dadjoke.ps1
        dest: C:\Temp\dadjoke.ps1

    - name: Run a command with an idempotent check on what it creates, will only run when somedir/somelog.txt does not exist
      ansible.windows.win_shell: C:\Temp\dadjoke.ps1 >> C:\Temp\dadjoke.txt
      args:
        chdir: C:\Temp
        creates: C:\Temp\dadjoke.txt
