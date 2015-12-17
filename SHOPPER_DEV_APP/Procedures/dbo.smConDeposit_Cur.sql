USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDeposit_Cur]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDeposit_Cur]
        @parm1 varchar( 6 )
AS
SELECT * FROM smConDeposit
        WHERE
                PerPost = @parm1 AND
                AccruedtoGL = 0
        ORDER BY
                PerPost,
                AccruedToGL,
                ContractID,
                TranDate,
                Batnbr,
                Linenbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
