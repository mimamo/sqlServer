USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConMisc_ContractID_Taxable_]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConMisc_ContractID_Taxable_]
        @parm1 varchar( 10 ),
        @parm2 varchar( 1 ),
        @parm3 varchar( 10 )
AS
        SELECT *
        FROM smConMisc
        WHERE ContractID LIKE @parm1
           AND Taxable LIKE @parm2
           AND BatNbr LIKE @parm3
        ORDER BY ContractID,
           Taxable,
           BatNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
