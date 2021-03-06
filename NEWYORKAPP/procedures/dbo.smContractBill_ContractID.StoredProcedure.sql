USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smContractBill_ContractID]    Script Date: 12/21/2015 16:01:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
        [dbo].[smContractBill_ContractID]
                @parm1  varchar(10)
                ,@parm2 varchar(10)
                ,@parm3 varchar(10)
AS
        SELECT
                *
        FROM
                smContractBill
        WHERE
                ContractId = @parm1
                        AND
                BillDate  BETWEEN @parm2 AND @parm3
        ORDER BY
                ContractID
                ,BillDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
