USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[RptExtra_Cleanup]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RptExtra_Cleanup    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.RptExtra_Cleanup    Script Date: 4/7/98 12:56:04 PM ******/
Create Proc [dbo].[RptExtra_Cleanup] @parm1 varchar ( 47), @parm2 varchar ( 21) as
       Delete rptextra from RptExtra where UserId = @parm1 And
                                  ComputerName = @parm2
GO
