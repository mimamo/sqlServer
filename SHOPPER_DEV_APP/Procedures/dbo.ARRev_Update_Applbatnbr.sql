USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_Update_Applbatnbr]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_Update_Applbatnbr    Script Date: 11/12/00 12:30:32 PM ******/
CREATE PROC [dbo].[ARRev_Update_Applbatnbr] @parm1 varchar (10), @parm2 varchar ( 15),
            @parm3 varchar ( 2), @parm4 varchar ( 10), @parm5 varchar (10) AS
UPDATE ARDOC
   SET applbatnbr = @parm1
 WHERE applbatnbr = "" AND
       Custid = @parm2 AND
       Doctype = @parm3 AND
       Refnbr = @parm4 AND
       Batnbr = @parm5
GO
