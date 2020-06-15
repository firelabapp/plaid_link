package app.firelab.plaid_link;

import com.plaid.link.configuration.AccountSubtype;
import com.plaid.link.configuration.AccountSubtype.CREDIT.CREDIT_CARD;
import com.plaid.link.configuration.AccountSubtype.CREDIT.PAYPAL_CREDIT;
import com.plaid.link.configuration.AccountSubtype.DEPOSITORY.CD;
import com.plaid.link.configuration.AccountSubtype.DEPOSITORY.CHECKING;
import com.plaid.link.configuration.AccountSubtype.DEPOSITORY.HSA_DEPOSITORY;
import com.plaid.link.configuration.AccountSubtype.DEPOSITORY.MONEY_MARKET;
import com.plaid.link.configuration.AccountSubtype.DEPOSITORY.PAYPAL_DEPOSITORY;
import com.plaid.link.configuration.AccountSubtype.DEPOSITORY.PREPAID_DEPOSITORY;
import com.plaid.link.configuration.AccountSubtype.DEPOSITORY.SAVINGS;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.AUTO;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.COMMERCIAL;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.CONSTRUCTION;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.CONSUMER;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.HOME_EQUITY;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.LINE_OF_CREDIT;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.LOAN;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.MORTGAGE;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.OVERDRAFT;
import com.plaid.link.configuration.AccountSubtype.LOAN_SUBTYPE.STUDENT;
import com.plaid.link.configuration.AccountSubtype.OTHER_SUBTYPE.CASH_MANAGEMENT;
import com.plaid.link.configuration.AccountSubtype.OTHER_SUBTYPE.OTHER;

public enum PlaidAccountSubtype {
  CREDIT_CREDIT_CARD(new CREDIT_CARD()),
  CREDIT_PAYPAL(new PAYPAL_CREDIT()),

  DEPOSITORY_CASH_MANAGEMENT(new CASH_MANAGEMENT()),
  DEPOSITORY_CD(new CD()),
  DEPOSITORY_CHECKING(new CHECKING()),
  DEPOSITORY_HSA(new HSA_DEPOSITORY()),
  DEPOSITORY_SAVINGS(new SAVINGS()),
  DEPOSITORY_MONEY_MARKET(new MONEY_MARKET()),
  DEPOSITORY_PAYPAL(new PAYPAL_DEPOSITORY()),
  DEPOSITORY_PREPAID(new PREPAID_DEPOSITORY()),

  LOAN_AUTO(new AUTO()),
  LOAN_COMMERCIAL(new COMMERCIAL()),
  LOAN_CONSTRUCTION(new CONSTRUCTION()),
  LOAN_CONSUMER(new CONSUMER()),
  LOAN_HOME_EQUITY(new HOME_EQUITY()),
  LOAN_LOAN(new LOAN()),
  LOAN_MORTGAGE(new MORTGAGE()),
  LOAN_OVERDRAFT(new OVERDRAFT()),
  LOAN_LINE_OF_CREDIT(new LINE_OF_CREDIT()),
  LOAN_STUDENT(new STUDENT()),

  OTHER_OTHER(new OTHER());

  // TODO(keenant): Investment subtypes

  private final AccountSubtype instance;

  PlaidAccountSubtype(AccountSubtype instance) {
    this.instance = instance;
  }

  public AccountSubtype getInstance() {
    return instance;
  }
}
