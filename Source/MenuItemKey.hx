package;


class MenuItemKey extends MenuItem {
  private var binding: String;
  private var bindingName: String;
  
  function startKeySelect(): Void {
    title = "..press a key..";
    menu.lockKeyInput = this;
  }
  
  function generateTitle(): String {
    return bindingName + ": " + Input.KEY_STRINGS[Input.keyBindings[binding]];
  }

  public function new(bindingName: String, binding:String, fontSize:Int) {
    this.bindingName = bindingName;
    this.binding = binding;
    super(generateTitle(), startKeySelect, fontSize);
  }
  
  override public function keyDown(keyCode: Int) : Void {
    Input.keyBindings[binding] = keyCode;
    
    title = generateTitle();
  }
  
}
