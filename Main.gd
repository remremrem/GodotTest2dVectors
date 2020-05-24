tool
extends Node2D

var dot_product
#export var cross_product = Vector2()
#export(int, -100, 100, 1) var velx setget update_vel_x
#export(int, -100, 100, 1) var vely setget update_vel_y

export(int, -100, 1000, 1) var xpos setget update_pos_x
export(int, -100, 1000, 1) var ypos setget update_pos_y

export(int, -720, 720, 1) var velrot setget update_velrot

var velocity = Vector2(10,0)

var distance_to_target
var direction_to_target
#export var input_speed = 10

#export var update = false setget do_update


# Called when the node enters the scene tree for the first time.
func _ready():
    print("tool script 'Object.gd' is ready")
    var timer = Timer.new()
    timer.connect("timeout",self,"_on_timer_timeout")
    add_child(timer) #to process
    timer.start(.2) #to start
    
    
func _on_timer_timeout():
    #print("timer timeout")
    do_update(1)

func update_velrot(arg):
    velrot = arg
    velocity = Vector2(velocity.length(),0).rotated(deg2rad(arg))
    print("velocity: ", velocity)
    update_velocity()

"""func update_vel_x(arg):
    velx = arg
    update_vel()
    
func update_vel_y(arg): 
    vely = arg
    update_vel()
    
func update_vel():
    velocity = Vector2(velx, vely)"""
    

func update_pos_x(arg):
    xpos = arg
    update_pos()
    
func update_pos_y(arg): 
    ypos = arg
    update_pos()
    
func update_pos():
    $Object.global_position = Vector2(xpos, ypos)

func update_velocity():
    var v = velocity * 10
    var position2 = $Object.global_position + v
    var direction = velocity.normalized()
    var angle = position2.angle_to($Object.global_position)
    var angle2 = position2.angle_to_point($Object.global_position)
    var distance = $Object.global_position.distance_to(position2)
    #print(distance, direction, angle, angle2)
    var target_indic_pos = $Object.global_position + (direction * distance * .5)
    var t = $Indicators/Velocity
    t.global_position = target_indic_pos
    t.rotation = angle2
    t.get_node("Line").scale.x = distance*.5
    #print(t.get_property_list())
    #print(t.global_transform, " | ", t.scale)
    $Object/Velocity.rotation = angle2 - deg2rad(90)
    return [direction, angle2]

func update_destination():
    var direction = $Object.global_position.direction_to($DestinationObject.global_position)
    var angle = $DestinationObject.global_position.angle_to($Object.global_position)
    var angle2 = $DestinationObject.global_position.angle_to_point($Object.global_position)
    var distance = $DestinationObject.global_position.distance_to($Object.global_position)
    #print(distance, direction, angle, angle2)
    var target_indic_pos = $Object.global_position + (direction * distance * .5)
    var t = $Indicators/Destination
    t.global_position = target_indic_pos
    t.get_node("Line").rotation = angle2
    t.get_node("Line").scale.x = distance*.5
    t.get_node("PanelContainer/Label").text = "ANGLE: "+String(angle2)
    #print(t.get_property_list())
    #print(t.global_transform, " | ", t.scale)
    return [direction, angle2]


func update_target():
    var direction = $Object.global_position.direction_to($TargetObject.global_position)
    var angle = $TargetObject.global_position.angle_to($Object.global_position)
    var angle2 = $TargetObject.global_position.angle_to_point($Object.global_position)
    var distance = $TargetObject.global_position.distance_to($Object.global_position)
    #print(distance, direction, angle, angle2)
    var target_indic_pos = $Object.global_position + (direction * distance * .5)
    var t = $Indicators/Target
    t.global_position = target_indic_pos
    t.get_node("Line").rotation = angle2
    t.get_node("Line").scale.x = distance*.5
    t.get_node("PanelContainer/Label").text = "ANGLE: "+String(angle2)
    #print(t.get_property_list())
    #print(t.global_transform, " | ", t.scale)
    return [direction, angle2]

     
func do_update(arg):
    var t = update_target()
    var d = update_destination()
    var v = update_velocity()
    dot_product  = t[0].normalized().dot(v[0].normalized())
    $GridContainer/DotPro.text = "Dot: " + String(dot_product)
    $Object/PanelContainer/Label.text = "ANGLE: "+String(d[0].angle_to(t[0]))
    #print("t: ", t, " v: ",v ," dot: ", dot_product)
    #update_dot_pro(t, v)
    
    
"""func _process(delta):
    if Input.is_action_pressed("ui_left"):
        print("move left")
        update_pos_x(-delta * input_speed)
    elif Input.is_action_pressed("ui_right"):
        update_pos_x(delta * input_speed)
    elif Input.is_action_pressed("ui_up"):
        update_pos_y(-delta * input_speed)
    elif Input.is_action_pressed("ui_down"):
        update_pos_y(delta * input_speed)"""
    
