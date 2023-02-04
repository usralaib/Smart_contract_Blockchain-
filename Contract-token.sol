pragma solidity ^0.8.0;

// Définition du contrat du token
contract DAITAS {
  // Noms et symboles du token
  string public name = "DAITAS ARE THE BEST";
  string public symbol = "DAITAS ";
  uint8 public decimals = 18; 

  // Total de tokens en circulation
  uint public totalSupply;

  // Mapping des balances des adresses
  mapping (address => uint) public balanceOf;

  // Mapping des autorisations accordées aux adresses pour transférer des tokens en votre nom
  mapping (address => mapping (address => uint256)) public allowed;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

  // Constructeur du contrat
  constructor() public {
    // Définissez ici la quantité totale de tokens à créer et la répartition initiale entre les adresses.
    // Par exemple, pour créer 1 000 000 de tokens et les attribuer à l'adresse 0x123..., vous pouvez utiliser :
    totalSupply = 1000 * (10 ** uint256(decimals));
    balanceOf[0x82Ece8f726869a80505500c2f594F8D326eeE09C] = totalSupply;
  }

  // Fonction pour récupérer le nombre total de tokens en circulation
  function _totalSupply() public view returns (uint256) {
    return totalSupply;
  }

  // Fonction pour récupérer la balance d'une adresse
  function _balanceOf(address _owner) public view returns (uint256) {
    return balanceOf[_owner];
  }

  // Fonction pour transférer des tokens d'une adresse à une autre
  function transfer(address _to, uint256 _value) public {
    require(balanceOf[msg.sender] >= _value && _value > 0, "balance insuffisante");
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
  }

  // Fonction pour autoriser une adresse à transférer des tokens en votre nom
  function approve(address _spender, uint256 _value) public {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
  }

  // Fonction pour vérifier si une adresse a l'autorisation de transférer des tokens en votre nom
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }
// Fonction pour transférer des tokens en utilisant l'autorisation accordée par une adresse
  function transferFrom(address _from, address _to, uint256 _value) public {
    require(balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0, "balance ou permission insuffisante");
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowed[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
  }

// Fonction pour créer de nouveaux tokens et les attribuer à une adresse
function mint(address _to, uint256 _value) public {
  balanceOf[_to] += _value;
  totalSupply += _value;
  emit Mint(_to, _value);
}

// Fonction pour détruire des tokens d'une adresse
function burn(address _from, uint256 _value) public {
  require(balanceOf[_from] >= _value && _value > 0, "balance insuffisante");
  balanceOf[_from] -= _value;
  totalSupply -= _value;
  emit Burn(_from, _value);
}
}