## ShooterKeyboard

A funny script that plays gun shot sounds when you hit buttons on your keyboard.

### Requirements

The only dependency required to run this program is the `evtest` package.

### Device Configuration

Before running the program, you need to identify the input device path you want to use.

You can list the available input devices by running:

```bash
sudo evtest
```
Find the device you want to use and note its input path (for example, `/dev/input/event6`). Enter this path when prompted by the program.

![evtest command](https://github.com/user-attachments/assets/7f15b003-a744-464d-82bb-584fe5f7dfdc)

![wlcome page](https://github.com/user-attachments/assets/f180ab49-8518-47cf-a3d1-83cab97d4667)