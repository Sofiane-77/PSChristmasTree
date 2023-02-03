# Getting Started

Welcome to the Getting Started page!

In this page, we will guide you through your first Christmas tree, and show you the basics of the main features offered by PSChristmasTree.

Before going further, please read the [Introduction](prerequisites.md) page and make sure you meet all the prerequisites and that the module is correctly installed.

### Display a Christmas tree

The connection is handled by the command `Show-PSChristmasTree`

```PowerShell
> Show-PSChristmasTree

			|
		   -+-
			A
		   /=\
		 i/ O \i
		 /=====\
		 /  i  \
	   i/ O * O \i
	   /=========\
	   /  *   *  \
	 i/ O   i   O \i
	 /=============\
	 /  O   i   O  \
   i/ *   O   O   * \i
   /=================\
		  |___|
```

Now that you have displayed the Christmas tree, you can ask him to play a melody during.

### Play a carol

For example, if you want to play carol two times in a row you can run this command:

```Powershell
> Show-PSChristmasTree -PlayCarol 2
```

### Change duration

Now we can display a Christmas tree with melody. We might want to change the display time:

```Powershell
> Show-PSChristmasTree -AnimationLoopNumber 30 -AnimationSpeed 250
```

AnimationLoopNumber is the number of generated frames and AnimationSpeed the display duration of each frame in milliseconds.

### Change the number of colors used

By default, we use all available colors to display the different elements but you can use only the ones you like : 

```Powershell
> Show-PSChristmasTree -Colors @('Blue', 'White', 'Red')
```

All color possibilities are listed [here](https://docs.microsoft.com/fr-fr/dotnet/api/system.consolecolor?view=net-6.0).

### Add more decorations to the Christmas tree

If you want more elements to light up or modify the default ones, you can do it with the decorations parameter.

```Powershell
> Show-PSChristmasTree -Decorations @{
	'i' = 'Yellow'
}
```

Decorations is a hashtable parameter where :
	  Key => character you want to animate.
	  Value => color you want to display this character.

### Change the language of the messages

You can specify the language code you want to use for the messages, if the language is not supported or the translation is not supported. The language displayed will be English (en-US).

```Powershell
> Show-PSChristmasTree -UICulture "fr-FR"
```

You can add a language in this [way](https://github.com/Sofiane-77/PSChristmasTree/tree/main/PSChristmasTree/locales).
