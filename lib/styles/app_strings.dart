class AppStrings {
  static const appTitle = "Bill Splitter";
  static const labelDashboard = "Dashboard";
  static const labelTransactions = "Transactions";
  static const labelTotalSpending = "Total Spending:";
  static const labelAddMember = "Add Member";
  static const labelCreateGroup = "Create Group";
  static const labelChangeGroup = "Change Group";
  static const labelLogout = "Logout";
  static const labelSplitMoney = "Split Money";
  static const labelAmount = "Amount";
  static const labelAmountSpentOn = "Amount spent on";
  static const labelDescription = "Description";
  static const labelTransactionDetail = "Transaction Detail";
  static const labelAmountSplitBetween = "Amount split between";
  static const labelMember = "member";
  static const labelGroups = "Groups";
  static const labelLoginHere = "Login here.";
  static const labelWelcomeBack = "Welcome back";
  static const labelHey = "Hey,";
  static const labelIfYouAreNew = "If you are new / ";
  static const labelCreateAccount = "Create account";
  static const labelEmail = "Email";
  static const labelPassword = "Password";
  static const labelLogin = "Login";
  static const labelRegisterNow = "Register Now.";
  static const labelIfYouHaveAccount = "If you already have account / ";
  static const labelYourName = "Your name";
  static const labelSettleUp = "Settle Up";
  static const labelPayViaUPI = "Pay via UPI";
  static const labelMarkAsPaid = "Mark as paid";
  static const labelPayViaCash = "Pay via cash";
  static const labelSelectUPIApp = "Select UPI app";
  static const labelReceiverUPIId = "Receiver UPI id";
  static const labelNote = "Note";
  static const labelMemberId = "Member id";
  static const labelGroupName = "Group name";

  static const messageTransactionAdded =
      "Your transaction has been added successfully";

  static const messageSettleUpDone =
      "You have successfully settle up the amount";
}

enum PaymentMethod { upi, cash }

List<String> appKeyword = ["users", "groups", "members", "transactions"];
