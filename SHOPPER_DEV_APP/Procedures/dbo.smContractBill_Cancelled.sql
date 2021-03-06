USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContractBill_Cancelled]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContractBill_Cancelled]
        @parm1 as VarChar(10)
AS
        SELECT * FROM smContractBill
        WHERE
                smContractBill.BillFlag = 0 AND
                smContractBill.Status = 'O' AND
                smContractBill.ContractID = @parm1

        Order By
                smContractBill.ContractID,
                smContractBill.BillDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
