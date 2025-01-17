# frogger
An adaptation of the classic 1981 Konami game frogger, created in MIPS assembly

How to run:

1. Ensure you have Java Runtime Environment installed and added to your system's PATH. You can download it here: https://www.oracle.com/java/technologies/downloads/#java8
2. Download the .jar file and store it somewhere on your system
3. Download the frogger.asm file and store it somewhere on your system
4. Open your command prompt/terminal, run the following command: java -jar "path of your .jar file"
5. This will open Mars MIPS Assembler and Runtime Simulator
6. At the top left of the page, click "File" -> "Open" -> find your frogger.asm file and  click "Open"
7. At the top, click "Tools" -> "Keyboard and Display MMIO Simulator"
8. Once the "Keyboard and Display MMIO Simulator" is open, click "Connect to MIPS" at the bottom left corner
9. At the top, click "Tools" -> "Bitmap Display"
10. Once "Bitmap Display" is open, set "Unit Width in Pixels" to 8, "Unit Height in Pixels" to 8, "Display Width in Pixels" to 256, "Display Height in Pixels" to 256, and "Base address for display" to 0x10008000 ($gp)
11. After the setup, click "Connect to MIPS" at the bottom left corner
12. At the top tab, click "Run" -> "Assemble", then click the green arrow button to start the program
13. Have fun!
