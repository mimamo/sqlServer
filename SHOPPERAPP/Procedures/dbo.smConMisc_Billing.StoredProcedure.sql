USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConMisc_Billing]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConMisc_Billing]
        @parm1 varchar( 10 ),
        @parm2 smalldatetime
AS
SELECT * FROM smConMisc
        WHERE
                ContractID = @parm1 AND
                TranDate <= @parm2 AND
                Status = 'A'
        ORDER BY
                ContractID,
                TranDate,
                Batnbr,
                LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
