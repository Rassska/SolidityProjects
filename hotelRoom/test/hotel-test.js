const { expect } = require("chai")
const { ethers, waffle } = require("hardhat")
const provider = waffle.provider
const parseEther = ethers.utils.parseEther

describe("HotelRoom", function () {
  let accounts = []
  let hotelRoom
  beforeEach(async function () {
    accounts = await ethers.getSigners()
    const HotelRoom = await ethers.getContractFactory("HotelRoom", accounts[0])
    hotelRoom = await HotelRoom.deploy()
    await hotelRoom.deployed()
  })

  it("should be deployed", async function() {
    expect(hotelRoom.address).to.be.properAddress
  })
  it("should've 0 ether by default", async function() {
    const currBalance = await provider.getBalance(hotelRoom.address) 
    expect(currBalance).to.eq(0)
  })
  it("sets hotel room state to the Vacant by default", async function() {
    const result = await hotelRoom.getState();
    expect(ethers.utils.parseBytes32String(result)).to.eq("Vacant")
  })
  it("sends some funds", async function() {
    let txValue = parseEther("1.0")
    const tx = {
      to: hotelRoom.address,
      value: txValue
    }
    await accounts[1].sendTransaction(tx)
    let result = await provider.getBalance(hotelRoom.address)
    expect(txValue).to.equal(result)

  })
  it("reverts > 1 ether funds ", async function() {
    let txValue = parseEther("1.1")
    const tx = {
      to: hotelRoom.address,
      value: txValue
    }
    await expect(accounts[1].sendTransaction(tx)).to.be.revertedWith('Cost is exactly 1 ether')
  })
  it("reverts < 1 ether funds ", async function() {
    let txValue = parseEther("0.8")
    const tx = {
      to: hotelRoom.address,
      value: txValue
    }
    await expect(accounts[1].sendTransaction(tx)).to.be.revertedWith('Cost is exactly 1 ether')
  })
  it("reverts an attempts to book an occupied room", async function() {
    let txValue = parseEther("1.0")
    const tx = {
      to: hotelRoom.address,
      value: txValue
    }
    await accounts[1].sendTransaction(tx)
    await expect(accounts[6].sendTransaction(tx)).to.be.revertedWith("Current Room is Occupied!")

  })
})