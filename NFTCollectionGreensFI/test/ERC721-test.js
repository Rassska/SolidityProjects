const { expect } = require("chai");
const { ethers, upgrades} = require("hardhat");

describe('LandNFT', function () {
    let LandNFT, LandNFTV2, LandNFTV3, landNFTContract, landNFTV2Contract, landNFTV3Contract, owner, addr1, addr2, addr3, addr4;
    const amountOfTokens = 5;
    const nftCollectionName = "LandNFT";
    const nftCollectionSymbol = "NFL";
    const uriSuffix = ".json";
    const baseURI = "https://gateway.pinata.cloud/ipfs/QmNd5MKmkM4VhXgo9J9DvGEAM4XWZwyvBVtZ1K6iAjEkhr/";
    const maxMintAmountPerTx = 10000;


    beforeEach(async function (){ 
        LandNFT = await ethers.getContractFactory('LandNFT');
        LandNFTV2 = await ethers.getContractFactory('LandNFTV2');
        LandNFTV3 = await ethers.getContractFactory('LandNFTV3', addr2);

        [owner, addr1, addr2, addr3, addr4] = await ethers.getSigners();
        landNFTContract = await upgrades.deployProxy(LandNFT); 
        await landNFTContract.deployed();
    })

    describe("initialize", function () {

        it("checks the initial name of the nft collection", async function() {
            expect(await landNFTContract.name()).to.equal(nftCollectionName);
        })

        it("checks the initial symbol of the nft collection", async function() {
            expect(await landNFTContract.symbol()).to.equal(nftCollectionSymbol);
        })

        it("checks the initial uriSuffix of the nft collection", async function() {
            expect(await landNFTContract.uriSuffix()).to.equal(uriSuffix);
        })

        it("checks the initial baseURI of the nft collection", async function() {
            expect(await landNFTContract.baseURI()).to.equal(baseURI);
        })

        it("checks the initial maxMintAmountPerTx of the nft collection", async function() {
            expect(await landNFTContract.maxMintAmountPerTx()).to.equal(maxMintAmountPerTx);
        })

    })

    describe("UpgradeProxy", function () {
        it("should be possible to upgrade a contract for the owner", async function() {
            landNFTV2Contract = await upgrades.upgradeProxy(landNFTContract, LandNFTV2);
            expect(await landNFTV2Contract.getCurrentVersion()).to.equal("v2!");
        })

        it("should not be possible to upgrade a contract for a non-owner", async function() {
            await expect(
                upgrades.upgradeProxy(landNFTContract, LandNFTV3)
            ).to.be.revertedWith("Ownable: caller is not the owner");
        })

    })

    describe("mintForAddress", function() {

        it("should be possible to mint new tokens for the owner under the mintCompliance modifier", async function() {
            landNFTContract.mintForAddress(amountOfTokens, addr4.address);
            expect(await landNFTContract.totalSupply()).to.equal(amountOfTokens);
        })

        it("should not be possible to mint new tokens for a non-owner under the mintCompliance modifier", async function() {
            await expect(
                landNFTContract.connect(addr3).mintForAddress(amountOfTokens, addr4.address)
            ).to.be.revertedWith("Ownable: caller is not the owner");
        })

        it("should set the balance of the receiver to the minted amount", async function() {
            landNFTContract.mintForAddress(amountOfTokens, addr4.address);
            expect(await landNFTContract.balanceOf(addr4.address)).to.equal(amountOfTokens);
        })

        it("reverts an attempt to mint new tokens for the owner after exceeding max mintCompliance", async function() {
            await expect(
                landNFTContract.mintForAddress(amountOfTokens + 10000, addr4.address)
            ).to.be.revertedWith("Invalid mint amount!");
        })

        it("reverts an attempt to mint new tokens for the owner after exceeding min mintCompliance", async function() {
            await expect(
                landNFTContract.mintForAddress(amountOfTokens - 5, addr4.address)
            ).to.be.revertedWith("Invalid mint amount!");
        })


    })

    describe("walletOfOwner", function () {
        it("checks the owner wallet after minting", async function() {
            landNFTContract.mintForAddress(amountOfTokens, addr4.address);
            const walletOfOwner = await landNFTContract.walletOfOwner(addr4.address);
            expect(walletOfOwner.map(Number)).to.eql([1, 2, 3, 4, 5]);
        })
    })
    
    describe("tokenURI", function () {
        it("reverts, if the tokenId does not exist", async function() {
            landNFTContract.mintForAddress(amountOfTokens, addr4.address);
            await expect(
                landNFTContract.tokenURI(5000)
            ).to.be.revertedWith("ERC721Metadata: URI query for nonexistent token");
        })
        it("returns an empty string, if the baseURI is not setted", async function() {
            landNFTContract.mintForAddress(amountOfTokens, addr4.address);
            landNFTContract.setBaseURI("");

            expect(await landNFTContract.tokenURI(3)).to.equal("");
        })

        it("returns baseURI for token", async function() {
            landNFTContract.mintForAddress(amountOfTokens, addr4.address);

            expect(await landNFTContract.tokenURI(3)).to.equal(baseURI + "3" + uriSuffix);
        })
    })

    describe("setMaxMintAmountPerTx", function () {
        it("resets maxMintAmountPerTx state variable", async function() {
            landNFTContract.setMaxMintAmountPerTx(maxMintAmountPerTx * 10);
            expect(await landNFTContract.maxMintAmountPerTx()).to.equal(maxMintAmountPerTx * 10);
        })

        it("should not be possible to reset the setMaxMintAmountPerTx for non-owner", async function() {
            await expect(
                landNFTContract.connect(addr3).setMaxMintAmountPerTx(maxMintAmountPerTx * 10)
            ).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("setBaseURI", function () {
        it("resets baseURI state variable", async function() {
            landNFTContract.setBaseURI("https://pornhub.com/");
            expect(await landNFTContract.baseURI()).to.equal("https://pornhub.com/");
        })

        it("should not be possible to reset baseURI for non-owner", async function() {
            await expect(
                landNFTContract.connect(addr3).setBaseURI("https://pornhub.com/")
            ).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

    describe("setUriSuffix", function () {
        it("resets uriSuffix state variable", async function() {
            landNFTContract.setUriSuffix(".vim");
            expect(await landNFTContract.uriSuffix()).to.equal(".vim");
        })

        it("should not be possible to reset uriSuffix for non-owner", async function() {
            await expect(
                landNFTContract.connect(addr3).setUriSuffix(".vim")
            ).to.be.revertedWith("Ownable: caller is not the owner");
        })
    })

})
