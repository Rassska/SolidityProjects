//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    
    mapping (address => uint256) private __balances;
    mapping (address => mapping(address => uint256)) __allowances;

    uint256 private __totalSupply;
    string private __name;
    string private __symbol;


    constructor(string memory _name, string memory _symbol) {
        __name = _name;
        __symbol = _symbol;
    }

    function name() public view virtual override returns(string memory) {
        return __name;
    }

    function symbol() public view virtual override returns(string memory) {
        return __symbol;
    }

    function decimals() public pure virtual override returns(uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns(uint256) {
        return __totalSupply;
    }

    function balanceOf(address _account) public view virtual override returns(uint256) {
        return __balances[_account];
    }

    function transfer(address _to, uint256 _amount) public virtual override returns(bool) {
        __transfer(msg.sender, _to, _amount);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _amount) public virtual override returns(bool) {
        __spendAllowance(_from, msg.sender, _amount);
        __transfer(_from, _to, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view virtual override returns(uint256) {
        return __allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _amount) public virtual override returns(bool) {
        __approve(msg.sender, _spender, _amount);
        return true;
    }

    // internal functions


    function __transfer(address _from, address _to, uint256 _amount) internal virtual{

        require(_from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(__balances[_from] >= _amount, "ERC20: transfer amount exceeds current balance");
        require(__balances[_to] + _amount >= __balances[_to], "ERC20: transfer amount overflows current balance");

        unchecked {
            __balances[_from] -= _amount;
            __balances[_to] += _amount;
        }

        emit Transfer(_from, _to, _amount);
        
    }
    function __approve(address _owner, address _spender, uint256 _amount) internal virtual {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");
        __allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
    }

    function __spendAllowance(address _owner, address _spender, uint256 _amount) internal virtual {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");
        require(__allowances[_owner][_spender] >= _amount, "ERC20: insufficient allowance");
        
        __approve(_owner, _spender, __allowances[_owner][_spender] - _amount);



    }
}

