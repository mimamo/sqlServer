USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ReverseApp_AdjdDocument]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ReverseApp_AdjdDocument    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ReverseApp_AdjdDocument] @parm1 varchar ( 15),
                                         @parm2 varchar ( 10),
                                         @parm3 varchar (2) AS
  SELECT *
    FROM ARDoc
   WHERE Custid = @parm1 AND
         Refnbr = @parm2 AND
         Doctype = @parm3
GO
