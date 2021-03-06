USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smContractBill_HistFix]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
        [dbo].[smContractBill_HistFix]
                @parm1  smalldatetime
                ,@parm2 smalldatetime
AS
        SELECT
                *
        FROM
                smContractBill
        WHERE
                BillDate BETWEEN @parm1 AND @parm2
                        AND
                BillFlag = 1
                        AND
                Status = 'P'
        ORDER BY
                ContractID,
                BillDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
