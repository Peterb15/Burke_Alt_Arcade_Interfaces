using Godot;
using System;
using System.IO.Ports;

public partial class Arduino : Node2D
{
	SerialPort serialPort;
	RichTextLabel text;
	bool hasHeardFromArduino = false;
	float timer;

	private Node player; // Use Node instead of Player

	public override void _Ready()
	{
		text = GetNode<RichTextLabel>("RichTextLabel");

		// Get the Player node from the scene tree
		player = GetNode("/root/Main/Player_Input/Player");
		
		try
		{
			serialPort = new SerialPort
			{
				PortName = "COM4",
				BaudRate = 9600
			};
			serialPort.Open();
		}
		catch (Exception e)
		{
			GD.Print("Error opening serial port: " + e.Message);
		}
	}

	public override void _Process(double delta)
	{
		if (!serialPort.IsOpen) return;

		if (serialPort.BytesToRead > 0)
		{
			try
			{
				string serialMessage = serialPort.ReadLine().Trim();
				text.Text = serialMessage;

				if (serialMessage == "left" || serialMessage == "right" || serialMessage == "balanced" || serialMessage == "LEFT" || serialMessage == "RIGHT")
				{
					hasHeardFromArduino = true;
					timer = Time.GetTicksMsec();
					// Check if player is not null before calling methods
					if (player != null)
					{
						// Use call() to invoke the GDScript method
						player.Call("SetControllerInput", serialMessage);
					}
				}
			}
			catch (Exception e)
			{
				GD.Print("Error reading from serial port: " + e.Message);
			}
		}
	}

	public override void _ExitTree()
	{
		if (serialPort.IsOpen)
		{
			serialPort.Close();
		}
		serialPort.Dispose();
	}
}
