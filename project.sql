Select count(LoanNumber) as Loans_Approved, sum(InitialApprovalAmount) Total_Net_Dollars, AVG(InitialApprovalAmount) Average_Loan_Size, 
(select count(distinct (OriginatingLender))from [dbo].[sba_public_data])Total_Originating_Lender_Count
from [dbo].[sba_public_data]
order by 3 desc
