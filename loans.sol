pragma solidity ^0.8.13;

//ierc20

Struct Loan{
    uint256 loanID;
    uint256 loanType;
    uint256 loanRate;
    uint40 startDate;
    uint40 expDate;
    uint256 loanamt;
    uint256 loanmax;
    uint256 amtPaid;
    address lenderx;
    address borrowery;
    uint256 lenderProf;
    uint256 devProf;
    bool accepted;
}

Struct Lender{
    uint256 totalLent;
    uint256 totalEarned;
    uint256 totalWithdrawable;
    Deposits [] deps;
    Loans [] pendingLoanX;
}

Struct Borrower{
    
    uint256 totalLoan;
    uint256 totalPaid;
    uint256 totalwdable;
    Deposits [] pymnts;
    Loans [] pendingLoanY;
}

Struct Deposits{
    uint40 unixtime;
    uint256 amtz;
}

// Struct Staker{
//     uint256 totalStaked;
//     Deposits [] depositsArr;
//     uint256 totalRewards;
// }

Struct Main{
    uint256 liqPool;
    uint256 lendingPool;
    uint256 borrowedPool;
    uint256 stakedRewards;
    uint256 netProfits;
}

//global structs

//event declarations

contract lendingProt{
    using SafeMath for uint256;
    using SafeMath for uint40;

    uint256 public loanCount;

    mapping (uint256 => Loan) public loans;
    mapping (address => Lender) public lenders;
    mapping (address => Borrower) public borrowers;
    // mapping (address => Staker) public stakers;
    mapping (uint8 => Main) public main;

    address payable public ownerWallet;
    uint256 public bPool;
    uint256 public lPool;
    uint256 public loanCount;
    uint256 [] pendingLoansL;
    uint256 [] pendingLoansB;
    uint256 [] liveLoans;
    uint256 [5] types = [10,30,90,180,360];
    uint256 [5] rates = [25,40,70,90,120];
    uint256 [5] lends = [20,30,50,75,100];

    constructor(){
        ownerWallet = msg.sender;
    }
    //1 = borrow
    //2 = lend
    
    function createLoanL(uint256 amtL, uint256 rateL, uint256 typeLoanL){
        Loan storage loan = loans[loanCount];
        Lender storage lender = lenders[msg.sender];
        loan.loanID = loanCount;
        loan.loanType = typeLoanL;
        loan.lenderx = msg.sender;
        loan.borrowery = 0;
        loan.loanRate = rates[rateL];
        loan.loanmax = loanamt + (loanamt * loanRate);
        lender.totalWithdrawable += amtL;
        pendingLoansL.push(loanCount);
        loanCount += 1;
        }

    
    function createLoanB(uint256 amtB, uint256 rateB, uint256 typeLoanB){
        Loan storage loan = loans[loanCount];
        Borrower storage borrower = borrowers[msg.sender];
        loan.loanID = loanCount;
        loan.loanType = typeLoanB;
        loan.borrowery = msg.sender;
        loan.loanRate = rates[rateL];
        loan.loanmax = loanamt + (loanamt * loanRate);
        borrower.totalwdable += amtB;
        loan.lenderx = 0;
        pendingLoansB.push(loanCount);
        loanCount += 1;
    }

    function acceptLoanL(uint256 loanIDx){
        Loan storage loan = loans[loanIDx];
        loan.lenderx = msg.sender;
        loan.startDate = block.timestamp;
        for (uint i = 0, i < types.length, i++){
            if (loanType == i){
            uint256 tempVar = types[i];
            loan.expDate = tempVar + startDate;
            uint256 tempV2 = rates[i] - lends[i];
            loan.devProf = tempV2*loanamt;
            uint256 tempV3 = lends[i].mul(lend.loanamt)
            loan.lenderProf = tempV3;
            } 
        loan.accepted = true;
        liveLoans.push(loanIDy);
        for (uint y = 0, y < pendingLoans.length, y++){
        if (pendingLoansB[y] == loanIDy){
            delete pendingLoansB[y];
            }
        }
        Lender storage lender = lender[msg.sender];
        lender.totalLent += loan.loanamt;
        lender.totalWithdrawable -= loan.loanamt;
        lender.pendingLoanX.push(loan);
        address tempBor = loan.borrowery;
        Borrower storage borrower = borrowers[tempBor];
        borrower.pendingLoanY.push(loan);
        borrower.totalLoan += (amt+ amt*loan.tier);
        borrower.totalwdable -= loan.loanmax;

    }

    function acceptLoanB(uint256 loanIDy){
        Loan storage loan = loans[loanIDy];
        loan.borrowery = msg.sender;
        require (loan.lenderx != 0 || loan.borrowery != 0);
        loan.startDate = block.timestamp;
        for (uint i = 0, i < types.length, i++){
            if (loanType == i){
            uint256 tempVar = types[i];
            loan.expDate = tempVar + startDate;
            uint256 tempV2 = rates[i] - lends[i];
            loan.devProf = tempV2*loanamt;
            uint256 tempV3 = lends[i].mul(lend.loanamt)
            loan.lenderProf = tempV3;
            } 
        loan.accepted = true;
        liveLoans.push(loanIDy);
        for (uint y = 0, y < pendingLoans.length, y++){
            if (pendingLoansL[y] == loanIDy){
                delete pendingLoansL[y];
            }
        Borrower storage borrower = borrowers[msg.sender];
        borrower.totalLoan += (amt+ amt*loan.tier);
        borrower.pendingLoanY.push(loan);
        address tempBor = loan.borrowery;
        Lender storage lender = lenders[tempBor];
        lender.pendingLoanX.push(loan);
        lender.totalLoan += (amt+ amt*loan.tier); //fix later
        }
    }

    function makePayments(uint256 theXamt){
        Borrower storage borrower = borrowers[msg.sender];
        checkifCurrent(msg.sender);
        borrower.totalPaid += theXamt;
        borrower.totalWithdrawable += theXamt;
    }

    function withdrawAmtL(){
        Lender storage lender = lenders[msg.sender];
        require (lenders.totalWithdrawable > 0);
    }

    function withdrawAmtB(){
        Borrower storage borrower = borrowers[msg.sender];
        require (borrower.totalwdable > 0);
    }

    function setLender(uint256 amtp){
        Lender storage lender = lenders[msg.sender]
        lender.totalLend += amtp;
        
        lender.deps.push(Deposits(
            unixtime: uint40 block.timestamp;
            amtz: amtp
        )
    };

    function setBorrower(uint256 amtf, uint256 tier);
        Borrower storage borrower = borrowers[msg.sender];
        if (tier == 0){
            newAmtfx = amtf.div(
        }

    // function setStaker();

    function setLoan();

    function setMain(uint256 numberx, uint256 lNumbers, uint256 bNumbers, uint256 stRewards){

    }

    function checkifcurrent(){

    }








}


