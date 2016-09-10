package;


class OptionsMenu extends Menu {

  public function new(backAction:Void -> Void) {
    super(18);
    
    addItem("Transmission: auto", function() {});
    addKeyItem("Accelerate", "accelerate");
    addKeyItem("Brake", "brake");
    addKeyItem("+ Gear", "gear_plus");
    addKeyItem("- Gear", "gear_minus");

    addItem("< Back", backAction);

    selected_item = 0;
  }
  
}
