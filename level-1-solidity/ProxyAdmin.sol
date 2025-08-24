
pragma solidity ^0.8.16 ;
  interface ITrasnparentUpgradeableProxy {
    function upgradeTo(address newImplementation) external;
    function changeAdmin(address newAdmin) external;
  }

 contrcat ProxyAdmin {
    address private owner;

  constructor(){
    owner = msg.sender;
  }  
  modifier onlyowner(){
    require(msg.sender == owner,"Not the owner");
    _;
  }
  function upgrade(address proxy, address NewLogicContract) external onlyowner {
     ITrasnparentUpgradeableProxy(proxy).upgradeTo(NewLogicContract);
  }
    function changeProxyAdmin(address proxy, address newAdmin) external onlyOwner {
        ITransparentUpgradeableProxy(proxy).changeAdmin(newAdmin);
    }
 } 
 /*
1. Logic Contract (Implementation Contract)

Ye wahi contract hai jisme functions aur business logic hota hai.
Lekin iska state data directly use nahi hota.
Agar tum logic contract ko upgrade karte ho → purana state data lose ho jayega.
Isiliye iske sath proxy use kiya jata hai.

2. Proxy Contract (TransparentUpgradeableProxy)

Ye ek middle layer hai jo user aur logic contract ke beech hota hai.
Proxy ke paas sirf state variables store hote hain (users ke balances, mappings, etc).
Jab bhi koi user function call karta hai:
Proxy contract delegatecall ke through us function ko Logic contract me forward kar deta hai.
Matlab execution Logic contract me hoti hai, state store Proxy me hoti hai.

3. ProxyAdmin Contract

Ye ek manager contract hai jo ek ya multiple Proxy contracts ko control karta hai.
ProxyAdmin ka owner hi decide kar sakta hai ki:
Kounsa proxy kaunsa logic contract use karega.
Kab proxy ko upgrade karna hai.
Normal users ke paas ProxyAdmin ka access nahi hota.

4. Upgrade Process

Jab naya version of Logic contract banate ho:
Pehle naya Logic contract deploy karte ho.
Fir ProxyAdmin ke through upgrade(proxy, newLogic) function call karte ho.
Ye proxy contract ke andar implementation address ko update kar deta hai.
Ab proxy user ke calls ko nayi implementation par delegatecall karega.

5. Important Points

State variables Proxy me rehte hain → upgrade ke baad bhi data safe rehta hai.
Delegatecall ka kaam: code dusre contract ka chale, par storage caller contract (proxy) ka use ho.
Proxy address kabhi change nahi hota → isiliye users hamesha same address se interact karte hain.
Only ProxyAdmin ke owner upgrade kar sakta hai → security ke liye.

6. Code Example (Simplified)
function upgrade(address proxy, address newLogic) external onlyOwner {
    ITransparentUpgradeableProxy(proxy).upgradeTo(newLogic);
}


proxy → TransparentUpgradeableProxy ka address (jisme state hai).
newLogic → Naya Logic contract ka address.
upgradeTo() → Proxy contract ke andar implementation address replace ho jata hai.

7. Summary in One Line

 Proxy → storage rakhta hai, Logic → code rakhta hai, ProxyAdmin → in dono ka boss hai jo decide karta hai ki Proxy kis Logic ko follow karega.
 Bhai ye teri final theory hai – ekdum notes-ready version.
 Chahta hai mai isko ek flow diagram bhi bana du jisme arrows se dikhau ki kaise Proxy → Logic → ProxyAdmin ka connection hota hai?

 */