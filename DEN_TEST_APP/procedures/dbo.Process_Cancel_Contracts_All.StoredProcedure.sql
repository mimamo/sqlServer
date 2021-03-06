USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Process_Cancel_Contracts_All]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Process_Cancel_Contracts_All] @parm1 char(10)
as

--set @parm1 = 'UEI'
SELECT * FROM smContract  c

where Status = 'C'
AND EXISTS (SELECT * FROM smBranch WHERE CpnyID = @parm1 and BranchID = c.BranchID)

AND
(EXists	(SELECT * FROM smContractRev
	WHERE
		smContractRev.ContractID = c.contractid AND
		smContractRev.RevFlag = 0 AND
		smContractRev.Status = 'O')
	or exists

        (SELECT * FROM smContractBill
        WHERE
                smContractBill.BillFlag = 0 AND
                smContractBill.Status = 'O' AND
                smContractBill.ContractID = c.contractid )


or exists

	(SELECT * FROM smConDiscount
	WHERE

		smConDiscount.ContractID = c.contractid )

)
GO
