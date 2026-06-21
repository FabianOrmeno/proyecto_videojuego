class_name ActivatebleBody

extends StaticBody3D

func activate():
	rotation.y -= 90
	Debug.log("Activate")
	
func deactivate():
	rotation.y += 90
	Debug.log("Deactivate")
