
# DISCLAIMER
Most of the code in this mod was written and developed by Chissel. I do not take ownership of that code. If Chissel wishes I take down this repo, I will do so.

# FS25_KloggersEnhancedLoanSystem
This is a port of the original 'Enhanced Loan System' for Farming Simulator 2022, made to work in Farming Simulator 2025. Credit goes to Chissel for creating the original. This is just a port to Farming Simulator 2025 of their mod, with some graphical updates.

This mod makes the credit system a bit more realistic. However, the standard game credits will be deactivated. If a farm still has a loan, it will be transferred to the new system.

With this system it is possible to take annuity loans. For this, a loan with a fixed amount, a term and a loan interest rate is concluded. This calculates the monthly installment, which is debited at the end of each month.
The bank requires collateral here, so the maximum loan amount is calculated from the current sales value of your vehicles, fields (60%), cash and your already current loans.
To make this a bit more realistic the loan rate can go up, down or stay the same each month. This makes it all the more crucial when the loan is taken out. However, you can also change this variable loan interest rate to a fixed loan interest rate in the settings.

How does an annuity loan work? Here is a brief explanation:
An annuity loan has an annuity, the monthly installment, and a loan interest rate. This annuity is made up of the repayment amount and the interest amount. The interest amount is calculated by multiplying the loan interest rate by the remaining amount of the loan. As a result, the interest amount keeps decreasing and the repayment amount keeps increasing.

Changelog 1.3.0.0: (Kloggers)
- Compatibility: Updated UI's and scripts to be compatible with FS25.
- Feature: Updated graphics of dialogs and menus to match FS25's UI.
- Known Bugs: Settings toggle has some visual animation issues. Working on a fix for this.
- Multiplayer has not been tested, but shouldn't have changed since FS22. Post an issue if something comes up, and I'll take a look.

Changelog 1.2.0.0:
- Bugfix: Newly created farms in multiplayer no longer have standard credits
- Feature: The total costs for all current loans are also displayed
- Feature: Loans that have already been paid off can now be shown and hidden

Changelog 1.1.1.0:
- Bugfix: Changes to the credit are correctly displayed in the statistics

Changelog 1.1.0.0:
- Feature: It is now possible to set the maximum duration of a loan