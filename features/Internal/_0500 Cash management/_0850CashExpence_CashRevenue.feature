﻿#language: en
@tree
@Positive
@CashManagement

Feature: write off expenses and record income directly to/from the account

As an accountant
I want to create Cash revenue and Cash expence documents
For write off expenses and record income directly to/from the account

Background:
	Given I launch TestClient opening script or connect the existing one


# Cash revenue

	
Scenario: _085000 preparation (Cash expence and Cash revenue)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create document CashExpense objects
		When Create document CashRevenue objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Post
		And I execute 1C:Enterprise script at server
			| "Documents.CashExpense.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashRevenue.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows
	


Scenario: _085001 check tax calculation in the document Cash revenue
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table		
		And I finish line editing in "PaymentList" table
	* Tax calculation check
		And "PaymentList" table contains lines
			| 'Net amount' | 'Profit loss center'      | 'Revenue type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '100,00'     | 'Accountants office' | 'Fuel'         | '118,00'       | 'TRY'      | '18%' | '18,00'      |
		And I close all client application windows

Scenario: _085002 check Cash revenue creation
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashRevenue1$$" variable
		And I delete "$$CashRevenue1$$" variable
		And I save the value of "Number" field as "$$NumberCashRevenue1$$"
		And I save the window as "$$CashRevenue1$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberCashRevenue1$$' |
		And I close all client application windows
	





Scenario: _085003 check the unavailability of currency selection in Cash revenue when it is strongly fixed in the Account
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the Currency field unavailability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		When I Check the steps for Exception
			|'And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table'|

Scenario: _085004 check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Cash desk №1' |
		And I select current line in "List" table
	* Check the Currency field availability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And in "PaymentList" table "Currency" attribute is available


# Cash expence

Scenario: _085005 check tax calculation in the document Cash expense
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Tax calculation check
		And "PaymentList" table contains lines
			| 'Net amount' | 'Profit loss center' | 'Expense type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '100,00'     | 'Accountants office' | 'Fuel'         | '118,00'       | 'TRY'      | '18%' | '18,00'      |
		And I close all client application windows

Scenario: _085006 check Cash expense creation
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table		
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashExpense1$$" variable
		And I delete "$$CashExpense1$$" variable
		And I save the value of "Number" field as "$$NumberCashExpense1$$"
		And I save the window as "$$CashExpense1$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberCashExpense1$$' |
		And I close all client application windows
	
	



Scenario: _085007 check the unavailability of currency selection in Cash expense when it is strongly fixed in the Account
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the Currency field unavailability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		When I Check the steps for Exception
			|'And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table'|


Scenario: _085008 check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Cash desk №1' |
		And I select current line in "List" table
	* Check the Currency field availability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And in "PaymentList" table "Currency" attribute is available
	
Scenario: _085009 copy Cash expense and change date
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Copy Cash expense
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I move to "Other" tab
		And I move to "More" tab
		And I input "14.03.2022 00:00:00" text in the field named "Date"
		And I click "Post" button
		Then user message window does not contain messages

Scenario: _085010 copy Cash revenue and change date
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Copy Cash revenue
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I move to "Other" tab
		And I move to "More" tab
		And I input "14.03.2022 00:00:00" text in the field named "Date"
		And I click "Post" button
		Then user message window does not contain messages	
		
				

		

