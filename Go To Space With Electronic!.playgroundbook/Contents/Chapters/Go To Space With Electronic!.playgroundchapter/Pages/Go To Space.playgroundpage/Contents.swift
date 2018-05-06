//#-hidden-code
import UIKit
//#-end-hidden-code
/*:
 # Go To Space!
 
 ## Ion Thruster
 
 When we look at a space rocket, we usually image it with a huge fire on the back that directs it. Recently, however, the development of new models of propulsion is being started. Some of them, called ion thrusters, generate a boost taking advantage by electric fields like the ones that we saw at the beginning. Now let's analyse how they work:
 
 ![ionThruster](ionThruster.png)
 
 1. Neutral atoms are injected into the engine.
 2. The electrons are bombarded into the engine in order to destabilize the atoms. This creates positive and negative ions.
 3. The positive ions are deposited on the bottom of the engine where a grid with a high positive charge repels them while they are attracted by a second negative grid. The positive ions are directed to the exit of the engine and this creates the boost.
 4. Eventually, a neutralizer ensures that there is no strong charge imbalance.
 
 
 Our goal is to collect the negative charges to allow us to gain push and reach the space! When you come back, I hope to meet you at WWDC18!
 
 
 ## How to play
 
 If you prefer, set the difficulty level changing the value of `var` difficulty from 1 to 3.
 */
//#-code-completion(everything, hide)
//#-hidden-code
import PlaygroundSupport
import SpriteKit


class GameScene: SKScene {
  var spaceship = SKSpriteNode()
  var propeller = SKEmitterNode()
  var backgroundGround = SKSpriteNode()
  var backgroundStar1 = SKSpriteNode()
  var backgroundStar2 = SKSpriteNode()
  var proton = SKSpriteNode()
  var electron = SKSpriteNode()
  var checkWonLostSprite = SKSpriteNode()
  var scaleAction = SKAction()
  var particleAction = SKAction()
  var electronLabel = SKLabelNode()
  var launch = false
  var yCamera: CGFloat = 0
  var numberOfElectrons = 0
  //#-end-hidden-code
  //#-editable-code
  var difficulty = 1
  //#-end-editable-code
  //#-hidden-code
  let cameraNode = SKCameraNode()
  var cameraRect : CGRect {
    let x = cameraNode.position.x - size.width/2 + (size.width - self.frame.width)/2
    let y = cameraNode.position.y - size.height/2 + (size.height - self.frame.height)/2
    return CGRect(x: x, y: y, width: self.frame.width,height: self.frame.height)
  }
  
  override init(size: CGSize) {
    super.init(size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMove(to view: SKView) {
    //Create background
    backgroundGround = SKSpriteNode(imageNamed: "backgroundGround")
    backgroundGround.anchorPoint = CGPoint.zero
    backgroundGround.position = CGPoint(x: self.position.x, y: self.position.y - backgroundGround.frame.height/2)
    self.addChild(backgroundGround)
    backgroundStar1 = SKSpriteNode(imageNamed: "backgroundStars1")
    backgroundStar1.anchorPoint = CGPoint.zero
    backgroundStar1.position =
      CGPoint(x: 0, y: backgroundGround.size.height - backgroundStar1.frame.height/2)
    self.addChild(backgroundStar1)
    backgroundStar2 = SKSpriteNode(imageNamed: "backgroundStars2")
    backgroundStar2.anchorPoint = CGPoint.zero
    backgroundStar2.position =
      CGPoint(x: 0, y: backgroundGround.size.height + backgroundStar1.size.height - backgroundStar2.frame.height/2)
    self.addChild(backgroundStar2)
    //Create Camera
    camera = cameraNode
    cameraNode.position = CGPoint(x: backgroundGround.size.width/2, y: backgroundGround.size.height/2 - backgroundStar1.size.height/2)
    addChild(cameraNode)
    //Add a spaceship
    spaceship = SKSpriteNode(imageNamed: "spaceship")
    spaceship.position = CGPoint(x: (scene?.frame.midX)! + 250, y: (scene?.frame.minY)! - 180)
    spaceship.name = "spaceship"
    self.addChild(spaceship)
    
    //Check the difficulty min to 1 max to 3
    if difficulty > 3 {
      difficulty = 3
    } else if difficulty <= 0 {
      difficulty = 1
    }
    //Add a label to count electrons
    electronLabel = SKLabelNode(fontNamed: "Marker Felt")
    electronLabel.fontColor = SKColor(red:1.00, green:0.37, blue:0.37, alpha:1.0)
    electronLabel.fontSize = 60
    electronLabel.zPosition = 150
    electronLabel.position = CGPoint(
      x:  -(scene?.frame.width)!/2 + 180,
      y: -(scene?.frame.minY)! - 370)
    electronLabel.text = "Electrons: \(numberOfElectrons)/\(5 * difficulty)"
    cameraNode.addChild(electronLabel)
    //Action for electrons and protons
    scaleAction = SKAction.scale(by: 0.5, duration: 0.5)
    let scaleActionFull = SKAction.sequence([scaleAction, scaleAction.reversed()])
    particleAction = SKAction.repeatForever(scaleActionFull)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first?.location(in: self)
    //If is the first touch, add propeller and start to spawn particles
    if atPoint(touch!).name == "spaceship" && !launch {
        propeller = SKEmitterNode(fileNamed: "SpaceshipEmitter")!
        propeller.position.y -= 93
        spaceship.addChild(propeller)
        launch = true
        self.run(SKAction.repeatForever(
          SKAction.sequence([SKAction.run() { [weak self] in
            self?.spawnProton()
            }, SKAction.wait(forDuration: 1)])))
        
        self.run(SKAction.repeatForever(
          SKAction.sequence([SKAction.run() { [weak self] in
            self?.spawnElectron()
            }, SKAction.wait(forDuration: 1.5)])))
        spaceship.position = CGPoint(x: touch!.x, y: (scene?.frame.minY)! - 180)
    }
    //Restart the game
    if atPoint(touch!).name == "lost" || atPoint(touch!).name == "won" {
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      let scene = GameScene(size: CGSize(width: 1024, height: 768))
      let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 512, height: 384))
      sceneView.showsFPS = true
      sceneView.showsFields = true
      sceneView.showsPhysics = true
      scene.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
      scene.scaleMode = .aspectFit
      sceneView.presentScene(scene, transition: reveal)
      PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first?.location(in: self)
    //Move the spaceship to touch position x
    if atPoint(touch!).name == "spaceship" {
      spaceship.position = CGPoint(x: touch!.x, y: (scene?.frame.minY)! - 180)
    }
  }

  override func update(_ currentTime: TimeInterval) {
    //Create endless background
    if backgroundStar2.position.y + backgroundStar2.size.height < self.cameraRect.origin.y {
      backgroundStar2.position.y = self.backgroundStar2.position.y + backgroundStar2.size.height*2
    }
    if backgroundStar1.position.y + backgroundStar1.size.height < self.cameraRect.origin.y {
      backgroundStar1.position.y = self.backgroundStar1.position.y + backgroundStar1.size.height*2
    }
    if launch {
      //Move camera and check that spaceship down fall down
      moveCamera()
      checkBound()
    }
    
  }
  func checkBound() {
    let bottomBound = CGPoint(x: cameraRect.minX, y: cameraRect.minY)
    if spaceship.frame.minY <= bottomBound.y + spaceship.frame.height/2 + 50{
      spaceship.position.y = bottomBound.y + spaceship.frame.height/2 + 50
    }
  }
  
  override func didEvaluateActions() {
    enumerateChildNodes(withName: "proton") { node, _ in
      let proton = node as! SKSpriteNode
      //Lose a point/electron
      if proton.frame.intersects(self.spaceship.frame) {
        proton.removeFromParent()
        self.numberOfElectrons -= 1
        self.electronLabel.text = "Electrons: \(self.numberOfElectrons)/\(5 * self.difficulty)"
        self.checkWonLost()
      }
    }
    enumerateChildNodes(withName: "electron") { node, _ in
      let electron = node as! SKSpriteNode
      //Gain a point/electron
      if electron.frame.intersects(self.spaceship.frame) {
        electron.removeFromParent()
        self.numberOfElectrons += 1
        self.checkWonLost()
        self.electronLabel.text = "Electrons: \(self.numberOfElectrons)/\(5 * self.difficulty)"
        self.checkWonLost()
      }
      if self.proton.frame.intersects(self.electron.frame) {
        self.proton.removeFromParent()
      }
    }
  }
  
  func moveCamera() {
    yCamera += 4 * CGFloat(difficulty)
    cameraNode.position.y = yCamera
  }
  
  func spawnProton() {
    proton = SKSpriteNode(imageNamed: "proton")
    proton.name = "proton"
    proton.position = CGPoint(x: random(min: cameraRect.minX + 50, max: cameraRect.maxX - 50), y: random(min: cameraRect.midY, max:  cameraRect.maxY))
    self.addChild(proton)
    proton.run(particleAction)
  }
  
  func spawnElectron() {
    electron = SKSpriteNode(imageNamed: "electron")
    electron.name = "electron"
    electron.position = CGPoint(x: random(min: cameraRect.minX + 50, max: cameraRect.maxX - 50), y: random(min: cameraRect.midY, max:  cameraRect.maxY))
    self.addChild(electron)
    electron.run(particleAction)
  }
  
  func checkWonLost() {
    //You win
    if numberOfElectrons >= 5 * difficulty {
      propeller.removeFromParent()
      spaceship.removeFromParent()
      checkWonLostSprite = SKSpriteNode(imageNamed: "won")
      checkWonLostSprite.name = "won"
      checkWonLostSprite.position = CGPoint(x: cameraRect.midX, y: cameraRect.midY)
      checkWonLostSprite.zPosition = 10
      self.addChild(checkWonLostSprite)
      //Set the label to new position and text
      electronLabel.fontColor = SKColor.white
      electronLabel.position.x = (scene?.frame.minX)!
      electronLabel.text = "Made by Carlo Palumbo"
      launch = false
    }
    //You lose
    else if numberOfElectrons < 0 {
      propeller.removeFromParent()
      spaceship.removeFromParent()
      electronLabel.removeFromParent()
      checkWonLostSprite = SKSpriteNode(imageNamed: "lost")
      checkWonLostSprite.name = "lost"
      checkWonLostSprite.position = CGPoint(x: cameraRect.midX, y: cameraRect.midY)
      checkWonLostSprite.zPosition = 10
      self.addChild(checkWonLostSprite)
      launch = false
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
scene.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
scene.scaleMode = .aspectFit
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
