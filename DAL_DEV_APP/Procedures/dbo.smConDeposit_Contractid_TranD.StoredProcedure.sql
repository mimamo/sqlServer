USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDeposit_Contractid_TranD]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDeposit_Contractid_TranD]
        @parm1 varchar( 10 ),
        @parm2min smalldatetime, @parm2max smalldatetime,
        @parm3 varchar( 10 )
AS
        SELECT *
        FROM smConDeposit
        WHERE Contractid LIKE @parm1
           AND TranDate BETWEEN @parm2min AND @parm2max
           AND BatNbr LIKE @parm3
        ORDER BY Contractid,
           TranDate,
           BatNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
