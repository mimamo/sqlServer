USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContractBill_ContractID2]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContractBill_ContractID2]
        @parm1 varchar(10),
        @parm2 smalldatetime,
        @parm3 smalldatetime
AS
        SELECT * FROM smContractBill
        WHERE
                ContractId = @parm1 AND
                BillDate  BETWEEN @parm2 AND @parm3
        ORDER BY
                ContractID,
                BillDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
