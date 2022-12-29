import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token{
  var owner : Principal = Principal.fromText("64lrs-xrge3-d63lw-v3jkv-yjuja-voj4p-tr53j-hwz3m-vwuiw-dwve7-aqe");
  var totalSupply: Nat = 1000000000;
  var symbol : Text = "UM";

  private stable var balanceEntries: [(Principal, Nat)] = [];
  private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

  if(balances.size() < 1){
    balances.put(owner, totalSupply);
  }; 

  public query func balanceOf(who: Principal) : async Nat{
    // get the owner by principal or id and 
    // return the amount of token they own
    // if the result is null the return zero 
    // else return the amount
    let balance : Nat = switch(balances.get(who)){
      case null 0;
      case (?result) result;
    };

    return balance;
  };

  public query func getTokenName(): async Text{
    return symbol;
  };

  public shared(msg) func payOut() : async Text{
    if(balances.get(msg.caller) == null){
      let amount = 10000;
      let result = await transfer(msg.caller, amount);
      return result;
    }else{
      return "Already claimed";
    }    
  };

  public shared(msg) func transfer(recipient: Principal, amount: Nat): async Text{
    let callerId = msg.caller;
    let senderBalance = await balanceOf(callerId);

    if(senderBalance > amount){
      // get sender balance
      // and debit sender's account
      let newSenderBalance : Nat = senderBalance - amount;
      balances.put(callerId, newSenderBalance);

      // get recipient balance 
      // and credit recipient's account
      let recipientBalance = await balanceOf(recipient);
      let newRecipientBalance = recipientBalance + amount;
      balances.put(recipient, newRecipientBalance);      
      return "Success";
    }else{
      return "Insufficient funds";
    }
  };

  system func preupgrade(){
    balanceEntries := Iter.toArray(balances.entries());
  };

  system func postupgrade(){
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal,Principal.hash);
    
    if(balances.size() < 1){
      balances.put(owner, totalSupply);
    }    
  };
};
