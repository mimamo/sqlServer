USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDeposit_Billing]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDeposit_Billing]
        @parm1 varchar( 10 ),
        @parm2 smalldatetime
AS
        SELECT * FROM smConDeposit
        WHERE
                ContractID = @parm1 AND
                BillDate <= @parm2 AND
                Status = 'A'
        ORDER BY
                ContractID,
                BillDate,
                Batnbr,
                LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
