/*: 
 # RC Circuit
 
 Electronic circuits influence everyday life even if we do not see them. For example, the iPad that you are using in this moment has a huge electronic circuit inside of it! An electronic circuit needs an energy source to work, that in our case will be given by a battery with infinite charge:
 
 ![Battery](battery.png)
 
 Run code and tap on it!
 
 As we can see, the current flowing in the circuit is represented by electrons. Let’s try now to set the switches ON to see how the circuit works.
 
 
 ## Why do we talk about the RC circuit?
 
 Its name derives from two essential components in electronics: the resistor and the capacitor.
 An electrical resistance limits the passage of current inside of it:
 
 ![Resistor](resistor.png)
 
 Let’s try to add it into the circuit to see what the effect is.
 ````
 addResistor()
 ````
 
 An electric capacitor acts as a charge collector:
 
 ![Capacitor](capacitor.png)
 
 Try to add the capacitor into the circuit setting the battery switch ON in order to charge it.
 ````
 addCapacitor()
 ````
 
 Great! Now we just have to put all these components together but let’s add a twist with a light bulb! 
 Charge the capacitor as before and when it is charged enough, turn the battery switch OFF and switch ON the one of the capacitor. Eventually tap on the capacitor to see the bulb lighting up gradually. This is the capacitor discharge cycle. If we want to repeat it, let’s tap on the lamp to turn it off.
 
 ````
 addLamp()
 ````
 
 
 Well done! We have just learned how an electronic circuit works! But now it's time to [Go To Space!](@next)
 
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addResistor(), addCapacitor(), addLamp())
//#-hidden-code
import PlaygroundSupport
import SpriteKit


class GameScene: SKScene {
  
  
  
  
  var battery = SKSpriteNode()
  var circuit = SKSpriteNode()
  var resistor = SKSpriteNode()
  var capacitor = SKSpriteNode()
  var capacitorBar = SKShapeNode()
  var capacitorBarIndicator = SKShapeNode()
  var lampBulb = SKSpriteNode()
  var lampOff = SKSpriteNode()
  var lampOn = SKSpriteNode()
  var switchBattery = SKSpriteNode()
  var switchBatteryLabel = SKLabelNode()
  var switchCapacitor = SKSpriteNode()
  var switchCapacitorLabel = SKLabelNode()
  var electron = SKSpriteNode()
  var moveLeft = SKAction()
  var moveRight = SKAction()
  var moveUp = SKAction()
  var moveDown = SKAction()
  var move = SKAction()
  var sequence = SKAction()
  var resistorIsCreated = false
  var capacitorIsCreated = false
  var lampIsCreated = false
  var switchBatteryState = false
  var switchCapacitorState = false
  var numberOfElectronsCapacitor = 0
  var numberOfElectronsLamp = 0
  
  override init(size: CGSize) {
    super.init(size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMove(to view: SKView) {
    addBattery()
    //#-end-hidden-code
    //#-editable-code
    //#-end-editable-code
    //#-hidden-code
    //Create the circuit
    circuit = SKSpriteNode(imageNamed: "circuit")
    circuit.position = CGPoint(x: battery.frame.minX - 450, y: battery.frame.midY + 75)
    circuit.zPosition = -1
    battery.addChild(circuit)
    //Add a switch to a battery
    switchBattery = SKSpriteNode(imageNamed: "switch")
    switchBattery.position = CGPoint(x: battery.position.x - 275, y: battery.position.y + 58)
    switchBattery.name = "switchBattery"
    self.addChild(switchBattery)
    switchBatteryLabel = SKLabelNode(fontNamed: "Marker Felt")
    switchBatteryLabel.fontColor = SKColor.white
    switchBatteryLabel.fontSize = 35
    switchBatteryLabel.zPosition = 20
    switchBatteryLabel.position =  CGPoint(x: battery.position.x - 275, y: battery.position.y + 10)
    switchBatteryLabel.text = "OFF"
    switchBatteryLabel.name = "switchBatteryLabel"
    self.addChild(switchBatteryLabel)
    //Add a switch and indicator to a capacitor
    switchCapacitor = SKSpriteNode(imageNamed: "switch")
    switchCapacitor.position = CGPoint(x: self.frame.maxX - 218, y: self.frame.maxY - 102)
    switchCapacitor.name = "switchCapacitor"
    self.addChild(switchCapacitor)
    switchCapacitorLabel = SKLabelNode(fontNamed: "Marker Felt")
    switchCapacitorLabel.fontColor = SKColor.white
    switchCapacitorLabel.fontSize = 35
    switchCapacitorLabel.zPosition = 20
    switchCapacitorLabel.position = CGPoint(x: self.frame.maxX - 218, y: self.frame.maxY - 150)
    switchCapacitorLabel.text = "OFF"
    switchCapacitorLabel.name = "switchCapacitorLabel"
  self.addChild(switchCapacitorLabel)
  }
  //Add a battery
  func addBattery() {
    battery = SKSpriteNode(imageNamed: "battery")
    battery.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 155)
    battery.name = "battery"
    self.addChild(battery)
  }
  //Add a Resistor
  func addResistor() {
    resistor = SKSpriteNode(imageNamed: "resistor")
    resistor.position = CGPoint(x: battery.position.x - 365, y:  (scene?.frame.midY)!)
    resistor.setScale(0.5)
    resistor.name = "resitor"
    self.addChild(resistor)
    resistorIsCreated = true
  }
  //Add a Capacitor
  func addCapacitor() {
    capacitor = SKSpriteNode(imageNamed: "capacitor")
    capacitor.position = CGPoint(x: self.frame.maxX - 288, y:  (scene?.frame.midY)!)
    capacitor.setScale(0.5)
    capacitor.name = "capacitor"
    self.addChild(capacitor)
    capacitorIsCreated = true
    capacitorBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 8, height: 80))
    capacitorBar.position = CGPoint(x: capacitor.position.x + 50, y: capacitor.position.y - 40)
    capacitorBar.fillColor = SKColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
    self.addChild(capacitorBar)
    self.capacitorBarIndicator = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 8, height: 26.6))
    self.capacitorBarIndicator.position = self.capacitorBar.position
    self.capacitorBarIndicator.lineWidth = 0
    self.addChild(self.capacitorBarIndicator)
  }
  //Add a Lamp
  func addLamp() {
    lampBulb = SKSpriteNode(imageNamed: "lampBulb")
    lampBulb.position = CGPoint(x: self.frame.maxX - 150, y:  (scene?.frame.midY)! - 25)
    lampBulb.zPosition = 1
    lampBulb.setScale(0.5)
    self.addChild(lampBulb)
    lampOff = SKSpriteNode(imageNamed: "lampOff")
    lampOff.setScale(0.5)
    lampOff.position = CGPoint(x: lampBulb.position.x, y: lampBulb.position.y + 30)
    self.addChild(lampOff)
    lampIsCreated = true
  }
  //Create electrons
  func spawnElectrons(from: String) {
    //Spawn electron
    electron = SKSpriteNode(imageNamed: "electron")
    electron.name = "electron"
    electron.setScale(0.5)
    electron.zPosition = 2
    //Spawn from battery
    if from == "battery" {
       electron.position = battery.position
      moveUp = SKAction.move(by: CGVector(dx: 0, dy: 450), duration: 1)
      moveDown = SKAction.move(by: CGVector(dx: 0, dy: -450), duration: 1)
      //If switch on capacitor is off, flow in the shortest path
      if !switchCapacitorState{
        moveLeft = SKAction.move(by: CGVector(dx: circuit.frame.minX, dy: 0), duration: 1)
        moveRight = SKAction.move(by: CGVector(dx: (circuit.frame.maxX - 68) * 2, dy: 0), duration: 1)
        
        let firstSequence = SKAction.sequence([moveLeft, moveUp, moveRight, moveDown])
        let foreverSequence = SKAction.sequence([moveRight.reversed(), moveUp, moveRight, moveDown])
        let firstMove = SKAction.repeat(firstSequence, count: 1)
        let foreverMove = SKAction.repeatForever(foreverSequence)
        sequence = SKAction.sequence([firstMove, foreverMove])
        
        move = SKAction.repeatForever(sequence)
      }
      //Else flow in the longe
      else {
        moveLeft = SKAction.move(by: CGVector(dx: circuit.frame.minX, dy: 0), duration: 1)
        moveRight = SKAction.move(by: CGVector(dx: (circuit.frame.maxX + 4) * 2, dy: 0), duration: 1)
        sequence = SKAction.sequence([moveLeft, moveUp, moveRight, moveDown, moveLeft])
        move = SKAction.repeatForever(sequence)
      }
    //Spawn from capacitor
    } else if from == "capacitor" {
      electron.position = capacitor.position
    
      moveUp = SKAction.move(by: CGVector(dx: 0, dy: 225), duration: 1)
      moveDown = SKAction.move(by: CGVector(dx: 0, dy: -450), duration: 1)
       moveRight = SKAction.move(by: CGVector(dx: 140, dy: 0), duration: 1)
      sequence = SKAction.sequence([moveUp, moveRight, moveDown, moveRight.reversed(), moveUp])
      move = SKAction.repeatForever(sequence)
    }
   
     self.addChild(electron)
   
    electron.run(move)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first?.location(in: self)
    //Spawn electrons from battery
    if atPoint(touch!).name == "battery" {
      spawnElectrons(from: "battery")
    }
    //Invert the state of battery switch
    else if atPoint(touch!).name == "switchBattery" || atPoint(touch!).name == "switchBatteryLabel" {
      switchBattery.xScale *= -1
      switchBatteryState = !switchBatteryState
      if switchBatteryState {
        switchBatteryLabel.text = "ON"
      } else {
        switchBatteryLabel.text = "OFF"
      }
    }
    //Invert the state of capacitor switch
    else if atPoint(touch!).name == "switchCapacitor" || atPoint(touch!).name == "switchCapacitorLabel" {
      switchCapacitor.xScale *= -1
      switchCapacitorState = !switchCapacitorState
      if switchCapacitorState {
        switchCapacitorLabel.text = "ON"
      } else {
        switchCapacitorLabel.text = "OFF"
      }
    }
    //Spawn electrons from capacitor and discharge it
    else if atPoint(touch!).name == "capacitor" && !switchBatteryState && numberOfElectronsCapacitor != 0{
      spawnElectrons(from: "capacitor")
      numberOfElectronsCapacitor -= 1
      checkCapacitorIndicator()
    }
    //Turn off the lamp
    else if atPoint(touch!).name == "lampOn" {
      lampOn.removeFromParent()
      lampOff = SKSpriteNode(imageNamed: "lampOff")
      lampOff.setScale(0.5)
      lampOff.position = CGPoint(x: lampBulb.position.x, y: lampBulb.position.y + 30)
      self.addChild(lampOff)
      numberOfElectronsLamp = 0
    }
  }
  //Set the charge of capacitor with the indicator
  func checkCapacitorIndicator() {
    if self.numberOfElectronsCapacitor == 0 {
      self.capacitorBarIndicator.yScale = 0
    }
    else if self.numberOfElectronsCapacitor >= 1 &&  self.numberOfElectronsCapacitor < 15{
      self.capacitorBarIndicator.yScale = 1
      self.capacitorBarIndicator.fillColor = SKColor(red:1.00, green:0.37, blue:0.37, alpha:1.0)
      self.capacitorBarIndicator.strokeColor = SKColor(red:1.00, green:0.37, blue:0.37, alpha:1.0)
      self.capacitorBarIndicator.zPosition = 10
    }
    else if self.numberOfElectronsCapacitor >= 15 && self.numberOfElectronsCapacitor < 30{
      self.capacitorBarIndicator.yScale = 2
      self.capacitorBarIndicator.fillColor = SKColor(red:0.98, green:0.76, blue:0.39, alpha:1.0)
      self.capacitorBarIndicator.strokeColor = SKColor(red:0.98, green:0.76, blue:0.39, alpha:1.0)
    }
    else if self.numberOfElectronsCapacitor >= 30 {
      self.capacitorBarIndicator.yScale = 3
      self.capacitorBarIndicator.fillColor = SKColor(red:0.67, green:1.00, blue:0.62, alpha:1.0)
      self.capacitorBarIndicator.strokeColor = SKColor(red:0.67, green:1.00, blue:0.62, alpha:1.0)
    }
  }
  
  
  override func didEvaluateActions(){
    enumerateChildNodes(withName: "electron") { node, _ in
      let electron = node as! SKSpriteNode
      //If electron hit a switch off, remove it
      if !self.switchBatteryState && electron.frame.intersects(self.switchBattery.frame) {
        electron.removeFromParent()
      }
      if !self.switchCapacitorState && electron.frame.intersects(self.switchCapacitor.frame) {
        electron.removeFromParent()
      }
      
      //If there is a resistor and a electron flow on it, has the 20% to be removed
      if self.resistorIsCreated {
        if electron.frame.intersects(CGRect(x: self.resistor.frame.minX, y: self.resistor.frame.maxY - 144, width: self.resistor.frame.width / 2, height: self.resistor.frame.height / 4)) {
          let randomResistor = random(min: 0, max: 10)
          if randomResistor >= 8{
            electron.removeFromParent()
          }
        }
      }
      //If there is a capacitor and battery switch is ON, charge the capacitor
      if self.capacitorIsCreated && self.switchBatteryState
      {
        if electron.frame.intersects(self.capacitor.frame) {
          electron.removeFromParent()
          self.numberOfElectronsCapacitor += 1
          self.checkCapacitorIndicator()
        }
      }
      //If there is a lamp and electron hit it, turn on the lamp gradually
      if self.lampIsCreated {
        if electron.frame.intersects(self.lampBulb.frame) {
          self.numberOfElectronsLamp += 1
          electron.removeFromParent()
          if self.numberOfElectronsLamp == 1{
            self.lampOff.removeFromParent()
            self.lampOn = SKSpriteNode(imageNamed: "lampOn")
            self.lampOn.name = "lampOn"
            self.lampOn.setScale(0.5)
            self.lampOn.alpha = 0.3
            self.lampOn.position = CGPoint(x: self.lampBulb.position.x, y: self.lampBulb.position.y + 30)
            self.addChild(self.lampOn)
          }
          else if self.numberOfElectronsLamp >= 15 && self.numberOfElectronsLamp < 30 {
            self.lampOn.alpha = 0.7
          }
          else if self.numberOfElectronsLamp >= 30 {
            self.lampOn.alpha = 1
          }
        }
      }
    }
  }
}
//Set the scene
let scene = GameScene(size: CGSize(width: 1024, height: 768))
let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 512, height: 384))
//DEBUG
//sceneView.showsFPS = true
//sceneView.showsFields = true
//sceneView.showsPhysics = true
scene.scaleMode = .aspectFit
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
